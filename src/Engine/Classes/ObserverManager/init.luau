--!strict
--[[
    ObserverManager.luau
    3/22/26
    @gluGPU
--]]

local ObserverManager = {}
ObserverManager.__index = ObserverManager

type ObserverManagerData = {
    _observers: {},

    Destroy: (self: ObserverManagerData) -> (),

    CreateObserver: (self: ObserverManagerObject, observerId: string) -> (),
    FireObserver: (self: ObserverManagerObject, observerId: string) -> (),
    Observe: (self: ObserverManagerObject, observerId: string) -> (),
}

export type ObserverManagerObject = typeof(setmetatable({} :: ObserverManagerData, ObserverManager))


function ObserverManager.new(object: {[string]: any}): ObserverManagerObject
    local self = setmetatable({} :: ObserverManagerData, ObserverManager)

    self._observers = {
        example = function(foo: string, bar: number)
            
        end
    }

    return self
end


function ObserverManager.Destroy(self: ObserverManagerData)
    setmetatable(self, nil)
    table.clear(self)
end


function ObserverManager.CreateObserver<T>(self: ObserverManagerObject, observerId: string)
    
end


function ObserverManager.FireObserver(self: ObserverManagerObject, observerId: string, ...)
    
end


function ObserverManager.Observe(self: ObserverManagerObject, observerId: string)


    
end


return ObserverManager