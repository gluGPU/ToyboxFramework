--[[
    Tester_Server.luau
    2/15/26
    @gluGPU

    Testing file for server functionality of engine.
--]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Engine = require(ReplicatedStorage.Engine.Engine)

Engine.OnInitialized(function()
    local Replication = Engine.Services.Replication
    local rs = Replication.Server.CreateReplicatedState("ReallyAwesome", Players:GetPlayers(), 0)

    task.defer(function()
        local counter = 0
        while true do
            task.wait(0.333)

            counter += 1
            rs:ChangeState(counter)
        end
    end)

    Players.PlayerAdded:Connect(function(player: Player)
        rs:AddPlayers({player})
    end)
end)
