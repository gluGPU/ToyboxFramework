--[[
    Tick.luau
    2/15/26
    @gluGPU
--]]

local EngineTypes = require("../EngineTypes")
local Logger = require("../Classes/Logger")

local Tick = {}
Tick._lastUpdated = os.clock()
Tick._lastTick = 0
Tick.CurrentTick = 0
Tick.TickRate = 1 / 100
Tick.TickSpeed = 1
Tick.__index = Tick


local logger = Logger.new("Tick", true)


function Tick.Init(e: EngineTypes.Engine)
    logger:Print("Initializing...")
end


function Tick.PreSimulation(delta: number)
    -- simulation step
    local rate = Tick.TickRate
    local speed = Tick.TickSpeed

    local accumulated = os.clock() - Tick._lastUpdated
	local numTicks = Tick.GetNumTicksForDelta(accumulated, rate, speed)
	
    local currentTick = Tick.CurrentTick

	if numTicks > 0 then
		for i = 1, numTicks do
            --[[
            TODO

			for _, funcs in ordered do
				if not funcs.TickCallback then continue end
				funcs.TickCallback(tickRate)
			end
            --]]
			
			currentTick += 1
		end
		
        Tick.CurrentTick = currentTick
        Tick._lastUpdated += (numTicks * rate / speed)
	end
end


function Tick.PreRender(delta: number)
    -- interpolation step
    local accumulated = os.clock() - Tick._lastUpdated
    local currentTick = Tick.CurrentTick
    local lastTick = currentTick - 1

	local alpha = math.lerp(
		lastTick, currentTick,
		accumulated / Tick.TickRate * Tick.TickSpeed
	) - lastTick
	
    --[[
    TODO

	for _, funcs in Tick.OrderedCallbacks do
		if not funcs.InterpolationCallback then continue end
		funcs.InterpolationCallback(alpha)
	end
    --]]
end


function Tick.GetNumTicksForDelta(delta: number, tickRate: number, speed: number): number
    return math.floor(delta / tickRate * speed)
end


function Tick.BindToTick()
    
end


return Tick