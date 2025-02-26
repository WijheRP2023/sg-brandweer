RegisterNetEvent('sg-brandweer:connectHose')
AddEventHandler('sg-brandweer:connectHose', function(vehicleNetId)
    local locale = Locales[Config.Locale]
    local src = source
    local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)

    if vehicle then
        if not GlobalHoseConnections[vehicle] then
            GlobalHoseConnections[vehicle] = true
            TriggerClientEvent('sg-brandweer:notify', src, 'success', 'hose_connected')
        else
            TriggerClientEvent('sg-brandweer:notify', src, 'error', 'hose_already_connected')
        end
    end
end)

RegisterNetEvent('sg-brandweer:disconnectHose')
AddEventHandler('sg-brandweer:disconnectHose', function(vehicleNetId)
    local locale = Locales[Config.Locale]
    local src = source
    local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)

    if vehicle and GlobalHoseConnections[vehicle] then
        GlobalHoseConnections[vehicle] = nil
        TriggerClientEvent('sg-brandweer:notify', src, 'success', 'hose_disconnected')
    else
        TriggerClientEvent('sg-brandweer:notify', src, 'error', 'no_hose_connected')
    end
end)
