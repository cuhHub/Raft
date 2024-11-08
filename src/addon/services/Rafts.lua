--------------------------------------------------------
-- [Raft] Services - Rafts
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
    A service that manages all spawned rafts.
]]
---@class Rafts: NoirService
---@field Rafts table<integer, Raft> All rafts in the game
---@field RAFT_COMPONENT_ID integer The component ID used by the service when spawning rafts. This is constant
---@field DEFAULT_RAFT_SPAWN SWMatrix The default spawn position for the main raft
---
---@field OnTickConnection NoirTask A connection to the onTick game callback
Raft.Rafts = Noir.Services:CreateService(
    "Rafts",
    false,
    "Handles the tracking and spawning of rafts.",
    "Handles the tracking and spawning of rafts.",
    {"Cuh4"}
)

Raft.Rafts.InitPriority = 0
Raft.Rafts.StartPriority = 0

--[[
    Called when the service is initialized.
]]
function Raft.Rafts:ServiceInit()
    self.Rafts = {} -- this is a table in case i plan on adding multiple rafts
    self.ID = self:EnsuredLoad("ID", 1)

    self.RAFT_COMPONENT_ID = 5
    self.DEFAULT_RAFT_SPAWN = self:GetIdealFishHotspot()
end

--[[
    Called when the service is started.
]]
function Raft.Rafts:ServiceStart()
    -- Load rafts
    self:LoadRafts()

    -- Spawn main raft
    if not self:GetMainRaft() then
        self:SpawnRaft(self.DEFAULT_RAFT_SPAWN)
    end

    -- Spawn raft vehicles if needed
    for _, raft in pairs(self:GetRafts()) do
        if not raft.Vehicle then
            raft:Spawn()
        end
    end

    -- Update rafts every tick
    self.OnTickConnection = Noir.Callbacks:Connect("onTick", function()
        for _, raft in pairs(self:GetRafts()) do
            raft:Update()
        end
    end)
end

--[[
    Returns the current raft ID while also incrementing the ID and saving it/
]]
---@return integer
function Raft.Rafts:GetID()
    self.ID = self.ID + 1
    self:Save("ID", self.ID)

    return self.ID
end

--[[
    Returns the position of the most ideal fish hotspot. This can be used as a raft spawn point for player convenience.
]]
---@return SWMatrix
function Raft.Rafts:GetIdealFishHotspot()
    local hotspots = server.getFishHotspots()

    table.sort(hotspots, function(a, b)
        return a.y < b.y
    end)


    local hotspot = hotspots[1]
    return matrix.translation(hotspot.x, 0, hotspot.z)
end

--[[
    Spawn a raft.
]]
---@param at SWMatrix
function Raft.Rafts:SpawnRaft(at)
    local raft = Raft.Classes.Raft:New(self:GetID(), at, self.RAFT_COMPONENT_ID)
    self:RegisterRaft(raft)
end

--[[
    Register a raft.
]]
---@param raft Raft
function Raft.Rafts:RegisterRaft(raft)
    self.Rafts[raft.ID] = raft
end

--[[
    Returns all rafts.
]]
---@return table<integer, Raft>
function Raft.Rafts:GetRafts()
    return self.Rafts
end

--[[
    Returns the main raft.
]]
---@return Raft
function Raft.Rafts:GetMainRaft()
    local index = next(self.Rafts)
    return self.Rafts[index]
end

--[[
    Returns all saved rafts.
]]
---@return table<integer, RaftSerialized>
function Raft.Rafts:GetSavedRafts()
    return self:Load("Rafts")
end

--[[
    Saves all rafts to g_savedata.
]]
function Raft.Rafts:SaveRafts()
    local rafts = {}

    for _, raft in pairs(self:GetRafts()) do
        rafts[raft.ID] = raft:Serialize()
    end

    self:Save("Rafts", rafts)
end

--[[
    Save a specific raft to g_savedata.
]]
---@param raft Raft
function Raft.Rafts:SaveRaft(raft)
    local rafts = self:GetSavedRafts()
    rafts[raft.ID] = raft:Serialize()

    self:Save("Rafts", rafts)
end

--[[
    Loads all rafts from g_savedata if possible.
]]
function Raft.Rafts:LoadRafts()
    local serializedRafts = self:GetSavedRafts()

    if not serializedRafts then
        self:SaveRafts()
        return
    end

    for _, serializedRaft in pairs(serializedRafts) do
        local raft = Raft.Classes.Raft:FromSerialized(serializedRaft)
        self:RegisterRaft(raft)
    end
end