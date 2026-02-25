--[[
    Debug.luau
    2/25/26
    @gluGPU
--]]

local RunService = game:GetService("RunService")

local BaseService = require("./BaseService")
local Logger = require("../Classes/Logger")
local Iris = require("../Libraries/Iris/lib")

export type Debug = {
    Iris: typeof(Iris.Init())
}

local isClient = RunService:IsClient()

local logger = Logger.new("Debug", true)
local Debug = BaseService.new() :: BaseService.BaseService & Debug
if isClient then
    Debug.Iris = Iris.Init()
end

function Debug.Init()
    logger:Print("Initializing...")

    Debug.Initialized = true
    Debug._executeInitHooks()
end


return Debug