--[[
    Engine Configurations
--]]

return {
    USE_RBX_CHARACTERS = true,

    -- // Environment

    -- // Region.luau
    MAX_LOADED_REGIONS = 16,

    -- // Tick.luau

    -- How many times per second the game simulation will tick.
    -- Leave as whole number since TickService will divide 1 / TICK_RATE 
    TICK_RATE = 100,

    MAX_TICKS_PER_FRAME = 10,
}