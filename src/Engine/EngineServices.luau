--[[
    Engine Services to Load
--]]

local SERVICES = {
    Replication = require("./Services/Replication"),
    World = require("./Services/World"),
    Tick = require("./Services/Tick"),
    TestService = require("./Services/TestService")
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