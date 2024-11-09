--------------------------------------------------------
-- [Raft] Services - Debug
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
    A service for general debugging.
]]
---@class Debug: NoirService
Raft.Debug = Noir.Services:CreateService(
    "Debug",
    false,
    "A service for general debugging.",
    "A service for general debugging, comes with commands, etc.",
    {"Cuh4"}
)

--[[
    Called when the service is started.
]]
function Raft.Debug:ServiceStart()
    self:CreateCommands()
end

--[[
    Creates debug commands.
]]
function Raft.Debug:CreateCommands()
    Noir.Services.CommandService:CreateCommand(
        "savedata",
        {"sd", "g_savedata"},
        {},
        false,
        true,
        false,
        "Prints g_savedata",

        function(player, message, args, hasPermission)
            if not hasPermission then
                return
            end

            print(g_savedata)
            Noir.Services.NotificationService:Success("g_savedata", "Printed g_savedata, see logs.", player)
        end
    )

    Noir.Services.CommandService:CreateCommand(
        "despawn",
        {"de", "c"},
        {},
        false,
        true,
        false,
        "Despawns all vehicles and objects",

        function(player, message, args, hasPermission)
            if not hasPermission then
                return
            end

            for _, vehicle in pairs(Noir.Services.VehicleService:GetVehicles()) do
                vehicle:Despawn()
            end

            for _, object in pairs(Noir.Services.ObjectService:GetObjects()) do
                object:Despawn()
            end

            Noir.Services.NotificationService:Success("Despawn", "Despawned all vehicles and objects.", player)
        end
    )

    Noir.Services.CommandService:CreateCommand(
        "setthrottle",
        {"th"},
        {},
        false,
        true,
        false,
        "Sets the throttle of the main raft",

        function(player, message, args, hasPermission)
            if not hasPermission then
                return
            end

            local throttle = tonumber(args[1])

            if not throttle then
                Noir.Services.NotificationService:Error("Throttle", "Throttle must be a number.", player)
                return
            end

            Raft.Rafts:GetMainRaft():SetThrottle(throttle)
            Noir.Services.NotificationService:Success("Throttle", ("Set throttle to %d."):format(throttle), player)
        end
    )

    Noir.Services.CommandService:CreateCommand(
        "setlevel",
        {"sl"},
        {},
        false,
        true,
        false,
        "Sets the level of the main raft",

        function(player, message, args, hasPermission)
            if not hasPermission then
                return
            end

            local level = tonumber(args[1])

            if not level then
                Noir.Services.NotificationService:Error("Level", "Level must be a number.", player)
                return
            end

            local raft = Raft.Rafts:GetMainRaft()

            if level > raft.MaxLevel then
                Noir.Services.NotificationService:Error("Level", "Level must be less than %d.", player, raft.MaxLevel)
                return
            end

            raft:SetLevel(level)
            Noir.Services.NotificationService:Success("Level", "Level has been set to %d", player, level)
        end
    )
end