--!strict
--[[
    Input.luau
    2/26/26
    @gluGPU
--]]

local UserInputService = game:GetService("UserInputService")

local BaseService = require("./BaseService")
local Logger = require("../Classes/Logger")

local ActionGroup = require("@self/ActionGroup")

export type ActionGroupObject = ActionGroup.ActionGroupObject

export type Input = {
    CreateActionGroup: (groupId: string) -> (ActionGroupObject),
    GetActionGroup: (groupId: string) -> (ActionGroupObject)
}

local logger = Logger.new("Input", true)
local Input = BaseService.new() :: BaseService.BaseService & Input

local actionGroups = {}


function Input.Init()
    logger:Print("Initializing...")

    Input.Initialized = true
    Input._executeInitHooks()
end


function Input.CreateActionGroup(groupId: string): ActionGroupObject
    
end


function Input.GetActionGroup(groupId: string): ActionGroupObject
    
end


return Input