local ActiveFires = {}
local FireSpreadTimer = 30 -- Tijd in seconden voordat een brand zich uitbreidt
local MaxSmokeLevel = 5 -- Hoeveel rookniveaus er maximaal kunnen zijn

RegisterNetEvent('sg-brandweer:reportFire')
AddEventHandler('sg-brandweer:reportFire', function(x, y, z)
    local fireId = #ActiveFires + 1
    ActiveFires[fireId] = { coords = vector3(x, y, z), isActive = true, smokeLevel = 1 }

    TriggerClientEvent('sg-brandweer:startFire', -1, fireId, x, y, z, 1)
    StartFireSpreadTimer(fireId)
end)

RegisterNetEvent('sg-brandweer:applyWater')
AddEventHandler('sg-brandweer:applyWater', function(fireId, pressure)
    if ActiveFires[fireId] and ActiveFires[fireId].isActive then
        if pressure > 50 then
            ActiveFires[fireId].smokeLevel = ActiveFires[fireId].smokeLevel - 1
            if ActiveFires[fireId].smokeLevel <= 0 then
                ActiveFires[fireId].isActive = false
                TriggerClientEvent('sg-brandweer:extinguishFire', -1, fireId)
            else
                TriggerClientEvent('sg-brandweer:updateSmoke', -1, fireId, ActiveFires[fireId].smokeLevel)
            end
        end
    end
end)

function StartFireSpreadTimer(fireId)
    Citizen.CreateThread(function()
        while ActiveFires[fireId] and ActiveFires[fireId].isActive do
            Citizen.Wait(FireSpreadTimer * 1000)

            if ActiveFires[fireId] and ActiveFires[fireId].isActive then
                local oldCoords = ActiveFires[fireId].coords
                local newX = oldCoords.x + math.random(-3, 3)
                local newY = oldCoords.y + math.random(-3, 3)
                local newZ = oldCoords.z
                
                local newFireId = #ActiveFires + 1
                ActiveFires[newFireId] = { coords = vector3(newX, newY, newZ), isActive = true, smokeLevel = 1 }

                -- Verhoog rookniveau van de originele brand
                if ActiveFires[fireId].smokeLevel < MaxSmokeLevel then
                    ActiveFires[fireId].smokeLevel = ActiveFires[fireId].smokeLevel + 1
                end
                
                TriggerClientEvent('sg-brandweer:startFire', -1, newFireId, newX, newY, newZ, 1)
                TriggerClientEvent('sg-brandweer:updateSmoke', -1, fireId, ActiveFires[fireId].smokeLevel)
            end
        end
    end)
end
