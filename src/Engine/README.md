# Engine
This is where the main functionality of the engine lives. Engine.luau is the main module that initializes framework services.

## Engine Loop
The engine loop is comprised of two stages:
    - **Tick**: Fixed timestep hook. The tick rate is configurable in `EngineConfig.luau`.
    - **Render**: Interpolation hooks are fired and then render hooks.

To connect a function to the engine loop, you can use:
    - `Tick.BindToTick(name, priority, callback)`
    - `Tick.BindToInterpolation(name, priority, callback)`
    - `Tick.BindToRender(name, priority, callback)`