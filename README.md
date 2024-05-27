# EngineToggle
FiveM Script - Vehicle Engine Toggle On/Off Modified by Clink123

![GitHub release (latest by date)](https://img.shields.io/github/v/release/Musiker15/engine-toggle?color=gree&label=Update)

**Forum:** https://forum.cfx.re/t/re-release-enginetoggle/4793840

**Discord Support:** https://discord.gg/5hHSBRHvJE

## Description
* The engine keeps running if you leave the vehicle without turning the engine off.
* You can set that the engine starts automatically when entering a vehicle.
* You can choose if you use a Hotkey or a Command.
* You can choose between 3 diffrent Notifications.
* If you set `Config.VehicleKeys` to true then only the Owner of the Vehicle or someone with a Key can start the Engine!

## Requirements
### Optional
* Wasabi Carlock

### RealisticVehicleDamage
If you use `RealisticVehicleDamage`, then replace following Code in `client.lua` on Line 333 in RealisticVehicleDamage:
```lua
if healthEngineCurrent > cfg.engineSafeGuard+1 then
    SetVehicleUndriveable(vehicle,false)
    TriggerEvent('engine-toggle:RPDamage', true)
end

if healthEngineCurrent <= cfg.engineSafeGuard+1 and cfg.limpMode == false then
    SetVehicleUndriveable(vehicle,true)
    TriggerEvent('engine-toggle:RPDamage', false)
end
```

## License
**GNU General Public License v3.0**
