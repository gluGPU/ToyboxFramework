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

Engine.IsUpdateLoopActive = false
Engine._tickConn = nil :: RBXScriptConnection?
Engine._renderConn = nil :: RBXScriptConnection?

export type Engine = typeof(Engine)

function Engine.Init(configOverrides: {[string]: any}?)
    -- print("Starting main initialization")
    engineLogger:Print("Starting engine init")

    local config = Engine.Config
    local services = Engine.Services

    if isStudio and configOverrides then
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


local executeTick = Tick.ExecuteTickCallbacks
local executeInterp = Tick.ExecuteInterpCallbacks
local executeRender = Tick.ExecuteRenderCallbacks
function Engine.CreateUpdateLoop()
    engineLogger:Assert(Engine.Initialized, "Engine has not initialized yet.")
    engineLogger:Assert(not Engine.IsUpdateLoopActive, "Engine loop is already active.")

    Engine.IsUpdateLoopActive = true

    engineLogger:Warn("Creating Update Loop")

    local c1, c2 = nil, nil

    c1 = RunService.PreSimulation:Connect(function(delta: number)
        executeTick(delta)
    end)

    c2 = RunService.PreRender:Connect(function(delta: number)
        executeInterp(delta)
        executeRender(delta)
    end)

    Engine._tickConn = c1
    Engine._renderConn = c2
end


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


function Engine.StepUpdateOnce()
    engineLogger:Assert(not Engine.IsUpdateLoopActive, "Can only step if update loop is inactive.")

    local c1: RBXScriptConnection?, c2: RBXScriptConnection? = nil, nil

    engineLogger:Warn("StepUpdateOnce called")

    c1 = RunService.PreSimulation:Connect(function(delta: number)
        executeTick(delta)

        c1:Disconnect()
        c1 = nil
    end)
    
    c2 = RunService.PostSimulation:Connect(function(delta: number)
        executeInterp(delta)
        executeRender(delta)

        c2:Disconnect()
        c2 = nil
    end)
end


return Engine