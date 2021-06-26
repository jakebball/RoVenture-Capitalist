local ReplicatedStorage = game.ReplicatedStorage

local Vendor = ReplicatedStorage.Modules.Vendor

local Roact = require(Vendor.Roact)

local App = require(ReplicatedStorage.Modules.Components.App)

local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

Roact.mount(Roact.createElement(App), PlayerGui, "RoVenture Capitalist")