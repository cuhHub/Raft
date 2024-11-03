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
    A service that manages the server's Raft.
]]
---@class Rafts: NoirService
---@field Rafts table<integer, Raft>
---
---@field OnTickConnection NoirTask
Raft.Rafts = Noir.Services:CreateService(
    "Rafts"
)

Raft.Rafts.InitPriority = 0
Raft.Rafts.StartPriority = 0

--[[
    Called when the service is initialized.
]]
function Raft.Rafts:ServiceInit()
    self.Rafts = {} -- this is a table in case i plan on adding multiple rafts
end

--[[
    Called when the service is started.
]]
function Raft.Rafts:ServiceStart()
    -- Load rafts
    self:LoadRafts()

    -- Spawn raft vehicles if needed
    for _, raft in pairs(self:GetRafts()) do
        if not raft.Vehicle then
            raft:Spawn()
        end
    end

    -- Update rafts every tick
    self.OnTickConnection = Noir.Services.TaskService:AddTickTask(function()
        for _, raft in pairs(self:GetRafts()) do
            raft:Update()
        end
    end, 1)
end

--[[
    Register a raft.
]]
---@param raft Raft
function Raft.Rafts:RegisterRaft(raft)
    table.insert(self:GetRafts(), raft)
end

--[[
    Returns all rafts.
]]
---@return table<integer, Raft>
function Raft.Rafts:GetRafts()
    return self.Rafts
end

--[[
    Returns the server's Raft.
]]
---@return Raft
function Raft.Rafts:GetServerRaft()
    return self.Rafts[0]
end

--[[
    Returns all saved rafts.
]]
---@return table<integer, RaftSerialized>
function Raft.Rafts:GetLoadedRafts()
    local loadedRafts = {}

    for _, raft in pairs(self:GetRafts()) do
        table.insert(loadedRafts, raft:Serialize())
    end

    return loadedRafts
end

--[[
    Saves all rafts to g_savedata.
]]
function Raft.Rafts:SaveRafts()
    local rafts = {}

    for _, raft in pairs(self:GetRafts()) do
        table.insert(rafts, raft:Serialize())
    end

    self:Save("Rafts", rafts)
end

--[[
    Loads all rafts from g_savedata if possible.
]]
function Raft.Rafts:LoadRafts()
    local serializedRafts = self:GetLoadedRafts()

    if not serializedRafts then
        self:SaveRafts()
        return
    end

    for _, serializedRaft in pairs(serializedRafts) do
        local raft = Raft.Classes.Raft:FromSerialized(serializedRaft)
        self:RegisterRaft(raft)
    end
end