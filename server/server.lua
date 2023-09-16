-- FiveM Vehicle Whitelist v3 | By Toasty | 2023

local plyarray = {}

RegisterNetEvent('dawnstar:request:data')
AddEventHandler('dawnstar:request:data', function()
    local src = source
    local discord = ExtractIdentifiers(src).discord:gsub("discord:", "")
    if discord == nil then
    TriggerClientEvent('chatMessage', src , '^1[' .. GetCurrentResourceName() .. ']^0: Your discord id was not found, therefore we could not load your whitelisted vehicles. If this issue persists contact server development. If you have no whitelisted vehicles, you can ignore this message.')
    print('[' .. GetCurrentResourceName() .. '] Unable to get ' .. GetPlayerName(src) .. '\'s whitelisted vehicles, their discord id was not found.')
    end
     MySQL.Async.fetchAll("SELECT * FROM trusted WHERE discord = @discord", { ["@discord"] = discord }, function(result)
        if result ~= nil then
        plyarray[src] = {vehicles = result}
        TriggerClientEvent('dawnstar:return:discord', src, discord, plyarray[src].vehicles, Byspass(src))
        else
        plyarray[src] = {vehicles = nil}
        TriggerClientEvent('dawnstar:return:discord', src, discord, plyarray[src].vehicles, Byspass(src))
        end
     end)
 end)

RegisterNetEvent('dawnstar:check:allowed')
AddEventHandler('dawnstar:check:allowed', function(owner, hash)
    local src = source
    local discord = ExtractIdentifiers(src).discord:gsub("discord:", "")
    local check = false
    if owner == discord or Byspass(src) then
        check = true
    else
        if plyarray[src] ~= nil then
            for i, v in ipairs(plyarray[src].vehicles) do
                if hash == tonumber(v.hash) then
                    check = true
                    break;
                end
            end
            if not check then
                TriggerClientEvent('dawnstar:delete:vehicle', src)
            end
        end
    end
end)

RegisterNetEvent('dawnstar:trust:player')
AddEventHandler('dawnstar:trust:player', function(spawncode, vehname, playerid, k)
    local id = tonumber(playerid)
    local src = source
    if src == id then
        TriggerClientEvent("chat:addMessage", src, { template = '<div style="padding: 0.7vh; text-align: center; margin: 0.5vw; background-color: rgb(0,255,0 0.4); font-size: 1.7vh; border-radius: 0.5px;"><b>{0}</b></div>', args = { '^1Error^0: You cannot use this command on yourself!' } })
    else
        if GetPlayerName(id) == nil then
            TriggerClientEvent("chat:addMessage", src, { template = '<div style="padding: 0.7vh; text-align: center; margin: 0.5vw; background-color: rgb(0,255,0 0.4); font-size: 1.7vh; border-radius: 0.5px;"><b>{0}</b></div>', args = { '^1Error^0: You entered an invalid player id.' } })
        else
            local discord = ExtractIdentifiers(src).discord:gsub("discord:", "")
            MySQL.Async.fetchAll("SELECT COUNT(*) spawncode FROM trusted WHERE @spawncode = spawncode;", { ["@spawncode"] = GetHashKey(spawncode) }, function(result)
                if result[1] ~= nil then
                    if tonumber(result[1].spawncode) >= config.vehicles[k].slots then
                        TriggerClientEvent("chat:addMessage", src, { template = '<div style="padding: 0.7vh; text-align: center; margin: 0.5vw; background-color: rgb(0,255,0 0.4); font-size: 1.7vh; border-radius: 0.5px;"><b>{0}</b></div>', args = { '^1Error^0: ' .. config.setup.max_slots } })
                    else
                      TriggerClientEvent("chat:addMessage", src, { template = '<div style="padding: 0.7vh; text-align: center; margin: 0.5vw; background-color: rgb(0,255,0 0.4); font-size: 1.7vh; border-radius: 0.5px;"><b>{0}</b></div>', args = { '^2Success^0: You trusted ' .. GetPlayerName(id) .. ' to drive your vehicle with the spawncode: ' .. spawncode .. '.' } })
                       MySQL.Async.execute("INSERT INTO trusted (discord, spawncode, owner, vehname, hash) VALUES (@discord, @spawncode, @owner, @vehname, @hash)", { ["@discord"] = discord, ["@spawncode"] = spawncode, ["@owner"] = GetPlayerName(src), ["@vehname"] = vehname, ["@hash"] = GetHashKey(spawncode) })
                        TriggerClientEvent("chat:addMessage", id, { template = '<div style="padding: 0.7vh; text-align: center; margin: 0.5vw; background-color: rgb(0,255,0 0.4); font-size: 1.7vh; border-radius: 0.5px;"><b>{0}</b></div>', args = { '^5Alert^0: ' .. GetPlayerName(src) .. ' gave you access to their vehicle with the spawncode: ' .. spawncode .. '.' } })
                        Citizen.Wait(100)
                        TriggerEvent('dawnstar:update:plyarray', id, discord)
                    end
                else 
                    TriggerClientEvent("chat:addMessage", src, { template = '<div style="padding: 0.7vh; text-align: center; margin: 0.5vw; background-color: rgb(0,255,0 0.4); font-size: 1.7vh; border-radius: 0.5px;"><b>{0}</b></div>', args = { '^2Success^0: You trusted ' .. GetPlayerName(id) .. ' to drive your vehicle with the spawncode: ' .. spawncode .. '.' } })
                    MySQL.Async.execute("INSERT INTO trusted (discord, spawncode, owner, vehname, hash) VALUES (@discord, @spawncode, @owner, @vehname, @hash)", { ["@discord"] = discord, ["@spawncode"] = spawncode, ["@owner"] = GetPlayerName(src), ["@vehname"] = vehname, ["@hash"] = GetHashKey(spawncode) })
                    TriggerClientEvent("chat:addMessage", id, { template = '<div style="padding: 0.7vh; text-align: center; margin: 0.5vw; background-color: rgb(0,255,0 0.4); font-size: 1.7vh; border-radius: 0.5px;"><b>{0}</b></div>', args = { '^5Alert^0: ' .. GetPlayerName(src) .. ' gave you access to their vehicle with the spawncode: ' .. spawncode .. '.' } })
                    Citizen.Wait(100)
                    TriggerEvent('dawnstar:update:plyarray', id, discord)
                end
            end)
        end
    end
end)

RegisterNetEvent('dawnstar:untrust:player')
AddEventHandler('dawnstar:untrust:player', function(spawncode, playerid)
    local id = tonumber(playerid)
    local src = source
    if src == id then
        TriggerClientEvent("chat:addMessage", src, { template = '<div style="padding: 0.7vh; text-align: center; margin: 0.5vw; background-color: rgb(0,255,0 0.4); font-size: 1.7vh; border-radius: 0.5px;"><b>{0}</b></div>', args = { '^1Error^0: You cannot use this command on yourself!' } })
    else
        if GetPlayerName(id) ~= nil then
            local discord = ExtractIdentifiers(src).discord:gsub("discord:", "")
            TriggerClientEvent("chat:addMessage", id, { template = '<div style="padding: 0.7vh; text-align: center; margin: 0.5vw; background-color: rgb(0,255,0 0.4); font-size: 1.7vh; border-radius: 0.5px;"><b>{0}</b></div>', args = { '^5Alert^0: ' .. GetPlayerName(src) .. ' revoked your access to their vehicle with the spawncode: ' .. spawncode .. '.' } })
            MySQL.Async.execute('DELETE FROM trusted WHERE discord = @discord AND spawncode = @spawncode', { ["@discord"] = discord, ["@spawncode"] = GetHashKey(spawncode) })
            TriggerClientEvent("chat:addMessage", src, { template = '<div style="padding: 0.7vh; text-align: center; margin: 0.5vw; background-color: rgb(0,255,0 0.4); font-size: 1.7vh; border-radius: 0.5px;"><b>{0}</b></div>', args = { '^2Success^0: You revoked ' .. GetPlayerName(id) .. ' access to drive your vehicle with the spawncode: ' .. spawncode .. '.' } })
            Citizen.Wait(100)
            TriggerEvent('dawnstar:update:plyarray', id, discord)
        else
            TriggerClientEvent("chat:addMessage", src, { template = '<div style="padding: 0.7vh; text-align: center; margin: 0.5vw; background-color: rgb(0,255,0 0.4); font-size: 1.7vh; border-radius: 0.5px;"><b>{0}</b></div>', args = { '^1Error^0: You entered an invalid player id.' } })
        end
    end
end)

RegisterNetEvent('dawnstar:update:plyarray')
AddEventHandler('dawnstar:update:plyarray', function(id, discord)
     MySQL.Async.fetchAll("SELECT * FROM trusted WHERE discord = @discord", { ["@discord"] = discord }, function(result)
        plyarray[id] = { vehicles = result }
        TriggerClientEvent('dawnstar:return:discord', id, discord, plyarray[id].vehicles)
        if config.dubug_messages then
            print('Updated vehicle plyarray for ' .. GetPlayerName(id) .. '// Discord ID: ' .. discord)
        end
    end)
end)

function Byspass(src)
    if IsPlayerAceAllowed(src, config.setup.ace_bypass) then
        return true
    else
        return false
    end
end

function ExtractIdentifiers(src)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)
        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end
    return identifiers
end

Citizen.CreateThread(function()
    MySQL.ready(function() 
        MySQL.Async.fetchAll("SELECT * FROM trusted WHERE discord LIKE @char", {["@char"] = "%"}, function(data)
            if(data == nil) then
                MySQL.Async.execute("CREATE TABLE trusted (discord varchar(50) DEFAULT NULL, spawncode LONGTEXT DEFAULT NULL, owner LONGTEXT DEFAULT NULL, vehname LONGTEXT DEFAULT NULL, hash varchar(50) DEFAULT NULL);")
                Citizen.Wait(1000)
                print("[^1TABLE vehicle missing^0] The table trusted was not found within the database. I have automatically created it for you!")
            end
        end)
    end)
end)