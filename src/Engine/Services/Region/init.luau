--!strict
--[[
    Region.luau
    1/11/26
    @gluGPU

    
--]]

local BaseService = require("./BaseService")
local EngineTypes = require("../EngineTypes")
local Logger = require(".././Classes/Logger")
local RegionObject = require("@self/RegionObject")

export type RegionObject = RegionObject.RegionObject
  
export type Region = {
    _loadedRegions: {RegionObject},
    _regionDataFolder: Folder?,
    _maxLoadedRegions: number,

    SetRegionFolder: (folder: Folder) -> (),
    FindRegion: (RegionName: string) -> (),
    LoadRegion: (RegionName: string) -> (),
    GetCurrentRegions: () -> ({RegionObject})
}

local Region = BaseService.new() :: BaseService.BaseService & Region
Region._loadedRegions = {}
Region._regionDataFolder = nil
Region._maxLoadedRegions = 16


local logger = Logger.new("Region", true)


function Region.Init(e: EngineTypes.Engine)
    logger:Print("Initializing...")
    Region._maxLoadedRegions = e.Config.MAX_LOADED_REGIONS

    Region.Initialized = true
    Region._executeInitHooks()
end


function Region.SetRegionFolder(folder: Folder)
    Region._regionDataFolder = folder
end


function Region.FindRegion(RegionName: string)
    
end


function Region.LoadRegion(RegionName: string)
    
end


function Region.GetCurrentRegions(): {RegionObject}
    return Region._loadedRegions
end


return Region