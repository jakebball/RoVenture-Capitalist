
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

    increment = function(state, action)
        local newState = shallowCopy(state)

        newState[action.statname] = newState[action.statname] + action.value

        return newState
    end,
})

local initialBusinessState = {
    BeggingForRobux = {
        gain = BusinessData.Begging_For_Robux.Initial_Revenue,
        time = BusinessData.Begging_For_Robux.Initial_Time,
        cost = BusinessData.Begging_For_Robux.Initial_Cost,
        amountbuying = 1,
        hasmanager = false,
        playerOwnsBusiness = true,
    }
}

local businessReducer = Rodux.createReducer(initialBusinessState, {
    updateGain = function(state, action)
        
    end,

    updateTime = function(state, action)
        
    end,

    updateCost = function(state, action)
        
    end,

    updateAmountbuying = function(state, action)
        
    end,

    setManager = function(state, action)
        
    end,

    setOwnsBusiness = function(state, action)
        
    end
})

return {
    menuReducer = menuReducer,
    playerdataReducer = playerdataReducer, 
    businessReducer = businessReducer
}