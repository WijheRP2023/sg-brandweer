local activeFires = {}

function StartFire(x, y, z)
    local fireId = #activeFires + 1
    activeFires[fireId] = { coords = vector3(x, y, z), intensity = 1, lastExtinguish = GetGameTimer() }
    
    Citizen.CreateThread(function()
        while activeFires[fireId] do
            Citizen.Wait(5000) -- Controleer om de 5 seconden of het vuur zich uitbreidt

            if GetGameTimer() - activeFires[fireId].lastExtinguish > 10000 then -- Geen blussing in 10 sec? Uitbreiding!
                ExpandFire(fireId)
            end
        end
    end)
end

function ExpandFire(fireId)
    if not activeFires[fireId] then return end

    local fireCoords = activeFires[fireId].coords
    local newX = fireCoords.x + math.random(-2, 2)
    local newY = fireCoords.y + math.random(-2, 2)
    local newZ = fireCoords.z

    StartFire(newX, newY, newZ) -- Nieuwe brandhaard creëren
    TriggerServerEvent('sg-brandweer:notifyFireExpansion', fireCoords)
end

function ExtinguishFire(fireId, waterPressure)
    if not activeFires[fireId] then return end

    if waterPressure > 50 then
        activeFires[fireId] = nil -- Brand geblust
        lib.notify({ title = '🔥 Brand geblust!', description = 'Deze brand is succesvol geblust.', type = 'success' })
    else
        activeFires[fireId].lastExtinguish = GetGameTimer() -- Reset uitbreidings-timer
    end
end
