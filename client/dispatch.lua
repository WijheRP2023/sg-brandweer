local ActiveDispatches = {}

RegisterNetEvent('sg-brandweer:receiveDispatch', function(dispatch)
    table.insert(ActiveDispatches, dispatch)

    -- Geef melding en bliep-geluid
    PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", 1)
    ESX.ShowNotification("🔥 Nieuwe melding ontvangen: " .. dispatch.description)

    -- Zet een waypoint op de kaart
    SetNewWaypoint(dispatch.coords.x, dispatch.coords.y)
end)

RegisterNetEvent('sg-brandweer:updateDispatch', function(updatedDispatch)
    for i, dispatch in pairs(ActiveDispatches) do
        if dispatch.id == updatedDispatch.id then
            ActiveDispatches[i] = updatedDispatch
            break
        end
    end
end)

RegisterNetEvent('sg-brandweer:acceptDispatch', function(incidentId)
    TriggerServerEvent('sg-brandweer:acceptDispatch', incidentId)
end)
