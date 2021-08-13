local ReplicatedStorage = game.ReplicatedStorage

local Vendor = ReplicatedStorage.Modules.Vendor

local Roact = require(Vendor.Roact)
local RoactRodux = require(Vendor.RoactRodux)
local Flipper = require(Vendor.Flipper)
local RoactFlipper = require(Vendor.RoactFlipper)
local MathUtil = require(Vendor.MathUtil)

local UnlockData = require(ReplicatedStorage.Modules.EconomyData.UnlockData)

local e = Roact.createElement

local Unlocks = Roact.Component:extend("Unlocks")

function Unlocks:init()

    self.positionMotor = Flipper.SingleMotor.new(0)
    self.leftButtonMotor = Flipper.SingleMotor.new(0)
    self.rightButtonMotor = Flipper.SingleMotor.new(0)

    self.backgroundPosition, self.updateBackgroundPosition = Roact.createBinding(self.positionMotor:getValue())
    self.leftButtonBinding = RoactFlipper.getBinding(self.leftButtonMotor)
    self.rightButtonBinding = RoactFlipper.getBinding(self.rightButtonMotor)

    self.positionMotor:onStep(self.updateBackgroundPosition)
end

function Unlocks:render()
    local unlockChildren = {}
    local pageNumber = 0
    local maxPageNumber = 0
    local index = 0

    for _,unlocks in ipairs(UnlockData) do
        for _,unlock in ipairs(unlocks[unlocks.UnlockName]) do
            local isMultiple = (index % 10) == 0 
            if isMultiple or pageNumber == 0 then
                pageNumber += 1
                maxPageNumber += 1
                unlockChildren[pageNumber] = {}
            end
            index += 1

            unlockChildren[pageNumber][unlock.Name] = e("Frame",{
                BackgroundColor3 = Color3.fromRGB(76,192,222),
                BackgroundTransparency = 0.1,
                LayoutOrder = index,
                ZIndex = 3
            }, {
                UICorner = e("UICorner"),
    
                Underline = e("Frame", {
                    AnchorPoint = Vector2.new(0.5,0.5),
                    Position = UDim2.new(0.5, 0, 0.77, 0),
                    Size = UDim2.new(0.716, 0, 0.016, 0),
                    BackgroundColor3 = Color3.fromRGB(255,255,255),
                    ZIndex = 3,
                }, {
                    UICorner = e("UICorner")
                }),
    
                Icon = e("TextLabel", {
                    AnchorPoint = Vector2.new(0.5,0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.499, 0, 0.484, 0),
                    Size = UDim2.new(0.564, 0, 0.315, 0),
                    ZIndex = 3,
                    Text = string.upper(string.sub(unlock.Name, 1, 1)),
                    TextScaled =  true,
                    TextColor3 = Color3.fromRGB(255,255,255),
                    Font = Enum.Font.DenkOne
                }),
    
                Title = e("TextLabel", {
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.173, 0),
                    Size = UDim2.new(0.84, 0, 0.266, 0),
                    Font = Enum.Font.DenkOne,
                    Text = unlockText,
                    TextColor3 = Color3.fromRGB(255,255,255),
                    TextScaled = true,
                    ZIndex = 3,
                }),
    
                Level = e("TextLabel", {
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.702, 0),
                    Size = UDim2.new(0.84, 0, 0.118, 0),
                    Font = Enum.Font.DenkOne,
                    Text = "Level "..unlock.Goal,
                    TextColor3 = Color3.fromRGB(255,255,255),
                    TextScaled = true,
                    ZIndex = 3,
                }),
    
                Description = e("TextLabel", {
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.879, 0),
                    Size = UDim2.new(0.84, 0, 0.159, 0),
                    Font = Enum.Font.DenkOne,
                    Text = unlock.Description,
                    TextColor3 = Color3.fromRGB(255,255,255),
                    TextScaled = true,
                    ZIndex = 3
                }),

                LockedFrame = e("Frame", {
                    BackgroundTransparency = 0.5,
                    Size = UDim2.new(1,0,1,0),
                    ZIndex = 6,
                    Visible = table.find(self.props.unlocks, unlock.Name) == nil
                }, {
                    LockedImage = e("ImageLabel", {
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0.5, 0, 0.484, 0),
                        Size = UDim2.new(0.564, 0, 0.315, 0),
                        ZIndex = 7,
                        Image = "rbxassetid://6996354189",
                        ScaleType = Enum.ScaleType.Fit
                    }),

                    UICorner = e("UICorner")
                })
            })
        end
    end

    self.props.dispatchAction({
        type = "set",
        statname = "maxunlockpage",
        value = maxPageNumber
    })
    
    for _,v in ipairs(unlockChildren) do
        v.UICorner = e("UICorner")

        v.UIGridLayout = e("UIGridLayout", {
            CellPadding = UDim2.new(0.05, 0, 0.05, 0),
            CellSize = UDim2.new(0.15, 0, 0.45, 0),
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            StartCorner = Enum.StartCorner.TopLeft,
            SortOrder = Enum.SortOrder.LayoutOrder
        })
    end

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
            Size = UDim2.new(1,0,1,0),
            Image = "rbxassetid://6996355759"
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
                Text = "Unlocks",
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
        }, unlockChildren[self.props.unlockpage]),

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
                    type = "decrementUnlockPage",
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
                    type = "incrementUnlockPage",
                })
            end
        }),

        CurrentPage = e("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0.778, 0, 0.042, 0),
            Size = UDim2.new(0.026, 0, 0.066, 0),
            ZIndex = 3,
            Font = Enum.Font.DenkOne,
            Text = self.props.unlockpage,
            TextColor3 = Color3.fromRGB(255,255,255),
            TextScaled = true
        }),

        MoneyAmount = e("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0.025, 0, 0.036, 0),
            Size = UDim2.new(0.22, 0, 0.091, 0),
            Font = Enum.Font.DenkOne,
            Text = MathUtil.Shorten(self.props.money).."$",
            TextColor3 = Color3.fromRGB(255,255,255),
            TextScaled = true
        }),
    })
end

function Unlocks:didUpdate()
    if self.props.menu == "Unlocks" then
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
            unlocks = state.playerdata.unlocks,
            unlockpage = state.playerdata.currentunlockpage,
            money = state.playerdata.money
        }
    end,
    function(dispatch)
        return {
            dispatchAction = function(action)
                dispatch(action)
            end,
        }
    end
)(Unlocks)