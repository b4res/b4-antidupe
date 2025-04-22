local QBCore = exports['qb-core']:GetCoreObject()


local playerLimits = {}


local function IsPlayerAdmin(playerId)
    if not Config.AdminExemption then return false end
    local Player = QBCore.Functions.GetPlayer(playerId)
    if Player then
        -- qb-admin'deki admin paneline sahip olup olmadığını kontrol et
        -- Örnek: 'admin' yetkisi varsa muaf kabul ediliyor
        return QBCore.Functions.HasPermission(playerId, 'admin') or QBCore.Functions.HasPermission(playerId, 'god')
    end
    return false
end

-- Discord Webhook Gönderme Fonksiyonu
local function SendDiscordLog(logType, playerId, details)
    local Player = QBCore.Functions.GetPlayer(playerId)
    if not Player then return end

    local identifiers = GetPlayerIdentifiers(playerId)
    local steamHex = "Bilinmiyor"
    local discordId = "Bilinmiyor"
    local ip = "Bilinmiyor"

    for _, id in pairs(identifiers) do
        if string.find(id, "steam:") then steamHex = id end
        if string.find(id, "discord:") then discordId = id:gsub("discord:", "") end
        if string.find(id, "ip:") then ip = id:gsub("ip:", "") end
    end

    local embed = {
        {
            ["title"] = Config.Logs[logType].Title,
            ["color"] = Config.Logs[logType].Color,
            ["fields"] = {
                { ["name"] = "Oyuncu Adı", ["value"] = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname, ["inline"] = true },
                { ["name"] = "Steam Hex", ["value"] = steamHex, ["inline"] = true },
                { ["name"] = "Discord ID", ["value"] = discordId, ["inline"] = true },
                { ["name"] = "IP Adresi", ["value"] = ip, ["inline"] = true },
                { ["name"] = "Detaylar", ["value"] = details, ["inline"] = false },
                { ["name"] = "Tarih/Saat", ["value"] = os.date("%Y-%m-%d %H:%M:%S"), ["inline"] = false }
            },
            ["footer"] = { ["text"] = "Anti-Dupe Script by B4RES" }
        }
    }

    PerformHttpRequest(Config.WebhookURL, function(err, text, headers) end, 'POST', json.encode({embeds = embed}), { ['Content-Type'] = 'application/json' })
end


local function CheckLimit(playerId, type, amount)
    if IsPlayerAdmin(playerId) then return true end 

    local src = playerId
    if not playerLimits[src] then
        playerLimits[src] = { Weapon = 0, Money = 0, Item = 0, Vehicle = 0 }
    end

    playerLimits[src][type] = playerLimits[src][type] + amount

    local limit = Config.Limits[type]
    if playerLimits[src][type] > limit then
        local Player = QBCore.Functions.GetPlayer(src)
        if Player then
            
            local details = string.format("%s limiti aşıldı! Limit: %d, Kullanılan: %d", type, limit, playerLimits[src][type])
            SendDiscordLog(type, src, details)

           
            DropPlayer(src, "Dupe tespit edildi! Limit aşımı: " .. type)
            QBCore.Functions.ExecuteSql(false, "DELETE FROM players WHERE citizenid = @citizenid", { ['@citizenid'] = Player.PlayerData.citizenid })
            print("[Anti-Dupe] " .. Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname .. " dupe nedeniyle kicklendi ve CK yedi.")
        end
        return false
    end
    return true
end


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.ResetInterval * 1000) 
        playerLimits = {} 
        print("[Anti-Dupe] Limitler sıfırlandı.")
    end
end)


RegisterServerEvent('antiDupe:checkWeapon')
AddEventHandler('antiDupe:checkWeapon', function(weaponName)
    local src = source
    if CheckLimit(src, "Weapon", 1) then
        
    end
end)

RegisterServerEvent('antiDupe:checkMoney')
AddEventHandler('antiDupe:checkMoney', function(amount)
    local src = source
    if CheckLimit(src, "Money", amount) then
        
    end
end)

RegisterServerEvent('antiDupe:checkItem')
AddEventHandler('antiDupe:checkItem', function(itemName, count)
    local src = source
    if CheckLimit(src, "Item", count) then
        
    end
end)

RegisterServerEvent('antiDupe:checkVehicle')
AddEventHandler('antiDupe:checkVehicle', function(vehicleModel)
    local src = source
    if CheckLimit(src, "Vehicle", 1) then
        
    end
end)


AddEventHandler('playerDropped', function()
    local src = source
    if playerLimits[src] then
        playerLimits[src] = nil
    end
end)