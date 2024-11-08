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
---@field New fun(self: Raft, ID: integer, spawnPos: SWMatrix, componentID: integer): Raft
---@field ID integer
---@field SpawnPosition SWMatrix The position of the raft
---@field ComponentID integer The component ID of the raft
---@field Vehicle NoirVehicle The vehicle this raft is attached to
---@field Level integer The level of the raft
---@field MaxLevel integer The maximum level of the raft
---@field Storage Storage The storage for this raft
---@field Throttle number The throttle of the raft. >0 will make the raft move
---
---@field OnLevelUp NoirEvent Fired when this Raft levels up
Raft.Classes.Raft = Noir.Class("Raft")

--[[
    Initialize Raft objects.
]]
---@param ID integer
---@param spawnPos SWMatrix
---@param componentID integer
function Raft.Classes.Raft:Init(ID, spawnPos, componentID)
    self.ID = 0
    self.SpawnPosition = spawnPos
    self.ComponentID = componentID
    self.Vehicle = nil
    self.Level = 1
    self.MaxLevel = 10
    self.Storage = Raft.Classes.Storage:New(50)
    self.Throttle = 0

    self.OnLevelUp = Noir.Libraries.Events:Create()
end

--[[
    Update this raft. This is to be called every tick.
]]
function Raft.Classes.Raft:Update()
    if self.Vehicle then
        if not self.Vehicle.Spawned then
            self.Vehicle = nil
            self:Save()

            error("Raft", "Raft vehicle was despawned improperly")
        end

        -- self:Lock()
        self:Reflect()
        self:Replenish()
        self:UpdateTooltip()
    end
end

--[[
    Reflects things like throttle onto the raft.
]]
function Raft.Classes.Raft:Reflect()
    if not self.Vehicle then
        error("Raft", "Attempted to reflect raft when raft is not spawned.")
    end

    self.Vehicle.PrimaryBody:SetKeypad("Throttle", self.Throttle)
end

--[[
    Keeps the raft replenished (recharges, refuels, etc)
]]
function Raft.Classes.Raft:Replenish()
    if not self.Vehicle then
        error("Raft", "Attempted to replenish raft when raft is not spawned.")
    end

    self.Vehicle.PrimaryBody:SetBattery("Battery", 100)
end

--[[
    Locks the raft's X and Z axis.
]]
function Raft.Classes.Raft:Lock()
    if not self.Vehicle then
        error("Raft", "Attempted to lock raft when raft is not spawned.")
    end

    local pos = self:GetPosition()
    self.Vehicle:Move(matrix.translation(self.SpawnPosition[13], pos[14], self.SpawnPosition[15]))
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
    Save this raft in the Rafts service.
]]
function Raft.Classes.Raft:Save()
    Raft.Rafts:SaveRaft(self)
end

--[[
    Set the throttle of this raft.
]]
---@param throttle number
function Raft.Classes.Raft:SetThrottle(throttle)
    self.Throttle = throttle
    self:Save()
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

    self:Save()
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
    self:Save()

    return self.Vehicle
end

--[[
    Despawn this raft.
]]
function Raft.Classes.Raft:Despawn()
    if self.Vehicle then
        self.Vehicle:Despawn()
        self.Vehicle = nil
        self:Save()
    end

    Raft.Rafts:UnregisterRaft(self)
end

--[[
    Serializes this raft into g_savedata format.
]]
---@return RaftSerialized
function Raft.Classes.Raft:Serialize()
    return {
        ID = self.ID,
        SpawnPosition = self.SpawnPosition,
        ComponentID = self.ComponentID,
        VehicleID = self.Vehicle and self.Vehicle.ID,
        Level = self.Level,
        MaxLevel = self.MaxLevel,
        Storage = self.Storage:Serialize(),
        Throttle = self.Throttle
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

    local raft = self:New(data.ID, data.SpawnPosition, data.ComponentID)
    raft.ID = data.ID
    raft.SpawnPosition = data.SpawnPosition
    raft.ComponentID = data.ComponentID
    raft.Vehicle = data.VehicleID and Noir.Services.VehicleService:GetVehicle(data.VehicleID)
    raft.Level = data.Level
    raft.MaxLevel = data.MaxLevel
    raft.Storage = Raft.Classes.Storage:FromSerialized(data.Storage)
    raft.Throttle = data.Throttle

    return raft
end

-------------------------------
-- // Intellisense
-------------------------------

--[[
    A serialized Raft object.
]]
---@class RaftSerialized
---@field ID integer
---@field SpawnPosition SWMatrix
---@field ComponentID integer
---@field VehicleID integer
---@field Level integer
---@field MaxLevel integer
---@field Storage nil -- TODO: storage
---@field Throttle number