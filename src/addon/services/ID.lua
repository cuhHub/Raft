--------------------------------------------------------
-- [Raft] Services - ID
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
    A service that provides an ID that is incremented on every retrieval call.
]]
---@class ID: NoirService
---@field ID integer The current ID
Raft.ID = Noir.Services:CreateService(
    "ID",
    false,
    "A service that provides an ID that is incremented on every retrieval call.",
    "A service that provides an ID that is incremented on every retrieval call. Other services can use this for unique identifiers.",
    {"Cuh4"}
)

--[[
    Called when the service is initialized.
]]
function Raft.ID:ServiceInit()
    self.ID = self:EnsuredLoad("ID", 1)
end

--[[
    Returns the current ID, but incrementing it and saving it beforehand.
]]
---@return integer
function Raft.ID:GetID()
    self.ID = self.ID + 1
    self:Save("ID", self.ID)

    return self.ID
end