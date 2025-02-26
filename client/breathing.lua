Citizen.CreateThread(function()
    for _, station in pairs(Config.OxygenRefillStations) do
        exports.ox_target:addBoxZone({
            coords = station.coords,
            size = vec3(1.0, 1.0, 1.5),
            rotation = 0,
            debug = false,
            options = {
                {
                    name = 'oxygen_refill',
                    event = 'sg-brandweer:refillOxygen',
                    icon = 'fas fa-gas-pump',
                    label = 'Ademlucht bijvullen',
                }
            }
        })

        if station.blip then
            local blip = AddBlipForCoord(station.coords.x, station.coords.y, station.coords.z)
            SetBlipSprite(blip, 436) -- Blip ID voor tankstation
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, 0.8)
            SetBlipColour(blip, 3)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Ademlucht bijvullen")
            EndTextCommandSetBlipName(blip)
        end
    end
end)