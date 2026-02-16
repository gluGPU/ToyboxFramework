--[[
    Engine.luau
    1/11/26
    @gluGPU

    Framework
--]]

-- Dependencies
local RunService = game:GetService("RunService")

local Config = require("./EngineConfig")
local Services = require("./EngineServices")
local Types = require("./EngineTypes")


-- Vars
local isClient = RunService:IsClient()
local isServer = RunService:IsServer()
local isStudio = RunService:IsStudio()

local Engine = {}
Engine.Services = Services
Engine.Config = Config
Engine.Types = Types

function Engine.Init(configOverrides: {[string]: any}?)
    print("Starting main initialization")

    local config = Engine.Config

    if isStudio and configOverrides then
        for i, v in configOverrides do
            config[i] = v
        end

        if isClient then
            print("Engine (Client): CLIENT Testing Config Overrides")
        elseif isServer then
            print("Engine (Server): SERVER Testing Config Overrides")
        end

        print(configOverrides)
    end

    for i, module in config.Modules do
        module.Init(Engine)
    end
end

return Engine