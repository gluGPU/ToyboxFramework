--!strict
--[[
    ReplicatedState_Server.luau
    2/24/26
    @gluGPU
--]]

local Logger = require("../../Classes/Logger")
local Signal = require("../../Libraries/Signal/SignalPlus")

local logger = Logger.new("STATIC-ReplicatedState_Server")

local ReplicatedState_Server = {}
ReplicatedState_Server.__index = ReplicatedState_Server

local currentId = 1

type ReplicatedState_ServerData<T> = {
    _onChangedObservers: {[(newState: T?) -> ()]: boolean},
    _onDestroyHooks: {() -> ()},

    _remote: RemoteEvent,
    Id: number,
    Name: string,
    State: T?,
    Players: {Player},

    PlayersAdded: Signal.Signal<{Player}>,
    PlayersRemoved: Signal.Signal<{Player}>,

    Destroy: (self: ReplicatedState_Server<T>) -> (),

    AddPlayers: (self: ReplicatedState_Server<T>, players: {Player}) -> (),
    RemovePlayers: (self: ReplicatedState_Server<T>, players: {Player}) -> (),

    ChangeState: (self: ReplicatedState_Server<T>, newState: T?) -> (),

    OnDestroying: (self: ReplicatedState_Server<T>, callback: () -> ()) -> (),
    ObserveState: (self: ReplicatedState_Server<T>, callback: (newState: T?) -> () -> ()) -> () -> (),
}

export type ReplicatedState_Server<T> = typeof(setmetatable({} :: ReplicatedState_ServerData<T>, ReplicatedState_Server))


function ReplicatedState_Server.new<T>(name: string, remote: RemoteEvent, players: {Player}, initialState: T?): ReplicatedState_Server<T>
    logger:Print(string.format(
        "Create new ReplicatedState_Server - id: %i, name: %s, has init state: %*",
        currentId, name, initialState ~= nil
    ))
    
    local self: ReplicatedState_Server<T> = setmetatable({} :: ReplicatedState_ServerData<T>, ReplicatedState_Server)
    
    local changedObservers = {}
    local destroyHooks = {}

    self._onChangedObservers = changedObservers
    self._onDestroyHooks = destroyHooks

    self._remote = remote
    self.Id = currentId
    self.Name = name
    self.State = initialState
    self.Players = players

    self.PlayersAdded = Signal() :: Signal.Signal<{Player}>
    self.PlayersRemoved = Signal() :: Signal.Signal<{Player}>
    
    currentId += 1

    return self
end


function ReplicatedState_Server.Destroy<T>(self: ReplicatedState_Server<T>)
    for _, callback in self._onDestroyHooks do
        callback()
    end

    setmetatable(self, nil)
    table.clear(self)
end


function ReplicatedState_Server.AddPlayers<T>(self: ReplicatedState_Server<T>, players: {Player})
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


function ReplicatedState_Server.RemovePlayers<T>(self: ReplicatedState_Server<T>, players: {Player})
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


function ReplicatedState_Server.ChangeState<T>(self: ReplicatedState_Server<T>, newState: T?)
    self.State = newState

    for onChanged, _ in self._onChangedObservers do
        onChanged(newState)
    end

    local remote = self._remote
    for _, player in self.Players do
        remote:FireClient(player, newState)
    end
end


function ReplicatedState_Server.OnDestroying<T>(self: ReplicatedState_Server<T>, callback: () -> ())
    table.insert(self._onDestroyHooks, callback)
end


function ReplicatedState_Server.ObserveState<T>(self: ReplicatedState_Server<T>, callback: (newState: T?) -> () -> ()): () -> ()
    local cleaner: () -> ()? = nil
    local currentId = 0
    local connected = true

    local function onChanged(newState: T?)
        if cleaner then
            cleaner()
            cleaner = nil
        end

        currentId += 1
        local thisId = currentId

        if newState ~= nil then
            local newCleaner = callback(newState)
            if thisId == currentId and connected then
                cleaner = newCleaner
            else
                newCleaner()
            end
        end
    end
    
    self._onChangedObservers[onChanged] = true
    onChanged(self.State)

    return function()
        connected = nil
        self._onChangedObservers[onChanged] = nil
        if cleaner then 
            cleaner()
            cleaner = nil
        end
    end
end


return ReplicatedState_Server