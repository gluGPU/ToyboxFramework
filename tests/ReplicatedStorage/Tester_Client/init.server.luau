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

-- print("Hey Hey Hey")
local rc = EngineServices.ReplicationClient
rc.OnInitialized(function()
    rc.ObserveReplicatorTag("hello", function() print("yo") end)
end)

local Tick = EngineServices.Tick
warn("yaya")
Engine.OnInitialized(function()
    Engine.CreateUpdateLoop()

    warn("Gosh diddly darn it!")

    Tick.BindToTick("Hello", 5, function(delta: number)
        -- warn(Tick.CurrentTick, "Wassup", delta)
    end)

    Tick.BindToTick("Hello2", 10, function(delta: number)
        -- warn(Tick.CurrentTick, "This is second")
    end)

    Tick.BindToInterpolation("Hello", 5, function(alpha: number)
        -- warn("Interp step", string.format("%.3f", alpha))
    end)

    Tick.BindToInterpolation("Hello2", 6, function(alpha: number)
        -- warn("Second")
    end)

    return function(e: Engine.Engine)
        -- print("Cleanup Hook Called")
    end
end)

-- EngineServices.ReplicationServer.CreateReplicator("hello", {})