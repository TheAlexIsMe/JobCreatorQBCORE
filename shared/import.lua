local QBCore = exports['qb-core']:GetCoreObject()
Imports = {}

Imports.Jobs = {
    ['bishops'] = {
        label = 'Bishops Restaurant',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            ['0'] = { name = 'Recruit', payment = 50 },
            ['1'] = { name = 'Chef', payment = 100 },
            ['2'] = { name = 'Boss', isboss = true, payment = 250 }
        }
    },
    ['police'] = {
        label = 'LSPD',
        defaultDuty = true,
        grades = {
            ['0'] = { name = 'Officer', payment = 75 },
            ['1'] = { name = 'Sergeant', payment = 150 },
            ['2'] = { name = 'Chief', isboss = true, payment = 350 }
        }
    },
    ['ems'] = {
        label = 'EMS',
        defaultDuty = true,
        grades = {
            ['0'] = { name = 'Paramedic', payment = 75 },
            ['1'] = { name = 'Doctor', payment = 160 },
            ['2'] = { name = 'Director', isboss = true, payment = 320 }
        }
    }
}

-- Inject jobs safely into core runtime
CreateThread(function()
    Wait(500)
    if QBCore and QBCore.Shared and QBCore.Shared.Jobs then
        for jobName, jobData in pairs(Imports.Jobs) do
            QBCore.Shared.Jobs[jobName] = jobData
        end
    end
end)
