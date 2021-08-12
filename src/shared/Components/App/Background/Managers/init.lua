local ReplicatedStorage = game.ReplicatedStorage

local Vendor = ReplicatedStorage.Modules.Vendor

local Roact = require(Vendor.Roact)
local RoactRodux = require(Vendor.RoactRodux)
local Flipper = require(Vendor.Flipper)
local MathUtil = require(Vendor.MathUtil)

local e = Roact.createElement

local Managers = Roact.Component:extend("Managers")

local ManagerFrame = require(script.ManagerFrame)

local ManagerData = require(ReplicatedStorage.Modules.EconomyData.ManagerData)

function Managers:init()

    self.positionMotor = Flipper.SingleMotor.new(0)

    self.backgroundPosition, self.updateBackgroundPosition = Roact.createBinding(self.positionMotor:getValue())
    
    self.positionMotor:onStep(self.updateBackgroundPosition)
end

function Managers:render()

    local managerChildren = {}

    for index,manager in ipairs(ManagerData) do
        managerChildren[manager.Name] = e(ManagerFrame, {
            layoutorder = index,
            Managers = self.props.managers,
            Manager = manager,
            playermoney = self.props.playermoney,
            dispatchAction = self.props.dispatchAction
        })
    end

    managerChildren.UICorner = e("UICorner")

    managerChildren.UIGridLayout = e("UIGridLayout", {
        CellPadding = UDim2.new(0.05, 0, 0.05, 0),
        CellSize = UDim2.new(0.15, 0, 0.45, 0),
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = "LayoutOrder",
        StartCorner = "TopLeft",
        VerticalAlignment = "Center"
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
                Text = "Managers",
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
            }),

            Main = e("Frame", {
                AnchorPoint = Vector2.new(0.5,0.5),
                BackgroundTransparency = 0.8,
                Position = UDim2.new(0.5, 0,0.559, 0),
                Size = UDim2.new(0.952, 0, 0.82, 0),
                ZIndex = 6,
            }, managerChildren),

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
    })
end

function Managers:didUpdate()
    if self.props.menu == "Managers" then
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
            playermoney = state.playerdata.money,
            managers = state.playerdata.managers
        }
    end,
    function(dispatch)
        return {
            dispatchAction = function(action)
                dispatch(action)
            end,
        }
    end
)(Managers)
