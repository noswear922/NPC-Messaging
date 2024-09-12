local QBCore = exports['qb-core']:GetCoreObject()

QBCore = exports['qb-core']:GetCoreObject()
local npcs = {
    {
        model = "a_f_y_business_01", -- Ped model
        coords = vector4(-557.01, -186.30, 38.22, 215.14), -- Ped coords
        webhook = "Add_webhook",
        label = "Add_name", --Target name 
        roleId = "1262294980513366077" -- ID discord role 
    },
    {
        model = "s_f_y_scrubs_01", -- Ped model
        coords = vector4(-437.57, -323.18, 34.91, 164.03), -- Ped coords
        webhook = "Add_webhook",
        label = "Add_name", --Target name 
        roleId = "1262294980513366077" -- ID discord role 
    },
    {
        model = "s_f_y_cop_01", -- Ped model
        coords = vector4(633.25, 8.85, 82.63, 165.19), -- Ped coords
        webhook = "Add_webhook",
        label = "Add_name", --Target name 
        roleId = "1262294980513366077" -- ID discord role 
    },
    {
        model = "s_f_y_migrant_01", -- Ped model
        coords = vector4(2745.37, 3468.73, 55.67, 254.65), -- Ped coords
        webhook = "Add_webhook",
        label = "Add_name", --Target name 
        roleId = "1262294980513366077" -- ID discord role 
    },
    {
        model = "a_f_y_business_01", -- Ped model
        coords = vector4(-554.76, -185.18, 38.22, 217.66), -- Ped coords
        webhook = "Add_webhook",
        label = "Add_name", --Target name 
        roleId = "1262294980513366077" -- ID discord role 
    }
}

Citizen.CreateThread(function()
    for _, npcData in ipairs(npcs) do
        local npcModel = GetHashKey(npcData.model)

        RequestModel(npcModel)
        while not HasModelLoaded(npcModel) do
            Wait(100)
        end

        local npc = CreatePed(4, npcModel, npcData.coords.x, npcData.coords.y, npcData.coords.z - 1, npcData.coords.w, false, true)
        SetEntityAsMissionEntity(npc, true, true)
        SetBlockingOfNonTemporaryEvents(npc, true)
        FreezeEntityPosition(npc, true)
        
        SetPedCanRagdoll(npc, false)
        SetPedCanBeShotInVehicle(npc, false)
        
        SetPedCanBeTargetted(npc, false)
        SetPedCanBeTargettedByTeam(npc, false)

        SetPedFleeAttributes(npc, 0, false)
        SetPedCombatAttributes(npc, 46, true)

        exports['ox_target']:addLocalEntity(npc, {
            {
                name = 'npc_talk_' .. _,
                label = 'Talk ' .. npcData.label,
                icon = 'fas fa-comments',
                onSelect = function()
                    TriggerEvent('npc:showProp', npc)
                    StartMessageDialog(npcData.webhook, npcData.roleId)
                end
            }
        })
    end
end)

RegisterNetEvent('npc:showProp')
AddEventHandler('npc:showProp', function(npc)
    local propModel = GetHashKey("prop_amb_phone") 
    RequestModel(propModel)
    while not HasModelLoaded(propModel) do
        Wait(100)
    end

    local prop = CreateObject(propModel, GetEntityCoords(npc), true, true, true)
    AttachEntityToEntity(prop, npc, GetPedBoneIndex(npc, 57005), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
end)

function StartMessageDialog(webhook, roleId)

    local playerData = QBCore.Functions.GetPlayerData()
    local charName = playerData.charinfo.firstname .. ' ' .. playerData.charinfo.lastname
    local phoneNumber = playerData.charinfo.phone

    local input = exports.ox_lib:inputDialog("Leave a message", {
        {label = "Leave your message here", type = "textarea"}
    })

    if input then
        local additionalInfo = input[1]
        TriggerServerEvent("npc:sendToDiscord", {
            charName = charName,
            phoneNumber = phoneNumber,
            additionalInfo = additionalInfo,
            webhook = webhook,
            roleId = roleId,
        })
        QBCore.Functions.Notify("The message was sent successfully!")
        QBCore.Functions.Progressbar("progress_bar", "Processing of information...", 5000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "amb@world_human_clipboard@male@idle_a",
            anim = "idle_a",
            flags = 49,
        }, {}, {}, function() 
            QBCore.Functions.Notify("The operation ended successfully!")
        end, function() 
            QBCore.Functions.Notify("The operation was interrupted!")
        end)
    end
end
