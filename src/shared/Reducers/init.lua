
local ReplicatedStorage = game.ReplicatedStorage

local Vendor = ReplicatedStorage.Modules.Vendor

local EconomyData = ReplicatedStorage.Modules.EconomyData

local Rodux = require(Vendor.Rodux)

local BusinessData = require(EconomyData.BusinessData)
local UnlockData = require(EconomyData.UnlockData)

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
    unlocks = {},
    unlockpage = 1
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

    giveUnlock = function(state, action)
        local newState = shallowCopy(state)

        local newUnlocks = shallowCopy(state.unlocks)
        table.insert(newUnlocks, action.unlock)

        newState.unlocks = newUnlocks

        return newState
    end,

    incrementUnlockPage = function(state, _)
        local newState = shallowCopy(state)

        if state.unlockpage < 2 then
            newState.unlockpage = state.unlockpage + 1
        end

        return newState
    end,

    decrementUnlockPage = function(state, _)
        local newState = shallowCopy(state)

        if state.unlockpage > 1 then
            newState.unlockpage = state.unlockpage - 1
        end

        return newState
    end,
})

local initialBusinessState = {
    ["Begging For Robux"] = {},
    ["Selling Free Models"] = {},
    ["Basic Item Trading"] = {},
    ["Selling Bad UGC"] = {},
    ["Developer Commissions"] = {},
    ["Limited Item Trading"] = {},
    ["Selling Frontpage UGC"] = {},
    ["Selling Plugins"] = {},
    ["Selling Game Maps"] = {},
    ["Make A Clicking Game"] = {},
    ["Make A Simulator"] = {},
    ["Make An FPS Game"] = {},
    ["amountbuying"] = 1,
    ["currentpage"] = 1
}

for k,v in pairs(initialBusinessState) do
    if k ~= "amountbuying" and k ~= "currentpage" then
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

        local newNestedState = shallowCopy(state[action.businessname])

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

    incrementBusinessPage = function(state, _)
        local newState = shallowCopy(state)

        if state.currentpage < 2 then
            newState.currentpage = state.currentpage + 1
        end

        return newState
    end,

    decrementBusinessPage = function(state, _)
        local newState = shallowCopy(state)

        if state.currentpage > 1 then
            newState.currentpage = state.currentpage - 1
        end

        return newState
    end,

    buyFirstBusiness = function(state, action)
        local newState = shallowCopy(state)

        local newNestedState = shallowCopy(newState[action.businessname])
        newNestedState.amountowned = 1

        newState[action.businessname] = newNestedState

        return newState
    end,

    implementUnlock = function(state, action)
        local newState = shallowCopy(state)

        local target = action.unlock.Target or action.businessname

        local newNestedState = shallowCopy(newState[target])
        
        if action.unlock.Effect == "Speed" then
            newNestedState.time = state[target].time / 2
        end
        
        newState[target] = newNestedState

        return newState
    end
})

return {
    menuReducer = menuReducer,
    playerdataReducer = playerdataReducer, 
    businessReducer = businessReducer
}
