--!strict
--[[
    System.luau
    3/21/26
    @gluGPU
--]]


local EngineEnums = require("../../EngineEnums")


local System = {}
System.__index = System

type SystemData = {
    
}

export type SystemObject = typeof(setmetatable({} :: SystemData, System))

function System.new(stage: index<typeof(EngineEnums.EcsStages), keyof<typeof(EngineEnums.EcsStages)>>): SystemObject
    local self = setmetatable({} :: SystemData, System)

    

    return self
end



return System