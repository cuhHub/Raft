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
---@field Storage Storage The storage for this raft
---
---@field OnLevelUp NoirEvent Fired when this Raft levels up
Raft.Classes.Raft = Noir.Class("Raft")

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
    self.Storage = Raft.Classes.Storage:New(50)

    self.OnLevelUp = Noir.Libraries.Events:Create()
end

--[[
    Update this raft. This is to be called every tick.
]]
function Raft.Classes.Raft:Update()
    if self.Vehicle then
        self.Vehicle.PrimaryBody:SetBattery("Battery", 100)
        self.Vehicle.PrimaryBody:SetKeypad("SpeedMultiplier", self.Level / self.MaxLevel)

        self:UpdateTooltip()
    end
end

--[[
    Update the tooltip of this raft.
]]
function Raft.Classes.Raft:UpdateTooltip()
    if not self.Vehicle then
        error("Raft", "Attempted to update tooltip when raft is not spawned.")
    end

    self.Vehicle.PrimaryBody:SetTooltip(table.concat({
        "Raft",
        ("Level %d/%d"):format(self.Level, self.MaxLevel),
        ("Items: %d/%d"):format(self.Storage:GetItemCount(), self.Storage.ItemLimit)
    }, "\n"))
end

--[[
    Returns if this raft is loaded or not.
]]
---@return boolean
function Raft.Classes.Raft:IsLoaded()
    return self.Vehicle and self.Vehicle.PrimaryBody:IsSimulating()
end

--[[
    Returns the position of this raft.
]]
---@return SWMatrix
function Raft.Classes.Raft:GetPosition()
    return self.Vehicle:GetPosition()
end

--[[
    Get the spawn point of this raft.<br>
    Can only be called when the raft vehicle has loaded.
]]
---@return SWMatrix
function Raft.Classes.Raft:GetSpawnPoint()
    local data = self.Vehicle.PrimaryBody:GetSign("Spawn")

    if not data then
        error("Raft", "Could not find spawn point.")
    end

    return Noir.Libraries.Matrix:Offset(self.Vehicle.PrimaryBody:GetPosition(data.pos.x, data.pos.y, data.pos.z), 0, 2.5, 0)
end

--[[
    Levels this raft up.
]]
function Raft.Classes.Raft:SetLevel()
    if self.Level >= self.MaxLevel then
        return
    end

    self.Level = self.Level + 1
    self.OnLevelUp:Fire()

    Raft.Rafts:SaveRafts()
end

--[[
    Set the vehicle of this raft.
]]
---@return NoirVehicle
function Raft.Classes.Raft:Spawn()
    if self.Vehicle then
        error("Raft", "Raft is already spawned.")
    end

    self.Vehicle = Noir.Services.VehicleService:SpawnVehicle(self.ComponentID, self.SpawnPosition)
    Raft.Rafts:SaveRafts()

    return self.Vehicle
end

--[[
    Serializes this raft into g_savedata format.
]]
---@return RaftSerialized
function Raft.Classes.Raft:Serialize()
    return {
        SpawnPosition = self.SpawnPosition,
        ComponentID = self.ComponentID,
        VehicleID = self.Vehicle and self.Vehicle.ID,
        Level = self.Level,
        MaxLevel = self.MaxLevel,
        Storage = self.Storage:Serialize()
    }
end

--[[
    Creates a raft object from a serialized raft.
    *staticmethod*
]]
---@param data RaftSerialized
---@return Raft
function Raft.Classes.Raft:FromSerialized(data)
    if self._IsObject then
        error("Raft", "Cannot create an object from an object.")
    end

    local raft = self:New(data.SpawnPosition, data.ComponentID)
    raft.SpawnPosition = data.SpawnPosition
    raft.ComponentID = data.ComponentID
    raft.Vehicle = data.VehicleID and Noir.Services.VehicleService:GetVehicle(data.VehicleID)
    raft.Level = data.Level
    raft.MaxLevel = data.MaxLevel
    raft.Storage = Raft.Classes.Storage:FromSerialized(data.Storage)

    return raft
end

-------------------------------
-- // Intellisense
-------------------------------

--[[
    A serialized Raft object.
]]
---@class RaftSerialized
---@field SpawnPosition SWMatrix
---@field ComponentID integer
---@field VehicleID integer
---@field Level integer
---@field MaxLevel integer
---@field Storage nil -- TODO: storage