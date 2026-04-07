--!strict
--[[
    EngineEnums.luau
--]]

local Enum = require("./Classes/Enum")

export type Enum<EnumType, Keys, ValueType> = Enum.Enum<EnumType, Keys, ValueType>
export type EnumItem<EnumType, ValueType> = Enum.EnumItem<EnumType, ValueType>

-- enums
local ReplicationAction = {
    Set = 0, Update = 1
}

local TickPriority = {
    Default = 1000
}

local EcsStages = {
    Process = 0,
    Perform = 1,
    Render = 2
}

local AudioGroups = {
    Sound = 0,
    Music = 1,
    Ambient = 2,
    Voice = 3
}

local DebuggingLabels = {
    TICK_UPDATE_INPUT_CALLBACKS = "TOYBOX-UPDATE_INPUT_CALLBACKS",
    TICK_UPDATE_TICKING_CALLBACKS = "TOYBOX-UPDATE_TICK_CALLBACKS",
    TICK_UPDATE_INTERP_CALLBACKS = "TOYBOX-UPDATE_INTERP_CALLBACKS",
    TICK_UPDATE_RENDER_CALLBACKS = "TOYBOX-UPDATE_RENDER_CALLBACKS",
    
    TICK_RUN_INPUT_STEP = "TOYBOX-RUN_INPUT_STEP",
    TICK_RUN_TICK_STEP = "TOYBOX-RUN_TICK_STEP",
    TICK_RUN_INTERP_STEP = "TOYBOX-RUN_INTERP_STEP",
    TICK_RUN_RENDER_STEP = "TOYBOX-RUN_RENDER_STEP"
}


local enums = {
    ReplicationAction = Enum.new("ReplicationAction", ReplicationAction) :: Enum<"ReplicationAction", keyof<typeof(ReplicationAction)>, number>,
    TickPriority = Enum.new("TickPriority", TickPriority) :: Enum<"TickPriority", keyof<typeof(TickPriority)>, number>,
    EcsStages = Enum.new("EcsStages", EcsStages) :: Enum<"EcsStages", keyof<typeof(EcsStages)>, number>,
    AudioGroups = Enum.new("AudioGroups", AudioGroups) :: Enum<"AudioGroups", keyof<typeof(AudioGroups)>, number>,
    DebuggingLabels = Enum.new("DebuggingLabels", DebuggingLabels) :: Enum<"DebuggingLabels", keyof<typeof(DebuggingLabels)>, string>
}

table.freeze(enums)
return enums