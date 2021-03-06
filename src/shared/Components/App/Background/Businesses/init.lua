local ReplicatedStorage = game.ReplicatedStorage

local Vendor = ReplicatedStorage.Modules.Vendor

local Roact = require(Vendor.Roact)
local RoactRodux = require(Vendor.RoactRodux)
local Flipper = require(Vendor.Flipper)
local RoactFlipper = require(Vendor.RoactFlipper)
local MathUtil = require(Vendor.MathUtil)

local e = Roact.createElement

local Businesses = Roact.Component:extend("Businesses")

local BaseBusiness = require(script.BaseBusiness)

local BUSINESS_INFO = {
    {Name = "Begging For Robux"},
    {Name = "Selling Free Models"},
    {Name = "Item Trading"},
    {Name = "Selling Bad UGC"},
    {Name = "Selling Frontpage UGC"},
    {Name = "Selling Plugins"},
    {Name = "Selling Game Maps"},
    {Name = "Make A Clicking Game"},
    {Name = "Make A Simulator"},
    {Name = "Make An FPS Game"},
}

function Businesses:init()
    self:createBindings()
end

function Businesses:render()

    local pageChildren = {}

    for index,business in ipairs(BUSINESS_INFO) do
        pageChildren[business.Name] = e(BaseBusiness, {
            name = business.Name,
            gain = self.props.business[business.Name].gain,
            time = self.props.business[business.Name].time,
            cost = self.props.business[business.Name].cost,
            amountowned = self.props.business[business.Name].amountowned,
            hasmanager = self.props.business[business.Name].hasmanager,
            dispatchAction = self.props.dispatchAction,
            playermoney = self.props.money,
            amountbuying = self.props.amountbuying,
            layoutorder = index,
            unlocks = self.props.unlocks,
            notify = self.props.notify
        })
    end

        pageChildren.UIListLayout = e("UIGridLayout", {
            CellPadding = UDim2.new(0.05, 0, 0.06, 0),
            CellSize = UDim2.new(0.45, 0, 0.2, 0),
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            StartCorner = Enum.StartCorner.TopLeft,
            SortOrder = Enum.SortOrder.LayoutOrder,
        },{
            UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
                AspectRatio = 4.051,
                AspectType = Enum.AspectType.FitWithinMaxSize,
                DominantAxis = Enum.DominantAxis.Width
            })
        })

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

        Main = e("ScrollingFrame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            CanvasSize = UDim2.new(0,0,1.2,0),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, 0, 0.557, 0),
            Size = UDim2.new(0.952, 0, 0.825, 0),
        },pageChildren),

        MoneyAmount = e("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0.025, 0, 0.036, 0),
            Size = UDim2.new(0.22, 0, 0.091, 0),
            Font = Enum.Font.DenkOne,
            Text = MathUtil.Shorten(self.props.money).."$",
            TextColor3 = Color3.fromRGB(255,255,255),
            TextScaled = true
        }),

        AmountBuying = e("ImageLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0.851, 0, 0.007, 0),
            Size = UDim2.new(0.148, 0, 0.137, 0),
            ZIndex = 3,
            Rotation = 25,
            Image = "rbxassetid://7042822718",
            ScaleType = Enum.ScaleType.Fit
        }, {
            AmountBuyingButton = e("TextButton", {
                AnchorPoint = Vector2.new(0.5,0.5),
                BackgroundTransparency = 1,
                Position = UDim2.new(0.517, 0, 0.468, 0),
                Rotation = -25,
                Size = UDim2.new(0.523, 0, 0.594, 0),
                ZIndex = 4,
                Font = Enum.Font.DenkOne,
                Text = self.props.amountbuying.."x",
                TextColor3 = Color3.fromRGB(76,192,222),
                TextScaled = true,

                [Roact.Event.MouseButton1Click] = function()
                    if self.props.amountbuying == 1 then
                        self.props.dispatchAction({
                            type = "setAmount",
                            amount = 3
                        })
                    elseif self.props.amountbuying == 3 then
                        self.props.dispatchAction({
                            type = "setAmount",
                            amount = 10
                        })
                    elseif self.props.amountbuying == 10 then
                        self.props.dispatchAction({
                            type = "setAmount",
                            amount = 100
                        })
                    elseif self.props.amountbuying == 100 then
                        self.props.dispatchAction({
                            type = "setAmount",
                            amount = 1
                        })
                    end
                end,
            })
        }),
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

function Businesses:createBindings()
    self.positionMotor = Flipper.SingleMotor.new(1)
    self.hiderTransparencyMotor = Flipper.SingleMotor.new(0)
    self.leftButtonMotor = Flipper.SingleMotor.new(0)
    self.rightButtonMotor = Flipper.SingleMotor.new(0)

    self.backgroundPosition, self.updateBackgroundPosition = Roact.createBinding(self.positionMotor:getValue())
    self.leftButtonBinding = RoactFlipper.getBinding(self.leftButtonMotor)
    self.rightButtonBinding = RoactFlipper.getBinding(self.rightButtonMotor)

    self.positionMotor:onStep(self.updateBackgroundPosition)
end

return RoactRodux.connect(
    function(state)
        return {
            menu = state.menu,
            amountbuying = state.business.amountbuying,
            money = state.playerdata.money,
            business = state.business,
            unlocks = state.playerdata.unlocks,
        }
    end,

    function(dispatch)
        return {
            dispatchAction = function(action)
                dispatch(action)
            end,
        }
    end
)(Businesses)
