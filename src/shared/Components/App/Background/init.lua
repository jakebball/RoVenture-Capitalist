local ReplicatedStorage = game.ReplicatedStorage

local Vendor = ReplicatedStorage.Modules.Vendor

local Roact = require(Vendor.Roact)

local e = Roact.createElement

local Background = Roact.Component:extend("Background")

local Sidebar = require(script.Sidebar)

function Background:render()
    return e("Frame", {
        Size = UDim2.new(1,0,1,0),
        BackgroundColor3 = Color3.fromRGB(115, 105, 96),
        ZIndex = -1,
    }, {
        Wood = e("ImageLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1,0,1,0),
            ZIndex = -1,
            Image = "http://www.roblox.com/asset/?id=2325123",
            ImageTransparency = 0.8,
            ScaleType = Enum.ScaleType.Stretch
        }),

        Sidebar = e(Sidebar, {
            setupAnimations = self.props.setupAnimation,
            callAnimations = self.props.callAnimation,
        })
    })
end

return Background