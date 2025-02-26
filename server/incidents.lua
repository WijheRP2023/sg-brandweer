local ActiveFires = {}

function GenerateFire()
    local fireLocations = Config.FireLocations
    local randomIndex = math.random(1, #fireLocations)
    local coords = fireLocations[randomIndex]

    local fireId = #ActiveFires + 1
    ActiveFires[fireId] = {
        id = fireId,
        coords = coords,
        active = true,
        waterReceived = 0 -- Houdt bij hoeveel water er is gebruikt
    }

    TriggerClientEvent('sg-brandweer:startFire', -1, ActiveFires[fireId])
    TriggerEvent('sg-brandweer:createDispatch', 'brand', coords, 'Melding: Grote brand')

    print('[BRANDWEER] 🔥 Brand gestart op locatie:', coords)
end

function SpreadFire(fireId)
    if ActiveFires[fireId] and ActiveFires[fireId].active then
        local fire = ActiveFires[fireId]

        -- Check of er te weinig water op is gespoten
        if fire.waterReceived < Config.MinWaterToStopSpread then
            local newCoords = {
                x = fire.coords.x + math.random(-3, 3),
                y = fire.coords.y + math.random(-3, 3),
                z = fire.coords.z
            }

            local newFireId = #ActiveFires + 1
            ActiveFires[newFireId] = {
                id = newFireId,
                coords = newCoords,
                active = true,
                waterReceived = 0
            }

            TriggerClientEvent('sg-brandweer:startFire', -1, ActiveFires[newFireId])
            print('[BRANDWEER] 🔥 Brand verspreidt zich naar:', newCoords)
        end
    end
end

-- Controleer elke minuut of vuur zich moet uitbreiden
CreateThread(function()
    while true do
        Wait(Config.FireSpreadTime * 1000)
        for fireId, fire in pairs(ActiveFires) do
            if fire.active then
                SpreadFire(fireId)
            end
        end
    end
end)

RegisterNetEvent('sg-brandweer:applyWater')
AddEventHandler('sg-brandweer:applyWater', function(fireId, amount)
    if ActiveFires[fireId] then
        ActiveFires[fireId].waterReceived = ActiveFires[fireId].waterReceived + amount
        if ActiveFires[fireId].waterReceived >= Config.WaterToExtinguish then
            ActiveFires[fireId].active = false
            TriggerClientEvent('sg-brandweer:extinguishFire', -1, fireId)
            print('[BRANDWEER] ✅ Brand geblust:', fireId)
        end
    end
end)
