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
local Strings = require("../Util/Strings")

export type RegionObject = RegionObject.RegionObject
  
export type Region = {
    _loadedRegions: {[string]: RegionObject},
    _regionDataFolder: Folder?,
    _maxLoadedRegions: number,
    _currentLoadedRegions: number,

    SetRegionFolder: (folder: Folder) -> (),

    CreateRegion: (regionName: string) -> (),
    GetRegion: (regionName: string) -> (RegionObject?),
    GetCurrentRegions: () -> ({RegionObject})
}

local Region = BaseService.new() :: BaseService.BaseService & Region
Region._loadedRegions = {}
Region._regionDataFolder = nil
Region._maxLoadedRegions = 16
Region._currentLoadedRegions = 0


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


function Region.CreateRegion(regionName: string): RegionObject?
    logger:AssertIfUninitialized(Region)
    logger:Assert(
        Region._currentLoadedRegions < Region._maxLoadedRegions,
        Strings.ERR_TOO_MANY_REGIONS
    )

    

    Region._currentLoadedRegions += 1
end


function Region.GetRegion(regionName: string): RegionObject?
    logger:AssertIfUninitialized(Region)
    return Region._loadedRegions[regionName] or nil
end


function Region.GetCurrentRegions(): {[string]: RegionObject}
    logger:AssertIfUninitialized(Region)
    return Region._loadedRegions
end


return Region