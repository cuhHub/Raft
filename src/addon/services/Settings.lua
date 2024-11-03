--------------------------------------------------------
-- [Raft] Services - Setiings
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
    A service that manages the game settings.
]]
---@class Settings: NoirService
---@field Settings table<SWGameSettingEnum, boolean> The settings that the game should use
---@field OnTickConnection NoirConnection A connection to the onTick game callback
Raft.Settings = Noir.Services:CreateService(
    "Settings",
    false,
    "Handles the game's settings.",
    "Handles the game's settings to prevent cheating.",
    {"Cuh4"}
)

--[[
    Called when the service is initialized.
]]
function Raft.Settings:ServiceInit()
    self.Settings = {
        photo_mode = true,
        map_show_players = false,
        sharks = true,
        infinite_fuel = true,
        lightning = true,
        show_name_plates = true,
        override_weather = true, -- for weather service
        megalodon = false,
        infinite_money = true,
        -- day_length = 0,
        fast_travel = false,
        cleanup_vehicle = false,
        settings_menu = false,
        settings_menu_lock = true,
        rogue_mode = false,
        ceasefire = false,
        vehicle_damage = false,
        vehicle_spawning = false,
        engine_overheating = true,
        third_person_vehicle = false,
        infinite_ammo = false,
        no_clip = false,
        unlock_all_components = true,
        player_damage = true,
        map_show_vehicles = false,
        despawn_on_leave = true,
        third_person = false,
        infinite_batteries = true,
        teleport_vehicle = true,
        clear_fow = false, -- keep map hidden, let players discover
        npc_damage = true,
        show_3d_waypoints = false,
        map_teleport = false,
        respawning = true,
        unlock_all_islands = true
    }
end

--[[
    Called when the service is started.
]]
function Raft.Settings:ServiceStart()
    self.OnTickConnection = Noir.Callbacks:Connect("onTick", function()
        self:Update()
    end)
end

--[[
    Sets all settings.
]]
function Raft.Settings:Update()
    for setting, value in pairs(self.Settings) do
        Noir.Services.GameSettingsService:SetSetting(setting, value)
    end
end