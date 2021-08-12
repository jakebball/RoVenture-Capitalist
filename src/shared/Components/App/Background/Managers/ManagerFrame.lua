local ReplicatedStorage = game.ReplicatedStorage

local Vendor = ReplicatedStorage.Modules.Vendor

local Roact = require(Vendor.Roact)
local Flipper = require(Vendor.Flipper)
local RoactFlipper = require(Vendor.RoactFlipper)
local MathUtil = require(Vendor.MathUtil)

local e = Roact.createElement

local ManagerFrame = Roact.Component:extend("ManagerFrame")

function ManagerFrame:init()
    self.buyButtonSizeMotor = Flipper.SingleMotor.new(0)
    
    self.buyButtonSizeBinding = RoactFlipper.getBinding(self.buyButtonSizeMotor)
end

function ManagerFrame:render()
    local ManagerText = "Buy ("..MathUtil.Shorten(self.props.Manager.Cost).. "$)"

    if table.find(self.props.Managers, self.props.Manager.Name) ~= nil then ManagerText = "Owned" end

    return e("Frame", {
        BackgroundColor3 = Color3.fromRGB(76,192,222),
        LayoutOrder = self.props.layoutorder,
        ZIndex = 9
    },{
        UICorner = e("UICorner"),

        MoneyAmount = e("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0.025, 0, 0.036, 0),
            Size = UDim2.new(0.22, 0, 0.091, 0),
            Font = Enum.Font.DenkOne,
            Text = MathUtil.Shorten(self.props.playermoney).."$",
            TextColor3 = Color3.fromRGB(255,255,255),
            TextScaled = true
        }),
        
        Icon = e("ImageLabel", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5,0.5),
            Position = UDim2.new(0.5,0,0.423,0),
            Size = UDim2.new(0.6, 0, 0.4, 0),
            ZIndex = 10,
            ScaleType = Enum.ScaleType.Fit
        }),

        Title = e("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0.055, 0, 0.125, 0),
            Size = UDim2.new(0.912, 0, 0.187, 0),
            ZIndex = 11,
            Font = Enum.Font.DenkOne,
            Text = self.props.Manager.Name,
            TextColor3 = Color3.fromRGB(255,255,255),
            TextScaled = true
        }),

        Effect = e("TextLabel", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0.055, 0, 0.714, 0),
            Size = UDim2.new(0.912, 0, 0.102, 0),
            ZIndex = 11,
            Font = Enum.Font.DenkOne,
            Text = "",
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
            ZIndex = 11,
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

                if self.props.playermoney >= self.props.Manager.Cost and table.find(self.props.Managers, self.props.Manager.Name) == nil then
                    self.props.dispatchAction({
                        type = "giveManager",
                        manager = self.props.Manager.Name
                    })

                    self.props.dispatchAction({
                        type = "increment",
                        statname = "money",
                        value = -self.props.Manager.Cost
                    })

                    self.props.dispatchAction({
                        type = "implementManager",
                        manager = self.props.Manager.Name
                    })
                end
            end
        },{
            BuyLabel = e("TextLabel", {
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(0.5,0.5),
                Position = UDim2.new(0.508, 0, 0.455, 0),
                Size = UDim2.new(0.5, 0, 0.591, 0),
                ZIndex = 12,
                Font = Enum.Font.DenkOne,
                Text = ManagerText,
                TextColor3 = Color3.fromRGB(255,255,255),
                TextScaled = true
            }),
        })
    })
end

return ManagerFrame