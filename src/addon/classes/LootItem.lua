--------------------------------------------------------
-- [Raft] Classes - Loot Item
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
    A class representing an item that will pass by rafts.
]]
---@class LootItem: NoirClass
---@field New fun(self: LootItem, equipmentType: SWEquipmentTypeEnum, minInt: integer, maxInt: integer, minFloat: number, maxFloat: number): LootItem
---@field EquipmentType SWEquipmentTypeEnum The equipment ID of the item.
---@field IntRange table<integer, integer> The minimum and maximum integer for this item
---@field FloatRange table<integer, number> The minimum and maximum float for this item
Raft.Classes.LootItem = Noir.Class("LootItem")

--[[
    Initialize LootItem objects.
]]
---@param equipmentType SWEquipmentTypeEnum The equipment ID of the item.
---@param minInt integer The minimum integer for this item
---@param maxInt integer The maximum integer for this item
---@param minFloat number The minimum float for this item
---@param maxFloat number The maximum float for this item
function Raft.Classes.LootItem:Init(equipmentType, minInt, maxInt, minFloat, maxFloat)
    self.EquipmentType = equipmentType
    self.IntRange = {minInt, maxInt}
    self.FloatRange = {minFloat, maxFloat}
end

--[[
    Spawn this item.
]]
---@param at SWMatrix
---@return NoirObject|nil
function Raft.Classes.LootItem:Spawn(at)
    return Noir.Services.ObjectService:SpawnEquipment(
        self.EquipmentType,
        at,
        self:GetRandomInt(),
        self:GetRandomFloat()
    )
end

--[[
    Get random integer.
]]
---@return integer
function Raft.Classes.LootItem:GetRandomInt()
    return math.random(table.unpack(self.IntRange))
end

--[[
    Get random float.
]]
---@return number
function Raft.Classes.LootItem:GetRandomFloat()
    return math.random(self.FloatRange[1] * 100, self.FloatRange[2] * 100) / 100
end