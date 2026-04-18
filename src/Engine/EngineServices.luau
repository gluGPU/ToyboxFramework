--[[
    Engine Services to Load
--]]

local ServerStorage = game:GetService("ServerStorage")

local services = script.Parent.Services
local client = services.Client
local shared = services.Shared

local serverServices = ServerStorage.Engine.Services.Server


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

type function GetAvailableServices(isClient: type)
    if isClient == types.singleton(true) then
        return types.string
    else
        return types.singleton(nil)
    end
end

return SERVICES