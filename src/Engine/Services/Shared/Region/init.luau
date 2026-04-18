--!strict
--[[
    Region.luau
    1/11/26
    @gluGPU
--]]

local CollectionService = game:GetService("CollectionService")

local BaseService = require("../BaseService")
local EngineConfig = require("../../EngineConfig")
local Logger = require("../../Classes/Logger")
local RegionObject = require("./Region/RegionObject")
local Strings = require("../../Util/Strings")

export type RegionObject = RegionObject.RegionObject
  
export type Region = {
    SetRegionFolder: (folder: Folder) -> (),

    CreateRegion: (regionName: string) -> (),
    GetRegion: (regionName: string) -> (RegionObject?),
    GetCurrentRegions: () -> ({RegionObject})
}

export type RegionRbxInstances<PreloadType, ScriptType, CollectionType> = (Model | Folder) & {
    PreloadScripts: Folder & PreloadType,
    Scripts: Folder & ScriptType,
    RegionCollection: Folder & CollectionType
}

local Region = BaseService.new() :: BaseService.BaseService & Region

local loadedRegions: {[string]: RegionObject} = {}
local regionDataFolder: Folder? = nil
local maxLoadedRegions: number = 16
local currentLoadedRegions: number = 0

local nonReplicatingParent = workspace.CurrentCamera


local logger = Logger.new("Region", true)


function Region.Init(configs: EngineConfig.ConfigType)
    logger:Print("Initializing...")
    maxLoadedRegions = configs.MAX_LOADED_REGIONS

    for _, region in CollectionService:GetTagged(configs.REGION_TAG_NAME) do
        
    end

    Region.Initialized = true
    Region._executeInitHooks()
end


function Region.SetRegionFolder(folder: Folder)
    regionDataFolder = folder
end


function Region.CreateRegion(regionName: string)--: RegionObject?
    logger:AssertIfUninitialized(Region)
    logger:Assert(
        currentLoadedRegions < maxLoadedRegions,
        Strings.ERR_TOO_MANY_REGIONS
    )

    

    currentLoadedRegions += 1
end


function Region.GetRegion(regionName: string): RegionObject?
    logger:AssertIfUninitialized(Region)
    return loadedRegions[regionName] or nil
end


function Region.GetCurrentRegions(): {[string]: RegionObject}
    logger:AssertIfUninitialized(Region)
    return loadedRegions
end


return Region