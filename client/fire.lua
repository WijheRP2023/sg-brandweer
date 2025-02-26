local ActiveFires = {}

RegisterNetEvent('sg-brandweer:applyWater', function(fireId, amount)
    TriggerServerEvent('sg-brandweer:applyWater', fireId, amount)
end)

function UseFireHose()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    for i, fire in ipairs(ActiveFires) do
        local dist = #(vector3(fire.coords.x, fire.coords.y, fire.coords.z) - coords)
        if dist < 5.0 then
            local pressure = GetWaterPressure() -- Haalt drukwaarde op
            TriggerServerEvent('sg-brandweer:applyWater', fire.id, pressure)

            lib.notify({
                title = '🚒 Water toegediend',
                description = 'Je blust het vuur met druk: ' .. pressure,
                type = 'success'
            })

            StartWaterEffect(fire.coords) -- Effect toevoegen
        end
    end
end

function StartWaterEffect(coords)
    UseParticleFxAssetNextCall('core')
    local waterEffect = StartParticleFxLoopedAtCoord('ent_sht_water', coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
    Citizen.Wait(2000)
    StopParticleFxLooped(waterEffect, false)
end

function GetWaterPressure()
    return math.random(30, 100) -- Simuleer realistische waterdruk
end

-- Voeg ox_target toe voor interactie
exports.ox_target:addBoxZone({
    coords = vector3(0, 0, 0), -- Wordt dynamisch geplaatst bij vuur
    size = vec3(1, 1, 1),
    options = {
        {
            name = 'firehose',
            event = 'sg-brandweer:useFireHose',
            icon = 'fas fa-fire-extinguisher',
            label = 'Blussen'
        }
    }
})

RegisterNetEvent('sg-brandweer:useFireHose', function()
    UseFireHose()
end)


local FireSmokeLevels = {}
local PlayerInSmoke = false
local WearingBreathingApparatus = false
local OxygenLevel = 100 -- Start met volle tank
local OxygenWarningGiven = false -- Voorkomt spam van waarschuwingen

RegisterNetEvent('sg-brandweer:startFire')
AddEventHandler('sg-brandweer:startFire', function(fireId, x, y, z, smokeLevel)
    FireSmokeLevels[fireId] = {coords = vector3(x, y, z), level = smokeLevel}
    StartSmokeEffect(fireId, x, y, z, smokeLevel)
end)

RegisterNetEvent('sg-brandweer:updateSmoke')
AddEventHandler('sg-brandweer:updateSmoke', function(fireId, smokeLevel)
    if FireSmokeLevels[fireId] then
        FireSmokeLevels[fireId].level = smokeLevel
    end
end)

RegisterNetEvent('sg-brandweer:toggleBreathingApparatus')
AddEventHandler('sg-brandweer:toggleBreathingApparatus', function()
    if OxygenLevel <= 0 then
        lib.notify({ title = '❌ Geen zuurstof!', description = 'Je ademlucht is op, bijvullen nodig!', type = 'error' })
        return
    end

    WearingBreathingApparatus = not WearingBreathingApparatus
    if WearingBreathingApparatus then
        lib.notify({ title = '🫁 Ademlucht geactiveerd', description = 'Je bent beschermd tegen rook.', type = 'success' })
    else
        lib.notify({ title = '🚨 Ademlucht verwijderd', description = 'Je bent kwetsbaar voor rook.', type = 'error' })
    end
end)

Citizen.CreateThread(function()
    while true do
        if WearingBreathingApparatus then
            OxygenLevel = OxygenLevel - 1
            
            if OxygenLevel == 20 and not OxygenWarningGiven then
                lib.notify({ title = '⚠️ Lage zuurstof!', description = 'Je zuurstofniveau is onder de 20%.', type = 'warning' })
                OxygenWarningGiven = true
            end

            if OxygenLevel <= 0 then
                WearingBreathingApparatus = false
                lib.notify({ title = '❌ Zuurstof op!', description = 'Je moet bijvullen om opnieuw te gebruiken.', type = 'error' })
            end
        end
        Citizen.Wait(3000) -- Elke 3 sec -1 zuurstof
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if OxygenLevel <= 20 then
            DrawRect(0.5, 0.5, 2.0, 2.0, 255, 0, 0, 80) -- Rode overlay op het scherm
        end
    end
end)

RegisterNetEvent('sg-brandweer:refillOxygen')
AddEventHandler('sg-brandweer:refillOxygen', function()
    OxygenLevel = 100
    OxygenWarningGiven = false -- Reset de waarschuwing na bijvullen
    lib.notify({ title = '✅ Zuurstof bijgevuld', description = 'Je ademlucht is weer vol.', type = 'success' })
end)

function ApplySmokeEffects(smokeLevel, distance)
    local damage = math.ceil((smokeLevel / distance) * 2)
    ApplyDamageToPed(PlayerPedId(), damage, false)

    lib.notify({
        title = '🚨 Giftige rook!',
        description = 'Je ademt rook in en krijgt schade!',
        type = 'error'
    })

    -- Hoesten toevoegen
    RequestAnimDict("timetable@gardener@smoking_joint")
    while not HasAnimDictLoaded("timetable@gardener@smoking_joint") do
        Citizen.Wait(10)
    end
    TaskPlayAnim(PlayerPedId(), "timetable@gardener@smoking_joint", "idle_cough", 1.0, -1, -1, 50, 0, false, false, false)

    -- Zicht verminderen
    SetTimecycleModifier("MP_corona_tint") -- Simuleert wazig zicht
    Citizen.Wait(5000) -- 5 seconden wazig
    ClearTimecycleModifier()
end