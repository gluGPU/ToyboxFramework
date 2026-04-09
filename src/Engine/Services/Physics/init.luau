--!strict
--[[
    Physics.luau
    3/25/26
    @gluGPU
--]]

local EngineConfig = require("../EngineConfig")
local LuauPhysics = require("../Libraries/Impulse/luau-physics")
local BaseService = require("./BaseService")

local World = LuauPhysics.World

export type Physics = {
    World: typeof(World),

    SetGravity: (gravity: number) -> ()
}


local Physics = BaseService.new() :: BaseService.BaseService & Physics
Physics.World = World


function Physics.Init(configs: EngineConfig.ConfigType)
    e.Tick.BindToTick("Toybox-StepImpulse", 1500, function(delta: number)
        World.step(delta)
    end)

    Physics.Initialized = true
    Physics._executeInitHooks()
end


function Physics.SetGravity(gravity: number)
    World.Gravity = gravity
end


return Physics