local attachedHoses = {}

function AttachHose(target, type)
    local playerPed = PlayerPedId()

    if type == "vehicle" then
        if not DoesEntityExist(target) then
            lib.notify({ title = '🚒 Fout', description = 'Geen voertuig in de buurt!', type = 'error' })
            return
        end
        attachedHoses[playerPed] = target
        lib.notify({ title = '🚒 Brandslang aangesloten', description = 'Je hebt de slang aangesloten op het voertuig.', type = 'success' })
    elseif type == "hydrant" then
        attachedHoses[playerPed] = target
        lib.notify({ title = '🚒 Brandslang aangesloten', description = 'Je hebt de slang aangesloten op een brandkraan.', type = 'success' })
    end

    TriggerServerEvent('sg-brandweer:registerHose', target, type)
end

-- Voeg ox_target toe voor voertuigen en hydranten
exports.ox_target:addGlobalVehicle({
    name = 'connect_firehose_vehicle',
    icon = 'fa-solid fa-fire-extinguisher',
    label = 'Slang aansluiten',
    distance = 2.5,
    onSelect = function(data)
        AttachHose(data.entity, 'vehicle')
    end
})

exports.ox_target:addModel(Config.HydrantModel, {
    name = 'connect_firehose_hydrant',
    icon = 'fa-solid fa-tint',
    label = 'Slang aansluiten op brandkraan',
    distance = 2.5,
    onSelect = function(data)
        AttachHose(data.entity, 'hydrant')
    end
})