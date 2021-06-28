
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

local initialBusinessState = {
    ["Venture1"] = {
        Revenue = BusinessData.Begging_For_Robux.Initial_Revenue,
        AmountBought = 1,
        Time = BusinessData.Begging_For_Robux.Initial_Time,
        Name = "Begging For Robux"
    } 
}

return {
    menuReducer = Rodux.createReducer("Businesses", {
        setMenu = function(state, action)
            return action.menu
        end
    }),

    businessReducer = Rodux.createReducer(initialBusinessState, {
        setRevenue = function(state, action)
            local newState = shallowCopy(state[action.businessname])

            newState.Revenue = action.revenue

            return newState
        end,

        setAmountBought = function(state, action)
            local newState = shallowCopy(state[action.businessname])

            newState.AmountBought = action.amountbought

            return newState
        end,

        setTime = function(state, action)
            local newState = shallowCopy(state[action.businessname])

            newState.Time = action.time

            return newState
        end,
    })
}