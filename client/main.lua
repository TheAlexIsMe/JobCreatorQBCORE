local QBCore = exports['qb-core']:GetCoreObject()

CreateThread(function()
    for jobName, data in pairs(Config.Jobs) do
        -- Map Blips
        if data.locations['duty'] then
            local blip = AddBlipForCoord(data.locations['duty'][1].x, data.locations['duty'][1].y, data.locations['duty'][1].z)
            SetBlipSprite(blip, data.type == 'pd' and 60 or (data.type == 'ems' and 61 or 106))
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, 0.8)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(data.label)
            EndTextCommandSetBlipName(blip)
        end

        -- Target registration
        if data.locations['store_stash'] then
            exports['ox_target']:addBoxZone({
                coords = data.locations['store_stash'][1],
                size = vector3(1.5, 1.5, 2.0),
                options = {
                    {
                        name = jobName .. '_shared_stash',
                        icon = 'fas fa-box-open',
                        label = 'Open Store Stash',
                        onSelect = function()
                            TriggerServerEvent('JobCreatorQBCORE:server:openStash', jobName, 'shared')
                        end
                    }
                }
            })
        end

        if data.locations['stash'] then
            exports['ox_target']:addBoxZone({
                coords = data.locations['stash'][1],
                size = vector3(1.5, 1.5, 2.0),
                options = {
                    {
                        name = jobName .. '_dep_stash',
                        icon = 'fas fa-suitcase',
                        label = 'Open Secure Stash',
                        onSelect = function()
                            TriggerServerEvent('JobCreatorQBCORE:server:openStash', jobName, 'department')
                        end
                    }
                }
            })
        end

        if data.locations['armory'] then
            exports['ox_target']:addBoxZone({
                coords = data.locations['armory'][1],
                size = vector3(1.5, 1.5, 2.0),
                options = {
                    {
                        name = jobName .. '_armory',
                        icon = 'fas fa-shield-alt',
                        label = 'Open Armory',
                        onSelect = function()
                            TriggerEvent('JobCreatorQBCORE:client:openArmoryMenu', jobName)
                        end
                    }
                }
            })
        end
    end
end)

RegisterNetEvent('JobCreatorQBCORE:client:openArmoryMenu', function(jobName)
    local jobConfig = Config.Jobs[jobName]
    if not jobConfig or not jobConfig.armory then return end

    SendNUIMessage({
        action = "openMenu",
        title = jobConfig.label .. " - Armory Requisition",
        type = "armory",
        job = jobName,
        items = jobConfig.armory
    })
    SetNuiFocus(true, true)
end)

RegisterNUICallback('closeUI', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('selectItem', function(data, cb)
    SetNuiFocus(false, false)
    if data.type == 'armory' then
        TriggerServerEvent('JobCreatorQBCORE:server:buyArmoryItem', data.job, data.item, 1)
    end
    cb('ok')
end)
