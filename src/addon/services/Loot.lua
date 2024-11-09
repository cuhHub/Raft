--------------------------------------------------------
-- [Raft] Services - Loot
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

-- todo: rewrite

--[[
    A service that manages the spawning of loot.
]]
---@class Loot: NoirService
---@field MAX_LOOT integer The maximum amount of loot that can be spawned
---@field LOOT_SPAWNING_AMOUNT integer The amount of loot to spawn per raft
---@field LOOT_SPAWNING_INTERVAL number The amount of time between loot spawning
---@field LOOT_SPAWNING_DISTANCE_RANGE_X table<integer, integer> The minimum and maximum distance for loot to spawn on the X axis
---@field LOOT_SPAWNING_DISTANCE_RANGE_Z table<integer, integer> The minimum and maximum distance for loot to spawn on the Z axis
---@field LOOT_Y number The Y position of the loot
---@field LOOT_SPEED number The speed of spawned loot (the distance the loot moves per tick)
---@field LOOT_LIFETIME number The amount of time before spawned loot despawns
---@field SpawnableLoot table<integer, LootItem> The loot that can be spawned
---@field Loot table<integer, NoirObject> All spawned loot
---
---@field LootSpawningTask NoirTask A task to handle loot spawning
---@field LootMovementTask NoirTask A task that handles loot movement
Raft.Loot = Noir.Services:CreateService(
    "Loot",
    false,
    "Handles the spawning of loot.",
    "Handles the spawning of loot, as well as moving them across the ocean.",
    {"Cuh4"}
)

--[[
    Called when the service is initialized.
]]
function Raft.Loot:ServiceInit()
    self.MAX_LOOT = 120
    self.LOOT_SPAWNING_AMOUNT = 32
    self.LOOT_SPAWNING_INTERVAL = 32
    self.LOOT_SPAWNING_DISTANCE_RANGE_X = {-25, 25}
    self.LOOT_SPAWNING_DISTANCE_RANGE_Z = {75, 125}
    self.LOOT_Y = 0.02
    self.LOOT_SPEED = 4 / 60
    self.LOOT_LIFETIME = 60

    self.SpawnableLoot = {}
    self:CreateDefaultSpawnableLoot()

    self.Loot = {}
    self:CreateSaveData()
end

--[[
    Called when the service is started.
]]
function Raft.Loot:ServiceStart()
    self:LoadLootObjects()

    self.LootSpawningTask = Noir.Services.TaskService:AddTimeTask(function()
        for _, player in pairs(Noir.Services.PlayerService:GetPlayers(true)) do
            for _ = 1, self.LOOT_SPAWNING_AMOUNT do
                self:SpawnLoot(player, self:GetRandomLootItem())
            end
        end
    end, self.LOOT_SPAWNING_INTERVAL, nil, true)

    self.LootMovementTask = Noir.Services.TaskService:AddTickTask(function()
        local deltaTicks = Noir.Services.TaskService.DeltaTicks

        for _, loot in pairs(self.Loot) do
            local position = loot:GetPosition()
            position[15] = position[15] - (self.LOOT_SPEED * deltaTicks)

            loot:Teleport(position)
        end
    end, 1, nil, true)
end

--[[
    Create default spawnable loot.
]]
function Raft.Loot:CreateDefaultSpawnableLoot()
    self:CreateLootItem(Raft.Enums.EquipmentType.Fishing, {0, 4}, {0, 0})
    self:CreateLootItem(Raft.Enums.EquipmentType.FirstAid, {1, 4}, {0, 0})
    self:CreateLootItem(Raft.Enums.EquipmentType.Binoculars, {0, 0}, {0, 0})
end

--[[
    Create a loot item and add it to the spawnable loot.
]]
---@param equipmentType SWEquipmentTypeEnum
---@param intRange table<integer, integer>
---@param floatRange table<integer, number>
function Raft.Loot:CreateLootItem(equipmentType, intRange, floatRange)
    table.insert(self.SpawnableLoot, Raft.Classes.LootItem:New(equipmentType, intRange[1], intRange[2], floatRange[1], floatRange[2]))
end

--[[
    Returns a random loot item.
]]
---@return LootItem
function Raft.Loot:GetRandomLootItem()
    return Noir.Libraries.Table:Random(self.SpawnableLoot)
end

--[[
    Spawn a loot item.
]]
---@param player NoirPlayer
---@param lootItem LootItem
function Raft.Loot:SpawnLoot(player, lootItem)
    if #self.Loot >= self.MAX_LOOT then
        self:DespawnLootObject(self.Loot[1])
    end

    local object = lootItem:Spawn(self:GetRandomLootPosition(player))

    if not object then
        error("Loot", "Failed to spawn loot")
    end

    table.insert(self.Loot, object)
    self:SaveLootObject(object)

    Noir.Services.TaskService:AddTimeTask(function()
        self:DespawnLootObject(object)
    end, self.LOOT_LIFETIME)
end

--[[
    Despawn the first loot object.
]]
---@param object NoirObject
function Raft.Loot:DespawnLootObject(object)
    object:Despawn()

    self:RemoveLootObject(object)
    table.remove(self.Loot, 1)
end

--[[
    Returns a random loot position for a player.
]]
---@param player NoirPlayer
function Raft.Loot:GetRandomLootPosition(player)
    local position = player:GetPosition()
    position[14] = self.LOOT_Y

    return Noir.Libraries.Matrix:Offset(
        position,
        math.random(table.unpack(self.LOOT_SPAWNING_DISTANCE_RANGE_X)),
        0,
        math.random(table.unpack(self.LOOT_SPAWNING_DISTANCE_RANGE_Z))
    )
end

--[[
    Create a savedata table for spawned objects.
]]
function Raft.Loot:CreateSaveData()
    if not self:Load("Loot") then
        self:Save("Loot", {})
    end
end

--[[
    Save a loot object to g_savedata
]]
---@param object NoirObject
function Raft.Loot:SaveLootObject(object)
    self:GetSaveData().Loot[object.ID] = true
end

--[[
    Remove a specific spawned loot from g_savedata.
]]
---@param object NoirObject
function Raft.Loot:RemoveLootObject(object)
    self:GetSaveData()[object.ID] = nil
end

--[[
    Get saved loot objects from g_savedata.
]]
function Raft.Loot:GetSavedLootObjects()
    return self:EnsuredLoad("Loot", {})
end

--[[
    Load saved loot objects from g_savedata.
]]
function Raft.Loot:LoadLootObjects()
    for ID, _ in pairs(self:GetSavedLootObjects()) do
        local object = Noir.Services.ObjectService:GetObject(ID)

        if not object then
            goto continue
        end

        object:Despawn()
        ::continue::
    end
end