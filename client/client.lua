-- 🚒 Framework detectie
local QBCore, ESX = nil, nil

if Config.Framework == "qb" then
    QBCore = exports['qb-core']:GetCoreObject()
elseif Config.Framework == "esx" then
    ESX = exports['es_extended']:getSharedObject()
end

local activeHose = nil

-- 🚒 Spawnen van brandweerwagens
RegisterNetEvent('sg-brandweer:spawnFireTruck', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    for _, station in pairs(Config.FireStations) do
        local distance = #(coords - station.coords)
        if distance < 50 then
            if Config.Framework == "qb" then
                QBCore.Functions.TriggerCallback('sg-brandweer:getAvailableFireTruck', function(vehicle)
                    if vehicle then
                        QBCore.Functions.SpawnVehicle(vehicle, function(veh)
                            SetupFireTruck(veh, playerPed, station)
                        end, station.spawnCoords, true)
                    else
                        QBCore.Functions.Notify(_U("no_vehicles_available"), "error")
                    end
                end, station.vehicle)
            elseif Config.Framework == "esx" then
                ESX.TriggerServerCallback('sg-brandweer:getAvailableFireTruck', function(vehicle)
                    if vehicle then
                        ESX.Game.SpawnVehicle(vehicle, station.spawnCoords, station.spawnCoords.w, function(veh)
                            SetupFireTruck(veh, playerPed, station)
                        end)
                    else
                        ESX.ShowNotification(_U("no_vehicles_available"))
                    end
                end, station.vehicle)
            end
            return
        end
    end
end)

-- 🚒 Setup voertuig
function SetupFireTruck(veh, playerPed, station)
    SetVehicleNumberPlateText(veh, "BRANDWEER" .. math.random(100, 999))
    TaskWarpPedIntoVehicle(playerPed, veh, -1)
    SetVehicleFuelLevel(veh, 100.0)
    if Config.Framework == "qb" then
        QBCore.Functions.Notify(_U("spawn_firetruck"), "success")
    else
        ESX.ShowNotification(_U("spawn_firetruck"))
    end
end

-- 🔥 Brandslang koppelen en gebruiken
RegisterNetEvent('sg-brandweer:attachHose', function()
    if activeHose then
        RemoveHose()
        return
    end

    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    local hoseModel = "prop_fire_hose"
    RequestModel(hoseModel)
    while not HasModelLoaded(hoseModel) do Wait(10) end

    activeHose = CreateObject(hoseModel, coords.x, coords.y, coords.z, true, true, false)
    AttachEntityToEntity(activeHose, playerPed, GetPedBoneIndex(playerPed, 57005), 0.1, 0, -0.1, 0, 0, 0, true, true, false, true, 1, true)

    if Config.Framework == "qb" then
        QBCore.Functions.Notify(_U("attach_hose"), "success")
    else
        ESX.ShowNotification(_U("attach_hose"))
    end
end)

-- 🔥 Brandslang loskoppelen
function RemoveHose()
    if activeHose then
        DeleteObject(activeHose)
        activeHose = nil
        if Config.Framework == "qb" then
            QBCore.Functions.Notify(_U("detach_hose"), "error")
        else
            ESX.ShowNotification(_U("detach_hose"))
        end
    end
end

egisterNetEvent('sg-brandweer:notify')
AddEventHandler('sg-brandweer:notify', function(type, msgKey)
    local msg = locale[msgKey] or msgKey -- Fallback als de key niet bestaat
    lib.notify({
        title = msg,
        type = type
    })
end)

function UseFireHose()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    for i, fire in ipairs(ActiveFires) do
        local dist = #(vector3(fire.coords.x, fire.coords.y, fire.coords.z) - coords)
        if dist < 5.0 then
            TriggerServerEvent('sg-brandweer:applyWater', fire.id, Config.WaterPerSpray)
            TriggerEvent('sg-brandweer:notify', 'success', 'hose_connected')
        end
    end
end

RegisterCommand('blussen', function()
    UseFireHose()
end, false)
-- 🚒 OX-Target interacties
exports['ox_target']:AddBoxZone("firestation", vector3(1200.0, -1460.0, 34.9), 2.0, 2.0, {
    name="firestation",
    heading=0,
    debugPoly=false,
    minZ=33.0,
    maxZ=36.0
}, {
    options = {
        {
            event = "sg-brandweer:spawnFireTruck",
            icon = "fas fa-truck",
            label = _U("spawn_firetruck"),
        },
        {
            event = "sg-brandweer:attachHose",
            icon = "fas fa-fire-extinguisher",
            label = _U("attach_hose"),
        }
    },
    distance = 2.5
})
