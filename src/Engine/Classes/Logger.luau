--[[
    Logger.luau
    2/16/26
    @gluGPU

    Class providing extra print functions.
--]]

local RunService = game:GetService("RunService")
local Strings = require("../Util/Strings")

local normalPrefix = Strings.LOGGER_PREFIX
local assertPrefix = Strings.LOGGER_ASSERTION_PREFIX
local warnPrefix = Strings.LOGGER_WARNING_PREFIX
local notClientPrefix = Strings.LOGGER_NOT_CLIENT_PREFIX
local notServerPrefix = Strings.LOGGER_NOT_SERVER_PREFIX
local uninitializedPrefix = Strings.LOGGER_NOT_INITIALIZED

local isClient = RunService:IsClient()
local isServer = RunService:IsServer()
local isStudio = RunService:IsStudio()

local assertLevel = 2
local assertOptions = "ln"

local Logger = {}
Logger.__index = Logger


type LoggerData = {
    _loggerId: string,
    _env: string,
    IsStudioOnly: boolean,
    
    Destroy: (self: Logger) -> (),

    Assert: <T>(self: Logger, v: T, msg: string) -> (),
    AssertIfNotClient: (self: Logger) -> (),
    AssertIfNotServer: (self: Logger) -> (),
    Print: <T>(self: Logger, ...T) -> (),
    Warn: <T>(self: Logger, ...T) -> (),
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


function Logger.AssertIfUninitialized(self: Logger, t: {Initialized: boolean})
    if not t.Initialized then
        local tLine, tName = debug.info(assertLevel, assertOptions)

        error(string.format(
            uninitializedPrefix, self._env, self._loggerId, tName, tLine
        ))
    end
end


function Logger.AssertIfNotClient(self: Logger)
    if not isClient then
        local line, name = debug.info(assertLevel, assertOptions)
        error(string.format(
            notClientPrefix, self._env, self._loggerId, name, line
        ))
    end
end


function Logger.AssertIfNotServer(self: Logger)
    if not isServer then
        local line, name = debug.info(assertLevel, assertOptions)
        error(string.format(
            notServerPrefix, self._env, self._loggerId, name, line
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