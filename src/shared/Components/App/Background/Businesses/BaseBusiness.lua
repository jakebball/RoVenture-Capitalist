local ReplicatedStorage = game.ReplicatedStorage

local Vendor = ReplicatedStorage.Modules.Vendor

local Roact = require(Vendor.Roact)
local Flipper = require(Vendor.Flipper)
local RoactFlipper = require(Vendor.RoactFlipper)

local e = Roact.createElement

local BaseBusiness = Roact.Component:extend("BaseBusiness")

function BaseBusiness:init()
    self.buyButtonMotor = Flipper.SingleMotor.new(0)
    self.buyButtonBinding = RoactFlipper.getBinding(self.buyButtonMotor)

    self.runButtonMotor = Flipper.SingleMotor.new(0)
    self.runButtonBinding = RoactFlipper.getBinding(self.runButtonMotor)
end

function BaseBusiness:render()
    return e("Frame", {
        BackgroundTransparency = 1,
        ZIndex = 3
    }, {

        Background = e("ImageLabel", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            Position = UDim2.new(0.521, 0, 0.5, 0),
            Size = UDim2.new(0.865, 0, 0.68, 0),
            Image = "rbxassetid://6996351988",
            ZIndex = 2
        }),

        Icon = e("ImageButton", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5,0.5),
            Size = self.runButtonBinding:map(function(value)
                return UDim2.new(0.19, 0, 0.9, 0):Lerp(UDim2.new(0.211, 0, 1, 0), value)
            end),
            Position = UDim2.new(0.1, 0, 0.5, 0),
            Image = "rbxassetid://6996355491",
            ImageColor3 = Color3.fromRGB(255,221,25),
            ScaleType = Enum.ScaleType.Fit,
            ZIndex = 3,

            [Roact.Event.MouseButton1Click] = function(rbx)
                self.props.onCircleClick(rbx)
                self.runButtonMotor:setGoal(Flipper.Spring.new(0, {
                    frequency = 3,
                    dampingRatio = 0.85
                }))
            end,

            [Roact.Event.MouseEnter] = function()
                self.runButtonMotor:setGoal(Flipper.Spring.new(1, {
                    frequency = 3,
                    dampingRatio = 0.85
                }))
            end,

            [Roact.Event.MouseLeave] = function()
                self.runButtonMotor:setGoal(Flipper.Spring.new(0, {
                    frequency = 3,
                    dampingRatio = 0.85
                }))
            end
        }),

        Title = e("TextLabel", {
            AnchorPoint = Vector2.new(0.5,0.5),
            BackgroundTransparency = 0.97,
            Position = UDim2.new(0.559, 0, 0.028, 0),
            Size = UDim2.new(0.751, 0, 0.16, 0),
            Font = Enum.Font.DenkOne,
            TextColor3 = Color3.fromRGB(255,255,255),
            Text = self.props.name,
            TextScaled = true,
            ZIndex = 3
        }),

        TimeBarOutline = e("Frame", {
            Position = UDim2.new(0.22, 0, 0.248, 0),
            Size = UDim2.new(.7, 0, 0.241, 0),
            BackgroundTransparency = 1
        }, {
            UICorner = e("UICorner"),

            Hider = e("Frame", {
                AnchorPoint = Vector2.new(1,0.5),
                Position = UDim2.new(1.02, 0, 0.5, 0),
                Size = self.props.hiderPosition:map(function(value)
                    if value ~= nil then
                        return UDim2.new(1,0,0.8,0):Lerp(UDim2.new(0.011, 0, 0.8, 0), value)
                    end
                end),
                BackgroundColor3 = Color3.fromRGB(255,255,255),
                ZIndex = 4,
                BorderSizePixel = 0
            }),

            TimeBar = e("Frame", {
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = Color3.fromRGB(25,244,99),
                Position = UDim2.new(0.02, 0, 0.5, 0),
                Size = UDim2.new(0.989, 0, 0.8, 0),
                ZIndex = 3
            }, {
                UICorner = e("UICorner")
            }),

            Amount = e("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0.037, 0, 0, 0),
                Size = UDim2.new(0.943, 0, 1, 0),
                Font = Enum.Font.DenkOne,
                Text = self.props.amount,
                TextScaled = true,
                TextColor3 = Color3.fromRGB(130,86,215),
                ZIndex = 5
            }),

            Outline = e("Frame", {
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.new(0,0,0.5,0),
                Size = UDim2.new(1.029, 0, 1, 0),
                BackgroundColor3 = Color3.fromRGB(255,255,255),
                ZIndex = 2
            }, {
                UICorner = e("UICorner")
            })
        }),

        Buy = e("TextButton", {
            AnchorPoint = Vector2.new(0.5,0.5),
            BackgroundTransparency = 1,
            Position = UDim2.new(0.45, 0, 0.664, 0),
            Size = self.buyButtonBinding:map(function(value)
                return UDim2.new(0.397, 0, 0.235, 0):Lerp(UDim2.new(0.441, 0, 0.261, 0), value)
            end),
            TextTransparency = 1,
            ZIndex = 8,

            [Roact.Event.MouseButton1Click] = self.props.onBuyClick,
            
            [Roact.Event.MouseEnter] = function()
                self.buyButtonMotor:setGoal(Flipper.Spring.new(1, {
                    frequency = 3,
                    dampingRatio = 0.85
                }))
            end,

            [Roact.Event.MouseLeave] = function()
                self.buyButtonMotor:setGoal(Flipper.Spring.new(0, {
                    frequency = 3,
                    dampingRatio = 0.85
                }))
            end
        }, {
            Background =  e("ImageLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                ZIndex = 6,
                Image =  "rbxassetid://6996354785",
                ScaleType = Enum.ScaleType.Stretch
            }, {
                BuyLabel = e("TextLabel", {
                    AnchorPoint = Vector2.new(0.5,0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.271, 0, 0.5, 0),
                    Size = UDim2.new(0.468, 0, 0.802, 0),
                    ZIndex = 7,
                    Text = self.props.amountbuying,
                    TextColor3 = Color3.fromRGB(255,255,255),
                    TextScaled = true,
                    Font = Enum.Font.DenkOne
                }),

                CostLabel = e("TextLabel", {
                    AnchorPoint = Vector2.new(0.5,0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.734, 0, 0.5, 0),
                    Size = UDim2.new(0.458, 0, 0.802, 0),
                    ZIndex = 7,
                    Text = self.props.cost,
                    TextColor3 = Color3.fromRGB(255,255,255),
                    TextScaled = true,
                    Font = Enum.Font.DenkOne
                })
            })
        }),

        TimeLeft = e("TextLabel", {
            AnchorPoint = Vector2.new(0.5,0.5),
            Position = UDim2.new(0.813, 0, 0.664, 0),
            Size = UDim2.new(.254, 0, .261, 0),
            ZIndex = 8,
            BackgroundColor3 = Color3.fromRGB(255,141,10),
            Text = self.props.timeleft,
            TextColor3 = Color3.fromRGB(255,255,255),
            TextScaled = true,
            Font = Enum.Font.DenkOne
        }, {
            UICorner = e("UICorner")
        })
    })
end

return BaseBusiness