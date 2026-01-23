--[[
    Replicator.luau
    1/13/26
    @gluGPU
--]]

export type Replicator = {
    Players: {Player}
}

local Replicator = {}
Replicator.__index = Replicator

function Replicator.new(playersToReplicateTo: {Player}): Replicator
    local self = setmetatable({}, Replicator)
    self.Players = playersToReplicateTo

    return self
end

function Replicator.Destroy(self: Replicator)
    
end

function Replicator.AddPlayers(self: Replicator, playersToAdd: {Player})
    local t = self.Players
    for _, player in playersToAdd do
        table.insert(t, player)
    end
end

function Replicator.RemovePlayers(self: Replicator, playersToRemove: {Player})
    local i = table.find(self.Players)
    if i then
        table.remove(self.Players, i)
    end
end

function Replicator.FireAllAddedClients(self: Replicator, ...)
    
end

function Replicator.FireClient(self: Replicator, playerToFireTo: Player, ...)
    
end

return Replicator