local ReplicatedStorage = game.ReplicatedStorage
local Players = game:GetService("Players")

local Vendor = ReplicatedStorage.Modules.Vendor

local Roact = require(Vendor.Roact)
local Promise = require(Vendor.Promise)
local Maid = require(Vendor.Maid)

local Player = Players.LocalPlayer

local Unlocks = require(script.UnlocksButton)
local Upgrades = require(script.UpgradesButton)
local Managers = require(script.ManagersButton)
local Businesses = require(script.BusinessesButton)
local Donate = require(script.DonateButton)
local LeaderboardButton = require(script.LeaderboardButton)

local e = Roact.createElement

local Sidebar = Roact.Component:extend("Sidebar")

function Sidebar:init()
    self.viewportRef = Roact.createRef()
    self._maid = Maid.new()
end

function Sidebar:render()
    return e("Frame", {
        Size = UDim2.new(0.158, 0, 0.964, 0),
        Position = UDim2.new(0.091, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5,0.5),
        BackgroundColor3 = Color3.fromRGB(57, 52, 48)
    }, {

        UICorner = e("UICorner", {
            CornerRadius = UDim.new(0, 25)
        }),

        PlayerIcon = e("Frame", {
            Size = UDim2.new(0.826, 0, 0.246, 0),
            Position = UDim2.new(0.5, 0, 0.139, 0),
            AnchorPoint = Vector2.new(0.5,0.5),
            BackgroundTransparency = 1,
            ZIndex = 2
        },{

            Background = e("ImageButton", {
                Size = UDim2.new(1,0,1,0),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                AnchorPoint = Vector2.new(0.5,0.5),
                BackgroundTransparency = 1,
                Image = "rbxassetid://6996355719",
                ScaleType = Enum.ScaleType.Fit
            }),

            PlayerIcon = e("ViewportFrame", {
                Size = UDim2.new(0.8, 0, 0.8, 0),
                Position = UDim2.new(0.5,0,0.5,0),
                AnchorPoint = Vector2.new(0.5,0.5),
                BackgroundTransparency = 1,
                ZIndex = 3,

                [Roact.Ref] = self.viewportRef,
            }, {
                WorldModel = e("WorldModel"),
            }),

            LeaderboardButton = e(LeaderboardButton)
        }),

        ButtonList = e("Frame", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0,0,0.269,0),
            Size = UDim2.new(1,0,0.716,0)
        }, {

            UIListLayout = e("UIListLayout", {
                Padding = UDim.new(0.02, 0),
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder
            }),

            Unlocks = e(Unlocks),

            Upgrades = e(Upgrades),

            Managers = e(Managers),

            Businesses = e(Businesses),

            Donate = e(Donate)
        })
    })
end

function Sidebar:didMount()
    local viewport = self.viewportRef:getValue()

    local characterClone = ReplicatedStorage.CharacterModel:Clone()
    characterClone.Parent = viewport.WorldModel
    characterClone.HumanoidRootPart.Anchored = true
    
    Promise.new(function(resolve)
        local humanoidDescription = Players:GetHumanoidDescriptionFromUserId(Player.UserId)
        characterClone.Humanoid:ApplyDescription(humanoidDescription)

        return resolve()
    end):andThen(function()     
        local viewportCamera = Instance.new("Camera")
        viewportCamera.Parent = viewport

        viewport.CurrentCamera = viewportCamera

        characterClone.HumanoidRootPart.CFrame = viewportCamera.CFrame + (viewportCamera.CFrame.LookVector * 1.5) + Vector3.new(0, -2, 0)
        characterClone.HumanoidRootPart.CFrame = characterClone.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(170), 0)

        local IdleAnimation = Instance.new("Animation")
        IdleAnimation.AnimationId = "http://www.roblox.com/asset/?id=616111295"

        local YesAnimation = Instance.new("Animation")
        YesAnimation.AnimationId = "http://www.roblox.com/asset/?id=4841397952"

        local NoAnimation = Instance.new("Animation")
        NoAnimation.AnimationId = "http://www.roblox.com/asset/?id=4841401869"
        
        local IdleAnimationController = characterClone.Humanoid.Animator:LoadAnimation(IdleAnimation)
        IdleAnimationController.Looped = true
        IdleAnimationController:Play()

        local YesAnimationController = characterClone.Humanoid.Animator:LoadAnimation(YesAnimation)
        YesAnimationController.Looped = false
        YesAnimationController.Priority = Enum.AnimationPriority.Action

        local NoAnimationController = characterClone.Humanoid.Animator:LoadAnimation(NoAnimation)
        NoAnimationController.Looped = false
        NoAnimationController.Priority = Enum.AnimationPriority.Action
    
        self.props.setupAnimations(YesAnimationController, NoAnimationController)

    end):catch(function(err)
        warn("error loading character model: ")
        warn(err)
    end)
end

function Sidebar:willUnmount()
    self._maid:Destroy()
end

return Sidebar