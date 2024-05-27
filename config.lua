Config = {}
----------------------------------------------------------------
Config.Locale = 'en'
Config.VersionChecker = true
----------------------------------------------------------------
-- If Standalone then you cant't use the Hotwire Feature and you have to replace the Notification
Config.Framework = 'ESX' -- 'ESX' or 'Standalone'
----------------------------------------------------------------
-- !!! This function is clientside AND serverside !!!
Config.Notification = function(source, message)
    if IsDuplicityVersion() then -- serverside
        TriggerClientEvent('esx:showNotification', source, message)
    else -- clientside
        ESX.ShowNotification(message)
    end
end
----------------------------------------------------------------
Config.Hotkey = {
    enable = true, -- Set false if you don't want to use a Hotkey
    key = 303 -- default: 303 = U
}

Config.Command = {
    enable = true, -- Set true if you want to use a Command
    command = 'engine'
}

Config.AdminCommand = { -- ESX Framework required !!
    enable = false,
    command = 'adengine',
    groups = {'admin'}
}

Config.OnAtEnter = true -- Change 'false' to 'true' to toggle the engine automatically on when entering a vehicle
----------------------------------------------------------------
-- Vehicle Key System - set true then only the Owner of the Vehicle or someone with a Key can start the Engine
Config.VehicleKeys = true -- Wasabi Carlock
----------------------------------------------------------------
Config.SaveSteeringAngle = true
Config.SaveAngleOnExit = 75 -- default: F - 75 (Exit Vehicle)
Config.PerformanceVersion = false -- true = no sync but more performance
Config.RefreshTime = 1 -- in seconds // Refreshing SteeringAngle all 5 seconds
----------------------------------------------------------------
-- With this feature you can set vehicles and plates for which you don't need a key to start the engine
-- either exact plates or just a string that should be in the vehicles plate e.g. "ESX" will ignore te plate "ESX1234" too
Config.Whitelist = {
    vehicles = {
        -- "nero2",
        -- "zentorno",
    },
    plates = {
        -- "ESX",
        -- "MSK",
    },
}