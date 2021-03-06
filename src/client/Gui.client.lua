local ReplicatedStorage = game.ReplicatedStorage

local Vendor = ReplicatedStorage.Modules.Vendor
local RemoteEvents = ReplicatedStorage.RemoteEvents

local Roact = require(Vendor.Roact)
local Rodux = require(Vendor.Rodux)
local RoactRodux = require(Vendor.RoactRodux)

local App = require(ReplicatedStorage.Modules.Components.App)

local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local Reducers = require(ReplicatedStorage.Modules.Reducers)

local reducer = Rodux.combineReducers({
    menu = Reducers.menuReducer,
    playerdata = Reducers.playerdataReducer,
    business = Reducers.businessReducer
})

local store = Rodux.Store.new(reducer)

RemoteEvents.UpdateClientStore.OnClientEvent:Connect(function(newState)
    store:dispatch({
        type = "setAll",
        stats = newState.playerdata
    })

    store:dispatch({
        type = "setAllBusiness",
        newState = newState.business
    })
end)

Roact.mount(Roact.createElement(RoactRodux.StoreProvider, {
    store = store
}, {
    App = Roact.createElement(App)
}), PlayerGui, "RoVenture Capitalist")
