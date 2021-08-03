local ReplicatedStorage = game.ReplicatedStorage

local Vendor = ReplicatedStorage.Modules.Vendor

local Roact = require(Vendor.Roact)

local e = Roact.createElement

local Notification = Roact.Component:extend("Notification")

function Notification:init()
    self.mo
end
