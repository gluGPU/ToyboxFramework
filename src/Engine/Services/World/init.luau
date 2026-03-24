--!strict
--[[
    World.luau
    3/21/26
    @gluGPU

    ECS Framework
--]]

local BaseService = require("./BaseService")
local EngineTypes = require("../EngineTypes")
local Logger = require("../Classes/Logger")

local Archetype = require("@self/Archetype")
local Component = require("@self/Component")
local System = require("@self/System")

export type World = {
    RegisterComponent: () -> (),
    RegisterSystem: () -> ()
}


local logger = Logger.new("Input", true)
local World = BaseService.new() :: BaseService.BaseService & World


function World.Init()
    logger:Print("Initializing...")
    World.Initialized = true
    World._executeInitHooks()
end


function World.RegisterComponent()
    
end


function World.RegisterSystem()
    
end


return World