resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX Grapeseed Heist'

version '0.0.1'

server_scripts {
	--'@mysql-async/lib/MySQL.lua',
	"@vrp/lib/utils.lua",
	'pilotJob_config.lua',
	'sv_pilotJob.lua'
}

client_scripts {
	'cl_pilotJob.lua',
	'pilotJob_config.lua'
}

dependencies {
	
}