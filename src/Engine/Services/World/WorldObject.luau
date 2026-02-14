--[[
    WorldObject.luau
    2/13/26
    @gluGPU

    WorldObjects are a collection of various level datas including geometry and scripts.
--]]

export type WorldScript = (...any?) -> (...any?)

export type WorldObject = {
    -- metadata
    Name: string,
    TimeLoaded: number,
    

    _preloadScripts: {[string]: WorldScript},
    _worldScripts: {[string]: WorldScript},

    
    
}

local WorldObject = {}
WorldObject.__index = WorldObject


function WorldObject.new()
    
end


function WorldObject.GetScript(scriptName: string): WorldScript
    
end


return WorldObject