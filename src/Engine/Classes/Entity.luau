--[[
    Entity.luau
    2/6/26
    @gluGPU

    An Entity represents an ID that can be used to access Components. lalala.
--]]

local Strings = require("../Util/Strings")

local MAX_ENTITIES = 100

local Entity = {
    _MAX_ENTITIES = MAX_ENTITIES,

    EntityCount = 0,
    AvailableEntities = table.create(MAX_ENTITIES, true),
    Components = table.create(MAX_ENTITIES)
}

function Entity:CreateEntity()
    assert(Entity.EntityCount < MAX_ENTITIES, string.format(Strings.ERR_TOO_MANY_ENTITIES, MAX_ENTITIES))


end

return Entity