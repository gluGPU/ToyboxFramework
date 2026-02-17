--[[
    Logger.luau
    2/16/26
    @gluGPU

    Inspired by VEngine Logger
--]]

local RunService = game:GetService("RunService")
local Strings = require("../Util/Strings")

local normalPrefix = Strings.LOGGER_PREFIX
local assertPrefix = Strings.LOGGER_ASSERTION_PREFIX
local warnPrefix = Strings.LOGGER_WARNING_PREFIX

local isClient = RunService:IsClient()
local isServer = RunService:IsServer()
local isStudio = RunService:IsStudio()

local Logger = {}
Logger.__index = Logger


type LoggerData = {
    _loggerId: string,
    _env: string,
    IsStudioOnly: boolean,
    
    Destroy: (self: Logger) -> (),

    Assert: <T>(self: Logger, v: T, msg: string) -> (),
    Print: <T>(self: Logger, ...T) -> (),
    Warn: <T>(self: Logger, ...T) -> ()
}

export type Logger = typeof(setmetatable({} :: LoggerData, Logger))


function Logger.new(loggerId: string, isStudioOnly: boolean?): Logger
    local self: Logger = setmetatable({} :: LoggerData, Logger)

    self._loggerId = loggerId
    self._env = isClient and "Client" or isServer and "Server" or "???"
    self.IsStudioOnly = (isStudioOnly ~= nil and isStudioOnly) or false

    return self
end


function Logger.Destroy(self)
    setmetatable(self, nil)
    table.clear(self)
end


function Logger.Assert<T>(self: Logger, v: T, msg: string)
    if self.IsStudioOnly and not isStudio then
        return
    end

    if not v then
        error(string.format(
            assertPrefix, self._env, self._loggerId, msg
        ))
    end
end


function Logger.Print<T>(self: Logger, ...: T)
    if self.IsStudioOnly and not isStudio then
        return
    end

    print(string.format(normalPrefix, self._env, self._loggerId), ...)
end


function Logger.Warn<T>(self: Logger, ...: T)
    if self.IsStudioOnly and not isStudio then
        return
    end

    warn(string.format(warnPrefix, self._env, self._loggerId), ...)
end


return Logger