-- FiveM Vehicle Whitelist v3 | By Toasty | 2023

config = {}

config.dubug_messages = true -- provides some debug messages

config.setup = {
    ace_bypass = "ACE HERE", --- ace permission to bypass the blacklist fully
    delete_message = "You do not have access to this personal vehicle.", -- the message that appears when a car is deleted because the player doesn't have access
    not_your_vehicle_to_trust_msg = 'You do not own the inputted vehicle, therefore you cannot trust another player to drive it.', -- the error message that returns to a player when they try to trust a player to use
    not_your_vehicle_to_untrust_msg = 'You do not own the inputted vehicle, therefore you cannot untrust another player.', -- a vehicle they don't own.
    max_slots = "You cannot trust anymore players to use your vehicle (Max slot limit reached).", -- error message that returns upon max allowed slots reached.
    trust_command = "trust", -- the command a player uses to trust another player to use their vehicle
    untrust_command = "untrust", -- the command a player uses to untrust another player to use their vehicle
    enable_chat_suggestion = true, -- enable chat suggestion of trust command
    checking_time = 800 -- the amount of time between thread loops. This loop checks to see if the ped is in a blacklisted vehicle and checks if they have access. The script idles at 0 ms (for me).
    -- If you experience raise this value, if you don't i recommend not lowering below 800.
}

config.menu = {
    menu_title = "Vehicle Keys",
    use_command_to_open = true, --- do you want to enable the command to open the menu?
    command_to_open = "keys",
    use_keybind_to_open = false, --- do you want to enable the keybind to open the menu?
    keybind_to_open = 'F6',
    owned_menu_emoji = '🔑',
    shared_menu_emoji = '🔑'
}

config.vehicles = { -- below are example tables - use this format to add extra vehicles
    {
        spawncode = 'blista', -- spawncode of vehicle
        name = "Police Car", -- name of car
        discord_id = '12123', -- who owns the vehicle? Insert their discord ID here. They will then be authorised to trust/untrust players to use their vehicle
        slots = 1 -- how many times do you want to allow the owner of the vehicle to trust others. For example if slots is set to 1, they owner will only be allowed to trust 1 player.
    },
    {
        spawncode = 'police',
        name = "police3", -- name of car
        discord_id = '12123',
        slots = 2
    },
    {
        spawncode = 'trash',
        name = "Trash Truck", -- name of car
        discord_id = '1234',
        slots = 2
    },
    {
        spawncode = 'trashtruck',
        name = "Another trash", -- name of car
        discord_id = '1234567',
        slots = 2
    },
    {
        spawncode = 'fbi2',
        name = "Fed car", -- name of car
        discord_id = '123',
        slots = 2
    },
}