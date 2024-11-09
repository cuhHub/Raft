--------------------------------------------------------
-- [Raft] Services - Starter
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
    A service that manages starter items.
]]
---@class Starter: NoirService
---@field StarterItems table<SWSlotNumberEnum, StarterItem> The items that will be given to players on join/respawn.
---
---@field OnJoinConnection NoirConnection A connection to the `PlayerService` `OnJoin` event
---@field OnRespawnConnection NoirConnection A connection to the `PlayerService` `OnRespawn` event
Raft.Starter = Noir.Services:CreateService(
    "Starter",
    false,
    "Gives starter items to players.",
    "Gives starter items to players.",
    {"Cuh4"}
)

--[[
    Called when the service is initialized.
]]
function Raft.Starter:ServiceInit()
    self.StarterItems = {
        [1] = Raft.Classes.StarterItem:New(Raft.Enums.EquipmentType.Fishing, 0, 0), -- fishing rod
        [2] = Raft.Classes.StarterItem:New(Raft.Enums.EquipmentType.FirstAid, 4, 0), -- first aid kit (4 charges)
        [3] = Raft.Classes.StarterItem:New(Raft.Enums.EquipmentType.ArcticChar, 2, 0), -- arctic char (fish, flopping)
        [4] = Raft.Classes.StarterItem:New(Raft.Enums.EquipmentType.ArcticChar, 2, 0), -- arctic char (fish, flopping)
        [10] = Raft.Classes.StarterItem:New(Raft.Enums.EquipmentType.Arctic, 0, 0), -- arctic suit
    }
end

--[[
    Called when the service is started.
]]
function Raft.Starter:ServiceStart()
    ---@param player NoirPlayer
    self.OnJoinConnection = Noir.Services.PlayerService.OnJoin:Connect(function(player)
        self:GiveStarterItems(player)
    end)

    ---@param player NoirPlayer
    self.OnRespawnConnection = Noir.Services.PlayerService.OnRespawn:Connect(function(player)
        self:GiveStarterItems(player)
    end)

    for _, player in pairs(Noir.Services.PlayerService:GetPlayers(true)) do
        self:GiveStarterItems(player)
    end
end

--[[
    Gives starter items to a player.
]]
---@param player NoirPlayer
function Raft.Starter:GiveStarterItems(player)
    Noir.Services.NotificationService:Info("Starter Items", "You have been given starter items.", player)

    for slot, item in pairs(self.StarterItems) do
        player:GetCharacter():GiveItem(slot, item.EquipmentType, false, item.Int, item.Float)
    end
end