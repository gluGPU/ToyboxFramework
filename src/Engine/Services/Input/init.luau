--[[
    Input.luau
    2/26/26
    @gluGPU
--]]

local UserInputService = game:GetService("UserInputService")

local BaseService = require("./BaseService")
local Logger = require("../Classes/Logger")

export type Input = {

}

local logger = Logger.new("Input", true)
local Input = BaseService.new() :: BaseService.BaseService & Input


function Input.Init()
    logger:Print("Initializing...")

    Input.Initialized = true
    Input._executeInitHooks()
end


return Input