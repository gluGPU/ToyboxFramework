--[[
    Enum.luau
    4/5/26
    @gluGPU

    The <code>Enum</code> class allows you to create your own Enums.
--]]


--[=[
    @class EnumItem
    An item inside of an Enum.
]=]
local EnumItem = {}
EnumItem.__index = EnumItem


--[=[
    @class Enum
    
    The <code>Enum</code> class allows you to create your own enumerations. This helps reduce "magic values" around your codebase.
    The recommended use case to keep your <code>Enums</code> organized is to have a single ModuleScript that includes all the enums in your project, without any dependencies.
]=]
local Enum = {}
Enum.__index = Enum

type EnumItemData<EnumType, ValueType> = {
    read Name: string,
    read Value: ValueType,
}


type EnumData<EnumType, Keys, ValueType> = {
    [Keys]: EnumItem<EnumType, ValueType>,

    read EnumType: EnumType,

    read _enums: {[Keys]: EnumItem<EnumType, ValueType>},
    read _lookup: {[ValueType]: EnumItem<EnumType, ValueType>},

    read GetEnumItems: (self: Enum<EnumType, Keys, ValueType>) -> {[Keys]: EnumItem<EnumType, ValueType>},
    read FromValue: (self: Enum<EnumType, Keys, ValueType>, value: ValueType) -> EnumItem<EnumType, ValueType>
}

export type EnumItem<EnumType, ValueType> = typeof(setmetatable({} :: EnumItemData<EnumType, ValueType>, EnumItem))
export type Enum<EnumType, Keys, ValueType> = typeof(setmetatable({} :: EnumData<EnumType, Keys, ValueType>, Enum))


function EnumItem.new<EnumType, ValueType>(name: string, value: ValueType): EnumItem<EnumType, ValueType>
    local self = setmetatable({
        Name = name,
        Value = value
    } :: EnumItemData<EnumType, ValueType>, EnumItem)

    table.freeze(self)
    return self
end


--[=[
    Instantiates a new <code>Enum</code>.

    ```lua
    local enumData = {
        Value1 = 1,
        Value2 = 2
    }
    
    local e = Enum.new("EnumName", enumData)
    
    print(e.Value1.Value)
    print(e.Value2.Value)
    ```

    @param enumType EnumType -- The identifier for this <code>Enum</code>.
    @param enumData {[Keys]: ValueType} -- The dictionary to generate <code>EnumItems</code> from.
    @return Enum
]=]
function Enum.new<EnumType, Keys, ValueType>(enumType: EnumType, enumData: {[Keys]: ValueType}): Enum<EnumType, Keys, ValueType>
    local self = setmetatable({
        EnumType = enumType,
        _enums = {},
        _lookup = {}
    } :: EnumData<EnumType, Keys, ValueType>, Enum)
    
    for key, value in enumData do
        local newEnum = EnumItem.new(key, value)
        self[key] = newEnum
        self._enums[key] = newEnum
        self._lookup[value] = newEnum
    end

    table.freeze(self)
    table.freeze(self._enums)
    return self
end


--[=[
    Returns a dictionary of this <code>Enum</code>'s <code>EnumItems</code>.

    @return {[Keys]: EnumItem} -- A dictionary of the <code>Enum</code>'s keys and their corresponding <code>EnumItems</code>.
]=]
function Enum.GetEnumItems<EnumType, Keys, ValueType>(self: Enum<EnumType, Keys, ValueType>): {[Keys]: EnumItem<EnumType, ValueType>}
    return self._enums
end


--[=[
    Returns the corresponding <code>EnumItem</code> that matches the given value.

    @param value ValueType -- The value of the <code>EnumItem</code> that you want to retrieve.
    @return EnumItem -- The <code>EnumItem</code> that matches the given value.
]=]
function Enum.FromValue<EnumType, Keys, ValueType>(self: Enum<EnumType, Keys, ValueType>, value: ValueType): EnumItem<EnumType, ValueType>
    return self._lookup[value]
end


return Enum