# Toybox
Unified game framework to be used across my game projects.

## Disclaimer
Toybox is not a regular Roblox framework. If you aren't interested in keeping the game simulation completely inside of Lua, then Toybox is not for you. This framework mainly uses the Roblox engine for rendering / networking.

## Goals
- Performant manipulation of game entities through ECS.
- The game state should remain in full control of the framework as well as game systems that are built on top of the framework.
- Minimal CPU and memory overhead for game systems.

## Planned Features
- Fixed-timestep world simulation.
- Server-authoritative networking, with rollback/resimulate.
