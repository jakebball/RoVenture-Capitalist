local ReplicatedStorage = game.ReplicatedStorage

local Vendor = ReplicatedStorage.Modules.Vendor

local Roact = require(Vendor.Roact)

local e = Roact.createElement

local BaseButton = require(script.Parent.BaseButton)

local Upgrades = Roact.Component:extend("Upgrades")

function Upgrades:render()
    return e(BaseButton, {
        text = "Upgrades",
        image = "rbxassetid://6996354725",
        layoutorder = 2
    })
end

return Upgrades