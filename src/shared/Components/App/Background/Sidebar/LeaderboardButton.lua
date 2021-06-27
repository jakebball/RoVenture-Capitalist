local ReplicatedStorage = game.ReplicatedStorage

local Vendor = ReplicatedStorage.Modules.Vendor

local Roact = require(Vendor.Roact)
local RoactRodux = require(Vendor.RoactRodux)

local e = Roact.createElement

local LeaderboardButton = Roact.Component:extend("LeaderboardButton")

function LeaderboardButton:render()
    return e("ImageLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0.7, 0, 0.72, 0),
        Size = UDim2.new(0.371, 0, 0.301, 0),
        Image = "rbxassetid://6996355491",
        ImageColor3 = Color3.fromRGB(40,201,246),
        ScaleType = Enum.ScaleType.Fit,
        ZIndex = 5
    }, {
        TrophyButton = e("ImageLabel", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5,0,0.5,0),
            Size = UDim2.new(0.563, 0, 0.676, 0),
            Image = "rbxassetid://6996352449",
            ScaleType = Enum.ScaleType.Stretch,
            ZIndex = 6,       
        }, {
            ClickDetector = e("TextButton", {
                Size = UDim2.new(1.3,0,1.4,0),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                BackgroundTransparency = 1,
                TextTransparency = 1,
                AnchorPoint = Vector2.new(0.5,0.5),
                ZIndex = 6,

                [Roact.Event.MouseButton1Click] = function()
                    ReplicatedStorage.Sounds.ClickSound:Play()
                    self.props.onClick()
                end
            })
        })
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
                    menu = "Leaderboard"
                })
            end
        }
    end
)(LeaderboardButton)