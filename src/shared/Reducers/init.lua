
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

local menuReducer = Rodux.createReducer("Businesses", {
    setMenu = function(state, action)
        return action.menu
    end
})

local initialDataState = {
    money = 0,
    goldbars = 5,
}

local playerdataReducer = Rodux.createReducer(initialDataState, {
    set = function(state, action)
        local newState = shallowCopy(state)

        newState[action.statname] = action.value

        return newState
    end,

    setAll = function(_, action)
        return action.stats
    end,

    increment = function(state, action)
        local newState = shallowCopy(state)

        newState[action.statname] = newState[action.statname] + action.value

        return newState
    end,
})

local initialBusinessState = {
    ["Begging For Robux"] = {
        gain = BusinessData.Begging_For_Robux.Initial_Revenue,
        time = BusinessData.Begging_For_Robux.Initial_Time,
        cost = BusinessData.Begging_For_Robux.Initial_Cost,
        amountowned = 1,
        hasmanager = false,
        playerOwnsBusiness = true,
    }
}

local businessReducer = Rodux.createReducer(initialBusinessState, {

    incrementAmountOwned = function(state, action)
        local newState = shallowCopy(state)

        local newNestedState = shallowCopy(newState[action.businessname])
        newNestedState.amountowned += action.value

        newState[action.businessname] = newNestedState

        return newState
    end,

    setAllBusiness = function(_, action)
        return action.newState
    end
})

return {
    menuReducer = menuReducer,
    playerdataReducer = playerdataReducer, 
    businessReducer = businessReducer
}