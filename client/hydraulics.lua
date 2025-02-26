function UseHydraulicTool(vehicle, toolType)
    local playerPed = PlayerPedId()
    local animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
    local anim = "machinic_loop_mechandplayer"

    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do Wait(0) end

    TaskPlayAnim(playerPed, animDict, anim, 8.0, -8.0, -1, 1, 0, false, false, false)
    lib.progressCircle({
        duration = 7000,
        position = 'bottom',
        label = (toolType == "spreider") and locale['spreading'] or locale['cutting'],
        useWhileDead = false,
        canCancel = false,
        disable = { move = true, combat = true },
    })

    if toolType == "spreider" then
        SetVehicleDoorBroken(vehicle, 0, true) -- Voordeur verwijderen
        SetVehicleDoorBroken(vehicle, 1, true) -- Voordeur verwijderen
    else
        SetVehicleDoorBroken(vehicle, 4, true) -- Achterdeur verwijderen
        SetVehicleDoorBroken(vehicle, 5, true) -- Achterdeur verwijderen
    end

    ClearPedTasks(playerPed)
    lib.notify({
        title = locale['success'],
        description = (toolType == "spreider") and locale['door_removed'] or locale['roof_removed'],
        type = 'success'
    })
end

local locale = Locales[Config.Locale]

exports.ox_target:addGlobalVehicle({
    options = {
        {
            label = locale['use_spreader'],
            icon = "fa-solid fa-tools",
            item = "spreider",
            action = function(entity)
                UseHydraulicTool(entity, "spreider")
            end
        },
        {
            label = locale['use_cutter'],
            icon = "fa-solid fa-cut",
            item = "schaar",
            action = function(entity)
                UseHydraulicTool(entity, "schaar")
            end
        }
    },
    distance = 3.0
})

local locale = Locales[Config.Locale]

exports.ox_target:addGlobalVehicle({
    options = {
        {
            label = locale['rescue_victim'],
            icon = "fa-solid fa-hands-helping",
            item = "spreider",
            action = function(entity)
                RescueVictim(entity, "spreider")
            end
        },
        {
            label = locale['rescue_victim'],
            icon = "fa-solid fa-hands-helping",
            item = "schaar",
            action = function(entity)
                RescueVictim(entity, "schaar")
            end
        }
    },
    distance = 3.0
})
