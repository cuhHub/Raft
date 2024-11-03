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
    Returns the spawn point of the main raft.
]]
---@param callback fun(pos: SWMatrix)
function Raft.Spawning:GetSpawnPoint(callback)
    local raft = Raft.Rafts:GetServerRaft()

    if raft:IsLoaded() then
        local spawn = raft:GetSpawnPoint()

        if not spawn then
            error("Spawning", "Raft is loaded, but the spawn point is nil. The spawn sign may be missing.")
        end

        return callback(spawn)
    else
        raft.Vehicle.PrimaryBody.OnLoad:Once(function()
            local spawn = raft:GetSpawnPoint()

            if not spawn then
                error("Spawning", "Raft loaded after a bit, but the spawn point is nil. The spawn sign may be missing.")
            end

            return callback(spawn)
        end)
    end
end

--[[
    Teleports a player to the Raft.
]]
---@param player NoirPlayer
function Raft.Spawning:SpawnPlayer(player)
    -- Get raft
    local raft = Raft.Rafts:GetServerRaft()

    if not raft then
        error("Spawning", "Failed to get server raft.")
    end

    -- Get spawn
    self:GetSpawnPoint(function(pos)
        player:Teleport(pos)
    end)
end