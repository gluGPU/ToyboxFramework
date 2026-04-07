--[[
    Engine Services to Load
--]]

local SERVICES = {
    Audio = require("./Services/Audio"),
    Debug = require("./Services/Debug"),
    Replication = require("./Services/Replication"),
    Region = require("./Services/Region"),
    World = require("./Services/World"),
    Physics = require("./Services/Physics")
}

return SERVICES