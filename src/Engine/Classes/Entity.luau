--[[
    Entity.luau
    2/6/26
    @gluGPU

    An Entity represents an ID that can be used to access components.
--]]

local Strings = require("../Util/Strings")

local MAX_ENTITIES = 1024

local Entity = {
    _MAX_ENTITIES = MAX_ENTITIES,

    EntityCount = 0,
    AvailableEntities = table.create(MAX_ENTITIES),
    Components = table.create(MAX_ENTITIES)
}

function Entity:CreateEntity()
    assert(Entity.EntityCount < MAX_ENTITIES, string.format(Strings.ERR_TOO_MANY_ENTITIES, MAX_ENTITIES))


end

return Entity