--[[
    InitClient.luau
    1/11/26
    @gluGPU

    Initialize the Engine on the Client
--]]

local Engine = require(".././Engine")

if not game:IsLoaded() then
    game.Loaded:Wait()
end

print("Start Init - Client")

Engine.Init()

print("Init Complete - Client")