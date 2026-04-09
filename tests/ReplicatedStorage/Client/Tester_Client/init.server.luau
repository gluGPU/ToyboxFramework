--[[
    Tester_Client.luau
    2/15/26
    @gluGPU

    Testing file for client functionality of engine.
--]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Engine = require(ReplicatedStorage.Engine.Engine)
local EngineServices = Engine.Services

local Tick = Engine.Tick
Engine.OnInitialized(function()
    Engine.CreateUpdateLoop()

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
    local array = {}
    Replication.OnReplicatedStateCreated:Connect(function(rState)
        rState:ObserveState(function(newState)
            -- warn(rState.Name.. "Client: ".. newState)

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

        rState:OnDestroying(function()
            local i = table.find(array, rState)
            if i then
                table.remove(i)
            end
        end)

        table.insert(array, rState)
    end)

    local Debug = Engine.Services.Debug
    local Iris = Debug.Iris

    Iris:Connect(function()
        local windowSize = Iris.State(Vector2.new(250, 500))

        Iris.Window({"Toybox - Debug View"}, {size = windowSize})

            Iris.Tree({"Tick Info"})
                Iris.Text({"Tick Rate: ".. 1 / Tick.GetTickRate()})
                Iris.Text({string.format("Tick Speed: %.3f", Tick.GetTickSpeed())})
                Iris.Text({"Current Tick: ".. Tick.GetCurrentTick()})
                -- Iris.Text({string.format("Current Interp: %.3f", Tick.Get / (Tick.TickRate / Tick.TickSpeed))})
            Iris.End()

            Iris.Tree({"Replication Info"})
                Iris.Text({"# of RStates: ".. #array})
                Iris.Tree({"ReplicatedStates"})
                    for _, rState in array do
                        Iris.Text({string.format(
                            "%i: %s -- %*", rState.Id, rState.Name, rState.State
                        )})
                    end
                Iris.End()
            Iris.End()

        Iris.End()
    end)
end)

-- EngineServices.ReplicationServer.CreateReplicator("hello", {})