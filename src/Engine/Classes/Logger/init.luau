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


--[=[
    @class Logger
]=]
local Logger = {}
Logger.__index = Logger


type LoggerData = {
    _loggerId: string,
    _env: string,
    IsStudioOnly: boolean,
    
    Destroy: (self: Logger) -> (),

    Assert: <T>(self: Logger, v: T, msg: string) -> (),
    AssertIfUninitialized: (self: Logger, t: {Initialized: boolean}) -> (),
    AssertIfNotClient: (self: Logger) -> (),
    AssertIfNotServer: (self: Logger) -> (),
    Print: <T>(self: Logger, ...T) -> (),
    Warn: <T>(self: Logger, ...T) -> (),
}

export type Logger = typeof(setmetatable({} :: LoggerData, Logger))


--[=[
    Instantiates a new <code>Logger</code>.

    @param loggerId string -- The identifier of the <code>Logger</code>.
    @param isStudioOnly boolean? -- If <code>true</code>, the <code>Logger</code> will only print when running in Studio.
]=]
function Logger.new(loggerId: string, isStudioOnly: boolean?): Logger
    local self: Logger = setmetatable({} :: LoggerData, Logger)

    self._loggerId = loggerId
    self._env = isClient and "Client" or isServer and "Server" or "???"
    self.IsStudioOnly = (isStudioOnly ~= nil and isStudioOnly) or false

    return self
end


--[=[
    Destroys the Logger.
]=]
function Logger.Destroy(self)
    setmetatable(self, nil)
    table.clear(self)
end


--[=[
    Performs an assertion. If the given value doesn't evaluate to <code>true</code> or it is <code>nil</code>, then an error will be produced.

    @param v T -- The value to assert. If the value is <code>false</code> or <code>nil</code>, an error will be produced.
    @param msg string -- The message to display in the output if the assertion doesn't pass.
]=]
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


--[=[
    Intended only for methods of Toybox services. Given the table, if <code>t.Initialized</code> is <code>false</code>, then an error is produced.

    @param t {Initialized: boolean} -- A table with the <code>Initialized</code> key.
]=]
function Logger.AssertIfUninitialized(self: Logger, t: {Initialized: boolean})
    if not t.Initialized then
        local tLine, tName = debug.info(assertLevel, assertOptions)

        error(string.format(
            uninitializedPrefix, self._env, self._loggerId, tName, tLine
        ))
    end
end


--[=[
    Quick method to assert for client-sided methods. If not running on the client, then an error is produced.
]=]
function Logger.AssertIfNotClient(self: Logger)
    if not isClient then
        local line, name = debug.info(assertLevel, assertOptions)
        error(string.format(
            notClientPrefix, self._env, self._loggerId, name, line
        ))
    end
end


--[=[
    Quick method to assert for server-sided methods. If not running on the server, then an error is produced.
]=]
function Logger.AssertIfNotServer(self: Logger)
    if not isServer then
        local line, name = debug.info(assertLevel, assertOptions)
        error(string.format(
            notServerPrefix, self._env, self._loggerId, name, line
        ))
    end
end


--[=[
    Prints to the engine output with the specified arguments. If <code>Logger.IsStudioOnly</code> is <code>true</code> then this will only show up in Studio.

    @param params Tuple -- Values to be output to the console.
]=]
function Logger.Print<T>(self: Logger, ...: T)
    if self.IsStudioOnly and not isStudio then
        return
    end

    print(string.format(normalPrefix, self._env, self._loggerId), ...)
end


--[=[
    Prints to the engine output with the specified arguments with special formatting. If <code>Logger.IsStudioOnly</code> is <code>true</code> then this will only show up in Studio.

    @param params Tuple -- Values to be output to the console.
]=]
function Logger.Warn<T>(self: Logger, ...: T)
    if self.IsStudioOnly and not isStudio then
        return
    end

    warn(string.format(warnPrefix, self._env, self._loggerId), ...)
end


return Logger