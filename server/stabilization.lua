local stabilizedVehicles = {}

RegisterNetEvent('sg-brandweer:placeStut')
AddEventHandler('sg-brandweer:placeStut', function(vehNetId)
    local src = source
    if not stabilizedVehicles[vehNetId] then
        stabilizedVehicles[vehNetId] = {}
    end
    
    if #stabilizedVehicles[vehNetId] < Config.MaxStuttenPerVoertuig then
        table.insert(stabilizedVehicles[vehNetId], true)
        TriggerClientEvent('sg-brandweer:updateStabilization', -1, vehNetId, true)
    end
end)

RegisterNetEvent('sg-brandweer:removeStut')
AddEventHandler('sg-brandweer:removeStut', function(vehNetId)
    local src = source
    if stabilizedVehicles[vehNetId] and #stabilizedVehicles[vehNetId] > 0 then
        table.remove(stabilizedVehicles[vehNetId])
        if #stabilizedVehicles[vehNetId] == 0 then
            stabilizedVehicles[vehNetId] = nil
            TriggerClientEvent('sg-brandweer:updateStabilization', -1, vehNetId, false)
        end
    end
end)
