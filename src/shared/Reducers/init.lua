
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
    setMenu = function(_, action)
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
    ["Begging For Robux"] = {},
    ["Selling Free Models"] = {},
    ["amountbuying"] = 1
}

for k,v in pairs(initialBusinessState) do
    if k ~= "amountbuying" then
        v.gain = BusinessData[k].Initial_Revenue
        v.time = BusinessData[k].Initial_Time
        v.cost = BusinessData[k].Initial_Cost
        v.amountowned = 0
        v.hasmanager = false
        if k == "Begging For Robux" then
            v.playerOwnsBusiness = true
            v.amountowned = 1
        else
            v.playerOwnsBusiness = false
        end
    end
end

local businessReducer = Rodux.createReducer(initialBusinessState, {

    buyBusiness = function(state, action)
        local newState = shallowCopy(state)

        local newNestedState = shallowCopy(newState[action.businessname])

        newNestedState.gain += BusinessData[action.businessname].Initial_Revenue
        newNestedState.cost = BusinessData[action.businessname].Initial_Cost * BusinessData[action.businessname].Coefficient^((newNestedState.amountowned + newState.amountbuying) - 1)
        newNestedState.amountowned += newState.amountbuying

        newState[action.businessname] = newNestedState

        return newState
    end,

    setAllBusiness = function(_, action)
        return action.newState
    end,

    setAmount = function(state, action)
        local newState = shallowCopy(state)

        newState.amountbuying = action.amount

        return newState
    end,

    buyFirstBusiness = function(state, action)
        local newState = shallowCopy(state)

        local newNestedState = shallowCopy(newState[action.businessname])
        newNestedState.amountowned = 1

        newState[action.businessname] = newNestedState

        return newState
    end
})

return {
    menuReducer = menuReducer,
    playerdataReducer = playerdataReducer, 
    businessReducer = businessReducer
}
