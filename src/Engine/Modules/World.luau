--[[
    World.luau
    1/11/26
    @gluGPU

    World module manages simulation time-stepping.
--]]

local World = {}
World.CurrentTick = 0
World.__index = World

function World.Init()
    print("init world")
end




function World.BindToSimulation()
    
end

return World