--!strict
--[[
    World.luau
    1/11/26
    @gluGPU

    
--]]

local BaseService = require("./BaseService")
local EngineTypes = require("../EngineTypes")
local Logger = require(".././Classes/Logger")
local WorldObject = require("@self/WorldObject")

export type WorldObject = WorldObject.WorldObject

export type World = {
    _loadedWorlds: {WorldObject},
    _worldDataFolder: Folder?,

    SetWorldFolder: (folder: Folder) -> (),
    FindWorld: (worldName: string) -> (),
    LoadWorld: (worldName: string) -> (),
    GetCurrentWorlds: () -> ({WorldObject})
}

local World = BaseService.new() :: BaseService.BaseService & World
World._loadedWorlds = {}
World._worldDataFolder = nil


local logger = Logger.new("World", true)


function World.Init(e: EngineTypes.Engine)
    logger:Print("Initializing...")
end


function World.SetWorldFolder(folder: Folder)
    World._worldDataFolder = folder
end


function World.FindWorld(worldName: string)
    
end


function World.LoadWorld(worldName: string)
    
end


function World.GetCurrentWorlds(): {WorldObject}
    return {}
end


return World