local ReplicatedStorage = game.ReplicatedStorage

local Vendor = ReplicatedStorage.Modules.Vendor

local Roact = require(Vendor.Roact)
local RoactRodux = require(Vendor.RoactRodux)

local e = Roact.createElement

local BaseButton = require(script.Parent.BaseButton)

local Investors = Roact.Component:extend("Investors")

function Investors:render()
    return e(BaseButton, {
        text = "Investors",
        image = "rbxassetid://6996354785",
        layoutorder = 4,

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
                    menu = "Investors"
                })
            end
        }
    end
)(Investors)

