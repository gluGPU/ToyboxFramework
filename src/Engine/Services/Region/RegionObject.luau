--!strict
--[[
    RegionObject.luau
    2/13/26
    @gluGPU

    RegionObjects are a collection of various level datas including geometry and scripts.
--]]

local RegionObject = {}
RegionObject.__index = RegionObject

export type RegionScript = (self: RegionObject, ...any?) -> (...any?)

type RegionObjectData = {
    -- metadata
    WorldName: string,
    TimeLoaded: number,
    

    -- World Data
    _preloadScripts: {[string]: RegionScript},
    _worldScripts: {[string]: RegionScript},

    _worldGeo: Folder,
    _lightingData: Folder,


    -- Hooks
    _destroyHooks: {() -> ()},

    
    -- Methods
    Destroy: (self: RegionObject) -> (),

    LoadWorld: (self: RegionObject) -> (),
    UnloadWorld: (self: RegionObject) -> (),

    GetPreloadScript: (self: RegionObject, scriptName: string) -> (RegionScript),
    GetScript: (self: RegionObject, scriptName: string) -> (RegionScript),

    RunScripts: (self: RegionObject) -> (),
    RunPreloadScripts: (self: RegionObject) -> (),
}

export type RegionObject = typeof(setmetatable({} :: RegionObjectData, RegionObject))


function RegionObject.new(worldName: string): RegionObject
    local self: RegionObject = setmetatable({} :: RegionObjectData, RegionObject)
    return self
end


function RegionObject.Destroy(self: RegionObject)
    for _, callback in self._destroyHooks do
        callback()
    end
    
    setmetatable(self, nil)
    table.clear(self)
end


function RegionObject.LoadWorld(self: RegionObject)
    
end


function RegionObject.UnloadWorld(self: RegionObject)
    
end


function RegionObject.GetPreloadScript(self: RegionObject, scriptName: string): RegionScript
    return self._preloadScripts[scriptName]
end


function RegionObject.GetScript(self: RegionObject, scriptName: string): RegionScript
    return self._worldScripts[scriptName]
end


function RegionObject.RunScripts(self: RegionObject)
    for _, s in self._worldScripts do
        s(self)
    end
end


function RegionObject.RunPreloadScripts(self: RegionObject)
    for _, s in self._preloadScripts do
        s(self)
    end
end


return RegionObject