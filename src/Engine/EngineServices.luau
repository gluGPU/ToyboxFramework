--[[
    Engine Services to Load
--]]

local SERVICES = {
    ReplicationClient = require("./Services/ReplicationClient"),
    ReplicationServer = require("./Services/ReplicationServer"),
    World = require("./Services/World"),
    Tick = require("./Services/Tick"),
    
    -- TestingService = require("./Services/TestService"),
    -- TestingService2 = require("./Services/TestService2")
}

local PRE_SIMULATION = {
    "Tick"
}

local POST_SIMULATION = {

}

local PRE_RENDER = {
    "Tick"
}

return {
    Services = SERVICES,
    PreSimulationPriority = PRE_SIMULATION,
    PostSimulationPriority = POST_SIMULATION,
    PreRenderPriority = PRE_RENDER
}