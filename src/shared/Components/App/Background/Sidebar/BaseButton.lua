local ReplicatedStorage = game.ReplicatedStorage

local Vendor = ReplicatedStorage.Modules.Vendor

local Roact = require(Vendor.Roact)

local e = Roact.createElement

local BaseButton = Roact.Component:extend("BaseButton")

function BaseButton:render()
    return e("ImageButton", {
        AnchorPoint = Vector2.new(0.5,0.5),
        BackgroundTransparency = 1,
        Size = UDim2.new(0.855, 0, 0.147, 0),
        Image = self.props.image,
        ScaleType = Enum.ScaleType.Fit,
        LayoutOrder = self.props.layoutorder
    }, {
        e("TextLabel", {
            AnchorPoint = Vector2.new(0.5,0.5),
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5,0,0.5,0),
            Size = UDim2.new(0.85,0,0.85,0),
            Font = Enum.Font.DenkOne,
            TextColor3 = Color3.fromRGB(255,255,255),
            TextScaled = true,
            Text = self.props.text
        })
    })
end


return BaseButton