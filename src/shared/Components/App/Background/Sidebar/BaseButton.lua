local ReplicatedStorage = game.ReplicatedStorage

local Vendor = ReplicatedStorage.Modules.Vendor

local Roact = require(Vendor.Roact)
local Flipper = require(Vendor.Flipper)

local e = Roact.createElement

local BaseButton = Roact.Component:extend("BaseButton")

local SIZE_INCREASE_FACTOR = 1.05

function BaseButton:init()

    self.buttonSizeMotor = Flipper.SingleMotor.new(0)

    local sizeBinding, setSizeBinding = Roact.createBinding(self.buttonSizeMotor:getValue())
    self.sizeBinding = sizeBinding

    self.buttonSizeMotor:onStep(setSizeBinding)
end

function BaseButton:render()
    return e("ImageButton", {
        AnchorPoint = Vector2.new(0.5,0.5),
        BackgroundTransparency = 1,

        Size = self.sizeBinding:map(function(value)
            return UDim2.new(0.855, 0, 0.147, 0):Lerp(UDim2.new(0.940, 0, 0.161), value)
        end),

        Image = self.props.image,
        ScaleType = Enum.ScaleType.Fit,
        LayoutOrder = self.props.layoutorder,

        [Roact.Event.MouseButton1Click] = self.props.onClick,

        [Roact.Event.MouseEnter] = function(rbx)
            self.buttonSizeMotor:setGoal(Flipper.Spring.new(1, {
                frequency = 5,
                dampingRatio = 0.35
            }))
        end,

        [Roact.Event.MouseLeave] = function(rbx)
            self.buttonSizeMotor:setGoal(Flipper.Spring.new(0, {
                frequency = 5,
                dampingRatio = 0.35
            }))
        end
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