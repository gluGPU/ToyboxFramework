--[[
    World.luau
    1/11/26
    @gluGPU

    
--]]

local EngineTypes = require("../EngineTypes")
local WorldObject = require("@self/WorldObject")
export type WorldObject = WorldObject.WorldObject

local World = {}
World._loadedWorlds = table.create(16, nil :: WorldObject)
World._worldDataFolder = nil
World.__index = World


function World.Init(e: EngineTypes.Engine)
    
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