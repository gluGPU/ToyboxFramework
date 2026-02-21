--[[
    InitServer.luau
    1/11/26
    @gluGPU

    Initialize the Engine on the Server
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Engine = require(ReplicatedStorage.Engine.Engine)

print("Start Init - Server")

Engine.Init()

print("Init Complete - Server")