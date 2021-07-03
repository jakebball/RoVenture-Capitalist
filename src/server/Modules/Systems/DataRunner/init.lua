local DataRunner = {}

local ReplicatedStorage = game.ReplicatedStorage

local Vendor = ReplicatedStorage.Modules.Vendor

local Reducers = require(ReplicatedStorage.Reducers)

local Rodux = require(Vendor.Rodux)
local Promise = require(Vendor.Promise)

local PlayerData = require(script.PlayerData)

local Players = game:GetService("Players")

local RoduxStoreCache = {}

Players.PlayerRemoving:Connect(function(player)
    local store = RoduxStoreCache[player.UserId]
    if store ~= nil then
        DataRunner._saveStoreData(store)
        store:destruct()
        store = nil
    end
end)

function DataRunner.getStore(player)
    local store = RoduxStoreCache[player.UserId]

    if store == nil then
        store = Rodux.Store.new(Reducers)
        RoduxStoreCache[player.UserId] = store
        DataRunner._loadStoreData(store)
    end

    return store
end

function DataRunner._loadStoreData(store)
    
end

function DataRunner._saveStoreData(store)
    
end

return DataRunner