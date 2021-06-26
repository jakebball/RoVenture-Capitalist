local ReplicatedStorage = game.ReplicatedStorage


local Vendor = ReplicatedStorage.Modules.Vendor

local Roact = require(Vendor.Roact)

local e = Roact.createElement

local BaseButton = require(script.Parent.BaseButton)

local Unlocks = Roact.Component:extend("Unlocks")

function Unlocks:render()
    return e(BaseButton, {
        text = "Unlocks",
        image = "rbxassetid://6996354725",
        layoutorder = 1,

        onClick = function(rbx)
            ReplicatedStorage.Sounds.ClickSound:Play()
        end
    })
end

return Unlocks