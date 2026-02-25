--!strict
--[[
    Replication.luau
    2/24/26
    @gluGPU
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local BaseService = require("./BaseService")
local Logger = require("../Classes/Logger")
local Signal = require("../Libraries/Signal/SignalPlus")
local ReplicatedState_Client = require("@self/ReplicatedState_Client")
local ReplicatedState_Server = require("@self/ReplicatedState_Server")

local isClient = RunService:IsClient()
local isServer = RunService:IsServer()
local CREATE_RSTATE_REMOTE_NAME = "_createReplicatedStateRemote"
local RSTATE_REMOTES_FOLDER_NAME = "_replicatedStateRemotes"

export type ReplicatedState_Client<T> = ReplicatedState_Client.ReplicatedState_Client<T>
export type ReplicatedState_Server<T> = ReplicatedState_Server.ReplicatedState_Server<T>

export type ClientMethods = {
    -- ObserveReplicatedState: <T>(name: string) -> (ReplicatedState_Client<T>)
}

export type ServerMethods = {
    CreateReplicatedState: <T>(name: string, players: {Player}, initialState: T?) -> (ReplicatedState_Server<T>)
}

export type Replication = {
    _createReplicatedStateRemote: RemoteEvent,
    _replicatedStateRemotes: Folder,

    Client: ClientMethods,
    Server: ServerMethods,

    OnReplicatedStateCreated: Signal.Signal<ReplicatedState_Client<any>>
}

local logger = Logger.new("Replication", true)
local Replication = BaseService.new() :: BaseService.BaseService & Replication

local Client = {} :: ClientMethods
local Server = {} :: ServerMethods

Replication.Client = Client
Replication.Server = Server

function Replication.Init()
    logger:Print("Initializing...")

    local onRsCreatedSignal = Signal() :: Signal.Signal<ReplicatedState_Client<any>>
    Replication.OnReplicatedStateCreated = onRsCreatedSignal

    if isClient then
        local createRemote = ReplicatedStorage:FindFirstChild(CREATE_RSTATE_REMOTE_NAME) :: RemoteEvent
        local remotesFolder = ReplicatedStorage:FindFirstChild(RSTATE_REMOTES_FOLDER_NAME) :: Folder

        Replication._createReplicatedStateRemote = createRemote
        Replication._replicatedStateRemotes = remotesFolder

        createRemote.OnClientEvent:Connect(function(id: number, name: string, remote: RemoteEvent, initialState: any)
            local rState = ReplicatedState_Client.new(id, name, remote, initialState)
            onRsCreatedSignal:Fire(rState)
        end)
    elseif isServer then
        local remote = Instance.new("RemoteEvent")
        remote.Name = CREATE_RSTATE_REMOTE_NAME
        remote.Parent = ReplicatedStorage
        
        Replication._createReplicatedStateRemote = remote

        local folder = Instance.new("Folder")
        folder.Name = RSTATE_REMOTES_FOLDER_NAME
        folder.Parent = ReplicatedStorage

        Replication._replicatedStateRemotes = folder
    end

    Replication.Initialized = true
    Replication._executeInitHooks()
end


-- Server API
function Server.CreateReplicatedState<T>(name: string, players: {Player}, initialState: T?, isUnreliable: boolean?): ReplicatedState_Server<T>
    logger:AssertIfUninitialized(Replication)
    logger:AssertIfNotServer()
    logger:Assert(name ~= nil, "Must provide name argument")
    logger:Assert(players ~= nil, "Must provide players argument")

    local newRemote: RemoteEvent | UnreliableRemoteEvent = isUnreliable == true and Instance.new("UnreliableRemoteEvent") or Instance.new("RemoteEvent")
    newRemote.Name = name
    newRemote.Parent = Replication._replicatedStateRemotes

    local rState = ReplicatedState_Server.new(name, newRemote, players, initialState)
    
    local createRemote = Replication._createReplicatedStateRemote
    for _, player in players do
        createRemote:FireClient(player, rState.Id, name, newRemote, initialState)
    end

    local addedConn = rState.PlayersAdded:Connect(function(playersAdded: {Player})
        for _, player in playersAdded do
            createRemote:FireClient(player, rState.Id, name, newRemote, rState.State)
        end
    end)

    rState:OnDestroying(function()
        addedConn:Disconnect()
        rState = nil
    end)

    return rState
end


-- Client API
-- function Client.ObserveReplicatedState<T>(name: string, state: T): ReplicatedState_Client<T>
    
-- end

return Replication