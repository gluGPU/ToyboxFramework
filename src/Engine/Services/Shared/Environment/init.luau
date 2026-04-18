--[[
    Environment.luau
    2/23/26
    @gluGPU
--]]

local BaseService = require("../BaseService")
local Logger = require("../../Classes/Logger")

export type Environment = {

}

local Environment = BaseService.new() :: BaseService.BaseService & Environment

local logger = Logger.new("Environment")


function Environment.Init()
    
end


return Environment