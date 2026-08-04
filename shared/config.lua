Config = {}

Config.Framework = 'qb-core'
Config.Target = 'ox_target' -- Supports 'ox_target' or 'qb-target'

Config.Jobs = {
    ['bishops'] = {
        label = 'Bishops Restaurant',
        type = 'civ', -- 'civ', 'pd', 'ems'
        societyAccount = 'bishops',
        startingFunds = 10000,
        locations = {
            ['duty'] = {
                vector4(-186.25, -273.45, 42.50, 150.0)
            },
            ['bossmenu'] = {
                vector4(-184.10, -270.20, 42.50, 60.0)
            },
            ['store_stash'] = { -- Shared employee storage inventory
                vector4(-188.50, -275.10, 42.50, 240.0)
            },
            ['crafting'] = {
                vector4(-180.20, -265.50, 42.50, 330.0)
            }
        },
        -- Boss buys items here using the society fund account
        shopItems = {
            { name = 'flour', label = 'Flour Sack', price = 12 },
            { name = 'cheese', label = 'Block of Cheese', price = 18 },
            { name = 'tomato_sauce', label = 'Tomato Sauce', price = 10 }
        },
        -- Employee crafting recipes
        craftingRecipes = {
            {
                result = 'bishops_pizza',
                label = 'Bishops Special Pizza',
                time = 5000,
                cost = {
                    { name = 'flour', count = 2 },
                    { name = 'cheese', count = 1 },
                    { name = 'tomato_sauce', count = 1 }
                }
            }
        }
    },

    ['police'] = {
        label = 'Los Santos Police Department',
        type = 'pd',
        societyAccount = 'police',
        startingFunds = 75000,
        locations = {
            ['duty'] = { vector4(441.5, -982.2, 30.7, 180.0) },
            ['bossmenu'] = { vector4(448.1, -973.2, 30.7, 90.0) },
            ['stash'] = { vector4(452.3, -980.1, 30.7, 0.0) },
            ['armory'] = { vector4(455.1, -975.4, 30.7, 180.0) }
        },
        armory = {
            { name = 'weapon_combatpistol', label = 'Combat Pistol', price = 250, minRank = 0 },
            { name = 'weapon_carbinerifle', label = 'Carbine Rifle', price = 1000, minRank = 2 },
            { name = 'armor', label = 'Body Armor', price = 100, minRank = 0 }
        }
    },

    ['ems'] = {
        label = 'Pilgrim Medical Center',
        type = 'ems',
        societyAccount = 'ems',
        startingFunds = 50000,
        locations = {
            ['duty'] = { vector4(301.2, -598.4, 43.3, 260.0) },
            ['bossmenu'] = { vector4(305.5, -601.1, 43.3, 80.0) },
            ['stash'] = { vector4(309.1, -595.2, 43.3, 175.0) },
            ['armory'] = { vector4(312.4, -590.8, 43.3, 350.0) }
        },
        armory = {
            { name = 'firstaid', label = 'First Aid Kit', price = 20, minRank = 0 },
            { name = 'painkillers', label = 'Painkillers', price = 15, minRank = 0 },
            { name = 'defibrillator', label = 'Defibrillator', price = 500, minRank = 1 }
        }
    }
}
