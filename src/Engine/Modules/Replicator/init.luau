--[[
    Replicator.luau
    1/13/26
    @gluGPU
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Dependencies
local ReplicatorServer = require("@self/ReplicatorServer")

-- Variables
local ReplicatorService = {}
local isClient = RunService:IsClient()
local isServer = RunService:IsServer()

local remotesFolder: Folder? = nil
local createReplicatorRemote: RemoteEvent? = nil

if isServer then
    remotesFolder = Instance.new("Folder")
    remotesFolder.Name = "Remotes"
    remotesFolder.Parent = ReplicatedStorage
    ReplicatorService._remotesFolder = remotesFolder

    createReplicatorRemote = Instance.new("RemoteEvent")
    createReplicatorRemote.Name = "CreateReplicator"
    createReplicatorRemote.Parent = remotesFolder
    ReplicatorServer._createReplicatorRemote = createReplicatorRemote
else
    remotesFolder = ReplicatedStorage.Remotes
    createReplicatorRemote = remotesFolder.CreateReplicator
end


function ReplicatorService.Init()
    print("Init Replicator")

    if isClient then
        assert(createReplicatorRemote ~= nil, "CreateReplicatorRemoteEvent not found.")

        createReplicatorRemote.OnClientEvent:Connect(function(id: string, initialState: any)
            --TODO: When the ReplicatorClient class is created, initialize the client replicator with
            --      the initial state of the server replicator
        end)
    end
end


-- Can only be called on the server
function ReplicatorService.CreateReplicator<T>(playersToReplicateTo: {Player}): ReplicatorServer.ReplicatorServer<T>
    assert(isServer, "CreateReplicator() can only be called on the server.")

    local remote = Instance.new("RemoteEvent")
    remote.Parent = remotesFolder


end


return ReplicatorService