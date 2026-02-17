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
    print("TestingService Init")
end)

EngineServices.TestingService2.OnInitialized(function()
    print("TestingService2 Init")
end)

Engine.OnInitialized(function(e: Engine.Engine)
    Engine.CreateUpdateLoop()

    return function(e: Engine.Engine)
        -- print("Cleanup Hook Called")
    end
end)

