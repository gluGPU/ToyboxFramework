--!strict
--[[
    ReplicationClient.luau
    2/15/26
    @gluGPU
--]]

local BaseService = require("./BaseService")
local EngineTypes = require(".././EngineTypes")
local Logger = require(".././Classes/Logger")
local ReplicatorClient = require(".././Classes/ReplicatorClient")


export type ReplicationClient = {
    ObserveReplicatorTag: <T>(tag: string, callback: ReplicatorHook<T>) -> ()
}


local ReplicationClient = BaseService.new() :: BaseService.BaseService & ReplicationClient

export type ReplicatorClient<T> = ReplicatorClient.ReplicatorClient<T>
export type ReplicatorHook<T> = (replicator: ReplicatorClient<T>) -> (() -> ())


local logger = Logger.new("ReplicationClient", true)


function ReplicationClient.Init(e: EngineTypes.Engine)
    logger:Print("Initializing...")


end


function ReplicationClient.ObserveReplicatorTag<T>(tag: string, callback: ReplicatorHook<T>)
    
end


return ReplicationClient