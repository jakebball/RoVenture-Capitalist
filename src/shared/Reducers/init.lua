
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
    money = 360000,
    moonbucks = 0,
    unlocks = {},
    upgrades = {},
    currentpage = 1,
    currentunlockpage = 1,
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

    giveUpgrade = function(state, action)
        local newState = shallowCopy(state)

        local newUpgrades = shallowCopy(state.upgrades)
        table.insert(newUpgrades, action.upgrade)

        newState.upgrades = newUpgrades

        return newState
    end,

    incrementPage = function(state, _)
        local newState = shallowCopy(state)

        if state.currentpage < 2 then
            newState.currentpage = state.currentpage + 1
        end

        return newState
    end,

    decrementPage = function(state, _)
        local newState = shallowCopy(state)

        if state.currentpage > 1 then
            newState.currentpage = state.currentpage - 1
        end

        return newState
    end,

    incrementUnlockPage = function(state, _)
        local newState = shallowCopy(state)
     
        if state.currentunlockpage < 2 then
            newState.currentunlockpage = state.currentunlockpage + 1
        end

        print(newState.currentunlockpage)

        return newState
    end,

    decrementUnlockPage = function(state, _)
        local newState = shallowCopy(state)

        if state.currentunlockpage > 1 then
            newState.currentunlockpage = state.currentunlockpage - 1
        end

        return newState
    end,
})

local initialBusinessState = {
    ["Begging For Robux"] = {},
    ["Selling Free Models"] = {},
    ["Item Trading"] = {},
    ["Selling Bad UGC"] = {},
    ["Selling Frontpage UGC"] = {},
    ["Selling Plugins"] = {},
    ["Selling Game Maps"] = {},
    ["Make A Clicking Game"] = {},
    ["Make A Simulator"] = {},
    ["Make An FPS Game"] = {},
    ["amountbuying"] = 1,
    ["maxpage"] = 1
}

for k,v in pairs(initialBusinessState) do
    if BusinessData[k] ~= nil then
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
        elseif action.unlock.Effect == "Profit" then
            newNestedState.gain = state[target].gain * action.unlock.Amount
        end
        
        newState[target] = newNestedState

        return newState
    end,

    implementUpgrade = function(state, action)
        local newState = shallowCopy(state)

        local target = action.upgrade.Target 

        local newNestedState = shallowCopy(newState[target])
        
        if action.upgrade.Effect == "Profit" then
            newNestedState.gain = state[target].gain * action.upgrade.Amount
        end
        
        newState[target] = newNestedState

        return newState
    end,
    
    set = function(state, action)
        local newState = shallowCopy(state)

        newState[action.statname] = action.value

        return newState
    end
})

return {
    menuReducer = menuReducer,
    playerdataReducer = playerdataReducer, 
    businessReducer = businessReducer
}

--[[
      "You Gotta Start Somewhere",
        "Some Money Is Better Then No Money, Right?",
        "Getting The Job Done",
        "Average Beggar",
        "Beggars Cant Be Choosers",
        "Respected...For A Beggar",
        "Optimistic",
        "Choosers Can Be Beggars?",
        "Who Needs To Beg When You Got Family - Dom Torbego",
        "Smooth Talker",
        "Fastest Beggar In The West",
        "Kingpin....Of Begging"
]]