fx_version 'cerulean'
game 'gta5'

author 'TrAsKiN'
description 'A native progress bar for FiveM'

lua54 'yes'

client_scripts {
    'client/manager.lua',
    'client/progress.lua',
}

exports {
    'addBar',
    'updateBar',
    'removeBar',
}
