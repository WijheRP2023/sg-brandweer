local trappedVictims = {}

-- Functie om te checken of er een brandweerspeler online is
local function IsFirefighterOnline()
    local players = ESX.GetPlayers()
    for _, playerId in pairs(players) do
        local xPlayer = ESX.GetPlayerFromId(playerId)
        if xPlayer and xPlayer.job.name == "firefighter" then
            return true
        end
    end
    return false
end

RegisterNetEvent('sg-brandweer:setTrapped')
AddEventHandler('sg-brandweer:setTrapped', function(vehNetId)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if not xPlayer or xPlayer.job.name ~= "firefighter" then
        TriggerClientEvent('ox_lib:notify', src, {
            title = Lang("TITLE_BRANDWEER"),
            description = Lang("ERROR_ALLEEN_BRANDWEER"),
            type = "error"
        })
        return
    end

    -- Check of er brandweer online is
    if IsFirefighterOnline() then
        local isTrapped = math.random(1, 100) <= 50 -- 50% kans
        trappedVictims[vehNetId] = isTrapped
    else
        trappedVictims[vehNetId] = false -- Geen brandweer online, dus slachtoffer niet vastzetten
    end

    TriggerClientEvent('sg-brandweer:updateTrappedStatus', -1, vehNetId, trappedVictims[vehNetId])

    -- Admin log
    print((Lang("LOG_TRAPPED")):format(xPlayer.getName(), src, vehNetId, tostring(trappedVictims[vehNetId])))
end)

RegisterNetEvent('sg-brandweer:freeVictim')
AddEventHandler('sg-brandweer:freeVictim', function(vehNetId)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if not xPlayer or xPlayer.job.name ~= "firefighter" then
        TriggerClientEvent('ox_lib:notify', src, {
            title = Lang("TITLE_BRANDWEER"),
            description = Lang("ERROR_ALLEEN_BRANDWEER"),
            type = "error"
        })
        return
    end

    if trappedVictims[vehNetId] then
        trappedVictims[vehNetId] = false
        TriggerClientEvent('sg-brandweer:updateTrappedStatus', -1, vehNetId, false)

        -- Notificatie naar brandweer
        TriggerClientEvent('ox_lib:notify', src, {
            title = Lang("TITLE_BRANDWEER"),
            description = Lang("SUCCESS_VICTIM_FREED"),
            type = "success"
        })

        -- Admin log
        print((Lang("LOG_VICTIM_FREED")):format(xPlayer.getName(), src, vehNetId))
    end
end)
