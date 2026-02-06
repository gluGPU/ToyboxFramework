--[[
    ReplicatorServer.luau
    1/13/26
    @gluGPU
--]]

export type ReplicatorServer<T> = {
    _id: number,
    _remote: RemoteEvent,
    CurrentState: T?,
    Players: {Player}
}

local ReplicatorServer = {}
ReplicatorServer._currentId = 0
ReplicatorServer.__index = ReplicatorServer

function ReplicatorServer.new<T>(playersToReplicateTo: {Player}, initialState: T?, remote: RemoteEvent): ReplicatorServer<T>
    local self = setmetatable({}, ReplicatorServer)
    self._id = ReplicatorServer._currentId
    self._remote = remote
    self.CurrentState = nil
    self.Players = playersToReplicateTo

    ReplicatorServer._currentId += 1

    return self
end

function ReplicatorServer.Destroy(self: ReplicatorServer<any>)
    table.clear(self)
    setmetatable(self, nil)
    self = nil
end

function ReplicatorServer.AddPlayers(self: ReplicatorServer<any>, playersToAdd: {Player})
    local t = self.Players
    for _, player in playersToAdd do
        table.insert(t, player)
    end
end

function ReplicatorServer.RemovePlayers(self: ReplicatorServer<any>, playersToRemove: {Player})
    local i = table.find(self.Players)
    if i then
        table.remove(self.Players, i)
    end
end

function ReplicatorServer.ChangeState(self: ReplicatorServer<any>)
    
end

return ReplicatorServer