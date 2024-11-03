--------------------------------------------------------
-- [Raft] Classes - Raft
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
---@class Raft: NoirClass
---@field New fun(self: Raft, spawnPos: SWMatrix, componentID: integer): Raft
---@field SpawnPosition SWMatrix The position of the raft
---@field ComponentID integer The component ID of the raft
---@field Vehicle NoirVehicle The vehicle this raft is attached to
---@field Level integer The level of the raft
---@field MaxLevel integer The maximum level of the raft
---@field Storage nil -- TODO: add storage class
---
---@field OnLevelUp NoirEvent Fired when this Raft levels up
Raft.Classes.Raft = Noir.Services:CreateService(
    "Rafts"
)

--[[
    Initialize Raft objects.
]]
---@param spawnPos SWMatrix
---@param componentID integer
function Raft.Classes.Raft:Init(spawnPos, componentID)
    self.SpawnPosition = spawnPos
    self.ComponentID = componentID
    self.Vehicle = nil
    self.Level = 1
    self.MaxLevel = 10
    self.Storage = nil -- TODO: storage
end

--[[
    Update this Raft. This is to be called every tick.
]]
function Raft.Classes.Raft:Update()
    self.Vehicle.PrimaryBody:SetBattery("Battery", 100)
    self.Vehicle.PrimaryBody:SetKeypad("SpeedMultiplier", self.Level / self.MaxLevel)
end

--[[
    Get the spawn point of this Raft.<br>
    Can only be called when the Raft vehicle has loaded.
]]
---@return SWMatrix|nil
function Raft.Classes.Raft:GetSpawnPoint()
    local data = self.Vehicle.PrimaryBody:GetSign("Spawn")

    if not data then
        error("Raft", "Could not find spawn point.")
    end

    return self.Vehicle.PrimaryBody:GetPosition(data.pos.x, data.pos.y, data.pos.z)
end

--[[
    Levels this Raft up.
]]
function Raft.Classes.Raft:SetLevel()
    if self.Level >= self.MaxLevel then
        return
    end

    self.Level = self.Level + 1
    self.OnLevelUp:Fire()
end

--[[
    Set the vehicle of this Raft.
]]
---@return NoirVehicle
function Raft.Classes.Raft:Spawn()
    if self.Vehicle then
        error("Raft", "Raft is already spawned.")
    end

    self.Vehicle = Noir.Services.VehicleService:SpawnVehicle(self.ComponentID, self.SpawnPosition)
    return self.Vehicle
end

--[[
    Serializes this Raft into g_savedata format.
]]
---@return RaftSerialized
function Raft.Classes.Raft:Serialize()
    return {
        VehicleID = self.Vehicle.ID,
        Level = self.Level,
        Storage = self.Storage:Serialize() -- TODO: storage
    }
end

--[[
    Deserializes this Raft from g_savedata format.
]]
---@param data RaftSerialized
function Raft.Classes.Raft:FromSerialized(data)
    self.Vehicle = Noir.Services.VehicleService:GetVehicle(data.VehicleID)

    if not self.Vehicle then
        error("Raft", "Could not find vehicle from serialized raft.")
    end

    self.Level = data.Level
    self.Storage = data.Storage
end

-------------------------------
-- // Intellisense
-------------------------------

--[[
    A serialized Raft object.
]]
---@class RaftSerialized
---@field VehicleID integer
---@field Level integer
---@field Storage nil -- TODO: storage