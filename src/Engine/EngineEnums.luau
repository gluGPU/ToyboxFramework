--!strict
--[[
    EngineEnums.luau
--]]

local EnumItem = {}
EnumItem.__index = EnumItem

local Enum = {}
Enum.__index = Enum

type EnumItemData<EnumType, ValueType> = {
    read Name: string,
    read EnumType: EnumType,
    read Value: ValueType,
}


type EnumData<EnumType, Keys, ValueType> = {
    [Keys]: EnumItem<EnumType, ValueType>,

    read EnumType: EnumType,
    read GetEnumItems: (self: Enum<EnumType, Keys, ValueType>) -> {},
}

export type EnumItem<EnumType, ValueType> = typeof(setmetatable({} :: EnumItemData<EnumType, ValueType>, EnumItem))
export type Enum<EnumType, Keys, ValueType> = typeof(setmetatable({} :: EnumData<EnumType, Keys, ValueType>, Enum))


function EnumItem.new<EnumType, ValueType>(name: string, enumType: EnumType, value: ValueType): EnumItem<EnumType, ValueType>
    local self = setmetatable({
        Name = name,
        EnumType = enumType,
        Value = value
    } :: EnumItemData<EnumType, ValueType>, EnumItem)

    table.freeze(self)
    return self
end


function Enum.new<EnumType, Keys, ValueType>(enumType: EnumType, enumData: {[Keys]: ValueType}): Enum<EnumType, Keys, ValueType>
    local self = setmetatable({
        EnumType = enumType
    } :: EnumData<EnumType, Keys, ValueType>, Enum)
    
    for key, value in enumData do
        self[key] = EnumItem.new(key, enumType, value)
    end

    table.freeze(self)
    return self
end


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


return {
    ReplicationAction = Enum.new("ReplicationAction", ReplicationAction) :: Enum<"ReplicationAction", keyof<typeof(ReplicationAction)>, number>,
    TickPriority = Enum.new("TickPriority", TickPriority) :: Enum<"TickPriority", keyof<typeof(TickPriority)>, number>,
    EcsStages = Enum.new("EcsStages", EcsStages) :: Enum<"EcsStages", keyof<typeof(EcsStages)>, number>,
    AudioGroups = Enum.new("AudioGroups", AudioGroups) :: Enum<"AudioGroups", keyof<typeof(AudioGroups)>, number>,
    DebuggingLabels = Enum.new("DebuggingLabels", DebuggingLabels) :: Enum<"DebuggingLabels", keyof<typeof(DebuggingLabels)>, string>
}