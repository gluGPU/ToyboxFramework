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

Engine.Services = Services.Services
Engine.Config = Config
Engine.Types = Types

Engine.PreSimCallbacks = table.create(#Services.PreSimulationPriority)
Engine.PostSimCallbacks = table.create(#Services.PostSimulationPriority)
Engine.PreRenderCallbacks = table.create(#Services.PreRenderPriority)

Engine.IsUpdateLoopActive = false
Engine._preSimConn = nil :: RBXScriptConnection?
Engine._postSimConn = nil :: RBXScriptConnection?
Engine._preRenderConn = nil :: RBXScriptConnection?

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

    for i, module in services do
        local preSim = table.find(Services.PreSimulationPriority, i)
        if preSim and module.PreSimulation then
            Engine.PreSimCallbacks[preSim] = module.PreSimulation
        end

        local postSim = table.find(Services.PostSimulationPriority, i)
        if postSim and module.PostSimulation then
            Engine.PostSimCallbacks[postSim] = module.PostSimulation
        end

        local preRender = table.find(Services.PreRenderPriority, i)
        if preRender and module.PreRender then
            Engine.PreRenderCallbacks[preRender] = module.PreRender
        end
        
        module.Init(Engine)
    end

    warn("Running init stuff")
    Engine.Initialized = true
    for _, callback in Engine.InitializationHooks do
        warn("Yo")
        local cleanup = callback(Engine)
        if cleanup then
            table.insert(Engine.CleanupHooks, cleanup)
        end
    end
end


function Engine.RegisterService()
    
end


function Engine.OnInitialized(callback: (Engine) -> ((Engine) -> ()?))
    warn("called")
    if Engine.Initialized then
        warn("just run it")
        local cleanup = callback(Engine)
        if cleanup then
            table.insert(Engine.CleanupHooks, cleanup)
        end
    else
        warn('add it')
        table.insert(Engine.InitializationHooks, callback)
    end
end


local function executeCallbacks(delta: number, t: {(...any?) -> (...any?)})
    for _, fn in t do
        fn(delta)
    end
end


function Engine.CreateUpdateLoop()
    engineLogger:Assert(Engine.Initialized, "Engine has not initialized yet.")
    engineLogger:Assert(not Engine.IsUpdateLoopActive, "Engine loop is already active.")

    Engine.IsUpdateLoopActive = true

    engineLogger:Print("Creating Update Loop")

    local c1, c2, c3 = nil, nil, nil
    local t1, t2, t3 = Engine.PreSimCallbacks, Engine.PostSimCallbacks, Engine.PreRenderCallbacks

    c1 = RunService.PreSimulation:Connect(function(delta: number)
        executeCallbacks(delta, t1)
    end)

    c2 = RunService.PostSimulation:Connect(function(delta: number)
        executeCallbacks(delta, t2)
    end)

    c3 = RunService.PreRender:Connect(function(delta: number)
        executeCallbacks(delta, t3)
    end)

    Engine._preSimConn = c1
    Engine._postSimConn = c2
    Engine._preRenderConn = c3
end


function Engine.DestroyUpdateLoop()
    engineLogger:Assert(Engine.IsUpdateLoopActive, "Engine loop is not active.")
    engineLogger:Print("Destroying Update Loop")

    local c1: RBXScriptConnection?, c2: RBXScriptConnection?, c3: RBXScriptConnection? = Engine._preSimConn, Engine._postSimConn, Engine._preRenderConn
    if c1 and c2 and c3 then
        c1:Disconnect()
        c2:Disconnect()
        c3:Disconnect()

        Engine._preSimConn = nil
        Engine._postSimConn = nil
        Engine._preRenderConn = nil

        c1 = nil
        c2 = nil
        c3 = nil
    end

    Engine.IsUpdateLoopActive = false
end


function Engine.StepUpdateOnce()
    engineLogger:Assert(not Engine.IsUpdateLoopActive, "Can only step if update loop is inactive.")

    local c1: RBXScriptConnection?, c2: RBXScriptConnection?, c3: RBXScriptConnection? = nil, nil, nil
    local t1, t2, t3 = Engine.PreSimCallbacks, Engine.PostSimCallbacks, Engine.PreRenderCallbacks

    engineLogger:Print("Begin Loop Step")
    
    c1 = RunService.PreSimulation:Connect(function(delta: number)
        executeCallbacks(t1)
        c1:Disconnect()
        c1 = nil
    end)
    
    c2 = RunService.PostSimulation:Connect(function(delta: number)
        executeCallbacks(t2)
        c2:Disconnect()
        c2 = nil
    end)

    c3 = RunService.PreRender:Connect(function(delta: number)
        executeCallbacks(t3)
        c3:Disconnect()
        c3 = nil
    end)
end


return Engine