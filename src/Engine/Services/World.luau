--!strict
--[[
    World.luau
    2/21/26
    @gluGPU

    
--]]

local BaseService = require("./BaseService")
local EngineTypes = require("../EngineTypes")
local Logger = require("../Classes/Logger")

local Arbiter = require("../Libraries/Impulse/luau-physics/narrowphase/Arbiter")
local Body = require("../Libraries/Impulse/luau-physics/Body")
local Bvh = require("../Libraries/Impulse/luau-physics/broadphase/Bvh")
local Hull = require("../Libraries/Impulse/luau-physics/narrowphase/Hull")
local Mpr = require("../Libraries/Impulse/luau-physics/narrowphase/Mpr")

export type Arbiter = Arbiter.Arbiter
export type Body = Body.Body
export type Bvh = Bvh.Bvh<Body>
export type Support = Hull.Support

export type RaycastResult = {
    Instance: Body,
    Position: vector,
    Normal: vector,
    Distance: number
}

export type World = {
    Gravity: number,

    _numActive: number,
    _arbiters: {},
    _active: {boolean},
    _bodies: {Body},
    _bvh: Bvh,

    ExecuteBroadphase: (delta: number) -> (),
    IntegrateForces: (delta: number) -> (),
    IntegrateConstraints: (delta: number) -> (),
    IntegrateBodies: (delta: number) -> (),
    Step: (delta: number) -> ()
}

local World = BaseService.new() :: BaseService.BaseService & World
World.Gravity = 196.2
World._numActive = 0
World._bvh = Bvh.new() :: Bvh
World._bodies = {} :: {Body}
World._active = {} :: {boolean}
World._arbiters = {} :: {Arbiter}

local logger = Logger.new("World")

function World.Init(e: EngineTypes.Engine)
    logger:Print("Initializing...")
end


function World.ExecuteBroadphase(delta: number)
    
end


function World.IntegrateForces(delta: number)
    
end


function World.IntegrateConstraints(delta: number)
    
end


function World.IntegrateBodies(delta: number)
    
end


function World.Step(delta: number)
    World.ExecuteBroadphase(delta)
    World.IntegrateForces(delta)
    World.IntegrateConstraints(delta)
    World.IntegrateBodies(delta)
end


return World