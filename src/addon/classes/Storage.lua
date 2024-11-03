--------------------------------------------------------
-- [Raft] Classes - Storage
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
    A class representing storage that contains items.
]]
---@class Storage: NoirClass
---@field New fun(self: Storage, itemLimit: integer): Storage
---@field Items table<integer, Item> The items in this storage.
---@field ItemLimit integer The maximum amount of items that can be stored in this storage.
---
---@field OnItemAdded NoirEvent Arguments: item (Item) | Fired when an item is added to this storage.
---@field OnItemRemoved NoirEvent Arguments: item (Item) | Fired when an item is removed from this storage.
Raft.Classes.Storage = Noir.Class("Storage")

--[[
    Initialize Storage objects.
]]
---@param itemLimit integer
function Raft.Classes.Storage:Init(itemLimit)
    self.Items = {}
    self.ItemLimit = itemLimit

    self.OnItemAdded = Noir.Libraries.Events:Create()
    self.OnItemRemoved = Noir.Libraries.Events:Create()
end

-- todo: methods for adding items, removing items, etc

--[[
    Returns a table of all items in this storage but serialized.
]]
---@return table<integer, ItemSerialized>
function Raft.Classes.Storage:SerializeItems()
    local items = {}

    for _, item in pairs(self.Items) do
        items[item.ID] = item:Serialize()
    end

    return items
end

--[[
    Serializes this Storage into g_savedata format.
]]
---@return StorageSerialized
function Raft.Classes.Storage:Serialize()
    return {
        ItemLimit = self.ItemLimit,
        Items = self:SerializeItems()
    }
end

--[[
    Converts serialized items into deserialized ones.
]]
---@param items table<integer, ItemSerialized>
function Raft.Classes.Storage:DeserializeItems(items)
    local deserializedItems = {}

    for _, item in pairs(items) do
        local deserializedItem = Raft.Classes.Item:New()
        deserializedItem:FromSerialized(item)

        deserializedItems[deserializedItem.ID] = deserializedItem
    end

    return deserializedItems
end

--[[
    Deserializes this Storage from g_savedata format.
]]
---@param data StorageSerialized
function Raft.Classes.Storage:FromSerialized(data)
    self.ItemLimit = data.ItemLimit
    self.Items = self:DeserializeItems(data.Items)
end

-------------------------------
-- // Intellisense
-------------------------------

--[[
    A serialized Storage object.
]]
---@class StorageSerialized
---@field ItemLimit integer
---@field Items table<integer, ItemSerialized>