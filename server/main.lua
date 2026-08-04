local QBCore = exports['qb-core']:GetCoreObject()

-- Discord Webhook Audit Logging (Optional: Add your webhook URL here)
local WebhookURL = "" 

local function SendDiscordLog(title, message, color)
    if WebhookURL == "" then return end
    local embed = {
        {
            ["title"] = title,
            ["description"] = message,
            ["type"] = "rich",
            ["color"] = color or 3447003,
            ["footer"] = { ["text"] = "JobCreatorQBCORE by AlexVasquez" },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }
    }
    PerformHttpRequest(WebhookURL, function(err, text, headers) end, 'POST', json.encode({username = "Job System Logs", embeds = embed}), { ['Content-Type'] = 'application/json' })
end

RegisterCommand('jobcreator', function(source, args, rawCommand)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player and Player.PlayerData.job.isboss then
        TriggerClientEvent('JobCreatorQBCORE:client:openDashboard', src)
    else
        TriggerClientEvent('QBCore:Notify', src, 'Access Denied: Boss authorization required.', 'error')
    end
end, false)

RegisterNetEvent('JobCreatorQBCORE:server:buyShopItem', function(jobName, itemName, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local jobConfig = Config.Jobs[jobName]

    if not jobConfig or not Player then return end

    if Player.PlayerData.job.name == jobName and Player.PlayerData.job.isboss then
        local itemPrice = 0
        local itemLabel = itemName
        for _, item in ipairs(jobConfig.shopItems) do
            if item.name == itemName then
                itemPrice = item.price * amount
                itemLabel = item.label
                break
            end
        end

        if itemPrice > 0 then
            TriggerEvent('qb-bossmenu:server:removeAccountMoney', jobConfig.societyAccount, itemPrice, function(success)
                if success then
                    exports['qb-inventory']:AddItem(src, itemName, amount, nil, true, 'Job Store Order')
                    TriggerClientEvent('QBCore:Notify', src, 'Purchased '..amount..'x '..itemLabel, 'success')
                    SendDiscordLog("Store Restock", "**Boss:** " .. Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname .. "\n**Job:** " .. jobName .. "\n**Item:** " .. itemLabel .. " (x" .. amount .. ")\n**Cost:** $" .. itemPrice, 65280)
                else
                    TriggerClientEvent('QBCore:Notify', src, 'Society fund balance is too low!', 'error')
                end
            end)
        end
    else
        TriggerClientEvent('QBCore:Notify', src, 'Unauthorized operation.', 'error')
    end
end)

RegisterNetEvent('JobCreatorQBCORE:server:buyArmoryItem', function(jobName, itemName, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local jobConfig = Config.Jobs[jobName]

    if not jobConfig or not jobConfig.armory then return end

    if Player.PlayerData.job.name == jobName then
        local playerRank = Player.PlayerData.job.grade.level
        local selectedItem = nil

        for _, item in ipairs(jobConfig.armory) do
            if item.name == itemName then
                selectedItem = item
                break
            end
        end

        if selectedItem and playerRank >= selectedItem.minRank then
            local totalPrice = selectedItem.price * amount
            TriggerEvent('qb-bossmenu:server:removeAccountMoney', jobConfig.societyAccount, totalPrice, function(success)
                if success then
                    exports['qb-inventory']:AddItem(src, itemName, amount, nil, true, 'Department Armory Requisition')
                    TriggerClientEvent('QBCore:Notify', src, 'Requisitioned '..selectedItem.label, 'success')
                else
                    TriggerClientEvent('QBCore:Notify', src, 'Department budget allocation failed.', 'error')
                end
            end)
        else
            TriggerClientEvent('QBCore:Notify', src, 'Insufficient security clearance level.', 'error')
        end
    end
end)

RegisterNetEvent('JobCreatorQBCORE:server:openStash', function(jobName, stashType, targetCitizenId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local stashId = ''

    if stashType == 'shared' then
        stashId = 'job_shared_' .. jobName
        exports['qb-inventory']:OpenInventory(src, stashId, { maxweight = 500000, slots = 60 })
    elseif stashType == 'department' then
        stashId = 'job_dep_' .. jobName
        exports['qb-inventory']:OpenInventory(src, stashId, { maxweight = 1000000, slots = 100 })
    elseif stashType == 'boss_employee_audit' and Player.PlayerData.job.isboss then
        stashId = 'job_personal_' .. jobName .. '_' .. targetCitizenId
        exports['qb-inventory']:OpenInventory(src, stashId, { maxweight = 250000, slots = 40 })
    end
end)
