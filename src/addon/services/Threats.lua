--------------------------------------------------------
-- [Raft] Services - Threats
--------------------------------------------------------

--[[
    ----------------------------

    CREDIT:
        Author(s): @Cuh4 (GitHub)
        GitHub Repository: https://github.com/cuhHub/Raft

    License:
        Copyright (C) 2024 Cuh4

        Licensed under the Apache License, Version 2.0 (the "License");
        you may not use this file except in compliance with the License.
        You may obtain a copy of the License at

            http://www.apache.org/licenses/LICENSE-2.0

        Unless required by applicable law or agreed to in writing, software
        distributed under the License is distributed on an "AS IS" BASIS,
        WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
        See the License for the specific language governing permissions and
        limitations under the License.

    ----------------------------
]]

-------------------------------
-- // Main
-------------------------------

--[[
    A service that spawns threats around the main raft.
]]
---@class Threats: NoirService
---@field MAX_THREATS number The maximum amount of threats that can be spawned at a time.
---@field SPAWN_DISTANCE number The max distance a threat can spawn from a player
---@field THREAT_SPAWN_INTERVAL number The interval at which threats are spawned
---@field Threats table<integer, Threat> All spawned threats
---@field ThreatSpawningTask NoirTask The task that handles threat spawning
Raft.Threats = Noir.Services:CreateService(
    "Threats",
    false,
    "Handles threats, particularly sharks.",
    "Handles threats like sharks by spawning them around the main raft.",
    {"Cuh4"}
)

--[[
    Called when the service is initialized.
]]
function Raft.Threats:ServiceInit()
    self.MAX_THREATS = 20
    self.SPAWN_DISTANCE = 100
    self.THREAT_SPAWN_INTERVAL = 32

    self.Threats = {}
end

--[[
    Called when the service is started.
]]
function Raft.Threats:ServiceStart()
    self:LoadThreats()

    self.ThreatSpawningTask = Noir.Services.TaskService:AddTimeTask(function()
        self:SpawnThreatRandom()
    end, self.THREAT_SPAWN_INTERVAL, nil, true)
end

--[[
    Spawn a threat around the main raft.
]]
function Raft.Threats:SpawnThreatRandom()
    local players = Noir.Libraries.Table:Values(Noir.Services.PlayerService:GetPlayers(true))

    if #players <= 0 then -- dedicated server with no players in it
        return
    end

    local player = Noir.Libraries.Table:Random(players) ---@type NoirPlayer
    self:SpawnThreat(self:GetRandomPositionAroundPlayer(player), 0, self:GetSizeMultiplier())
end

--[[
    Get size multiplier for newly spawned threats.
]]
function Raft.Threats:GetSizeMultiplier()
    local raft = Raft.Rafts:GetMainRaft()

    if not raft then
        error("Threats", "Failed to get size multiplier due to lack of a main raft.")
    end
    return 2 * (raft.Level / raft.MaxLevel) * 1.87
end

--[[
    Get a random position around a player for a threat to spawn at.
]]
---@param player NoirPlayer
---@return SWMatrix
function Raft.Threats:GetRandomPositionAroundPlayer(player)
    local position = player:GetPosition()
    return Noir.Libraries.Matrix:Offset(Noir.Libraries.Matrix:RandomOffset(position, self.SPAWN_DISTANCE, 0, self.SPAWN_DISTANCE), 0, -10, 0)
end

--[[
    Register a threat
]]
---@param threat Threat
function Raft.Threats:RegisterThreat(threat)
    self.Threats[threat.ID] = threat
end

--[[
    Unregister a threat.
]]
---@param threat Threat
function Raft.Threats:UnregisterThreat(threat)
    self.Threats[threat.ID] = nil
    self:UnsaveThreat(threat)
end

--[[
    Spawn a threat.
]]
---@param at SWMatrix
---@param animalType SWAnimalTypeEnum
---@param size number
---@return Threat
function Raft.Threats:SpawnThreat(at, animalType, size)
    if self:GetThreatCount() >= self:GetMaxThreats() then
        local _, threat = next(self:GetThreats())
        threat:Despawn()
    end

    local threat = Raft.Classes.Threat:New(Raft.ID:GetID(), animalType, at, size)
    threat:Spawn()

    self:RegisterThreat(threat)

    return threat
end

--[[
    Get the max amount of threats.
]]
---@return integer
function Raft.Threats:GetMaxThreats()
    local raft = Raft.Rafts:GetMainRaft()

    if not raft then
        error("Threats", "Failed to get max threats due to lack of a main raft.")
    end

    return self.MAX_THREATS * (raft.Level / raft.MaxLevel)
end

--[[
    Returns the amount of spawned threats.
]]
---@return integer
function Raft.Threats:GetThreatCount()
    return Noir.Libraries.Table:Length(self:GetThreats())
end

--[[
    Returns all spawned threats.
]]
---@return table<integer, Threat>
function Raft.Threats:GetThreats()
    return self.Threats
end

--[[
    Returns all saved threats.
]]
---@return table<integer, ThreatSerialized>
function Raft.Threats:GetSavedThreats()
    return self:EnsuredLoad("Threats", {})
end

--[[
    Saves all threats.
]]
function Raft.Threats:SaveThreats()
    local saved = {}

    for _, threat in pairs(self:GetThreats()) do
        saved[threat.ID] = threat
    end

    self:Save("Threats", saved)
end

--[[
    Save a specific threat.
]]
---@param threat Threat
function Raft.Threats:SaveThreat(threat)
    local saved = self:GetSavedThreats()
    saved[threat.ID] = threat:Serialize()

    self:Save("Threats", saved)
end

--[[
    Unsave a threat.
]]
---@param threat Threat
function Raft.Threats:UnsaveThreat(threat)
    local saved = self:GetSavedThreats()
    saved[threat.ID] = nil

    self:Save("Threats", saved)
end

--[[
    Loads all threats.
]]
function Raft.Threats:LoadThreats()
    local threats = self:GetSavedThreats()

    for _, threat in pairs(threats) do
        local deserialized = Raft.Classes.Threat:FromSerialized(threat)
        self:RegisterThreat(deserialized)
    end
end