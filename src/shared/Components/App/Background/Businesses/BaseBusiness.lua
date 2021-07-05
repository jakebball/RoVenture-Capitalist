local ReplicatedStorage = game.ReplicatedStorage

local RemoteEvents = ReplicatedStorage.RemoteEvents

local RunService = game:GetService("RunService")

local Vendor = ReplicatedStorage.Modules.Vendor

local Roact = require(Vendor.Roact)
local Flipper = require(Vendor.Flipper)
local RoactFlipper = require(Vendor.RoactFlipper)
local MathUtil = require(Vendor.MathUtil)
local SchedulerUtils = require(Vendor.SchedulerUtils)

local e = Roact.createElement

local BaseBusiness = Roact.Component:extend("BaseBusiness")

function BaseBusiness:init()
    self.buyButtonMotor = Flipper.SingleMotor.new(0)
    self.buyButtonBinding = RoactFlipper.getBinding(self.buyButtonMotor)

    self.runButtonMotor = Flipper.SingleMotor.new(0)
    self.runButtonBinding = RoactFlipper.getBinding(self.runButtonMotor)

    self.barMotor = Flipper.SingleMotor.new(0)
    self.barPosition, self.updateBarPosition = Roact.createBinding(self.barMotor:getValue())
    self.barMotor:onStep(self.updateBarPosition)

    self.timeLeftBinding, self.updateTimeLeftBinding = Roact.createBinding(self.props.time)

    self.motorRef = Roact.createRef()

    self.overflowAmount = 0

    self.lastTimeRan = 0
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

            [Roact.Ref] = self.motorRef,

            [Roact.Event.MouseButton1Click] = function()
                if self.props.hasmanager == false then
                    self:runBusinessMotor()
                    self.runButtonMotor:setGoal(Flipper.Spring.new(0, {
                        frequency = 3,
                        dampingRatio = 0.85
                    }))
                end
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
                Size = self.barPosition:map(function(value)
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

            Gain = e("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0.037, 0, 0, 0),
                Size = UDim2.new(0.943, 0, 1, 0),
                Font = Enum.Font.DenkOne,
                Text = MathUtil.Shorten(self.props.gain),
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
            end,

            [Roact.Ref] = self.rbx
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
                    Text = "Buy x"..self.props.amountbuying,
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
                    Text = MathUtil.Shorten(self.props.cost),
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
            Text = self.timeLeftBinding:map(function(value)
                return MathUtil.ConvertToHMS(value)
            end),
            TextColor3 = Color3.fromRGB(255,255,255),
            TextScaled = true,
            Font = Enum.Font.DenkOne
        }, {
            UICorner = e("UICorner")
        })
    })
end

function BaseBusiness:runBusinessMotor()
    if os.clock() - self.lastTimeRan <= self.props.time then
        return
    end

    if self.props.time >= 0.5 then
        local rbx = self.motorRef:getValue()

        local distance = -(rbx.Parent.TimeBarOutline.Outline.Position.X.Scale - (rbx.Parent.TimeBarOutline.Outline.Position.X.Scale + rbx.Parent.TimeBarOutline.Outline.Size.X.Scale))
        local velocity = distance / self.props.time

        local timeConn 

        timeConn = RunService.Heartbeat:Connect(function()
            local timeLeft = self.props.time * (1 - self.barMotor:getValue()) + 0 * self.barMotor:getValue()
            self.updateTimeLeftBinding(timeLeft)
        end)

        self.updateBarPosition(self.barMotor:setGoal(Flipper.Linear.new(1, {
            velocity = velocity
        })))

        local barConn
        
        barConn = self.barMotor:onComplete(function()
            self.updateBarPosition(self.barMotor:setGoal(Flipper.Instant.new(0)))
            barConn:disconnect()
            timeConn:Disconnect()
            self.runButtonMotor:setGoal(Flipper.Spring.new(1, {
                frequency = 3,
                dampingRatio = 0.85
            }))
            RemoteEvents.RunBusiness[self.props.name]:FireServer()
            self.props.onFinishRun(self.props.gain)
        end) 
    else
        self.overflowAmount += 1
    end

    self.lastTimeRan = os.clock()
end

function BaseBusiness:didMount()
    coroutine.wrap(function()
        while RunService.Heartbeat:Wait() do
            if self.props.hasmanager then
                self:runBusinessMotor()
            end
        end
    end)()

    coroutine.wrap(function()
        while true do
            RunService.Heartbeat:Wait()
            if self.overflowAmount > 0 then
                for _ = 0,self.overflowAmount,1 do
                    SchedulerUtils.Wait(0.25)
                    RemoteEvents.RunBusiness[self.props.name]:FireServer()
                end
                self.overflowAmount = 0
            end
        end
    end)()
end

return BaseBusiness