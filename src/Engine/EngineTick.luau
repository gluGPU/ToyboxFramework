local Body = require("./Libraries/Impulse/luau-physics/Body")
--!strict
--[[
    EngineTick.luau
    2/15/26
    @gluGPU
--]]

local CalculateTicks = require("./Util/CalculateTicks")
local EngineEnums = require("./EngineEnums")
local EngineTypes = require("./EngineTypes")
local Logger = require("./Classes/Logger")

local DEFAULT_PRIORITY = EngineEnums.TickPriority.Default

local UPDATE_INPUT_CALLBACKS = EngineEnums.DebuggingLabels.TICK_UPDATE_INPUT_CALLBACKS
local UPDATE_TICKING_CALLBACKS = EngineEnums.DebuggingLabels.TICK_UPDATE_TICKING_CALLBACKS
local UPDATE_INTERP_CALLBACKS = EngineEnums.DebuggingLabels.TICK_UPDATE_INTERP_CALLBACKS
local UPDATE_RENDER_CALLBACKS = EngineEnums.DebuggingLabels.TICK_UPDATE_RENDER_CALLBACKS
local TICK_RUN_INPUT_STEP = EngineEnums.DebuggingLabels.TICK_RUN_INPUT_STEP
local TICK_RUN_TICK_STEP = EngineEnums.DebuggingLabels.TICK_RUN_TICK_STEP
local TICK_RUN_INTERP_STEP = EngineEnums.DebuggingLabels.TICK_RUN_INTERP_STEP
local TICK_RUN_RENDER_STEP = EngineEnums.DebuggingLabels.TICK_RUN_RENDER_STEP


export type Tick = EngineTypes.Tick

local Tick = {} :: Tick

Tick._namedCallbacksInput = {}
Tick._namedCallbacksTicking = {}
Tick._namedCallbacksInterp = {}
Tick._namedCallbacksRender = {}
Tick._orderedCallbacksInput = {}
Tick._orderedCallbacksTicking = {}
Tick._orderedCallbacksInterp = {}
Tick._orderedCallbacksRender = {}

Tick.TickRate = 1 / 100
Tick.TickSpeed = 1
Tick.MaxTicks = 10

Tick.CurrentTick = 0
Tick._currentDelta = 0

Tick.DoInterpolation = true

local logger = Logger.new("Tick", true)


type TempData = {Priority: number, Callback: (delta: number, ...any?) -> (...any?)}
local temp: {[number]: TempData} = {}
local function updateCallbacksTicking()
    logger:Print("Rebuilding ticking callbacks...")

    debug.profilebegin(UPDATE_TICKING_CALLBACKS)
    local ordered = Tick._orderedCallbacksTicking
    local named = Tick._namedCallbacksTicking

    table.clear(temp)
    table.clear(ordered)

    for _, data in named do
        local t = {Priority = data.Priority, Callback = data.Callback}
        table.insert(temp, t)
    end

    table.sort(temp, function(a: TempData, b: TempData)
        return a.Priority < b.Priority
    end)

    for _, data in temp do
        table.insert(ordered, data.Callback)
    end

    debug.profileend()
end

local temp2: {[number]: TempData} = {}
local function updateCallbacksInterp()
    logger:Print("Rebuilding interpolation callbacks...")

    debug.profilebegin(UPDATE_INTERP_CALLBACKS)
    local ordered = Tick._orderedCallbacksInterp
    local named = Tick._namedCallbacksInterp

    table.clear(temp2)
    table.clear(ordered)

    for _, data in named do
        local t = {Priority = data.Priority, Callback = data.Callback}
        table.insert(temp2, t)
    end

    table.sort(temp2, function(a: TempData, b: TempData)
        return a.Priority < b.Priority
    end)

    for _, data in temp2 do
        table.insert(ordered, data.Callback)
    end
end

local temp3: {[number]: TempData} = {}
local function updateCallbacksRender()
    logger:Print("Rebuilding rendering callbacks...")

    debug.profilebegin(UPDATE_RENDER_CALLBACKS)
    local ordered = Tick._orderedCallbacksRender
    local named = Tick._namedCallbacksRender

    table.clear(temp3)
    table.clear(ordered)

    for _, data in named do
        local t = {Priority = data.Priority, Callback = data.Callback}
        table.insert(temp3, t)
    end

    table.sort(temp3, function(a: TempData, b: TempData)
        return a.Priority < b.Priority
    end)

    for _, data in temp3 do
        table.insert(ordered, data.Callback)
    end
end

local temp4: {[number]: TempData} = {}
local function updateCallbacksInput()
    logger:Print("Rebuilding input callbacks...")

    debug.profilebegin(UPDATE_INPUT_CALLBACKS)
    local ordered = Tick._orderedCallbacksInput
    local named = Tick._namedCallbacksInput

    table.clear(temp4)
    table.clear(ordered)

    for _, data in named do
        local t = {Priority = data.Priority, Callback = data.Callback}
        table.insert(temp4, t)
    end

    table.sort(temp4, function(a: TempData, b: TempData)
        return a.Priority < b.Priority
    end)

    for _, data in temp4 do
        table.insert(ordered, data.Callback)
    end

    debug.profileend()
end

local array = Tick._orderedCallbacksTicking
local rate = Tick.TickRate
local max = Tick.MaxTicks
function Tick.Init(e: EngineTypes.Engine)
    logger:Print("Initializing...")

    Tick.TickRate = 1 / e.Config.TICK_RATE
    Tick.MaxTicks = e.Config.MAX_TICKS_PER_FRAME
    
    rate = Tick.TickRate
    max = Tick.MaxTicks

    Tick.DoInterpolation = e.Config.TICK_INTERPOLATION
end

local inputArray = Tick._orderedCallbacksInput
function Tick.ExecuteInputCallbacks(delta: number)
    debug.profilebegin(TICK_RUN_INPUT_STEP)

    local tickSpeed = Tick.TickSpeed

    for _, callback in inputArray do
        callback(delta * tickSpeed)
    end

    debug.profileend()
end

function Tick.ExecuteTickCallbacks(delta: number)
    debug.profilebegin(TICK_RUN_TICK_STEP)

    -- simulation step
    local speed = Tick.TickSpeed
    local accumulated = Tick._currentDelta + delta
	local numTicks = math.clamp(CalculateTicks(accumulated, rate, speed), 0, max)

	if numTicks > 0 then
		for i = 1, numTicks do
            Tick.CurrentTick += 1

			for _, callback in array do
                callback(rate)
            end

		end
		
        accumulated -= (numTicks * rate / speed)
	end

    Tick._currentDelta = accumulated

    debug.profileend()
end


local interpArray = Tick._orderedCallbacksInterp
function Tick.ExecuteInterpCallbacks(delta: number)
    debug.profilebegin(TICK_RUN_INTERP_STEP)

    -- interpolation step
    if Tick.DoInterpolation then
        local accumulated = Tick._currentDelta
        local alpha = accumulated / (rate / Tick.TickSpeed)

        for _, callback in interpArray do
            callback(alpha)
        end
    else
        for _, callback in interpArray do
            callback(1)
        end
    end
    

    debug.profileend()
end


local renderArray = Tick._orderedCallbacksRender
function Tick.ExecuteRenderCallbacks(delta: number)
    debug.profilebegin(TICK_RUN_RENDER_STEP)

    local tickSpeed = Tick.TickSpeed

    for _, callback in renderArray do
        callback(delta * tickSpeed)
    end

    debug.profileend()
end


-- Do not set tickspeed to 0 for pausing, you should
-- stop the engine loop entirely to pause
function Tick.SetTickSpeed(new: number)
    local old = Tick.TickSpeed
    Tick._currentDelta *= (old / new)
    Tick.TickSpeed = new
end


function Tick.BindToTick(name: string, priority: number, callback: (delta: number, ...any?) -> (...any?))
    local t = Tick._namedCallbacksTicking

    if not priority then
        priority = DEFAULT_PRIORITY
    end

    local existing = t[name]
    if existing then
        existing.Priority = priority
        existing.Callback = callback

        updateCallbacksTicking()
    else
        t[name] = {
            Priority = priority,
            Callback = callback
        }

        updateCallbacksTicking()
    end
end


function Tick.BindToInterpolation(name: string, priority: number, callback: (alpha: number, ...any?) -> (...any?))
    local t = Tick._namedCallbacksInterp

    if not priority then
        priority = DEFAULT_PRIORITY
    end

    local existing = t[name]
    if existing then
        existing.Priority = priority
        existing.Callback = callback

        updateCallbacksInterp()
    else
        t[name] = {
            Priority = priority,
            Callback = callback
        }

        updateCallbacksInterp()
    end
end


function Tick.BindToRender(name: string, priority: number, callback: (delta: number, ...any?) -> (...any?))
    local t = Tick._namedCallbacksRender

    if not priority then
        priority = DEFAULT_PRIORITY
    end

    local existing = t[name]
    if existing then
        existing.Priority = priority
        existing.Callback = callback

        updateCallbacksRender()
    else
        t[name] = {
            Priority = priority,
            Callback = callback
        }

        updateCallbacksRender()
    end
end


function Tick.BindToInput(name: string, priority: number, callback: (delta: number, ...any?) -> (...any?))
    local t = Tick._namedCallbacksInput

    if not priority then
        priority = DEFAULT_PRIORITY
    end

    local existing = t[name]
    if existing then
        existing.Priority = priority
        existing.Callback = callback

        updateCallbacksInput()
    else
        t[name] = {
            Priority = priority,
            Callback = callback
        }

        updateCallbacksInput()
    end
end


function Tick.UnbindFromTick(name: string, updateArray: boolean?)
    local t = Tick._namedCallbacksTicking
    local existing = t[name]
    if existing then
        table.clear(existing)
        t[name] = nil
    end

    if updateArray then
        updateCallbacksTicking()
    end
end


function Tick.UnbindFromInterpolation(name: string, updateArray: boolean?)
    local t = Tick._namedCallbacksInterp
    local existing = t[name]
    if existing then
        table.clear(existing)
        t[name] = nil
    end

    if updateArray then
        updateCallbacksInterp()
    end
end


function Tick.UnbindFromRender(name: string, updateArray: boolean?)
    local t = Tick._namedCallbacksRender
    local existing = t[name]
    if existing then
        table.clear(existing)
        t[name] = nil
    end

    if updateArray then
        updateCallbacksRender()
    end
end

function Tick.UnbindFromInput(name: string, updateArray: boolean?)
    local t = Tick._namedCallbacksInput
    local existing = t[name]
    if existing then
        table.clear(existing)
        t[name] = nil
    end

    if updateArray then
        updateCallbacksInput()
    end
end


function Tick.WaitInTicks(ticks: number)
    
end


function Tick.WaitInSeconds(seconds: number)
    
end


return Tick