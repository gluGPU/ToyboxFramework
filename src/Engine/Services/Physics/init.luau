--[[
    Physics.luau
    3/25/26
    @gluGPU
--]]


local BaseService = require("./BaseService")


export type Physics = {

}


local Physics = BaseService.new() :: BaseService.BaseService & Physics


function Physics.Init()
    Physics.Initialized = true
    Physics._executeInitHooks()
end


return Physics