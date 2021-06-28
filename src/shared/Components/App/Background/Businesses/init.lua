local ReplicatedStorage = game.ReplicatedStorage

local Vendor = ReplicatedStorage.Modules.Vendor

local Roact = require(Vendor.Roact)
local RoactRodux = require(Vendor.RoactRodux)
local Flipper = require(Vendor.Flipper)

local e = Roact.createElement

local Businesses = Roact.Component:extend("Businesses")

local BaseBusiness = require(script.BaseBusiness)

function Businesses:init(initialProps)
    self.positionMotor = Flipper.SingleMotor.new(1)
    self.barVenture1Motor = Flipper.SingleMotor.new(0)
    
    self.backgroundPosition, self.updateBackgroundPosition = Roact.createBinding(self.positionMotor:getValue())
    self.barVenture1Position, self.updateVenture1BarPosition = Roact.createBinding(self.barVenture1Motor:getValue())
    
    self.positionMotor:onStep(self.updateBackgroundPosition)
    self.barVenture1Motor:onStep(self.updateVenture1BarPosition)
end

function Businesses:render()
    return e("Frame", {
        AnchorPoint = Vector2.new(0.5,0.5),
        BackgroundTransparency = 1,
        Position = self.backgroundPosition:map(function(value)
            return UDim2.new(1.5, 0, 0.5, 0):Lerp(UDim2.new(0.587,0, 0.5, 0), value)
        end),
        Size = UDim2.new(0.8, 0, 0.964, 0),
    }, {

        Background = e("ImageLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1,0,1,0),
            Image = "rbxassetid://6996355759",
        }, {

            UICorner = e("UICorner", {
                CornerRadius = UDim.new(0.1, 0)
            }),

            Title = e("TextLabel", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundTransparency = 1,
                Position = UDim2.new(0.5, 0, 0.07, 0),
                Size = UDim2.new(0.39, 0, 0.114, 0),
                Font = Enum.Font.DenkOne,
                Text = "Businesses",
                TextColor3 = Color3.fromRGB(255,255,255),
                TextScaled = true
            }, {
                Underline = e("Frame", {
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5,0,0.95,0),
                    Size = UDim2.new(1,0,0.1,0),
                    BackgroundColor3 = Color3.fromRGB(255,255,255)
                }, {
                    UICorner = e("UICorner")
                })
            })
        }),

        Main = e("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, 0, 0.557, 0),
            Size = UDim2.new(0.952, 0, 0.825, 0)
        }, {
            UIGridLayout = e("UIGridLayout", {
                CellPadding = UDim2.new(0.05, 0, 0, 0),
                CellSize = UDim2.new(0.45, 0, 0.2, 0),
                HorizontalAlignment = Enum.HorizontalAlignment.Center
            }),

            BeggingForRobux = e(BaseBusiness, {
                name = "Begging For Robux",
                amount = "5.2",
                onCircleClick = function()
                    self.updateVenture1BarPosition(self.barVenture1Motor:setGoal(Flipper.Spring.new(1, {
                        frequency = 3,
                        dampingRatio = 1,
                    })))
                end,
                hiderPosition = self.barVenture1Position
            })
        })
    })
end

function Businesses:didUpdate()
    if self.props.menu == "Businesses" then
        self.positionMotor:setGoal(Flipper.Spring.new(1, {
            frequency = self.props.frequency,
            dampingRatio = self.props.dampingRatio
        }))
    else
        self.positionMotor:setGoal(Flipper.Spring.new(0, {
            frequency = self.props.frequency,
            dampingRatio = self.props.dampingRatio
        })) 
    end
end

return RoactRodux.connect(
    function(state, props)
        return {
            menu = state.menu,
            businesses = state.business
        }
    end,
    function(dispatch)
        return {
            onClick = function()
                dispatch({
                   
                })
            end,
        }
    end
)(Businesses)
