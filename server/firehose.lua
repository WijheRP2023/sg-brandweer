local activeHoses = {}

RegisterNetEvent('sg-brandweer:registerHose')
AddEventHandler('sg-brandweer:registerHose', function(target, type)
    local src = source
    if type == "vehicle" then
        activeHoses[src] = { target = target, type = "vehicle" }
    elseif type == "hydrant" then
        activeHoses[src] = { type = "hydrant" }
    end
end)

RegisterNetEvent('sg-brandweer:removeHose')
AddEventHandler('sg-brandweer:removeHose', function()
    local src = source
    if activeHoses[src] then
        activeHoses[src] = nil
    end
end)
