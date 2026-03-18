return {
    ReplicationAction = {
        Set = 0,
        Update = 1,
    },

    TickPriority = {
        Default = 1000
    },

    DebuggingLabels = {
        TICK_UPDATE_TICKING_CALLBACKS = "TOYBOX-UPDATE_TICK_CALLBACKS",
        TICK_UPDATE_INTERP_CALLBACKS = "TOYBOX-UPDATE_INTERP_CALLBACKS",
        TICK_UPDATE_RENDER_CALLBACKS = "TOYBOX-UPDATE_RENDER_CALLBACKS",
        
        TICK_RUN_TICK_STEP = "TOYBOX-RUN_TICK_STEP",
        TICK_RUN_INTERP_STEP = "TOYBOX-RUN_INTERP_STEP",
        TICK_RUN_RENDER_STEP = "TOYBOX-RUN_RENDER_STEP"
    }
}