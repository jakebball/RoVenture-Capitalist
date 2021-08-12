local ReplicatedStorage = game.ReplicatedStorage

local Vendor = ReplicatedStorage.Modules.Vendor

local Roact = require(Vendor.Roact)
local RoactRodux = require(Vendor.RoactRodux)

local e = Roact.createElement

local BaseButton = require(script.Parent.BaseButton)

local Donate = Roact.Component:extend("Donate")

function Donate:render()
    return e(BaseButton, {
        text = "Donate",
        image = "rbxassetid://6996353680",
        layoutorder = 6,

        onClick = function()
            game:GetService("MarketplaceService"):PromptProductPurchase(game.Players.LocalPlayer, 1196113658)
        end
    })
end

return RoactRodux.connect(
    function(state)
        return {
            menu = state.menu
        }
    end,
    function()
        return {
            onClick = function()
                
            end
        }
    end
)(Donate)