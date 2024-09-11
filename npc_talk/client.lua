local npcs = {
    {
        model = "a_f_y_business_01", -- Ped model
        coords = vector4(-557.01, -186.30, 38.22, 215.14), -- Ped coords
        webhook = "https://discord.com/api/webhooks/1283480789324926976/F0BbluHQ_5Qr3ZmPCt7mtR9Ff6PuBFGjG0E57UYS9XGIk0HuWsAfYkL-fo4fEOJN8lQV",
        label = "Add name ", --Target name 
        roleId = "1262294980513366077" -- ID discord role 
    },
    {
        model = "s_f_y_scrubs_01", -- Ped model
        coords = vector4(-437.57, -323.18, 34.91, 164.03), -- Ped coords
        webhook = "https://discord.com/api/webhooks/1283501957696196679/NvqSIgZID--oZAaXrm1OP0BEGqZQkXCJA-T7OQ9VczsX60oSmkEcWybFmWRKkosQ9ZzT",
        label = "Add name ", --Target name 
        roleId = "1259612267276927196" -- ID discord role 
    },
    {
        model = "s_f_y_cop_01", -- Ped model
        coords = vector4(633.25, 8.85, 82.63, 165.19), -- Ped coords
        webhook = "https://discord.com/api/webhooks/1283502868481048658/4DYQNZ5fmFxbrYNDvcIUTtUDH0Jzr05vtUZB8IBnKxmh9MStV7myOOnIUz6uXNcrT51a", 
        label = "Add name ", --Target name 
        roleId = "1259610372713873408" -- ID discord role 
    },
    {
        model = "s_f_y_migrant_01", -- Ped model
        coords = vector4(2745.37, 3468.73, 55.67, 254.65), -- Ped coords
        webhook = "https://discord.com/api/webhooks/1283503430412931073/j7nQES7df2ewfk5fcAnmgpAHX9O9fqoe9Tu8Q2A6-IhosRzVfwn7vriKSvs-uqVUXAjE",
        label = "Add name ", --Target name 
        roleId = "1262294295944237119" -- ID discord role 
    },
    {
        model = "a_f_y_business_01", -- Ped model
        coords = vector4(-554.76, -185.18, 38.22, 217.66), -- Ped coords
        webhook = "https://discord.com/api/webhooks/1283495196100919347/kV_IEV1GjfuOPipf5HmIV-S5iimHPVoI6UeHAJQolu0m9_Z3x4UD2cVV9rmdOkQzxeyE", 
        label = "Add name ", --Target name 
        roleId = "1262294978994896946" -- ID discord role 
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
                label = 'Talk ' .. npcData.label, -- label
                icon = 'fas fa-comments',
                onSelect = function()
                    TriggerServerEvent('npc:requestPlayerInfo', npcData.webhook, npcData.roleId)
                end
            }
        })
    end
end)

RegisterNetEvent("npc:openMenuWithInfo")
AddEventHandler("npc:openMenuWithInfo", function(charName, phoneNumber, webhook, roleId)
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
            roleId = roleId
        })
    end
end)
