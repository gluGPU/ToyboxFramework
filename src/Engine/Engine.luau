--[[
    Engine.luau
    1/11/26
    @gluGPU

    Framework
--]]

-- Dependencies
local Config = require("./Config")



local Engine = {}
Engine.Modules = Config.MODULES
Engine.__index = Engine

function Engine.Init()
    print("Starting main initialization")

    for name, module in Engine.Modules do
        module.Init()
    end
end

return Engine