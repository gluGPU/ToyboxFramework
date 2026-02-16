--!strict
--[[
    WorldObject.luau
    2/13/26
    @gluGPU

    WorldObjects are a collection of various level datas including geometry and scripts.
--]]

local WorldObject = {}
WorldObject.__index = WorldObject

export type WorldScript = (self: WorldObject, ...any?) -> (...any?)

type WorldObjectData = {
    -- metadata
    WorldName: string,
    TimeLoaded: number,
    

    -- World Data
    _preloadScripts: {[string]: WorldScript},
    _worldScripts: {[string]: WorldScript},

    _worldGeo: Folder,
    _lightingData: Folder,

    
    -- Methods
    Destroy: (self: WorldObject) -> (),

    LoadWorld: (self: WorldObject) -> (),
    UnloadWorld: (self: WorldObject) -> (),

    GetPreloadScript: (self: WorldObject, scriptName: string) -> (WorldScript),
    GetScript: (self: WorldObject, scriptName: string) -> (WorldScript),

    RunScripts: (self: WorldObject) -> (),
    RunPreloadScripts: (self: WorldObject) -> (),
}

export type WorldObject = typeof(setmetatable({} :: WorldObjectData, WorldObject))


function WorldObject.new(worldName: string): WorldObject
    local self: WorldObject = setmetatable({} :: WorldObjectData, WorldObject)
    return self
end


function WorldObject.Destroy(self)
    setmetatable(self, nil)
    table.clear(self)
end


function WorldObject.LoadWorld(self: WorldObject)
    
end


function WorldObject.UnloadWorld(self: WorldObject)
    
end


function WorldObject.GetPreloadScript(self: WorldObject, scriptName: string): WorldScript
    return self._preloadScripts[scriptName]
end


function WorldObject.GetScript(self: WorldObject, scriptName: string): WorldScript
    return self._worldScripts[scriptName]
end


function WorldObject.RunScripts(self: WorldObject)
    for _, s in self._worldScripts do
        s(self)
    end
end


function WorldObject.RunPreloadScripts(self: WorldObject)
    for _, s in self._preloadScripts do
        s(self)
    end
end


return WorldObject