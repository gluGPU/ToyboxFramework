local Config = require("./EngineConfig")

export type Engine = {
    Initialized: boolean,
    InitializationHooks: {(Engine) -> ((Engine) -> ()?)},
    CleanupHooks: {(Engine) -> ()},

    Config: typeof(Config),

    IsUpdateLoopActive: boolean
}

return {}