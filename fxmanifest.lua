fx_version 'cerulean'
game 'gta5'

author 'AlexVasquez'
description 'All-in-one dynamic job, shop, crafting, and rank-locked armory creator for QB-Core'
version '1.0.0'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'shared/config.lua',
    'shared/import.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}

dependencies {
    'qb-core',
    'qb-target', -- changed from ox_target
    'qb-inventory'
}
