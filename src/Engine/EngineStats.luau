--!strict
--[[
    EngineStats.luau
    3/26/2026
    @gluGPU
--]]

export type Stats = {
    UpdateFrequency: number,

    PushTimes: (input: number, tick: number, interp: number, render: number) -> (),
    GetAvgTimes: () -> (number, number, number, number)
}

local Stats = {} :: Stats
Stats.UpdateFrequency = 0.5

local lastUpdate, numUpdates = os.clock(), 0
local curInput, curTick, curInterp, curRender = 0, 0, 0, 0
local lastInput, lastTick, lastInterp, lastRender = 0, 0, 0, 0

function Stats.PushTimes(input: number, tick: number, interp: number, render: number)
    numUpdates += 1
    curInput += input
    curTick += tick
    curInterp += interp
    curRender += render
end

function Stats.GetAvgTimes(): (number, number, number, number)
    local current = os.clock()
    if current - lastUpdate > Stats.UpdateFrequency then
        local inv = 1 / numUpdates

        lastInput = curInput * inv
        lastTick = curTick * inv
        lastInterp = curInterp * inv
        lastRender = curRender * inv

        numUpdates, curInput, curTick, curInterp, curRender = 0, 0, 0, 0, 0
        lastUpdate = os.clock()
    end

    return lastInput, lastTick, lastInterp, lastRender
end

return Stats