local ActiveDispatches = {}

RegisterNetEvent('sg-brandweer:receiveDispatch', function(dispatch)
    table.insert(ActiveDispatches, dispatch)

    -- Laat een melding zien
    lib.notify({
        title = '🚒 Brandweer Melding',
        description = dispatch.description,
        type = 'inform',
        duration = 8000
    })

    -- Zet een waypoint op de kaart
    SetNewWaypoint(dispatch.coords.x, dispatch.coords.y)
end)

-- Open het dispatch-menu
RegisterCommand('brandweerdispatch', function()
    local options = {}

    for _, dispatch in ipairs(ActiveDispatches) do
        table.insert(options, {
            title = '🔥 ' .. dispatch.description,
            description = 'Klik om deze melding te accepteren',
            icon = 'fire',
            onSelect = function()
                TriggerServerEvent('sg-brandweer:acceptDispatch', dispatch.id)
                lib.notify({
                    title = '🚒 Melding geaccepteerd',
                    description = 'Ga naar de locatie!',
                    type = 'success'
                })
                SetNewWaypoint(dispatch.coords.x, dispatch.coords.y)
            end
        })
    end

    lib.registerContext({
        id = 'brandweer_dispatch_menu',
        title = 'Brandweer Dispatch',
        options = options
    })

    lib.showContext('brandweer_dispatch_menu')
end, false)

RegisterNetEvent('sg-brandweer:updateDispatch', function(updatedDispatch)
    for i, dispatch in ipairs(ActiveDispatches) do
        if dispatch.id == updatedDispatch.id then
            ActiveDispatches[i] = updatedDispatch
            break
        end
    end
end)
