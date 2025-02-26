Config = {}

-- 🔥 Algemene instellingen
Config.Locale = 'nl' -- Keuze: 'nl' of 'en'
Config.Debug = false -- Zet op 'true' om debugging in te schakelen
Config.Framework = "esx" -- Opties: "qb" of "esx"


-- 🚒 Voertuig spawn instellingen
Config.FireStations = {
    {
        name = "Kazerne Centrum",
        coords = vector3(1200.0, -1460.0, 34.9), -- Pas aan naar jouw kazerne locatie
        spawnCoords = vector4(1205.0, -1465.0, 34.9, 180.0), -- Locatie waar voertuig spawnt
        vehicle = "firetruk", -- Standaard brandweerwagen
        maxVehicles = 1 -- Max aantal voertuigen per station
    },
    {
        name = "Kazerne Zuid",
        coords = vector3(-635.0, -124.0, 38.0),
        spawnCoords = vector4(-640.0, -130.0, 38.0, 90.0),
        vehicle = "firetruk",
        maxVehicles = 1
    }
}

-- 🚨 Dispatch instellingen
Config.Dispatch = {
    UseDispatch = true, -- Zet op false als je geen dispatch meldingen wilt
    DispatchScript = "cd_dispatch", -- Pas aan naar jouw dispatch script
    AutoFireAlerts = true -- Automatische meldingen bij branden
}

-- 🧯 Water & Brand instellingen
Config.FireSettings = {
    HoseRange = 15.0, -- Bereik van de brandslang in meters
    WaterPressure = 1.0, -- Hoe snel vuur dooft (1.0 = realistisch, hoger = sneller)
    HydrantFillTime = 10 -- Hoe lang het duurt om water uit een hydrant te vullen
}

-- 🛠️ Hulpverlenings Gereedschap
Config.Tools = {
    {name = "spreider", label = "Hydraulische Spreider", item = "spreider"},
    {name = "schaar", label = "Hydraulische Schaar", item = "schaar"},
    {name = "lucht", label = "Ademlucht Apparatuur", item = "ademlucht"}
}

Config.MaxStuttenPerVoertuig = 4 -- Aantal stutten per voertuig

--brand locaties en verspreiding 

Config.FireLocations = {
    {x = 215.76, y = -810.12, z = 30.73},
    {x = 320.21, y = -1050.5, z = 29.4},
    {x = 185.6, y = -1034.8, z = 29.3},
}
-- vuur verspreiding
Config.FireSpawnTime = 10 -- Minuten voordat een nieuwe brand ontstaat
Config.FireSpreadTime = 30 -- Seconden voordat een brand uitbreidt als er geen water is

Config.WaterToExtinguish = 100 -- Hoeveel water nodig is om een brand volledig te blussen
Config.MinWaterToStopSpread = 30 -- Minimum hoeveelheid water om uitbreiding te voorkomen
Config.WaterPerSpray = 5 -- Waterhoeveelheid per keer blussen

Config.HoseConnectionRange = 3.0 -- Afstand waarop je een slang kunt aansluiten
Config.HydrantModel = `prop_fire_hydrant_1, prop_fire_hydrant_2_l1, prop_fire_hydrant_4, prop_fire_hydrant_2` -- Model van de brandkraan

Config.WaterUsagePerSecond = 5 -- Hoeveel water per seconde wordt verbruikt
Config.HydrantPressure = 100 -- Maximale druk bij een hydrant
Config.VehiclePressure = 50 -- Maximale druk bij een voertuig

Config.OxygenRefillStations = {
    {coords = vector3(1200.0, -1472.0, 34.0), blip = false}, -- Kazerne locatie (voorbeeld)
    {coords = vector3(200.0, -1650.0, 29.0), blip = false} -- Extra locatie (kan worden aangepast)
}

Config.FireTrucks = { -- Lijst van voertuigen waar slangen op aangesloten kunnen worden
    'firetruk', -- Standaard brandweerwagen
    'bronto',   -- Hoogwerker (optioneel)
    'scania_p320' -- Extra voertuig (kan worden aangepast)
}

Config.HoseConnectionDistance = 3.0 -- Maximale afstand om een slang aan te sluiten
Config.WaterPressureBoost = 25 -- Extra druk bij aansluiting op een voertuig
