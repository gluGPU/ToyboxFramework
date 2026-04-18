--!strict
--[[
    ActionGroup.luau
    3/24/26
    @gluGPU
--]]


local Logger = require("../../Classes/Logger")

local ActionGroup = {}
ActionGroup.__index = ActionGroup


type ActionGroupData = {
    read _id: string,

    Enabled: boolean,

    Actions: {},

    SetEnabled: (self: ActionGroupObject, isEnabled: boolean) -> (),

    BindAction: (self: ActionGroupObject, actionName: string) -> (),
    UnbindAction: (self: ActionGroupObject, actionName: string) -> (),
}

export type ActionGroupObject = typeof(setmetatable({} :: ActionGroupData, ActionGroup))


function ActionGroup.new(groupId: string, isEnabled: boolean?): ActionGroupObject
    local self: ActionGroupObject = setmetatable({
        _id = groupId,
    } :: ActionGroupData, ActionGroup)

    self.Enabled = if isEnabled and isEnabled == true then true else false

    self.Actions = {}

    return self
end


function ActionGroup.SetEnabled(self: ActionGroupObject, isEnabled: boolean)
    
end


function ActionGroup.BindAction(self: ActionGroupObject, actionName: string)
    
end


function ActionGroup.UnbindAction(self: ActionGroupObject, actionName: string)
    
end


return ActionGroup