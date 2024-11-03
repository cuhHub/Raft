--------------------------------------------------------
-- [Raft] Services - Weather
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
    A service that manages the weather.
]]
---@class Weather: NoirService
---@field FogMultiplier number The fog multiplier
---@field RainMultiplier number The rain multiplier
---@field WindMultiplier number The snow multiplier
---@field WeatherRandomizerTask NoirTask A task used to randomize the weather
---
---@field OnTickConnection NoirConnection A connection to the onTick game callback
Raft.Weather = Noir.Services:CreateService(
    "Weather",
    false,
    "Handles the weather.",
    "Handles the weather, while also handling weather events, etc.",
    {"Cuh4"}
)

--[[
    Called when the service is started.
]]
function Raft.Weather:ServiceStart()
    self.WeatherRandomizerTask = Noir.Services.TaskService:AddTimeTask(function()
        self:OffsetFog(math.random(-1000, 1000) / 10000)
        self:OffsetRain(math.random(-1000, 1000) / 10000)
        self:OffsetWind(math.random(-1000, 1000) / 10000)
    end, 2)

    self.OnTickConnection = Noir.Callbacks:Connect("onTick", function()
        local level, maxLevel = self:GetRaftLevel()
        local levelMultiplier = level / maxLevel

        server.setWeather(
            1 * self.FogMultiplier * levelMultiplier,
            1 * self.RainMultiplier * levelMultiplier,
            1 * self.WindMultiplier * levelMultiplier
        )
    end)
end

--[[
    Get the level and max level of the main raft
]]
---@return number, number
function Raft.Weather:GetRaftLevel()
    local raft = Raft.Rafts:GetMainRaft()
    return raft.Level, raft.MaxLevel
end

--[[
    Offset the fog multiplier
]]
---@param offset number
function Raft.Weather:OffsetFog(offset)
    self.FogMultiplier = Noir.Libraries.Number:Clamp(self.FogMultiplier + offset, 0, 1)
end

--[[
    Offset the rain multiplier
]]
---@param offset number
function Raft.Weather:OffsetRain(offset)
    self.RainMultiplier = Noir.Libraries.Number:Clamp(self.RainMultiplier + offset, 0, 1)
end

--[[
    Offset the wind multiplier
]]
---@param offset number
function Raft.Weather:OffsetWind(offset)
    self.WindMultiplier = Noir.Libraries.Number:Clamp(self.WindMultiplier + offset, 0, 1)
end