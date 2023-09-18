-- FiveM Vehicle Whitelist v3 | By Toasty | 2023

fx_version 'bodacious'
game 'gta5'
author '@iitztoasty'
version '3.0'
lua54 'yes'

shared_script 'config.lua'

client_scripts {
    '@menuv/menuv.lua',
    'client/client.lua',
    'client/menu.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/server.lua',
}

dependency 'menuv'
