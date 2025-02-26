local ActiveIncidents = {}

RegisterNetEvent('sg-brandweer:createDispatch', function(type, coords, description)
    local src = source
    local incidentId = #ActiveIncidents + 1
    local newIncident = {
        id = incidentId,
        type = type,
        coords = coords,
        description = description,
        assigned = false
    }
    
    table.insert(ActiveIncidents, newIncident)

    -- Stuur naar alle brandweerlieden
    if Config.Framework == "qb" then
        local Players = QBCore.Functions.GetPlayers()
        for _, playerId in pairs(Players) do
            local Player = QBCore.Functions.GetPlayer(playerId)
            if Player and Player.PlayerData.job.name == "firefighter" then
                TriggerClientEvent('sg-brandweer:receiveDispatch', playerId, newIncident)
            end
        end
    elseif Config.Framework == "esx" then
        local xPlayers = ESX.GetPlayers()
        for _, playerId in pairs(xPlayers) do
            local xPlayer = ESX.GetPlayerFromId(playerId)
            if xPlayer and xPlayer.job.name == "firefighter" then
                TriggerClientEvent('sg-brandweer:receiveDispatch', playerId, newIncident)
            end
        end
    end
end)

RegisterNetEvent('sg-brandweer:acceptDispatch', function(incidentId)
    for _, incident in pairs(ActiveIncidents) do
        if incident.id == incidentId then
            incident.assigned = true
            TriggerClientEvent('sg-brandweer:updateDispatch', -1, incident)
            break
        end
    end
end)
