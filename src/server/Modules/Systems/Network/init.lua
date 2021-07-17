local Network = {}

local ReplicatedStorage = game.ReplicatedStorage

local EconomyData = ReplicatedStorage.Modules.EconomyData
local BusinessData = require(EconomyData.BusinessData)

local DataRunner = require(script.Parent.DataRunner)

local RunBusiness = Instance.new("Folder")
RunBusiness.Parent = ReplicatedStorage.RemoteEvents
RunBusiness.Name = "RunBusiness"

for k,_ in pairs(BusinessData) do
    local businessName = string.gsub(k, "_", " ")
    local Remote = Instance.new("RemoteEvent")
    Remote.Name = businessName
    Remote.Parent = RunBusiness
end

for _,remote in ipairs(ReplicatedStorage.RemoteEvents.RunBusiness:GetChildren()) do
    remote.OnServerEvent:Connect(function(player)

        local store = DataRunner.getStore(player)

        local businessState = store:getState().business[remote.Name]
        
        store:dispatch({
            type = "increment",
            statname = "money",
            value = businessState.gain
        })
    end)
end

ReplicatedStorage.RemoteEvents.BuyItems.BuyBusiness.OnServerEvent:Connect(function(player, businessName)
    if player:IsDescendantOf(game.Players) then
        local store = DataRunner.getStore(player)

        local state = store:getState()

        if state.playerdata.money >= state.business[businessName].cost then
            store:dispatch({
                type = "incrementAmountOwned",
                businessname = businessName,
                value = 1
            })

            store:dispatch({
                type = "increment",
                statname = "money",
                value = -(state.business[businessName].cost)
            })
        end
    end
end)





return Network