--!strict
--[[
    Observer.luau
    4/5/26
    @gluGPU
--]]


local Observer = {}
Observer.__index = Observer


type ObserverData<ValueType> = {
    _observers: {[(value: ValueType?) -> ()]: boolean},
    _observerCleanups: {() -> ()}
}


function Observer.Observe<Object, ValueType>(
    self: Object & ObserverData<ValueType>, keyToObserve: string,
    callback: (value: ValueType) -> () -> (),
    valueGuard: (value: ValueType?) -> boolean
): () -> ()
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
    observe(self[keyToObserve])

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

function Observer.CreateObserverFn(objectToObserve, keyToObserve: string)
    return Observer.Observe(objectToObserve, keyToObserve, callback, valueGuard)
end

return Observer