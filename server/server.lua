local QBCore, ESX = nil, nil

if Config.Framework == "qb" then
    QBCore = exports['qb-core']:GetCoreObject()
elseif Config.Framework == "esx" then
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
end

local ActiveFireTrucks = {}

-- 🚒 Callback voor voertuig ophalen
QBCore.Functions.CreateCallback('sg-brandweer:getAvailableFireTruck', function(source, cb, vehicleModel)
    local src = source
    local xPlayer = (Config.Framework == "qb") and QBCore.Functions.GetPlayer(src) or ESX.GetPlayerFromId(src)

    if not xPlayer then
        cb(nil)
        return
    end

    if ActiveFireTrucks[vehicleModel] then
        cb(nil)
    else
        ActiveFireTrucks[vehicleModel] = true
        cb(vehicleModel)
    end
end)

-- 🚒 Voertuig resetten bij verwijderen
RegisterNetEvent('sg-brandweer:returnFireTruck', function(vehicleModel)
    ActiveFireTrucks[vehicleModel] = nil
end)

-- 🔥 Brandincident opslaan
RegisterNetEvent('sg-brandweer:registerFireIncident', function(coords, type)
    local src = source
    local incidentType = type or "Onbekend"
    
    if Config.Framework == "qb" then
        local Players = QBCore.Functions.GetPlayers()
        for _, playerId in pairs(Players) do
            local Player = QBCore.Functions.GetPlayer(playerId)
            if Player and Player.PlayerData.job.name == "firefighter" then
                TriggerClientEvent('sg-brandweer:receiveIncident', playerId, coords, incidentType)
            end
        end
    elseif Config.Framework == "esx" then
        local xPlayers = ESX.GetPlayers()
        for _, playerId in pairs(xPlayers) do
            local xPlayer = ESX.GetPlayerFromId(playerId)
            if xPlayer and xPlayer.job.name == "firefighter" then
                TriggerClientEvent('sg-brandweer:receiveIncident', playerId, coords, incidentType)
            end
        end
    end
end)

RegisterNetEvent('sg-brandweer:applyWater')
AddEventHandler('sg-brandweer:applyWater', function(fireId, pressure)
    local locale = Locales[Config.Locale] -- Zorgt dat server ook juiste taal gebruikt
    local src = source

    if pressure > 50 then
        TriggerClientEvent('sg-brandweer:extinguishFire', -1, fireId)
        TriggerClientEvent('sg-brandweer:notify', src, 'success', 'fire_extinguished')
    else
        TriggerClientEvent('sg-brandweer:notify', src, 'error', 'not_enough_pressure')
    end
end)