local locale = Locales[Config.Locale] -- Haalt de juiste taal op

function ConnectHose(vehicle)
    if not vehicle then
        lib.notify({
            title = locale['no_firetruck_near'],
            description = locale['no_firetruck_near_desc'],
            type = 'error'
        })
        return
    end

    if DoesEntityExist(vehicle) then
        TriggerServerEvent('sg-brandweer:connectHose', VehToNet(vehicle))
        lib.notify({
            title = locale['hose_connected'],
            description = locale['hose_connected_desc'],
            type = 'success'
        })
    end
end

function DisconnectHose(vehicle)
    if not vehicle then
        lib.notify({
            title = locale['no_firetruck_near'],
            description = locale['no_firetruck_near_desc'],
            type = 'error'
        })
        return
    end

    if DoesEntityExist(vehicle) then
        TriggerServerEvent('sg-brandweer:disconnectHose', VehToNet(vehicle))
        lib.notify({
            title = locale['hose_disconnected'],
            description = locale['hose_disconnected_desc'],
            type = 'success'
        })
    end
end

exports.ox_target:addGlobalVehicle({
    options = {
        {
            label = locale['ox_target_hose_connect'],
            icon = "fa-solid fa-fire-extinguisher",
            action = function(entity)
                ConnectHose(entity)
            end,
            canInteract = function(entity, distance)
                return distance < 3.0
            end
        },
        {
            label = locale['ox_target_hose_disconnect'],
            icon = "fa-solid fa-hand-holding-water",
            action = function(entity)
                DisconnectHose(entity)
            end,
            canInteract = function(entity, distance)
                return distance < 3.0
            end
        }
    }
})

local usingHose = false
local waterPressure = 0

function StartWaterPressureUI()
    if usingHose then return end
    usingHose = true
    waterPressure = 50 -- Startwaarde (kan later dynamisch worden)

    lib.progressBar({
        duration = 5000,
        label = locale['water_pressure'],
        useWhileDead = false,
        canCancel = false,
        position = 'top',
        icon = 'fa-solid fa-tachometer-alt',
        onTick = function()
            -- Simuleer waterdrukverandering (pas aan op basis van echte druk)
            waterPressure = math.max(0, waterPressure - math.random(1, 3)) 
            return waterPressure > 0
        end,
        onFinish = function()
            usingHose = false
        end
    })
end

function UseFireHose()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    for i, fire in ipairs(ActiveFires) do
        local dist = #(vector3(fire.coords.x, fire.coords.y, fire.coords.z) - coords)
        if dist < 5.0 then
            TriggerServerEvent('sg-brandweer:applyWater', fire.id, waterPressure)
            lib.notify({
                title = locale['water_applied'],
                description = locale['extinguishing_fire'],
                type = 'success'
            })
            StartWaterPressureUI()
        end
    end
end

exports.ox_target:addGlobalVehicle({
    options = {
        {
            label = locale['ox_target_use_hose'],
            icon = "fa-solid fa-fire-extinguisher",
            action = function(entity)
                UseFireHose()
            end,
            canInteract = function(entity, distance)
                return distance < 3.0
            end
        }
    }
})