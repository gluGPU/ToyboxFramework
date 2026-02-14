--[[
    InitServer.luau
    1/11/26
    @gluGPU

    Initialize the Engine on the Server
--]]

local Config = require(".././Config")
local Engine = require(".././Engine")

print("Start Init - Server")

Engine.Init()

print("Init Complete - Server")