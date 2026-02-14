--[[
    World.luau
    1/11/26
    @gluGPU

    
--]]

local WorldObject = require("@self/WorldObject")

local World = {}
World.Loaded = {}
World.WorldFolder = nil
World.__index = World


export type WorldObject = {
    
}


function World.Init()
    
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