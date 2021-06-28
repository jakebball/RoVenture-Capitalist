local ReplicatedStorage = game.ReplicatedStorage

local Vendor = ReplicatedStorage.Modules.Vendor

local Roact = require(Vendor.Roact)

local e = Roact.createElement

local BaseBusiness = Roact.Component:extend("BaseBusiness")

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
            Size = UDim2.new(0.211, 0, 1, 0),
            Image = "rbxassetid://6996355491",
            ImageColor3 = Color3.fromRGB(255,221,25),
            ScaleType = Enum.ScaleType.Fit,
            ZIndex = 3,

            [Roact.Event.MouseButton1Click] = self.props.onCircleClick
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
                    return UDim2.new(1,0,0.8,0):Lerp(UDim2.new(0.011, 0, 0.8, 0), value)
                end),
                BackgroundColor3 = Color3.fromRGB(255,255,255),
                ZIndex = 4
            }, {
                UICorner = e("UICorner")
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
    })
end

function BaseBusiness:didUpdate()
    
end

return BaseBusiness