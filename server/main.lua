local QBCore = exports['qb-core']:GetCoreObject()

-- Command to open the creator management panel manually if needed
RegisterCommand('jobcreator', function(source, args, rawCommand)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player and Player.PlayerData.job.isboss then
        TriggerClientEvent('JobCreatorQBCORE:client:openDashboard', src)
    else
        TriggerClientEvent('QBCore:Notify', src, 'You must be a boss to use this command!', 'error')
    end
end, false)

-- Boss buying shop items from society funds
RegisterNetEvent('JobCreatorQBCORE:server:buyShopItem', function(jobName, itemName, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local jobConfig = Config.Jobs[jobName]

    if not jobConfig then return end

    if Player.PlayerData.job.name == jobName and Player.PlayerData.job.isboss then
        local itemPrice = 0
        for _, item in ipairs(jobConfig.shopItems) do
            if item.name == itemName then
                itemPrice = item.price * amount
                break
            end
        end

        if itemPrice > 0 then
            -- Deduct from society fund via qb-bossmenu / banking accounts
            TriggerEvent('qb-bossmenu:server:removeAccountMoney', jobConfig.societyAccount, itemPrice, function(success)
                if success then
                    exports['qb-inventory']:AddItem(src, itemName, amount, nil, true, 'Job Store Order')
                    TriggerClientEvent('QBCore:Notify', src, 'Successfully purchased '..amount..'x '..itemName, 'success')
                else
                    TriggerClientEvent('QBCore:Notify', src, 'Insufficient funds in society account!', 'error')
                end
            end)
        end
    else
        TriggerClientEvent('QBCore:Notify', src, 'Unauthorized access to society funds.', 'error')
    end
end)

-- Armory rank and purchase checks for PD/EMS
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
                    exports['qb-inventory']:AddItem(src, itemName, amount, nil, true, 'Department Armory')
                    TriggerClientEvent('QBCore:Notify', src, 'Acquired '..selectedItem.label, 'success')
                else
                    TriggerClientEvent('QBCore:Notify', src, 'Department budget is empty!', 'error')
                end
            end)
        else
            TriggerClientEvent('QBCore:Notify', src, 'Your rank is too low to requisition this item.', 'error')
        end
    end
end)

-- Crafting validation & inventory swap
RegisterNetEvent('JobCreatorQBCORE:server:craftItem', function(jobName, recipeIndex)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local jobConfig = Config.Jobs[jobName]
    local recipe = jobConfig.craftingRecipes[recipeIndex]

    if not recipe then return end

    local canCraft = true
    for _, ing in ipairs(recipe.cost) do
        if not exports['qb-inventory']:HasItem(src, ing.name, ing.count) then
            canCraft = false
            break
        end
    end

    if canCraft then
        for _, ing in ipairs(recipe.cost) do
            exports['qb-inventory']:RemoveItem(src, ing.name, ing.count)
        end
        exports['qb-inventory']:AddItem(src, recipe.result, 1)
        TriggerClientEvent('QBCore:Notify', src, 'Crafted '..recipe.label..' successfully!', 'success')
    else
        TriggerClientEvent('QBCore:Notify', src, 'Missing required ingredients.', 'error')
    end
end)

-- Dynamic Stash Routing (Shared Store vs Boss Employee Review)
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
