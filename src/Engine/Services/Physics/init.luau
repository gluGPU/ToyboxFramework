--!strict
--[[
    Physics.luau
    3/25/26
    @gluGPU
--]]


local LuauPhysics = require("../Libraries/Impulse/luau-physics")
local BaseService = require("./BaseService")
local EngineTypes = require("../EngineTypes")

local World = LuauPhysics.World

export type Physics = {
    World: typeof(World),

    SetGravity: (gravity: number) -> ()
}


local Physics = BaseService.new() :: BaseService.BaseService & Physics
Physics.World = World


function Physics.Init(e: EngineTypes.Engine)
    -- e.Tick.BindToTick("Toybox-StepImpulse", 1500, function(delta: number)
    --     World.step(delta)
    -- end)

    Physics.Initialized = true
    Physics._executeInitHooks()
end


function Physics.SetGravity(gravity: number)
    World.Gravity = gravity
end


return Physics