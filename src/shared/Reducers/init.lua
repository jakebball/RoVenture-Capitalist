
local ReplicatedStorage = game.ReplicatedStorage

local Vendor = ReplicatedStorage.Modules.Vendor

local EconomyData = ReplicatedStorage.Modules.EconomyData

local Rodux = require(Vendor.Rodux)

local BusinessData = require(EconomyData.BusinessData)

local function shallowCopy(original)
	local copy = {}
	for key, value in pairs(original) do
		copy[key] = value
	end
	return copy
end

local initialdataState = {
    
}

return {
    menuReducer = Rodux.createReducer("Businesses", {
        setMenu = function(state, action)
            return action.menu
        end
    }),

    dataReducer = Rodux.createReducer(initialdataState, {
       
    })
}