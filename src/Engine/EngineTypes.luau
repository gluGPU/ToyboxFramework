local Config = require("./EngineConfig")

export type Tick = {
    -- Methods
    Init: (e: Engine) -> (),

    GetTickRate: () -> number,
    GetTickSpeed: () -> number,
    GetCurrentTick: () -> number,
    IsInterpolationActive: () -> boolean,
    SetInterpolationActive: (isActive: boolean) -> (),

    ExecuteInputCallbacks: (delta: number) -> (),
    ExecuteTickCallbacks: (delta: number) -> (),
    ExecuteInterpCallbacks: (delta: number) -> (),
    ExecuteRenderCallbacks: (delta: number) -> (),

    SetTickSpeed: (new: number) -> (),

    BindToInput: (name: string, priority: number, callback: (delta: number, ...any?) -> (...any?)) -> (),
    BindToTick: (name: string, priority: number, callback: (delta: number, ...any?) -> (...any?)) -> (),
    BindToInterpolation: (name: string, priority: number, callback: (alpha: number, ...any?) -> (...any?)) -> (),
    BindToRender: (name: string, priority: number, callback: (delta: number, ...any?) -> (...any?)) -> (),

    UnbindFromInput: (name: string, updateArray: boolean?) -> (),
    UnbindFromTick: (name: string, updateArray: boolean?) -> (),
    UnbindFromInterpolation: (name: string, updateArray: boolean?) -> (),
    UnbindFromRender: (name: string, updateArray: boolean?) -> (),

    WaitInTicks: (ticks: number) -> (),
    WaitInSeconds: (seconds: number) -> ()
}

export type Engine = {
    Initialized: boolean,
    InitializationHooks: {(Engine) -> ((Engine) -> ()?)},
    CleanupHooks: {(Engine) -> ()},

    Config: typeof(Config),
    Tick: Tick,

    IsUpdateLoopActive: boolean
}

return {}