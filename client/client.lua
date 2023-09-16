-- FiveM Vehicle Whitelist v3 | By Toasty | 2023

---- variables -----

local discord_id = 0
local checked_status = false
local stored_vehicles = {}

Citizen.CreateThread(function()
    if NetworkIsSessionStarted() then
        if not checked_status then
           TriggerServerEvent('dawnstar:request:data')
            checked_status = true
        end
    end
end)

RegisterNetEvent('dawnstar:return:discord')
AddEventHandler('dawnstar:return:discord', function(discord, access_veh, bypass)
    discord_id = discord
    stored_vehicles = { keys = access_veh }
    TriggerEvent('dawnstar:update:menu', stored_vehicles.keys, discord, bypass)
end)

Citizen.CreateThread(function() --- Main vehicle checking thread
    while true do
        Citizen.Wait(config.setup.checking_time)
        local ped = GetPlayerPed(-1)
        local veh = GetVehiclePedIsIn(ped)
        local model = GetEntityModel(veh)
        local check_seat = GetPedInVehicleSeat(veh, -1)
        if check_seat == ped then
            for k, v in ipairs(config.vehicles) do
                if model == GetHashKey(v.spawncode) then
                   TriggerServerEvent('dawnstar:check:allowed', config.vehicles[k].discord_id, model)
                   break;
                end
            end
        end
    end
end)

RegisterNetEvent('dawnstar:delete:vehicle')
AddEventHandler('dawnstar:delete:vehicle', function()
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped)
    SetEntityAsMissionEntity(veh, true, true)
    DeleteEntity(veh)
    TriggerEvent("chat:addMessage", { template = '<div style="padding: 0.7vh; text-align: center; margin: 0.5vw; background-color: rgb(0,255,0 0.4); font-size: 1.7vh; border-radius: 0.5px;"><b>{0}</b></div>', args = { '^1Error^0: ' .. config.setup.delete_message } })
end)

RegisterCommand(config.setup.trust_command, function(source, args, rawCommand)
    local playerid = args[1]
    local spawncode = args[2]
    if CheckIfOwned(GetHashKey(spawncode), discord_id) then
        local numb = ReturnCarInfo(GetHashKey(spawncode))
       TriggerServerEvent('dawnstar:trust:player', spawncode, config.vehicles[numb].name, playerid, numb)
    else
        TriggerEvent("chat:addMessage", { template = '<div style="padding: 0.7vh; text-align: center; margin: 0.5vw; background-color: rgb(0,255,0 0.4); font-size: 1.7vh; border-radius: 0.5px;"><b>{0}</b></div>', args = { '^1Error^0: ' .. config.setup.not_your_vehicle_to_trust_msg } })
    end
end)

RegisterCommand(config.setup.untrust_command, function(source, args, rawCommand)
    local playerid = args[1]
    local spawncode = args[2]
    if CheckIfOwned(GetHashKey(spawncode), discord_id) then
       TriggerServerEvent('dawnstar:untrust:player', spawncode, playerid)
    else
        TriggerEvent("chat:addMessage", { template = '<div style="padding: 0.7vh; text-align: center; margin: 0.5vw; background-color: rgb(0,255,0 0.4); font-size: 1.7vh; border-radius: 0.5px;"><b>{0}</b></div>', args = { '^1Error^0: ' .. config.setup.not_your_vehicle_to_untrust_msg } })
    end
end)

Citizen.CreateThread(function()
    if config.setup.enable_chat_suggestion then
        TriggerEvent('chat:addSuggestion', config.setup.trust_command, 'Trust another player to use a personal vehicle (must be the owner)', { { name = "ID", help = "Spawncode" } })
        TriggerEvent('chat:addSuggestion', config.setup.untrust_command, 'Revoke another players access to use a personal vehicle (must be the owner)',{ { name = "ID", help = "Spawncode" } })
    end
end)

function CheckIfOwned(spawncode, discord)
    for k, v in pairs(config.vehicles) do
        if GetHashKey(v.spawncode) == spawncode then
            if discord == config.vehicles[k].discord_id then
                return true
            else
                return false
            end
        end
    end
end

function ReturnCarInfo(spawncode)
    for k, v in pairs(config.vehicles) do
        if GetHashKey(v.spawncode) == spawncode then
            return k
        else
            repeat until k
        end
    end
end




