--[[
    Replication.luau
    2/15/26
    @gluGPU
--]]

local RunService = game:GetService("RunService")

if RunService:IsClient() then
    return require("@self/ReplicationClient")
elseif RunService:IsServer() then
    return require("@self/ReplicationServer")
else
    warn(`Replication Service only works on Client/Server.`)
    return {}
end
