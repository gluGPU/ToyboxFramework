--!strict
--[[
    ReplicatorClient
    1/30/26
    @gluGPU
--]]


local ReplicatorClient = {}
ReplicatorClient.__index = ReplicatorClient


type ReplicatorClientData<T> = {
    _id: number, -- Replicator ID is dictated by the server.
    _remote: RemoteEvent,
    CurrentState: T?
}

export type ReplicatorClient<T> = typeof(setmetatable({} :: ReplicatorClientData<T>, ReplicatorClient))

function ReplicatorClient.new<T>(id: number, r: RemoteEvent, initialState: T?): ReplicatorClient<T>
    local self: ReplicatorClient<T> = setmetatable({} :: ReplicatorClientData<T>, ReplicatorClient)
    self._id = id
    self._remote = r
    self.CurrentState = initialState

    return self
end


return ReplicatorClient