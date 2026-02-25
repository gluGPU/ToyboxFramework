--[[
    Tester_Client.luau
    2/15/26
    @gluGPU

    Testing file for client functionality of engine.
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Engine = require(ReplicatedStorage.Engine.Engine)
local EngineServices = Engine.Services

EngineServices.TestingService.OnInitialized(function()
    -- warn("TestingService Init")
end)

EngineServices.TestingService2.OnInitialized(function()
    -- warn("TestingService2 Init")
end)

local Tick = Engine.Tick
warn("yaya")
Engine.OnInitialized(function()
    Engine.CreateUpdateLoop()

    warn("Gosh diddly darn it!")

    Tick.BindToTick("Hello", 5, function(delta: number)
        -- warn(Tick.CurrentTick, "Tick Start", delta)
    end)

    Tick.BindToTick("Hello2", 10, function(delta: number)
        -- warn(Tick.CurrentTick, "Tick2")
    end)

    Tick.BindToInterpolation("Hello", 5, function(alpha: number)
        -- warn("Interp step", string.format("%.3f", alpha))
    end)

    Tick.BindToInterpolation("Hello2", 6, function(alpha: number)
        -- warn("Interp2")
    end)

    Tick.BindToRender("Hello", 5, function(delta: number)
        -- warn("Render step", string.format("%.3f", delta))
    end)

    Tick.BindToRender("Hello2", 6, function()
        -- warn("Render2 (final)")
    end)

    -- task.spawn(function()
    --     while true do
    --         task.wait(3)
    --         Engine.DestroyUpdateLoop()
    --         task.wait(3)
    --         Engine.CreateUpdateLoop()
    --     end
    -- end)

    -- test replication
    local Replication = Engine.Services.Replication
    Replication.OnReplicatedStateCreated:Connect(function(rState)
        rState:ObserveState(function(newState)
            warn(newState)
        end)
    end)
end)

-- EngineServices.ReplicationServer.CreateReplicator("hello", {})