local ReplicatedStorage = game.ReplicatedStorage

local Vendor = ReplicatedStorage.Modules.Vendor

local Roact = require(Vendor.Roact)
local RoactRodux = require(Vendor.RoactRodux)

local e = Roact.createElement

local BaseButton = require(script.Parent.BaseButton)

local Upgrades = Roact.Component:extend("Upgrades")

function Upgrades:render()
    return e(BaseButton, {
        text = "Upgrades",
        image = "rbxassetid://6996354785",
        layoutorder = 2,

        onClick = self.props.onClick
    })
end

return RoactRodux.connect(
    function(state)
        return {
            menu = state.menu
        }
    end,
    function(dispatch)
        return {
            onClick = function()
                dispatch({
                    type = "setMenu",
                    menu = "Upgrades"
                })
            end
        }
    end
)(Upgrades)