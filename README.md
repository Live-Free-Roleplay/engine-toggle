# EngineToggle
 FiveM Script - Vehicle Engine Toggle On/Off

## Description
With Key "M" you can toggle your vehicle Engine on or off.
The engine keeps running if you leave the vehicle without turning the engine off.

If you set Config.VehicleKeyChain to true then only the Owner of the Vehicle or someone with a Key can start the Engine!

## Config
```
Config = {}

-- Change 'false' to 'true' to toggle the engine automatically on when entering a vehicle
Config.OnAtEnter = false

-- Change 'false' to 'true' to use a key instead of a button
Config.UseKey = true

Config.ToggleKey = 244 -- M (https://docs.fivem.net/docs/game-references/controls/)

-- If both false then Default ESX Notification is active!
Config.Notifications = false -- https://forum.cfx.re/t/release-standalone-notification-script/1464244
Config.OkokNotify = true -- https://okok.tebex.io/package/4724993

-- Vehicle Key System
Config.VehicleKeyChain = false -- https://kiminazes-script-gems.tebex.io/package/4524211
```

## Requirements
* ESX 1.2 (https://github.com/esx-framework/es_extended/releases/tag/v1-final)
### Optional
* Notification (https://forum.cfx.re/t/release-standalone-notification-script/1464244)
* okokNotify (https://okok.tebex.io/package/4724993)
* VehicleKeyChain (https://kiminazes-script-gems.tebex.io/package/4524211)
