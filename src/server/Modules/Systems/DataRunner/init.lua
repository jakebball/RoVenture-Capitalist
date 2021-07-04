local DataRunner = {}

local ReplicatedStorage = game.ReplicatedStorage

local Vendor = ReplicatedStorage.Modules.Vendor

local Reducers = require(ReplicatedStorage.Modules.Reducers)

local Rodux = require(Vendor.Rodux)
local Promise = require(Vendor.Promise)
local ProfileService = require(Vendor.ProfileService)


local Players = game:GetService("Players")

local RoduxStoreCache = {}
local ProfilesCache = {}

local GameProfileStore = ProfileService.GetProfileStore(
    "PlayerData",
    {}
)

local reducer = Rodux.combineReducers({
    menu = Reducers.menuReducer,
    playerdata = Reducers.playerdataReducer,
    business = Reducers.businessReducer
})

Players.PlayerRemoving:Connect(function(player)
    local store = RoduxStoreCache[player.UserId]
    if store ~= nil then
        DataRunner._saveStoreData(player, store)
        store:destruct()
        store = nil
    end
end)

game.Players.PlayerAdded:Connect(function(player)
    if RoduxStoreCache[player.UserId] == nil then
        local store = Rodux.Store.new(reducer, {}, {Rodux.loggerMiddleware})
        RoduxStoreCache[player.UserId] = store
        DataRunner._loadStoreData(player, store)
    end
end)

function DataRunner.getStore(player)
    local store = RoduxStoreCache[player.UserId]
    return store
end

function DataRunner._loadStoreData(player, store)

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
        else
            profile:Release()
        end
    else
        player:Kick("error loading data, please try again")
    end

    store:dispatch({
        type = "setAll",
        stats = profile.Data,
    })
end

function DataRunner._saveStoreData(player, store)
    if ProfilesCache[player.UserId] ~= nil then
        ProfilesCache[player.UserId].Data = store:getState()
    end
end

return DataRunner