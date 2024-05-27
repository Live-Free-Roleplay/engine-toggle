if Config.Framework:match('ESX') then
	ESX = exports["es_extended"]:getSharedObject()
end

local vehicles = {}; RPWorking = true

CreateThread(function()
	while true do
		local sleep = 200

		if Config.Hotkey.enable and Config.Hotkey.key and IsPedInAnyVehicle(PlayerPedId()) and (GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) == PlayerPedId()) then
			sleep = 0

			if IsControlJustReleased(0, Config.Hotkey.key) then
				TriggerEvent('engine-toggle:Engine')
			end
		end

		if GetSeatPedIsTryingToEnter(PlayerPedId()) == -1 and not table.contains(vehicles, GetVehiclePedIsTryingToEnter(PlayerPedId())) then
			table.insert(vehicles, {GetVehiclePedIsTryingToEnter(PlayerPedId()), IsVehicleEngineOn(GetVehiclePedIsTryingToEnter(PlayerPedId()))})
		elseif IsPedInAnyVehicle(PlayerPedId(), false) and not table.contains(vehicles, GetVehiclePedIsIn(PlayerPedId(), false)) then
			table.insert(vehicles, {GetVehiclePedIsIn(PlayerPedId(), false), IsVehicleEngineOn(GetVehiclePedIsIn(PlayerPedId(), false))})
		end
		
		for i, vehicle in ipairs(vehicles) do
			if DoesEntityExist(vehicle[1]) then
				if (GetPedInVehicleSeat(vehicle[1], -1) == PlayerPedId()) or IsVehicleSeatFree(vehicle[1], -1) then
					if RPWorking then
						SetVehicleEngineOn(vehicle[1], vehicle[2], false, false)
						SetVehicleJetEngineOn(vehicle[1], vehicle[2])
						
						if not IsPedInAnyVehicle(PlayerPedId(), false) or (IsPedInAnyVehicle(PlayerPedId(), false) and vehicle[1] ~= GetVehiclePedIsIn(PlayerPedId(), false)) then
							if IsThisModelAHeli(GetEntityModel(vehicle[1])) or IsThisModelAPlane(GetEntityModel(vehicle[1])) then
								if vehicle[2] then
									SetHeliBladesFullSpeed(vehicle[1])
								end
							end
						end
					end
				end
			else
				table.remove(vehicles, i)
			end
		end

		Wait(sleep)
	end
end)

RegisterNetEvent('engine-toggle:Engine')
AddEventHandler('engine-toggle:Engine', function(isAdmin)
	local veh
	local StateIndex

	for i, vehicle in ipairs(vehicles) do
		if vehicle[1] == GetVehiclePedIsIn(PlayerPedId(), false) then
			veh = vehicle[1] -- sets the veh variable as the vehicle you're currently in
			StateIndex = i -- sets the state index = 1
			break
		end
	end

	-- The below is simply to generate a timer for requesting control of entity
	local netTime = 15
    NetworkRequestControlOfEntity(veh)
    while not NetworkHasControlOfEntity(veh) and netTime > 0 do 
        NetworkRequestControlOfEntity(veh)
        Wait(1)
        netTime = netTime - 1
    end

	if not veh or not DoesEntityExist(veh) then return end

	if Config.VehicleKeys then
		local isVehicle, isPlate = false, false
		local isVehicleOrKeyOwner = exports.wasabi_carlock:HasKey(GetVehicleNumberPlateText(veh))

		for k, v in pairs(Config.Whitelist.vehicles) do 
			if GetHashKey(v) == GetEntityModel(veh) then
				isVehicle = true
				break
			end
		end

		for k, v in pairs(Config.Whitelist.plates) do 
			if string.find(trim(tostring(GetVehicleNumberPlateText(veh))), v) then 
				isPlate = true
				break
			end
		end

		if IsPedInAnyVehicle(PlayerPedId(), false) and (isVehicleOrKeyOwner or isVehicle or isPlate or isAdmin) then
			if (GetPedInVehicleSeat(veh, -1) == PlayerPedId()) then
				vehicles[StateIndex][2] = not GetIsVehicleEngineRunning(veh)
				if vehicles[StateIndex][2] then
					Config.Notification(nil, Translation[Config.Locale]['engine_start'])
				else
					Config.Notification(nil, Translation[Config.Locale]['engine_stop'])
				end
			end 
		elseif IsPedInAnyVehicle(PlayerPedId(), false) and (not isVehicleOrKeyOwner or not isVehicle or not isPlate) then
			Config.Notification(nil, Translation[Config.Locale]['key_nokey'])
    	end 
	else
		if IsPedInAnyVehicle(PlayerPedId(), false) then 
			if (GetPedInVehicleSeat(veh, -1) == PlayerPedId()) then
				vehicles[StateIndex][2] = not GetIsVehicleEngineRunning(veh)
				if vehicles[StateIndex][2] then
					Config.Notification(nil, Translation[Config.Locale]['engine_start'])
				else
					Config.Notification(nil, Translation[Config.Locale]['engine_stop'])
				end
			end
		end
    end 
end)

RegisterNetEvent('engine-toggle:RPDamage')
AddEventHandler('engine-toggle:RPDamage', function(State)
	RPWorking = State
end)

if Config.OnAtEnter then
	CreateThread(function()
		while true do
			local sleep = 200

			if GetSeatPedIsTryingToEnter(PlayerPedId()) == -1 then
				for i, vehicle in ipairs(vehicles) do
					if vehicle[1] == GetVehiclePedIsTryingToEnter(PlayerPedId()) and not vehicle[2] then
						Wait(0)
						vehicle[2] = true
						Config.Notification(nil, Translation[Config.Locale]['engine_onatenter'])
					end
				end
			end

			Wait(sleep)
		end
	end)
end

if Config.SaveSteeringAngle then
	local pressed = 1 * 1000
	
	function isPedDriving()
		local playerPed = PlayerPedId()

		if IsPedInAnyVehicle(playerPed) then
			local vehicle = GetVehiclePedIsIn(playerPed, false)

			if GetPedInVehicleSeat(vehicle, -1) == playerPed then
				return true
			end
		end

		return false
	end
	
	CreateThread(function()
		while true do
			local sleep = 200
			local playerPed = PlayerPedId()

			if isPedDriving() then 
				sleep = 0

				if IsControlJustPressed(0, Config.SaveAngleOnExit) then
					local vehicle = GetVehiclePedIsIn(playerPed, true)
					local steeringAngle = GetVehicleSteeringAngle(vehicle)
					pressed = 500

					while not IsControlJustReleased(0, Config.SaveAngleOnExit) do
						if Config.PerformanceVersion then 
							SetVehicleSteeringAngle(vehicle, steeringAngle)
						else
							local vehNetId = VehToNet(vehicle)

							if vehNetId then
								SetNetworkIdExistsOnAllMachines(vehNetId, true)
								TriggerServerEvent('engine-toggle:async', vehNetId, steeringAngle)
							end
						end

						break
					end
				end
			end

			Wait(sleep)
		end
	end)
	
	RegisterNetEvent("engine-toggle:syncanglesave")
	AddEventHandler("engine-toggle:syncanglesave", function(vehNetId, steeringAngle)
		if not NetworkDoesEntityExistWithNetworkId(vehNetId) then return end
		local vehicle = NetToVeh(vehNetId)

		if DoesEntityExist(vehicle) then
			SetVehicleSteeringAngle(vehicle, steeringAngle)
		end
	end)
	
	CreateThread(function()
		if not Config.PerformanceVersion then
			local playerPed = PlayerPedId()
			local justDeleted  

			while true do
				Wait(500)

				if IsPedInAnyVehicle(playerPed, false) then
					local vehicle = GetVehiclePedIsIn(playerPed, true)
					local vehNetId = VehToNet(vehicle)

					if GetPedInVehicleSeat(vehicle, -1) == playerPed and not justDeleted and GetIsVehicleEngineRunning(vehicle) and vehNetId then
						TriggerServerEvent("engine-toggle:angledelete", vehNetId)
						justDeleted = true
					end
				else
					justDeleted = false
				end
			end
		end
	end)
end

function table.contains(table, element)
	for _, value in pairs(table) do
		if value[1] == element then
			return true
		end
	end
	return false
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

function trim(str)
	return string.gsub(str, "%s+", "")
end