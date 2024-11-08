--------------------------------------------------------
-- [Raft] Classes - Starter Item
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
    A class representing a raft in the server.
]]
---@class StarterItem: NoirClass
---@field New fun(self: StarterItem, equipmentType: number, int: number, float: number): StarterItem
---@field EquipmentType SWEquipmentTypeEnum The equipment ID of the starter item.
---@field Int integer The integer value of the starter item.
---@field Float number The float value of the starter item.
Raft.StarterItem = Noir.Libraries.Dataclasses:New("StarterItem", {
    Noir.Libraries.Dataclasses:Field("EquipmentType", "number"),
    Noir.Libraries.Dataclasses:Field("Int", "number"),
    Noir.Libraries.Dataclasses:Field("Float", "number"),
})