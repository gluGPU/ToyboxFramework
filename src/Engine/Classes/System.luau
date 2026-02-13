--[[
    System.luau
    2/6/26
    @gluGPU

    A type of object that holds and acts on Entities and their Components.
    Keeping entities together in memory helps with data locality and software efficiency.
--]]

local System = {}
System.__index = System

function System.new()
    local self = setmetatable({}, System)
    return self
end

return System