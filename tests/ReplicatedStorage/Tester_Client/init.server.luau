--[[
    Tester_Client.luau
    2/15/26
    @gluGPU

    Testing file for client functionality of engine.
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Engine = require(ReplicatedStorage.Engine.Engine)
Engine.OnInitialized(function(e: Engine.Engine)
    print("--- Initialization Hook Called ---")
    Engine.CreateUpdateLoop()

    return function(e: Engine.Engine)
        print("Cleanup Hook Called")
    end
end)

local EngineServices = Engine.Services
local Replication = EngineServices.Replication