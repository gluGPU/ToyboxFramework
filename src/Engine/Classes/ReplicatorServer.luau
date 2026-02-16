--!strict
--[[
    ReplicatorServer.luau
    1/13/26
    @gluGPU
--]]

local ReplicatorServer = {}
ReplicatorServer._currentId = 0
ReplicatorServer.__index = ReplicatorServer

type ReplicatorServerData<T> = {
    _id: number, -- Static counter that increments whenever a new ReplicatorServer is created.
    _remote: RemoteEvent,
    CurrentState: T?,
    Players: {Player},

    
    -- Methods
    Destroy: (self: ReplicatorServer<T>) -> (),

    AddPlayers: (self: ReplicatorServer<T>, playersToAdd: {Player}) -> (),
    RemovePlayers: (self: ReplicatorServer<T>, playersToRemove: {Player}) -> (),

    ChangeState: (self: ReplicatorServer<T>, newState: T?) -> ()
}

export type ReplicatorServer<T> = typeof(setmetatable({} :: ReplicatorServerData<T>, ReplicatorServer))

function ReplicatorServer.new<T>(r: RemoteEvent, playersToReplicateTo: {Player}, initialState: T?): ReplicatorServer<T>
    local self: ReplicatorServer<T> = setmetatable({} :: ReplicatorServerData<T>, ReplicatorServer)
    self._id = ReplicatorServer._currentId
    self._remote = r
    self.CurrentState = nil
    self.Players = playersToReplicateTo

    ReplicatorServer._currentId += 1

    return self
end

function ReplicatorServer.Destroy(self)
    setmetatable(self, nil)
    table.clear(self)
end

function ReplicatorServer.AddPlayers(self: ReplicatorServer<any>, playersToAdd: {Player})
    local t = self.Players
    for _, p in playersToAdd do
        table.insert(t, p)
    end
end

function ReplicatorServer.RemovePlayers(self: ReplicatorServer<any>, playersToRemove: {Player})
    local t = self.Players
    for _, p in playersToRemove do
        local i = table.find(t, p)
        if i then
            table.remove(t, i)
        end
    end
end

function ReplicatorServer.ChangeState<T>(self: ReplicatorServer<T>, newState: T?)
    
end

return ReplicatorServer