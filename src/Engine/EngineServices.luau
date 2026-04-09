--[[
    Engine Services to Load
--]]

local Audio = require("./Services/Audio")
local Debug = require("./Services/Debug")
local Replication = require("./Services/Replication")
local Region = require("./Services/Region")
local World = require("./Services/World")
local Physics = require("./Services/Physics")

local SERVICES = {
    Audio = Audio,
    Debug = Debug,
    Replication = Replication,
    Region = Region,
    World = World,
    Physics = Physics
}

export type ServicesType = {
    Audio: typeof(Audio),
    Debug: typeof(Debug),
    Replication: typeof(Replication),
    Region: typeof(Region),
    World: typeof(World),
    Physics: typeof(Physics),
}

return SERVICES