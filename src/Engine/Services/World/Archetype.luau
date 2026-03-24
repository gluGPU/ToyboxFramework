--!strict
--[[
    Archetype.luau
    3/21/26
    @gluGPU
--]]


local Archetype = {}
Archetype.__index = Archetype

local archetypeId = 1


type ArchetypeData = {
    _id: number
}

export type ArchetypeObject = typeof(setmetatable({} :: ArchetypeData, Archetype))


function Archetype.new(): ArchetypeObject
    local self = setmetatable({} :: ArchetypeData, Archetype)
    
    self._id = archetypeId

    archetypeId += 1
    return self
end


return Archetype