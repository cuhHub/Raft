--------------------------------------------------------
-- [Raft] Services - Spawning
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
    A service that manages the spawning of players.
]]
---@class Spawning: NoirService
---@field JoinConnection NoirConnection
Raft.Spawning = Noir.Services:CreateService(
    "Spawning"
)

--[[
    Called when the service is started.
]]
function Raft.Spawning:ServiceStart()
    ---@param player NoirPlayer
    self.JoinConnection = Noir.Services.PlayerService.OnJoin:Connect(function(player)
        self:SpawnPlayer(player)
    end)

    for _, player in pairs(Noir.Services.PlayerService:GetPlayers(true)) do
        self:SpawnPlayer(player)
    end
end

--[[
    Teleports a player to the Raft.
]]
---@param player NoirPlayer
function Raft.Spawning:SpawnPlayer(player)
    local raft = Raft.Rafts:GetRaft()
    local spawn = raft:GetSpawnPoint()

    if not spawn then
        error("Spawning", "Failed to get spawn point from raft.")
    end

    player:Teleport(spawn)
end