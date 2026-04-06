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

local UPDATE_INPUT_CALLBACKS = EngineEnums.DebuggingLabels.TICK_UPDATE_INPUT_CALLBACKS.Value
local UPDATE_TICKING_CALLBACKS = EngineEnums.DebuggingLabels.TICK_UPDATE_TICKING_CALLBACKS.Value
local UPDATE_INTERP_CALLBACKS = EngineEnums.DebuggingLabels.TICK_UPDATE_INTERP_CALLBACKS.Value
local UPDATE_RENDER_CALLBACKS = EngineEnums.DebuggingLabels.TICK_UPDATE_RENDER_CALLBACKS.Value
local TICK_RUN_INPUT_STEP = EngineEnums.DebuggingLabels.TICK_RUN_INPUT_STEP.Value
local TICK_RUN_TICK_STEP = EngineEnums.DebuggingLabels.TICK_RUN_TICK_STEP.Value
local TICK_RUN_INTERP_STEP = EngineEnums.DebuggingLabels.TICK_RUN_INTERP_STEP.Value
local TICK_RUN_RENDER_STEP = EngineEnums.DebuggingLabels.TICK_RUN_RENDER_STEP.Value

type DeltaCallbacks = {[string]: {
    Priority: number,
    Callback: (delta: number, ...any?) -> (...any?)
}}

type DeltaCallbacksOrdered = {[number]: (delta: number, ...any?) -> (...any?)}

type AlphaCallbacks = {[string]: {
    Priority: number,
    Callback: (alpha: number, ...any?) -> (...any?)
}}

type AlphaCallbacksOrdered = {[number]: (alpha: number, ...any?) -> (...any?)}

local Tick = {}

local namedCallbacksInput = {} :: DeltaCallbacks
local namedCallbacksTicking = {} :: DeltaCallbacks
local namedCallbacksInterp = {} :: AlphaCallbacks
local namedCallbacksRender = {} :: DeltaCallbacks
local orderedCallbacksInput = {}  :: DeltaCallbacksOrdered
local orderedCallbacksTicking = {} :: DeltaCallbacksOrdered
local orderedCallbacksInterp = {} :: AlphaCallbacksOrdered
local orderedCallbacksRender = {} :: DeltaCallbacksOrdered

local tickRate = 1 / 100
local tickSpeed = 1
local maxTicks = 10

local currentTick = 0
local currentDelta = 0

local doInterpolation = true

local logger = Logger.new("Tick", true)


type TempData = {Priority: number, Callback: (delta: number, ...any?) -> (...any?)}
local temp: {[number]: TempData} = {}
local function updateCallbacksTicking()
    logger:Print("Rebuilding ticking callbacks...")

    debug.profilebegin(UPDATE_TICKING_CALLBACKS)
    local ordered = orderedCallbacksTicking
    local named = namedCallbacksTicking

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
    local ordered = orderedCallbacksInterp
    local named = namedCallbacksInterp

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

    debug.profileend()
end

local temp3: {[number]: TempData} = {}
local function updateCallbacksRender()
    logger:Print("Rebuilding rendering callbacks...")

    debug.profilebegin(UPDATE_RENDER_CALLBACKS)
    local ordered = orderedCallbacksRender
    local named = namedCallbacksRender

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

    debug.profileend()
end

local temp4: {[number]: TempData} = {}
local function updateCallbacksInput()
    logger:Print("Rebuilding input callbacks...")

    debug.profilebegin(UPDATE_INPUT_CALLBACKS)
    local ordered = orderedCallbacksInput
    local named = namedCallbacksInput

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



function Tick.Init(e: EngineTypes.Engine)
    logger:Print("Initializing...")

    tickRate = 1 / e.Config.TICK_RATE
    maxTicks = e.Config.MAX_TICKS_PER_FRAME

    doInterpolation = e.Config.TICK_INTERPOLATION
end


function Tick.GetTickRate(): typeof(tickRate)
    return tickRate
end


function Tick.GetTickSpeed(): typeof(tickSpeed)
    return tickSpeed
end


function Tick.GetCurrentTick(): typeof(currentTick)
    return currentTick
end


function Tick.IsInterpolationActive(): typeof(doInterpolation)
    return doInterpolation
end


function Tick.SetInterpolationActive(isActive: boolean)
    doInterpolation = isActive
end


function Tick.ExecuteInputCallbacks(delta: number)
    debug.profilebegin(TICK_RUN_INPUT_STEP)

    for _, callback in orderedCallbacksInput do
        callback(delta * tickSpeed)
    end

    debug.profileend()
end

function Tick.ExecuteTickCallbacks(delta: number)
    debug.profilebegin(TICK_RUN_TICK_STEP)

    -- simulation step
    local accumulated = currentDelta + delta
	local numTicks = math.clamp(CalculateTicks(accumulated, tickRate, tickSpeed), 0, maxTicks)

	if numTicks > 0 then
		for i = 1, numTicks do
            currentTick += 1

			for _, callback in orderedCallbacksTicking do
                callback(tickRate)
            end

		end
		
        accumulated -= (numTicks * tickRate / tickSpeed)
	end

    currentDelta = accumulated

    debug.profileend()
end


function Tick.ExecuteInterpCallbacks(delta: number)
    debug.profilebegin(TICK_RUN_INTERP_STEP)

    -- interpolation step
    if doInterpolation then
        local alpha = currentDelta / (tickRate / tickSpeed)

        for _, callback in orderedCallbacksInterp do
            callback(alpha)
        end
    else
        for _, callback in orderedCallbacksInterp do
            callback(1)
        end
    end
    

    debug.profileend()
end


function Tick.ExecuteRenderCallbacks(delta: number)
    debug.profilebegin(TICK_RUN_RENDER_STEP)

    for _, callback in orderedCallbacksRender do
        callback(delta * tickSpeed)
    end

    debug.profileend()
end


--[=[
    Sets how often ticks will occur each frame. 1 is fullspeed, 0.5 is halfspeed, and so on.
    Tick speed must be greater than zero. If you want to pause simulation, you should call Engine.DestroyUpdateLoop().

    @param new number -- The new tick speed. This must be a positive value.
]=]
function Tick.SetTickSpeed(new: number)
    assert(new > 0, `TickSpeed must be a positive value.`)

    local old = tickSpeed
    currentDelta *= (old / new)
    tickSpeed = new
end


function Tick.BindToTick(name: string, priority: number, callback: (delta: number, ...any?) -> (...any?))
    if not priority then
        priority = DEFAULT_PRIORITY.Value
    end

    local existing = namedCallbacksTicking[name]
    if existing then
        existing.Priority = priority
        existing.Callback = callback

        updateCallbacksTicking()
    else
        namedCallbacksTicking[name] = {
            Priority = priority,
            Callback = callback
        }

        updateCallbacksTicking()
    end
end


function Tick.BindToInterpolation(name: string, priority: number, callback: (alpha: number, ...any?) -> (...any?))
    if not priority then
        priority = DEFAULT_PRIORITY.Value
    end

    local existing = namedCallbacksInterp[name]
    if existing then
        existing.Priority = priority
        existing.Callback = callback

        updateCallbacksInterp()
    else
        namedCallbacksInterp[name] = {
            Priority = priority,
            Callback = callback
        }

        updateCallbacksInterp()
    end
end


function Tick.BindToRender(name: string, priority: number, callback: (delta: number, ...any?) -> (...any?))
    if not priority then
        priority = DEFAULT_PRIORITY.Value
    end

    local existing = namedCallbacksRender[name]
    if existing then
        existing.Priority = priority
        existing.Callback = callback

        updateCallbacksRender()
    else
        namedCallbacksRender[name] = {
            Priority = priority,
            Callback = callback
        }

        updateCallbacksRender()
    end
end


function Tick.BindToInput(name: string, priority: number, callback: (delta: number, ...any?) -> (...any?))
    if not priority then
        priority = DEFAULT_PRIORITY.Value
    end

    local existing = namedCallbacksInput[name]
    if existing then
        existing.Priority = priority
        existing.Callback = callback

        updateCallbacksInput()
    else
        namedCallbacksInput[name] = {
            Priority = priority,
            Callback = callback
        }

        updateCallbacksInput()
    end
end


function Tick.UnbindFromTick(name: string, updateArray: boolean?)
    local existing = namedCallbacksTicking[name]
    if existing then
        namedCallbacksTicking[name] = nil
    end

    if updateArray then
        updateCallbacksTicking()
    end
end


function Tick.UnbindFromInterpolation(name: string, updateArray: boolean?)
    local existing = namedCallbacksInterp[name]
    if existing then
        namedCallbacksInterp[name] = nil
    end

    if updateArray then
        updateCallbacksInterp()
    end
end


function Tick.UnbindFromRender(name: string, updateArray: boolean?)
    local existing = namedCallbacksRender[name]
    if existing then
        namedCallbacksRender[name] = nil
    end

    if updateArray then
        updateCallbacksRender()
    end
end

function Tick.UnbindFromInput(name: string, updateArray: boolean?)
    local existing = namedCallbacksInput[name]
    if existing then
        namedCallbacksInput[name] = nil
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