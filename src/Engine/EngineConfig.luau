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
    -- This should be a positive integer.
    TICK_RATE = 100,

    -- Max ticks to process per rendered frame. Helps prevent
    -- "spiral of death" issues.
    MAX_TICKS_PER_FRAME = 10,
}