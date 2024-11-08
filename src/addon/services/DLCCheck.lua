--------------------------------------------------------
-- [Raft] Services - DLC Check
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
    A service for checking if the server has the DLCs required.
]]
---@class DLCCheck: NoirService
---@field MissingDLCs boolean Whether the server is missing DLCs required for this addon
---@field OnJoinConnection NoirConnection A connection to the `PlayerService` `OnJoin` event
Raft.DLCCheck = Noir.Services:CreateService(
    "DLCCheck",
    false,
    "A service for checking if the server has the DLCs required.",
    "A service for checking if the server has the DLCs required. If not, all services are disabled.",
    {"Cuh4"}
)

Raft.DLCCheck.StartPriority = 0

--[[
    Called when the service is initialized.
]]
function Raft.DLCCheck:ServiceInit()
    self.MissingDLCs = false
end

--[[
    Called when the service is started.
]]
function Raft.DLCCheck:ServiceStart()
    ---@param player NoirPlayer
    self.OnJoinConnection = Noir.Services.PlayerService.OnJoin:Connect(function(player)
        if not self.MissingDLCs then
            return
        end

        self:Notify()
    end)

    self.MissingDLCs = not server.dlcWeapons()

    if self.MissingDLCs then
        self:DisableServices()
    end
end

--[[
    Notify that DLCs are missing.
]]
function Raft.DLCCheck:Notify()
    local message = "Raft is missing the required DLCs. Please enable the required DLCs shown on the workshop page."

    Noir.Services.NotificationService:Notify("Raft", message, 2, nil)
    Noir.Services.MessageService:SendMessage(nil, "[Raft]", message)
end

--[[
    Removes all services.
]]
function Raft.DLCCheck:DisableServices()
    for _, service in pairs(Raft --[[@as table<integer, NoirService>]]) do
        if not Noir.Classes.ServiceClass:IsSameType(service) then
            goto continue
        end

        -- service will be started even when removed since noir's bootstrapper has started doing its thing, so we have to do this instead
        service.ServiceStart = function() end

        ::continue::
    end
end