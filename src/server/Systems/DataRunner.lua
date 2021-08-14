local DataRunner = {}

local ReplicatedStorage = game.ReplicatedStorage

local Vendor = ReplicatedStorage.Modules.Vendor
local RemoteFunctions = ReplicatedStorage.RemoteFunctions
local RemoteEvent = ReplicatedStorage.RemoteEvents

local BusinessData = require(ReplicatedStorage.Modules.EconomyData.BusinessData)

local Reducers = require(ReplicatedStorage.Modules.Reducers)

local ProfileService = require(Vendor.ProfileService)

local Players = game:GetService("Players")

local ProfilesCache = {}

local initialBusinessTable = {
    ["Begging For Robux"] = {},
    ["Selling Free Models"] = {},
    ["Item Trading"] = {},
    ["Selling Bad UGC"] = {},
    ["Selling Frontpage UGC"] = {},
    ["Selling Plugins"] = {},
    ["Selling Game Maps"] = {},
    ["Make A Clicking Game"] = {},
    ["Make A Simulator"] = {},
    ["Make An FPS Game"] = {},
    ["amountbuying"] = 1,
    ["maxpage"] = 1
}

for k,v in pairs(initialBusinessTable) do
    if BusinessData[k] ~= nil then
        v.gain = BusinessData[k].Initial_Revenue
        v.time = BusinessData[k].Initial_Time
        v.cost = BusinessData[k].Initial_Cost
        v.amountowned = 0
        v.hasmanager = false
        if k == "Begging For Robux" then
            v.playerOwnsBusiness = true
            v.amountowned = 1
        else
            v.playerOwnsBusiness = false
        end
    end
end

local GameProfileStore = ProfileService.GetProfileStore(
    "PlayerData",
    {
        playerdata = {
            money = 0,
            unlocks = {},
            upgrades = {},
            managers = {},
            maxunlockpage = 0,
            maxupgradepage = 0,
            currentupgradepage = 1,
            currentunlockpage = 1,
        },
        menu = {
            "Business"
        },
        business = initialBusinessTable
    }
)
game.Players.PlayerAdded:Connect(function(player)
    DataRunner._loadProfileData(player)
end)

function DataRunner._loadProfileData(player)

    local profile = GameProfileStore:LoadProfileAsync(
        "Player-"..player.UserId,
        "ForceLoad"
    )

    if profile ~= nil then
        profile:Reconcile()
        profile:ListenToRelease(function()
            ProfilesCache[player.UserId] = nil
            player:Kick()
        end)

        if Players:FindFirstChild(player.Name) then
            ProfilesCache[player.UserId] = profile
            print(ProfilesCache[player.UserId].Data)
            RemoteEvent.UpdateClientStore:FireClient(player, ProfilesCache[player.UserId].Data)
        else
            profile:Release()
        end
    else
        player:Kick("error loading data, please try again")
    end
end

function DataRunner._updateStoreData(player, newState)
    local profile = ProfilesCache[player.UserId]

    if profile ~= nil then
        profile.Data = newState
        return true
    end

    return false
end

RemoteFunctions.Save.OnServerInvoke = DataRunner._updateStoreData

return DataRunner