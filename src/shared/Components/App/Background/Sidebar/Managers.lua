local ReplicatedStorage = game.ReplicatedStorage

local Vendor = ReplicatedStorage.Modules.Vendor

local Roact = require(Vendor.Roact)

local e = Roact.createElement

local BaseButton = require(script.Parent.BaseButton)

local Managers = Roact.Component:extend("Managers")

function Managers:render()
    return e(BaseButton, {
        text = "Managers",
        image = "rbxassetid://6996354725",
        layoutorder = 3
    })
end

return Managers