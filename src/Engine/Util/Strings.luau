--[[
    Strings.luau
    2/6/26
    @gluGPU
--]]

return {
    LOGGER_PREFIX = "[Toybox%s: %s]",
    LOGGER_ASSERTION_PREFIX = "[Toybox%s: %s] ASSERTION FAILED: %s",
    LOGGER_WARNING_PREFIX = "[Toybox%s: %s] WARNING:",
    LOGGER_NOT_CLIENT_PREFIX = "[Toybox%s: %s] %s:%s can only be called on the client.",
    LOGGER_NOT_SERVER_PREFIX = "[Toybox%s: %s] %s:%s can only be called on the server.",
    LOGGER_NOT_INITIALIZED = "[Toybox%s: %s] %s:%s can only be called after service initialization.",

    ERR_TOO_MANY_ENTITIES = "[Toybox%s: %s] Too many entities--max number of entities is %s!"
}