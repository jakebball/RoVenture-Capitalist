local ReplicatedStorage = game.ReplicatedStorage

local Vendor = ReplicatedStorage.Modules.Vendor

local Roact = require(Vendor.Roact)

local e = Roact.createElement

local Background = Roact.Component:extend("Background")

local Sidebar = require(script.Sidebar)
local Businesses = require(script.Businesses)
local Unlocks = require(script.Unlocks)
local Upgrades = require(script.Upgrades)
local Managers = require(script.Managers)
local Investors = require(script.Investors)
local Shop = require(script.Shop)
local Leaderboard = require(script.Leaderboard)

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
        }),

        Businesses = e(Businesses, {
            callAnimations = self.props.callAnimation,
            frequency = self.props.frequency,
            dampingRatio = self.props.dampingRatio
        }),

        Unlocks = e(Unlocks, {
            callAnimations = self.props.callAnimation,
            frequency = self.props.frequency,
            dampingRatio = self.props.dampingRatio
        }),

        Upgrades = e(Upgrades, {
            callAnimations = self.props.callAnimation,
            frequency = self.props.frequency,
            dampingRatio = self.props.dampingRatio
        }),

        Managers = e(Managers, {
            callAnimations = self.props.callAnimation,
            frequency = self.props.frequency,
            dampingRatio = self.props.dampingRatio
        }),

        Investors = e(Investors, {
            callAnimations = self.props.callAnimation,
            frequency = self.props.frequency,
            dampingRatio = self.props.dampingRatio
        }),
         
        Shop = e(Shop, {
            callAnimations = self.props.callAnimation,
            frequency = self.props.frequency,
            dampingRatio = self.props.dampingRatio
        }),

        Leaderboard = e(Leaderboard, {
            callAnimations = self.props.callAnimation,
            frequency = self.props.frequency,
            dampingRatio = self.props.dampingRatio
        })
    })
end

return Background