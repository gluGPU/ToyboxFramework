--!strict
--[[
    Engine.luau
    1/11/26
    @gluGPU

    Entry point for the Toybox Framework.
--]]

-- Dependencies
local RunService = game:GetService("RunService")

local Logger = require("./Classes/Logger")
local Config = require("./EngineConfig")
local Services = require("./EngineServices")
local Stats = require("./EngineStats")
local Tick = require("./EngineTick")


type EngineFields = {
    read Services: Services.ServicesType,
    read Config: Config.ConfigType,
    read Tick: Tick.Tick,
    read Stats: Stats.Stats,
}

type EngineMethods = {
    Init: (configOverrides: {[string]: any}?) -> (),
    OnInitialized: (callback: (Config.ConfigType) -> () -> ()) -> (),
    GetIsEngineInitialized: () -> boolean,

    CreateUpdateLoop: () -> (),
    DestroyUpdateLoop: () -> (),
    GetIsLoopActive: () -> boolean,
    StepUpdateOnce: () -> (),
}

export type Engine = EngineFields & EngineMethods


-- Vars
local isClient = RunService:IsClient()
local isServer = RunService:IsServer()
local isStudio = RunService:IsStudio()

local engineLogger = Logger.new("Engine")

local cleanupHooks = {} :: {(Config.ConfigType) -> ()}
local initHooks = {} :: {(Config.ConfigType) -> (() -> ()?)}

local isInitialized = false
local isUpdateLoopActive = false
local tickConn = nil :: RBXScriptConnection?
local renderConn = nil :: RBXScriptConnection?

local Engine = {
    Services = Services,
    Config = Config,
    Tick = Tick,
    Stats = Stats
} :: Engine

--[=[
    Initializes Toybox configurations and services, then calls engine initialization hooks.

    @param configOverrides {[string]: any}? -- A dictionary that overrides engine configs listed in EngineConfigs.luau.
]=]
function Engine.Init(configOverrides: {[string]: any}?)
    engineLogger:Assert(not isInitialized, `The engine is already initialized!`)

    -- print("Starting main initialization")
    engineLogger:Print("Starting engine init")

    local config = Config
    local services = Services

    if configOverrides then
        for i, v in pairs(configOverrides) do
            config[i] = v
        end

        engineLogger:Print("Config Overrides Applied")
        print(configOverrides)
    end

    -- initialize main systems
    Tick.Init(config)

    -- initialize auxillary services
    for i, module in services do
        module.Init(config)
    end

    isInitialized = true
    for _, callback in initHooks do
        local cleanup = callback(config)
        if cleanup then
            table.insert(cleanupHooks, cleanup)
        end
    end
end


--[=[
    Allows you to hook into the engine's post-initialization phase to reduce race conditions.

    @param callback (Engine) -> ((Engine) -> ()?) -- The callback to call after the engine initializes.
]=]
function Engine.OnInitialized(callback: (Config.ConfigType) -> () -> ())
    if isInitialized then
        local cleanup = callback(Engine.Config)
        if cleanup then
            table.insert(cleanupHooks, cleanup)
        end
    else
        table.insert(initHooks, callback)
    end
end


--[=[
    Returns if the engine has been initialized yet.

    @return boolean -- Whether or not the engine has been initialized.
]=]
function Engine.GetIsEngineInitialized(): boolean
    return isInitialized
end


local executeInput = Tick.ExecuteInputCallbacks
local executeTick = Tick.ExecuteTickCallbacks
local executeInterp = Tick.ExecuteInterpCallbacks
local executeRender = Tick.ExecuteRenderCallbacks

--[=[
    Starts Toybox's update loop. For more information, see EngineTick.
]=]
function Engine.CreateUpdateLoop()
    engineLogger:Assert(isInitialized, "Engine has not initialized yet.")
    engineLogger:Assert(not isUpdateLoopActive, "Engine loop is already active.")

    isUpdateLoopActive = true

    engineLogger:Warn("Creating Update Loop")

    local c1, c2 = nil, nil

    local input, tick, interp, render = 0, 0, 0, 0
    c1 = RunService.PreSimulation:Connect(function(delta: number)
        -- Input
        local t1 = os.clock()
        executeInput(delta)
        input = os.clock() - t1

        -- Tick
        local t2 = os.clock()
        executeTick(delta)
        tick = os.clock() - t2
    end)

    c2 = RunService.PreRender:Connect(function(delta: number)
        -- Interpolation
        local t1 = os.clock()
        executeInterp(delta)
        interp = os.clock() - t1

        -- Render
        local t2 = os.clock()
        executeRender(delta)
        render = os.clock() - t2

        Stats.PushTimes(input, tick, interp, render)
    end)

    tickConn = c1
    renderConn = c2
end


--[=[
    Stops Toybox's update loop.
]=]
function Engine.DestroyUpdateLoop()
    engineLogger:Assert(isUpdateLoopActive, "Engine loop is not active.")
    engineLogger:Warn("Destroying Update Loop")

    local c1: RBXScriptConnection?, c2: RBXScriptConnection? = tickConn, renderConn
    if c1 and c2 then
        c1:Disconnect()
        c2:Disconnect()

        tickConn = nil
        renderConn = nil
    end

    isUpdateLoopActive = false
end


--[=[
    Get if Toybox's update loop is currently active.

    @return boolean -- Whether or not the update loop is active.
]=]
function Engine.GetIsLoopActive(): boolean
    return isUpdateLoopActive
end


--[=[
    Steps a single time through the update loop.
]=]
function Engine.StepUpdateOnce()
    engineLogger:Assert(not isUpdateLoopActive, "Can only step if update loop is inactive.")

    local c1: RBXScriptConnection?, c2: RBXScriptConnection? = nil, nil

    engineLogger:Warn("StepUpdateOnce called")

    local input, tick, interp, render = 0, 0, 0, 0
    c1 = RunService.PreSimulation:Connect(function(delta: number)
        -- Input
        local t1 = os.clock()
        executeInput(delta)
        input = os.clock() - t1

        -- Tick
        local t2 = os.clock()
        executeTick(delta)
        tick = os.clock() - t2

        if c1 then
            c1:Disconnect()
        end
    end)
    
    c2 = RunService.PostSimulation:Connect(function(delta: number)
        -- Interpolation
        local t1 = os.clock()
        executeInterp(delta)
        interp = os.clock() - t1

        -- Render
        local t2 = os.clock()
        executeRender(delta)
        render = os.clock() - t2

        Stats.PushTimes(input, tick, interp, render)

        if c2 then
            c2:Disconnect()
        end
    end)
end


return Engine