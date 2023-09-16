-- FiveM Vehicle Whitelist v3 | By Toasty | 2023

local menu_ray = {}
local disc = nil
local bypassrestrict = false

RegisterNetEvent('dawnstar:update:menu')
AddEventHandler('dawnstar:update:menu', function (update, discord, access)
    menu_ray = {keys = update}
    disc = discord
    bypassrestrict = access
end)

local menu = MenuV:CreateMenu(false, config.menu.menu_title, 'topright', 155, 0, 0, 'size-125', 'example', 'menuv', 'Main')
local menu2 = MenuV:CreateMenu('Shared vehicles', 'You\'ve been given access to:', 'topright', 255, 0, 0, 'size-125', 'example', 'menuv', 'Given')
local menu3 = MenuV:CreateMenu('Owned vehicles', 'Your Owned Vehicles', 'topright', 255, 0, 0, 'size-125', 'example', 'menuv', 'Owned')
local owned = menu:AddButton({ icon = config.menu.owned_menu_emoji, label = 'Owned Vehicle Keys', value = menu3, description = 'Access your owned vehicles' })
local given_access = menu:AddButton({ icon = config.menu.shared_menu_emoji, label = 'Given Access Keys', value = menu2, description = 'Access vehicles that have been shared with you' })

menu2:On('open', function(m)
    m:ClearItems()
    for i, data in pairs(menu_ray.keys) do
      m:AddButton({ ignoreUpdate = i ~= 10, icon = '', label = (data.vehname .. ' (' .. data.spawncode .. ')'), value = menu, description = ('Vehicle Owner: ' .. data.owner), select = function(i) spawnvehicle(data.spawncode) end })
    end
end)

menu3:On('open', function(m)
	m:ClearItems()
	for k, v in pairs(config.vehicles) do
		if disc == v.discord_id or bypassrestrict == true then
        m:AddButton({ ignoreUpdate = i ~= 10, icon = '', label = (v.name .. ' (' .. v.spawncode .. ')'), value = menu, description = ('You own this vehicle'), select = function(i) spawnvehicle(v.spawncode) end })
		end
	end
end)


if config.menu.keybind_to_open then
	menu:OpenWith('KEYBOARD', config.menu.keybind_to_open)
end

if config.menu.use_command_to_open then
	RegisterCommand(config.menu.command_to_open, function()
		menu:Open()
	end)
end

---- spawn vehicle function ----

function spawnvehicle(car)
    MenuV:CloseAll()
    local ped = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(ped)
    local coords = GetEntityCoords(ped)
    SetEntityAsNoLongerNeeded(vehicle)
    DeleteEntity(vehicle)
    RequestModel(car)
    while not HasModelLoaded(car) do
        Citizen.Wait(0)
    end
    local veh = CreateVehicle(car, coords.x, coords.y, coords.z, GetEntityHeading(ped), true, false)
    SetPedIntoVehicle(ped, veh, -1)
    return veh
end
