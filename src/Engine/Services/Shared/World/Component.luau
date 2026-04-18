--!strict
--[[
    Component.luau
    3/21/26
    @gluGPU
--]]


local Component = {}
Component.__index = Component

local componentId = 1


type ComponentData<T> = {
    _id: number
}

export type ComponentObject<T> = typeof(setmetatable({} :: ComponentData<T>, Component))


function Component.new<T>(componentData: T): ComponentObject<T>
    local self = setmetatable({} :: ComponentData<T>, Component)

    self._id = componentId

    componentId += 1
    return self
end


return Component