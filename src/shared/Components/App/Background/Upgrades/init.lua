local ReplicatedStorage = game.ReplicatedStorage

local Vendor = ReplicatedStorage.Modules.Vendor

local Roact = require(Vendor.Roact)
local RoactRodux = require(Vendor.RoactRodux)
local Flipper = require(Vendor.Flipper)
local RoactFlipper = require(Vendor.RoactFlipper)
local MathUtil = require(Vendor.MathUtil)

local UpgradeFrame = require(script.UpgradeFrame)

local e = Roact.createElement

local Upgrades = Roact.Component:extend("Upgrades")

local UpgradeData = require(ReplicatedStorage.Modules.EconomyData.UpgradeData)

function Upgrades:init()

    self.positionMotor = Flipper.SingleMotor.new(0)
    self.leftButtonMotor = Flipper.SingleMotor.new(0)
    self.rightButtonMotor = Flipper.SingleMotor.new(0)

    self.backgroundPosition, self.updateBackgroundPosition = Roact.createBinding(self.positionMotor:getValue())
    
    self.positionMotor:onStep(self.updateBackgroundPosition)
    self.leftButtonBinding = RoactFlipper.getBinding(self.leftButtonMotor)
    self.rightButtonBinding = RoactFlipper.getBinding(self.rightButtonMotor)
end

function Upgrades:render()
    local pageNumber = 0
    local maxupgradepage = 0
    local upgradeChildren = {}

    for index,upgrade in ipairs(UpgradeData) do
        local isMultiple = (index % 9) == 0 
        if isMultiple or pageNumber == 0 then
            pageNumber += 1
            maxupgradepage += 1
            upgradeChildren[pageNumber] = {}
        end

        upgradeChildren[pageNumber][upgrade.Description] = e(UpgradeFrame, {
            upgrade = upgrade,
            upgrades = self.props.upgrades,
            layoutorder = index,
            playermoney = self.props.playermoney,
            dispatchAction = self.props.dispatchAction
        })
    end

    self.props.dispatchAction({
        type = "set",
        statname = "maxupgradepage",
        value = maxupgradepage
    })

    upgradeChildren[self.props.upgradepage].UICorner = e("UICorner")

    upgradeChildren[self.props.upgradepage].UIGridLayout = e("UIGridLayout", {
        CellPadding = UDim2.new(0.05, 0, 0.05, 0),
        CellSize = UDim2.new(0.2, 0, 0.45, 0),
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        StartCorner = Enum.StartCorner.TopLeft,
        VerticalAlignment = Enum.VerticalAlignment.Center
    })

    return e("Frame", {
        AnchorPoint = Vector2.new(0.5,0.5),
        BackgroundTransparency = 1,
        Position = self.backgroundPosition:map(function(value)
            return UDim2.new(1.5, 0, 0.5, 0):Lerp(UDim2.new(0.587,0, 0.5, 0), value)
        end),
        Size = UDim2.new(0.8, 0, 0.964, 0)
    }, {

        Background = e("ImageLabel", {
            BackgroundTransparency = 1,
            ImageColor3 = Color3.fromRGB(76,192,222),
            Size = UDim2.new(1,0,1,0),
            Image = "rbxassetid://6996355288",
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
                Text = "Upgrades",
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
            BackgroundTransparency = 0.8,
            Position = UDim2.new(0.5, 0, 0.559, 0),
            Size = UDim2.new(0.952, 0, 0.82, 0),
            ZIndex = 2
        }, upgradeChildren[self.props.upgradepage]),

        LeftPageButton = e("ImageButton", {
            AnchorPoint = Vector2.new(0.5,0.5),
            BackgroundTransparency = 1,
            Position = UDim2.new(0.756, 0, 0.072, 0),
            Rotation = 180,
            Size = self.leftButtonBinding:map(function(newValue)
                return UDim2.new(0.044, 0, 0.066, 0):Lerp(UDim2.new(0.044 * 1.2, 0, 0.066 * 1.2, 0), newValue) 
            end),
            ZIndex = 3,
            Image = "rbxassetid://6996353641",
            ScaleType = Enum.ScaleType.Fit,

            [Roact.Event.MouseEnter] = function()
                self.leftButtonMotor:setGoal(Flipper.Spring.new(1, {
                    frequency = 3,
                    dampingRatio = 0.85
                }))
            end,

            [Roact.Event.MouseLeave] = function()
                self.leftButtonMotor:setGoal(Flipper.Spring.new(0, {
                    frequency = 3,
                    dampingRatio = 0.85
                }))
            end,

            [Roact.Event.MouseButton1Click] = function()
                self.leftButtonMotor:setGoal(Flipper.Spring.new(0, {
                    frequency = 3,
                    dampingRatio = 0.85
                }))

                self.props.dispatchAction({
                    type = "decrementUpgradePage",
                })
            end
        }),

        RightPageButton = e("ImageButton", {
            AnchorPoint = Vector2.new(0.5,0.5),
            BackgroundTransparency = 1,
            Position = UDim2.new(0.824, 0, 0.072, 0),
            Rotation = 0,
            Size = self.rightButtonBinding:map(function(newValue)
                return UDim2.new(0.044, 0, 0.066, 0):Lerp(UDim2.new(0.044 * 1.2, 0, 0.066 * 1.2, 0), newValue) 
            end),
            ZIndex = 3,
            Image = "rbxassetid://6996353641",
            ScaleType = Enum.ScaleType.Fit,

            [Roact.Event.MouseEnter] = function()
                self.rightButtonMotor:setGoal(Flipper.Spring.new(1, {
                    frequency = 3,
                    dampingRatio = 0.85
                }))
            end,

            [Roact.Event.MouseLeave] = function()
                self.rightButtonMotor:setGoal(Flipper.Spring.new(0, {
                    frequency = 3,
                    dampingRatio = 0.85
                }))
            end,

            [Roact.Event.MouseButton1Click] = function()
                self.rightButtonMotor:setGoal(Flipper.Spring.new(0, {
                    frequency = 3,
                    dampingRatio = 0.85
                }))
                self.props.dispatchAction({
                    type = "incrementUpgradePage",
                })
            end
        }),

        CurrentPage = e("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0.778, 0, 0.042, 0),
            Size = UDim2.new(0.026, 0, 0.066, 0),
            ZIndex = 3,
            Font = Enum.Font.DenkOne,
            Text = self.props.upgradepage,
            TextColor3 = Color3.fromRGB(255,255,255),
            TextScaled = true
        }),

        MoneyAmount = e("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0.025, 0, 0.036, 0),
            Size = UDim2.new(0.22, 0, 0.091, 0),
            Font = Enum.Font.DenkOne,
            Text = MathUtil.Shorten(self.props.playermoney).."$",
            TextColor3 = Color3.fromRGB(255,255,255),
            TextScaled = true
        }),
    })
end

function Upgrades:didUpdate()
    if self.props.menu == "Upgrades" then
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
    function(state, _)
        return {
            menu = state.menu,
            upgradepage = state.playerdata.currentupgradepage,
            upgrades = state.playerdata.upgrades,
            playermoney = state.playerdata.money,
            currentpage = state.playerdata.currentpage
        }
    end,
    function(dispatch)
        return {
            dispatchAction = function(action)
                dispatch(action)
            end,
        }
    end
)(Upgrades)
