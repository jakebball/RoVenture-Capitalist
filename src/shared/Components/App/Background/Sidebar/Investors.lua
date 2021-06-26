local ReplicatedStorage = game.ReplicatedStorage

local Vendor = ReplicatedStorage.Modules.Vendor

local Roact = require(Vendor.Roact)

local e = Roact.createElement

local BaseButton = require(script.Parent.BaseButton)

local Investors = Roact.Component:extend("Investors")

function Investors:render()
    return e(BaseButton, {
        text = "Investors",
        image = "rbxassetid://6996354725",
        layoutorder = 4
    })
end

return Investors