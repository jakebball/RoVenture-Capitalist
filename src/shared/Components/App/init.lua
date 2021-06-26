
local ReplicatedStorage = game.ReplicatedStorage

local Vendor = ReplicatedStorage.Modules.Vendor
local Enums = ReplicatedStorage.Modules.Enums

local ViewportAnimationEnums = require(Enums.ViewportAnimationEnums)

local Roact = require(Vendor.Roact)

local e = Roact.createElement

local App = Roact.Component:extend("App")

local Background = require(script.Background)

function App:init()
    self.setupAnimations = function(_yesAnimationController, _noAnimationController)
        self.yesAnimationController, self.noAnimationController = _yesAnimationController, _noAnimationController
    end

    self.callAnimations = function(animationName)
        if self.yesAnimationController ~= nil and self.noAnimationController ~= nil then
            if animationName == ViewportAnimationEnums.YesAnimation then
                self.yesAnimationController:Play()
            elseif animationName == ViewportAnimationEnums.NoAnimation then
                self.noAnimationController:Play() 
            end
        else
            warn("ANIMATION CONTROLLERS ARE NIL")
        end
    end
end

function App:render()
    return e("ScreenGui", {
        IgnoreGuiInset = true
    }, {
        Background = e(Background, {
            setupAnimation = self.setupAnimations,
            callAnimation = self.callAnimations
        })
    })
end

return App