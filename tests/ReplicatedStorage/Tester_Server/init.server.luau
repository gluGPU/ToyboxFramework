--[[
    Tester_Server.luau
    2/15/26
    @gluGPU

    Testing file for server functionality of engine.
--]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Engine = require(ReplicatedStorage.Engine.Engine)

Engine.OnInitialized(function()
    local Replication = Engine.Services.Replication
    local rState = Replication.Server.CreateReplicatedState("ReallyAwesome", Players:GetPlayers(), 0)

    rState:ObserveState(function(newState: number)
        warn(rState.Name.. "Server: ".. newState)

        -- local n = 0
        -- local c: RBXScriptConnection? = nil

        -- c = RunService.PostSimulation:Connect(function(delta: number)
        --     n += delta
        --     print(n)
        -- end)

        return function()
            -- if c then
            --     c:Disconnect()
            -- end
        end
    end)

    task.defer(function()
        local counter = 0
        while true do
            task.wait(0.333)

            counter += 1
            rState:ChangeState(counter)
        end
    end)

    Players.PlayerAdded:Connect(function(player: Player)
        rState:AddPlayers({player})
    end)
end)
