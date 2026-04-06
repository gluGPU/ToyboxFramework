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
local Types = require("./EngineTypes")


-- Vars
local isClient = RunService:IsClient()
local isServer = RunService:IsServer()
local isStudio = RunService:IsStudio()

local engineLogger = Logger.new("Engine")

local Engine = {}

Engine.Initialized = false
Engine.InitializationHooks = {} :: {(Engine) -> ((Engine) -> ()?)}
Engine.CleanupHooks = {} :: {(Engine) -> ()}

Engine.Services = Services
Engine.Config = Config
Engine.Types = Types
Engine.Tick = Tick
Engine.Stats = Stats

Engine.IsUpdateLoopActive = false
Engine._tickConn = nil :: RBXScriptConnection?
Engine._renderConn = nil :: RBXScriptConnection?

export type Engine = typeof(Engine)

--[=[
    Initializes Toybox configurations and services, then calls engine initialization hooks.

    @param configOverrides {[string]: any}? -- A dictionary that overrides engine configs listed in EngineConfigs.luau.
]=]
function Engine.Init(configOverrides: {[string]: any}?)
    -- print("Starting main initialization")
    engineLogger:Print("Starting engine init")

    local config = Engine.Config
    local services = Engine.Services

    if configOverrides then
        for i, v in configOverrides do
            config[i] = v
        end

        engineLogger:Print("Config Overrides Applied")
        print(configOverrides)
    end

    -- initialize main systems
    Tick.Init(Engine)

    -- initialize auxillary services
    for i, module in services do
        module.Init(Engine)
    end

    Engine.Initialized = true
    for _, callback in Engine.InitializationHooks do
        local cleanup = callback(Engine)
        if cleanup then
            table.insert(Engine.CleanupHooks, cleanup)
        end
    end
end


--[=[
    Allows you to hook into the engine's post-initialization phase to reduce race conditions.

    @param callback (Engine) -> ((Engine) -> ()?) -- The callback to call after the engine initializes.
]=]
function Engine.OnInitialized(callback: (Engine) -> ((Engine) -> ()?))
    if Engine.Initialized then
        local cleanup = callback()
        if cleanup then
            table.insert(Engine.CleanupHooks, cleanup)
        end
    else
        table.insert(Engine.InitializationHooks, callback)
    end
end


local executeInput = Tick.ExecuteInputCallbacks
local executeTick = Tick.ExecuteTickCallbacks
local executeInterp = Tick.ExecuteInterpCallbacks
local executeRender = Tick.ExecuteRenderCallbacks

--[=[
    Starts Toybox's update loop. For more information, see EngineTick.
]=]
function Engine.CreateUpdateLoop()
    engineLogger:Assert(Engine.Initialized, "Engine has not initialized yet.")
    engineLogger:Assert(not Engine.IsUpdateLoopActive, "Engine loop is already active.")

    Engine.IsUpdateLoopActive = true

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

    Engine._tickConn = c1
    Engine._renderConn = c2
end


--[=[
    Stops Toybox's update loop.
]=]
function Engine.DestroyUpdateLoop()
    engineLogger:Assert(Engine.IsUpdateLoopActive, "Engine loop is not active.")
    engineLogger:Warn("Destroying Update Loop")

    local c1: RBXScriptConnection?, c2: RBXScriptConnection? = Engine._tickConn, Engine._renderConn
    if c1 and c2 then
        c1:Disconnect()
        c2:Disconnect()

        Engine._tickConn = nil
        Engine._renderConn = nil

        c1 = nil
        c2 = nil
    end

    Engine.IsUpdateLoopActive = false
end


--[=[
    Steps a single time through the update loop.
]=]
function Engine.StepUpdateOnce()
    engineLogger:Assert(not Engine.IsUpdateLoopActive, "Can only step if update loop is inactive.")

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

        c1:Disconnect()
        c1 = nil
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

        c2:Disconnect()
        c2 = nil
    end)
end


return Engine