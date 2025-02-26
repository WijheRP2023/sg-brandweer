local ox_target = exports.ox_target
local stabilizationProps = {}

RegisterNetEvent('sg-brandweer:updateStabilization')
AddEventHandler('sg-brandweer:updateStabilization', function(vehNetId, isStabilized)
    local vehicle = NetToVeh(vehNetId)
    if DoesEntityExist(vehicle) then
        if isStabilized then
            FreezeEntityPosition(vehicle, true)
            ShowStabilizationEffect(vehicle)
        else
            FreezeEntityPosition(vehicle, false)
            RemoveStabilizationEffect(vehicle)
        end
    end
end)

function ShowStabilizationEffect(vehicle)
    -- Hier kun je visuele effecten toevoegen zoals een marker of prop
end

function RemoveStabilizationEffect(vehicle)
    -- Hier verwijder je de visuele effecten
end

ox_target:addGlobalVehicle({
    options = {
        {
            label = Locales[Config.Locale]['place_stut'],
            icon = 'fa-solid fa-car-crash',
            onSelect = function(data)
                TriggerServerEvent('sg-brandweer:placeStut', VehToNet(data.entity))
            end
        },
        {
            label = Locales[Config.Locale]['remove_stut'],
            icon = 'fa-solid fa-tools',
            onSelect = function(data)
                TriggerServerEvent('sg-brandweer:removeStut', VehToNet(data.entity))
            end
        }
    },
    distance = 2.5
})