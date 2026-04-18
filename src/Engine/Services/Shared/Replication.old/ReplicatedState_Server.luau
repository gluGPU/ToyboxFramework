--!strict
--[[
    ReplicatedState_Server.luau
    2/24/26
    @gluGPU
--]]

local EngineEnums = require("../../EngineEnums")
local Logger = require("../../Classes/Logger")
local Property = require("../../Classes/Property")
local Signal = require("../../Libraries/Signal/SignalPlus")

local logger = Logger.new("STATIC-ReplicatedState_Server")

local ReplicationAction = EngineEnums.ReplicationAction

local ReplicatedState_Server = {}
ReplicatedState_Server.__index = ReplicatedState_Server

local currentId = 1

type ReplicatedState_ServerData<T, K> = {
    read _logger: Logger.Logger,
    read _onDestroyHooks: {() -> ()},

    read _remote: RemoteEvent | UnreliableRemoteEvent,
    read Id: number,
    read Name: string,
    read Properties: {[T]: Property.Property<K>},
    read Players: {Player},

    read PlayersAdded: Signal.Signal<{Player}>,
    read PlayersRemoved: Signal.Signal<{Player}>,

    read Destroy: (self: ReplicatedState_Server<T, K>) -> (),

    read AddPlayers: (self: ReplicatedState_Server<T, K>, players: {Player}) -> (),
    read RemovePlayers: (self: ReplicatedState_Server<T, K>, players: {Player}) -> (),
    read OnDestroying: (self: ReplicatedState_Server<T, K>, callback: () -> ()) -> ()
}

export type ReplicatedState_Server<T, K> = typeof(setmetatable({} :: ReplicatedState_ServerData<T, K>, ReplicatedState_Server))


function ReplicatedState_Server.new<T, K>(name: string, remote: RemoteEvent | UnreliableRemoteEvent, players: {Player}, properties: {[T]: K}): ReplicatedState_Server<T, K>
    logger:Print(string.format(
        "Create new ReplicatedState_Server - id: %i, name: %s",
        currentId, name
    ))
    
    local logger = Logger.new("ReplicatedState_Server: ".. name)
    local self: ReplicatedState_Server<T, K> = setmetatable({
        _logger = logger,
        _onDestroyHooks = {},

        _remote = remote,
        Id = currentId,
        Name = name,
        Properties = {},
        Players = players,

        PlayersAdded = Signal(),
        PlayersRemoved = Signal()
    } :: ReplicatedState_ServerData<T, K>, ReplicatedState_Server)

    for i, v in properties do
        self.Properties[i] = Property.new(v)
    end
    
    currentId += 1

    return self
end


function ReplicatedState_Server.Destroy<T, K>(self: ReplicatedState_ServerData<T, K>)
    for _, callback in self._onDestroyHooks do
        callback()
    end

    for _, prop in self.Properties do
        prop:Destroy()
    end

    table.clear(self.Properties)

    setmetatable(self, nil)
    table.clear(self)
end


function ReplicatedState_Server.AddPlayers<T, K>(self: ReplicatedState_Server<T, K>, players: {Player})
    local didAdd = {}
    local array = self.Players

    for _, player in players do
        if not table.find(array, player) then
            table.insert(array, player)
            table.insert(didAdd, player)
        end
    end

    self.PlayersAdded:Fire(didAdd)
end


function ReplicatedState_Server.RemovePlayers<T, K>(self: ReplicatedState_Server<T, K>, players: {Player})
    local didRemove = {}
    local array = self.Players

    for _, player in players do
        local i = table.find(array, player)
        if i then
            table.insert(didRemove, table.remove(array, i) :: Player)
        end
    end

    self.PlayersRemoved:Fire(didRemove)
end


function ReplicatedState_Server.OnDestroying<T, K>(self: ReplicatedState_Server<T, K>, callback: () -> ())
    table.insert(self._onDestroyHooks, callback)
end


return ReplicatedState_Server