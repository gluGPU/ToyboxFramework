--!strict
--[[
    BaseEngine.luau
    2/16/26
    @gluGPU
--]]

local EngineConfig = require("../EngineConfig")

local BaseService = {}
BaseService.__index = BaseService

export type BaseService = {
    Initialized: boolean,
    _initHooks: {() -> ()},

    Init: (configs: EngineConfig.ConfigType) -> (),
    OnInitialized: (callback: () -> ()) -> (),
    _executeInitHooks: () -> (),
}


--[=[
    Creates a new <code>BaseService</code> table.

    @return service BaseService -- A table containing the essentials for a service in Toybox.
]=]
function BaseService.new(): BaseService
    local t = {} :: BaseService
    t.Initialized = false
    t._initHooks = {}

    function t.OnInitialized(callback: () -> ())
        if t.Initialized then
            callback()
        else
            table.insert(t._initHooks, callback)
        end
    end

    function t._executeInitHooks()
        for _, callback in t._initHooks do
            callback()
        end
    end

    return t :: BaseService
end

return BaseService