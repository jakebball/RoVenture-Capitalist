local ReplicatedStorage = game.ReplicatedStorage

local RemoteFunctions = ReplicatedStorage.RemoteFunctions

local Vendor = ReplicatedStorage.Modules.Vendor

local Roact = require(Vendor.Roact)
local RoactRodux = require(Vendor.RoactRodux)

local BaseButton = require(script.Parent.BaseButton)

local e = Roact.createElement

local Save = Roact.Component:extend("Save")

function Save:init()
    self.TextBinding, self.updateTextBinding = Roact.createBinding("Save")
end

function Save:render()
    return e(BaseButton, {
        text = self.TextBinding,
        image = "rbxassetid://6996353680",
        layoutorder = 6,

        onClick = function()
            local saved = RemoteFunctions.Save:InvokeServer(self.props.state)
            
            if saved then
                self.updateTextBinding("Saved!")
            else
                self.updateTextBinding("Issue Saving! Please Try Again")
            end

            task.wait(3)
            
            self.updateTextBinding("Save")
        end
    })
end


return RoactRodux.connect(
    function(state, _)
        return {
            state = state
        }
    end
)(Save)
