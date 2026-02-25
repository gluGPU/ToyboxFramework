--[[
    Engine Services to Load
--]]

local SERVICES = {
    Debug = require("./Services/Debug"),
    Replication = require("./Services/Replication"),
    -- ReplicationClient = require("./Services/ReplicationClient"),
    -- ReplicationServer = require("./Services/ReplicationServer"),
    Region = require("./Services/Region"),
    World = require("./Services/World"),
    -- Tick = require("./Services/Tick"),

    TestingService = require("./Services/TestService"),
    TestingService2 = require("./Services/TestService2")
}

return SERVICES