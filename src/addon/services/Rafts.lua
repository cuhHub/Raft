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
---@field Raft Raft The server's Raft
Raft.Rafts = Noir.Services:CreateService(
    "Rafts"
)

--[[
    Called when the service is initialized.
]]
function Raft.Rafts:ServiceInit()
    self.Raft = Raft.Classes.Raft:New(matrix.translation(10000, 0, 0), 2)
    self:SaveRaft()
end

--[[
    Called when the service is started.
]]
function Raft.Rafts:ServiceStart()
    self:LoadRaft() -- saves if no raft to load

    if not self.Raft.Vehicle then
        self.Raft:Spawn()
        self:SaveRaft()
    end
end

--[[
    Saves the Raft to g_savedata.
]]
function Raft.Rafts:SaveRaft()
    self:Save("Raft", self.Raft:Serialize())
end

--[[
    Loads the Raft from g_savedata if possible.
]]
function Raft.Rafts:LoadRaft()
    local data = self:Load("Raft")

    if not data then
        self:SaveRaft()
        return
    end

    self.Raft:FromSerialized(data)
end