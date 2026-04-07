--!strict
--[[
    Property.luau
    4/5/26
    @gluGPU

    The Property class allows you to create easily observable properties for your own classes.
--]]


--[=[
    @class Property
]=]
local Property = {}
Property.__index = Property


type PropertyData<ValueType> = {
    Value: ValueType?,
    _observers: {[(value: ValueType?) -> ()]: boolean},
    _observerCleanups: {() -> ()},

    Set: (self: Property<ValueType>, value: ValueType?) -> nil,
    Observe: (self: Property<ValueType>, callback: (value: ValueType) -> () -> (), valueGuard: (value: ValueType?) -> boolean) -> () -> (),
}

export type Property<ValueType> = typeof(setmetatable({} :: PropertyData<ValueType>, Property))


--[=[
    Instantiates a new <code>Property</code> with the given value.

    @param value ValueType? -- The value of the <code>Property</code>.
    @return Property
]=]
function Property.new<ValueType>(value: ValueType?): Property<ValueType>
    local self = setmetatable({
        Value = value,
        _observers = {},
        _observerCleanups = {}
    } :: PropertyData<ValueType>, Property)

    return self
end


--[=[
    Fires attached observer cleanups, then destroys the <code>Property</code>.
]=]
function Property.Destroy<ValueType>(self: Property<ValueType>)
    for _, cleanup in self._observerCleanups do
        cleanup()
    end

    table.clear(self._observers)
    table.clear(self._observerCleanups)

    setmetatable(self, nil)
    table.clear(self)
end


--[=[
    Sets <code>Property.Value</code> and fires all attached observers. If <code>value</code> matches <code>Property.Value</code> then nothing will happen.

    ```lua
    local p = Property.new("Hello World")
    p:Set("Goodbye!") -- Fires any attached observers
    p:Set("Goodbye!") -- Doing this won't do anything.
    ```

    @param value ValueType? -- The new value of the <code>Property</code>.
]=]
function Property.Set<ValueType>(self: Property<ValueType>, value: ValueType?)
    if self.Value and value and self.Value == value then
        return
    end

    self.Value = value

    for observer in self._observers do
        observer(value)
    end
end


--[=[
    Allows you to observe changes to <code>Property.Value</code>. The given callback should return a cleanup function that gets called whenever the value is changed.

    ```lua
    local p = Property.new(5)

    -- :Observe() returns a cleaner function you can call if you want to stop observing.
    local cleaner = p:Observe(function(value: ValueType)
        -- The main body of the observer function.
        print("New value!", value)

        return function()
            -- This is where you should clean up any script connections or objects.
            print("Cleanup")
        end
    end)

    p:Set(10) -- Prints "Cleanup", then "New value! 10"

    cleaner()
    p:Set(30) -- Since we called the cleaner function, our p:Observe() from earlier stops getting called.
    ```

    
    @param callback (value: ValueType) -> () -> () -- Callback that gets fired whenever <code>Property:Set()</code> is called, returning a cleaner function that is called the next time <code>:Set()</code> runs.
    @param valueGuard (value: ValueType) -> boolean -- Gets fired before your observer function to see if the value is valid. If this returns <code>true</code>, then your observer will run. Does not affect cleanup.
    @return () -> () -- Cleaner function to stop observing the <code>Property</code>.
]=]
function Property.Observe<ValueType>(self: Property<ValueType>, callback: (value: ValueType) -> () -> (), valueGuard: (value: ValueType?) -> boolean): () -> ()
    local cleaner: () -> ()? = nil
    local currentId = 0
    local connected: boolean? = true

    local function observe(value: ValueType?)
        if cleaner then
            cleaner()
            cleaner = nil
        end

        currentId += 1
        local thisId = currentId

        if valueGuard(value) then
            local newCleaner = callback(value)
            if thisId == currentId and connected then
                cleaner = newCleaner
            else
                newCleaner()
            end
        end
    end

    self._observers[observe] = true
    observe(self.Value)

    local function observerCleanup()
        if connected then
            connected = nil
            self._observers[observe] = nil
            if cleaner then
                cleaner()
                cleaner = nil
            end
        end
    end

    table.insert(self._observerCleanups, observerCleanup)

    return observerCleanup
end

return Property