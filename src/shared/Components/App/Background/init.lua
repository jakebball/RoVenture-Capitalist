local ReplicatedStorage = game.ReplicatedStorage

local Vendor = ReplicatedStorage.Modules.Vendor

local Roact = require(Vendor.Roact)
local Flipper = require(Vendor.Flipper)
local RoactFlipper = require(Vendor.RoactFlipper)

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

function Background:init()
    self.notificationMotor = Flipper.SingleMotor.new(0)
    self.notificationBinding = RoactFlipper.getBinding(self.notificationMotor)

    self.notificationSmallTextBinding, self.updateSmallTextNotification = Roact.createBinding("")
    self.notificationLargeTextBinding, self.updateLargeTextNotification = Roact.createBinding("")

    self.notifyFunction = function(smallText, largeText)
        self.updateSmallTextNotification(smallText)
        self.updateLargeTextNotification(largeText)
        self.notificationMotor:setGoal(Flipper.Spring.new(1), {
            dampingRatio = 0.3,
            frequency = 1.3
        })
        task.wait(3)
        self.notificationMotor:setGoal(Flipper.Spring.new(0), {
            dampingRatio = 0.3,
            frequency = 1.3
        })
    end
end

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
            dampingRatio = self.props.dampingRatio,
            notify = self.notifyFunction
        }),

        Unlocks = e(Unlocks, {
            callAnimations = self.props.callAnimation,
            frequency = self.props.frequency,
            dampingRatio = self.props.dampingRatio,

            notify = self.notifyFunction
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
        }),

        Notification = e("ImageLabel", {
            BackgroundTransparency = 1,
            Position = self.notificationBinding:map(function(newValue)
                return UDim2.new(0.402, 0, -1, 0):Lerp(UDim2.new(0.402, 0, 0.14, 0), newValue)
            end),
            Size = UDim2.new(0.289, 0, 0.15, 0),
            ZIndex = 13,
            Image = "rbxassetid://6996354630",
            ScaleType = Enum.ScaleType.Fit
        }, {

            SmallTextLabel = e("TextLabel", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundTransparency = 1,
                Position = UDim2.new(0.5, 0, 0.243, 0),
                Size = UDim2.new(0.45, 0, .217, 0),
                ZIndex = 14,
                Font = Enum.Font.DenkOne,
                Text = self.notificationSmallTextBinding:map(function(newText)
                    return newText
                end),
                TextScaled = true,
                TextColor3 = Color3.fromRGB(255,255,255)
            }),

            LargeTextLabel = e("TextLabel", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundTransparency = 1,
                Position = UDim2.new(0.5, 0, 0.609, 0),
                Size = UDim2.new(0.62, 0, .514, 0),
                ZIndex = 14,
                Font = Enum.Font.DenkOne,
                Text = self.notificationLargeTextBinding:map(function(newText)
                    return newText
                end),
                TextScaled = true,
                TextColor3 = Color3.fromRGB(255,255,255)
            }),

            StarIcon = e("ImageLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0.07, 0, -.212, 0),
                Size = UDim2.new(0.253, 0, 0.502, 0),
                Rotation = -26,
                ZIndex = 14,
                Image = "rbxassetid://6996352626",
                ScaleType = Enum.ScaleType.Fit
            })
        })
    })
end

return Background