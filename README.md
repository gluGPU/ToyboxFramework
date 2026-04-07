# Toybox
Unified game framework to be used across my game projects.

Toybox is more of a simulation-oriented framework compared to other frameworks, in that you're expected to keep your game loop tied to Toybox's tick system. It also contains a number of Luau libraries that further allow you to separate the actual game state away from Roblox. In this sense, Roblox simply becomes a rendering interface while you maintain full control over what happens in your game.

## Goals
- **Allow developers to maintain full control over the game state.**
- Provide a number of useful utilities that makes developing easier, improving the quality of games.
- Minimal CPU and memory overhead for game systems.

## Working on
- **World.luau**: An ECS implementation that hooks neatly into other aspects of the framework.
- **Physics.luau**: Interface for Impulse Physics.
- **Input.luau**: Input service that allows you to create action groups and mappings.
- A way for developers to create custom services that get recognized by the engine.
- Adding documentation to framework features (ongoing).

## Planned Features
- Automatic rollback and resimulation for code that opts into this system.
- Audio utilities such as an AudioGraph (like an animgraph) and audio zones.