--[[
    World.luau
    1/11/26
    @gluGPU

    
--]]

local EngineTypes = require("../EngineTypes")

local Logger = require(".././Classes/Logger")
local WorldObject = require("@self/WorldObject")
export type WorldObject = WorldObject.WorldObject

local World = {}
World._loadedWorlds = table.create(16, nil :: WorldObject)
World._worldDataFolder = nil
World.__index = World


local logger = Logger.new("World", true)


function World.Init(e: EngineTypes.Engine)
    logger:Print("Initializing...")
end


function World.SetWorldFolder(folder: Instance)
    World.WorldFolder = folder
end


function World.FindWorld(worldName: string)
    
end


function World.LoadWorld(worldName: string)
    
end


function World.GetCurrentWorlds()
    
end


return World