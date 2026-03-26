local Config = require("./EngineConfig")

export type Tick = {
    _namedCallbacksInput: {[string]: {
        Priority: number,
        Callback: (delta: number, ...any?) -> (...any?)
    }},

    _namedCallbacksTicking: {[string]: {
        Priority: number,
        Callback: (delta: number, ...any?) -> (...any?)
    }},

    _namedCallbacksInterp: {[string]: {
        Priority: number,
        Callback: (alpha: number, ...any?) -> (...any?)
    }},

    _namedCallbacksRender: {[string]: {
        Priority: number,
        Callback: (delta: number, ...any?) -> (...any?)
    }},

    _orderedCallbacksInput: {[number]: (delta: number, ...any?) -> (...any?)},
    _orderedCallbacksTicking: {[number]: (delta: number, ...any?) -> (...any?)},
    _orderedCallbacksInterp: {[number]: (alpha: number, ...any?) -> (...any?)},
    _orderedCallbacksRender: {[number]: (delta: number, ...any?) -> (...any?)},

    TickRate: number,
    TickSpeed: number,
    MaxTicks: number,

    CurrentTick: number,
    _currentDelta: number,

    DoInterpolation: boolean,

    -- Methods
    Init: (e: Engine) -> (),

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