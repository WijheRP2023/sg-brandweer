local activeHoses = {}

RegisterNetEvent('sg-brandweer:registerHose')
AddEventHandler('sg-brandweer:registerHose', function(target, type)
    local src = source
    local pressure = type == "hydrant" and 100 or 50 -- Hydrant heeft hogere druk
    activeHoses[src] = { target = target, type = type, pressure = pressure, waterLevel = 100 }

    TriggerClientEvent('sg-brandweer:updateWaterPressure', src, src, pressure)
end)

RegisterNetEvent('sg-brandweer:consumeWater')
AddEventHandler('sg-brandweer:consumeWater', function(hoseId)
    local src = source
    if activeHoses[src] and activeHoses[src].type == "vehicle" then
        activeHoses[src].waterLevel = activeHoses[src].waterLevel - 5
        if activeHoses[src].waterLevel <= 0 then
            activeHoses[src].pressure = 0
            lib.notify({ title = '🚒 Geen water!', description = 'De watervoorraad in het voertuig is op!', type = 'error' })
        end
    end
end)
