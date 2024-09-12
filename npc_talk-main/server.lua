QBCore = exports['qb-core']:GetCoreObject()
local function sendToDiscord(data)
    local content = string.format("**Name:** %s\n**Phone number:** %s\n**Additional information:** %s\n<@&%s>", 
        data.charName, data.phoneNumber, data.additionalInfo, data.roleId)

    local payload = {
        username = "NPC Report Bot",
        content = content,
        avatar_url = "https://your-avatar-link.com/avatar.png"
    }

    PerformHttpRequest(data.webhook, function(err, text, headers) 
        if err ~= 200 then 
            print("Failed to send webhook, error: " .. tostring(err)) 
        end 
    end, "POST", json.encode(payload), { ["Content-Type"] = "application/json" })
end

RegisterNetEvent('npc:sendToDiscord')
AddEventHandler('npc:sendToDiscord', function(data)
    sendToDiscord(data)
end)

RegisterNetEvent('npc:requestPlayerInfo')
AddEventHandler('npc:requestPlayerInfo', function(webhook, roleId)
    local _source = source
    local xPlayer = QBCore.Functions.GetPlayer(_source)
    local charName = xPlayer.PlayerData.charinfo.firstname .. " " .. xPlayer.PlayerData.charinfo.lastname
    local phoneNumber = xPlayer.PlayerData.charinfo.phone

    TriggerClientEvent("npc:openMenuWithInfo", _source, charName, phoneNumber, webhook, roleId)
end)