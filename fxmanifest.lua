fx_version 'cerulean'
game 'gta5'

author 'JouwNaam'
description 'Realistisch Brandweer Script voor ESX met OX Support'
version '1.0.0'

shared_scripts {
    'config.lua',
    'locales.lua'
}

client_scripts {
    'client/client.lua'
	'client/breathing.lua'
	'client/dispatch.lua'
	'client/dispatch_ui.lua'
	'client/fire.lua'
	'client/fire_spread.lua'
	'client/firehose.lua'
	'client/waterpressure.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua', -- Database ondersteuning
    'server/server.lua'
	'server/dispatch.lua'
	'server/fire_management.lua'
	'server/firehose.lua'
	'server/firehose.lua'
	'server/waterpressure.lua'
}

dependencies {
    'ox_target', -- Interactie systeem
    'ox_inventory', -- Inventaris systeem
    'es_extended' -- ESX-framework
}
