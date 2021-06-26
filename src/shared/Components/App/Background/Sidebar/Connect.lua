local ReplicatedStorage = game.ReplicatedStorage

local Vendor = ReplicatedStorage.Modules.Vendor

local Roact = require(Vendor.Roact)

local e = Roact.createElement

local BaseButton = require(script.Parent.BaseButton)

local Connect = Roact.Component:extend("Connect")

function Connect:render()
    return e(BaseButton, {
        text = "Connect",
        image = "rbxassetid://6996353208",
        layoutorder = 5
    })
end

return Connect