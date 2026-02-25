--!strict
--[[
    ReplicatedState_Client.luau
    2/24/26
    @gluGPU
--]]

local Logger = require("../../Classes/Logger")

local logger = Logger.new("STATIC-ReplicatedState_Client")

local ReplicatedState_Client = {}
ReplicatedState_Client.__index = ReplicatedState_Client

type ReplicatedState_ClientData<T> = {
    _logger: Logger.Logger,
    _onChangedObservers: {[(newState: T?) -> ()]: boolean},
    _onDestroyHooks: {() -> ()},
    _remote: RemoteEvent | UnreliableRemoteEvent,

    Id: number,
    Name: string,
    State: T?,

    _remoteEventConn: RBXScriptConnection,

    Destroy: (self: ReplicatedState_Client<T>) -> (),

    OnDestroying: (self: ReplicatedState_Client<T>, callback: () -> ()) -> (),
    ObserveState: (self: ReplicatedState_Client<T>, callback: (newState: T?) -> () -> ()) -> () -> (),
}

export type ReplicatedState_Client<T> = typeof(setmetatable({} :: ReplicatedState_ClientData<T>, ReplicatedState_Client))


function ReplicatedState_Client.new<T>(id: number, name: string, remote: RemoteEvent | UnreliableRemoteEvent, initialState: T?): ReplicatedState_Client<T>
    logger:Print(string.format(
        "Create new ReplicatedState_Client - id: %i, name: %s, has init state: %*",
        id, name, initialState ~= nil
    ))

    local self: ReplicatedState_Client<T> = setmetatable({} :: ReplicatedState_ClientData<T>, ReplicatedState_Client)
    
    self._logger = Logger.new("ReplicatedState_Client-".. name, true)

    local changedObservers = {}
    local destroyHooks = {}

    self._onChangedObservers = changedObservers
    self._onDestroyHooks = destroyHooks

    self._remote = remote
    self.Id = id
    self.Name = name
    self.State = initialState

    self._remoteEventConn = remote.OnClientEvent:Connect(function(newState: T?)
        self.State = newState
        for onChanged, _ in changedObservers do
            onChanged(newState)
        end
    end)
    
    return self
end


function ReplicatedState_Client.Destroy<T>(self: ReplicatedState_Client<T>)
    for _, callback in self._onDestroyHooks do
        callback()
    end

    setmetatable(self, nil)
    table.clear(self)
end


-- Hooks
function ReplicatedState_Client.OnDestroying<T>(self: ReplicatedState_Client<T>, callback: () -> ())
    table.insert(self._onDestroyHooks, callback)
end


function ReplicatedState_Client.ObserveState<T>(self: ReplicatedState_Client<T>, callback: (newState: T?) -> () -> ()): () -> ()
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


return ReplicatedState_Client