local ReplicatedStorage = game.ReplicatedStorage

local Vendor = ReplicatedStorage.Modules.Vendor

local Roact = require(Vendor.Roact)
local RoactRodux = require(Vendor.RoactRodux)

local e = Roact.createElement

local BaseButton = require(script.Parent.BaseButton)

local Shop = Roact.Component:extend("Shop")

function Shop:render()
    return e(BaseButton, {
        text = "Shop",
        image = "rbxassetid://6996353680",
        layoutorder = 6,

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
                    menu = "Shop"
                })
            end
        }
    end
)(Shop)