--[[
    Replicator.luau
    1/13/26
    @gluGPU
--]]

local RunService = game:GetService("RunService")

-- Dependencies
local ReplicatorServer = require("@self/ReplicatorServer")

-- Variables
local ReplicatorService = {}
local isClient = RunService:IsClient()
local isServer = RunService:IsServer()

if isServer then
    local remotesFolder = Instance.new("Folder")
    remotesFolder.Name = "Remotes"
    remotesFolder.Parent = game:GetService("ReplicatedStorage")
    ReplicatorService._remotesFolder = remotesFolder

    local createReplicatorRemote = Instance.new("RemoteEvent")
    createReplicatorRemote.Name = "CreateReplicator"
    createReplicatorRemote.Parent = remotesFolder
    ReplicatorServer._createReplicatorRemote = createReplicatorRemote
end





function ReplicatorService.Init()
    print("Init Replicator")
end


function ReplicatorService.CreateReplicator(playersToReplicateTo: {Player}): ReplicatorServer.Replicator
    
end


return ReplicatorService