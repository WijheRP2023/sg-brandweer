local hoseData = {}

RegisterNetEvent('sg-brandweer:updateWaterPressure', function(hoseId, pressure)
    if hoseData[hoseId] then
        hoseData[hoseId].pressure = pressure
    end
end)

function GetWaterPressure(hoseId)
    return hoseData[hoseId] and hoseData[hoseId].pressure or 0
end

function StartWaterFlow(hoseId)
    local pressure = GetWaterPressure(hoseId)

    if pressure <= 0 then
        lib.notify({ title = '🚒 Geen water!', description = 'Er is geen waterdruk beschikbaar!', type = 'error' })
        return
    end

    -- Simuleer waterstraal en verbruik
    CreateWaterEffect(hoseId)
    Citizen.CreateThread(function()
        while hoseData[hoseId] and hoseData[hoseId].inUse do
            Citizen.Wait(1000)
            TriggerServerEvent('sg-brandweer:consumeWater', hoseId)
        end
    end)
end

function CreateWaterEffect(hoseId)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local waterEffect = StartParticleFxLoopedAtCoord("core", "water_splash_jet", coords.x, coords.y, coords.z, 0, 0, 0, 1.0, false, false, false, false)
    hoseData[hoseId].effect = waterEffect
end
