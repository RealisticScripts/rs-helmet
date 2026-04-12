fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Realistic Scripts'
name 'RS Helmet'
description 'A realistic script that allows players choose if they wear a helmet or not.'
version '1.0.0'
repository 'https://github.com/RealisticScripts/rs-helmet'
license 'MIT'


shared_scripts {
    'config.lua'
}

server_script { 
    'server.lua'
}

client_script {
    'client.lua'
}
