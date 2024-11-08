--------------------------------------------------------
-- [Raft] Classes - Threat
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
    A class representing a threat.
]]
---@class Threat: NoirClass
---@field New fun(self: Threat, ID: integer, animalType: SWAnimalTypeEnum, spawnPosition: SWMatrix, size: number): Threat
---@field ID integer
---@field AnimalType SWAnimalTypeEnum
---@field SpawnPosition SWMatrix
---@field Size number
---@field Object NoirObject
Raft.Classes.Threat = Noir.Class("Threat")

--[[
    Initialize Threat objects.
]]
---@param ID integer
---@param animalType SWAnimalTypeEnum
---@param spawnPosition SWMatrix
---@param size number
function Raft.Classes.Threat:Init(ID, animalType, spawnPosition, size)
    self.ID = ID
    self.AnimalType = animalType
    self.SpawnPosition = spawnPosition
    self.Size = size
    self.Object = nil
end

--[[
    Spawn this threat.
]]
function Raft.Classes.Threat:Spawn()
    self.Object = Noir.Services.ObjectService:SpawnAnimal(self.AnimalType, self.SpawnPosition, self.Size)
    self:Save()
end

--[[
    Despawn this threat.
]]
function Raft.Classes.Threat:Despawn()
    if self.Object then
        self.Object:Despawn()
    end

    Raft.Threats:UnregisterThreat(self)
end

--[[
    Save this threat.
]]
function Raft.Classes.Threat:Save()
    Raft.Threats:SaveThreat(self)
end

--[[
    Serializes this threat into a table.
]]
---@return ThreatSerialized
function Raft.Classes.Threat:Serialize()
    return {
        ID = self.ID,
        AnimalType = self.AnimalType,
        SpawnPosition = self.SpawnPosition,
        Size = self.Size,
        Object = self.Object and self.Object.ID
    }
end

--[[
    Creates a threat object from a serialized threat.
    *staticmethod*
]]
---@param data ThreatSerialized
---@return Threat
function Raft.Classes.Threat:FromSerialized(data)
    if self._IsObject then
        error("Threat", "Cannot create an object from an object.")
    end

    local threat = self:New(data.ID, data.AnimalType, data.SpawnPosition, data.Size)
    threat.ID = data.ID
    threat.AnimalType = data.AnimalType
    threat.SpawnPosition = data.SpawnPosition
    threat.Size = data.Size
    threat.Object = data.Object and Noir.Services.ObjectService:GetObject(data.Object)

    return threat
end

-------------------------------
-- // Intellisense
-------------------------------

--[[
    A serialized Threat object.
]]
---@class ThreatSerialized
---@field ID integer
---@field AnimalType SWAnimalTypeEnum
---@field SpawnPosition SWMatrix
---@field Size number
---@field Object integer