--[[
    ReplicationServer.luau
    1/13/26
    @gluGPU
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Dependencies
local ReplicatorServer = require("../../Classes/ReplicatorServer")

-- Variables
local ReplicationServer = {}

local isClient = RunService:IsClient()
local isServer = RunService:IsServer()

local remotesFolder: Folder = Instance.new("Folder")
remotesFolder.Name = "Remotes"
remotesFolder.Parent = ReplicatedStorage
ReplicationServer._remotesFolder = remotesFolder

local createReplicatorRemote: RemoteEvent = Instance.new("RemoteEvent")
createReplicatorRemote.Name = "CreateReplicator"
createReplicatorRemote.Parent = remotesFolder
ReplicationServer._createReplicatorRemote = createReplicatorRemote


function ReplicationServer.Init()
    print("Initializing ReplicationServer")
end


-- Can only be called on the server
function ReplicationServer.CreateReplicator<T>(playersToReplicateTo: {Player}): ReplicatorServer.ReplicatorServer<T>
    assert(isServer, "CreateReplicator() can only be called on the server.")

    local remote = Instance.new("RemoteEvent")
    remote.Parent = remotesFolder
end


return ReplicationServer