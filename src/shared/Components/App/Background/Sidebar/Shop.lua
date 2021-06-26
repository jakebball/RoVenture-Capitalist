local ReplicatedStorage = game.ReplicatedStorage

local Vendor = ReplicatedStorage.Modules.Vendor

local Roact = require(Vendor.Roact)

local e = Roact.createElement

local BaseButton = require(script.Parent.BaseButton)

local Shop = Roact.Component:extend("Shop")

function Shop:render()
    return e(BaseButton, {
        text = "Shop",
        image = "rbxassetid://6996353680",
        layoutorder = 6
    })
end

return Shop