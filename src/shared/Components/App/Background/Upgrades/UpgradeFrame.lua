local ReplicatedStorage = game.ReplicatedStorage

local Vendor = ReplicatedStorage.Modules.Vendor

local Roact = require(Vendor.Roact)
local Flipper = require(Vendor.Flipper)
local RoactFlipper = require(Vendor.RoactFlipper)
local MathUtil = require(Vendor.MathUtil)

local e = Roact.createElement

local UpgradeFrame = Roact.Component:extend("UpgradeFrame")

function UpgradeFrame:init()
    self.buyButtonSizeMotor = Flipper.SingleMotor.new(0)
    
    self.buyButtonSizeBinding = RoactFlipper.getBinding(self.buyButtonSizeMotor)
end

function UpgradeFrame:render()
    local upgradeText = "Buy ("..MathUtil.Shorten(self.props.upgrade.Cost).. "$)"

    if table.find(self.props.upgrades, self.props.upgrade.Name) ~= nil then upgradeText = "Owned" end

    local backgroundColor = Color3.fromRGB(76,192,222)

    if self.props.upgrade.Page == 2 then
        backgroundColor = Color3.fromRGB(91,91,91)
    end

    return e("Frame", {
        BackgroundColor3 = backgroundColor,
        LayoutOrder = self.props.layoutorder,
        ZIndex = 4
    },{
        UICorner = e("UICorner"),
        
        Icon = e("TextLabel", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5,0.5),
            Position = UDim2.new(0.5,0,0.423,0),
            Size = UDim2.new(0.6, 0, 0.4, 0),
            ZIndex = 5,
            Text = string.upper(string.sub(self.props.upgrade.Name, 1, 1)),
            TextScaled = true,
            TextColor3 = Color3.fromRGB(255,255,255),
            Font = Enum.Font.DenkOne
        }),

        Title = e("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0.055, 0, 0.125, 0),
            Size = UDim2.new(0.912, 0, 0.187, 0),
            ZIndex = 6,
            Font = Enum.Font.DenkOne,
            Text = self.props.upgrade.Name,
            TextColor3 = Color3.fromRGB(255,255,255),
            TextScaled = true
        }),

        Effect = e("TextLabel", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0.055, 0, 0.714, 0),
            Size = UDim2.new(0.912, 0, 0.102, 0),
            ZIndex = 6,
            Font = Enum.Font.DenkOne,
            Text = self.props.upgrade.Description,
            TextColor3 = Color3.fromRGB(255,255,255),
            TextScaled = true
        }),

        BuyButton = e("ImageButton", {
            AnchorPoint = Vector2.new(0.5, 0),
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, 0, 0.793, 0),
            Size = self.buyButtonSizeBinding:map(function(newVaue)
                return UDim2.new(0.912, 0, 0.187, 0):Lerp(UDim2.new(0.912 * 1.05, 0, 0.187 * 1.05, 0), newVaue)
            end),
            ZIndex = 6,
            Image = "rbxassetid://6996354785",
            ScaleType = Enum.ScaleType.Fit,

            [Roact.Event.MouseEnter] = function()
                self.buyButtonSizeMotor:setGoal(Flipper.Spring.new(1,{
                    dampingRatio = .8,
                    frequency = 6
                }))
            end,

            [Roact.Event.MouseLeave] = function()
                self.buyButtonSizeMotor:setGoal(Flipper.Spring.new(0,{
                    dampingRatio = .8,
                    frequency = 6
                }))
            end,

            [Roact.Event.MouseButton1Click] = function()
                self.buyButtonSizeMotor:setGoal(Flipper.Spring.new(0,{
                    dampingRatio = .8,
                    frequency = 6
                }))

                if self.props.playermoney >= self.props.upgrade.Cost and table.find(self.props.upgrades, self.props.upgrade.Name) == nil then
                    self.props.dispatchAction({
                        type = "giveUpgrade",
                        upgrade = self.props.upgrade.Name
                    })

                    self.props.dispatchAction({
                        type = "increment",
                        statname = "money",
                        value = -self.props.upgrade.Cost
                    })

                    self.props.dispatchAction({
                        type = "implementUpgrade",
                        businessname = self.props.name,
                        upgrade = self.props.upgrade
                    })
                end
            end
        },{
            BuyLabel = e("TextLabel", {
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(0.5,0.5),
                Position = UDim2.new(0.508, 0, 0.455, 0),
                Size = UDim2.new(0.5, 0, 0.591, 0),
                ZIndex = 6,
                Font = Enum.Font.DenkOne,
                Text = upgradeText,
                TextColor3 = Color3.fromRGB(255,255,255),
                TextScaled = true
            }),
        })
    })
end

return UpgradeFrame