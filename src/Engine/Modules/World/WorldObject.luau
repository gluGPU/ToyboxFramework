export type WorldObject = {
    -- metadata
    Name: string,
    TimeLoaded: number,
    

    PreloadScripts: {[string]: () -> ()},
    WorldScripts: {[string]: () -> ()},

    
}

local WorldObject = {}
WorldObject.__index = WorldObject

return WorldObject