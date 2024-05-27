if Config.Framework:match('ESX') then
	ESX = exports["es_extended"]:getSharedObject()

	if Config.AdminCommand.enable then
		ESX.RegisterCommand(Config.AdminCommand.command, Config.AdminCommand.groups, function(xPlayer, args, showError)
			xPlayer.triggerEvent('engine-toggle:Engine', true)
		end, false, {help = 'Start the Engine as Admin'})
	end
end

if Config.Command.enable then
	RegisterCommand(Config.Command.command, function(source)
		TriggerClientEvent('engine-toggle:Engine', source)
	end)
end

if Config.SaveSteeringAngle then
	savedAngles = {}

	RegisterServerEvent("engine-toggle:async")
	AddEventHandler("engine-toggle:async", function(vehNetId, angle)
		savedAngles[vehNetId] = angle
		TriggerClientEvent("engine-toggle:syncanglesave", -1, vehNetId, savedAngles[vehicle])
	end)

	RegisterServerEvent("engine-toggle:angledelete")
	AddEventHandler("engine-toggle:angledelete", function(vehNetId)
		savedAngles[vehNetId] = nil
	end)

	CreateThread(function()
		while true do
			local sleep = Config.RefreshTime * 1000

			for i, data in pairs(savedAngles) do
				if savedAngles[i] then
					local vehicle = NetworkGetEntityFromNetworkId(i)

					if DoesEntityExist(vehicle) then
						TriggerClientEvent("engine-toggle:syncanglesave", -1, i, savedAngles[i])
					else
						savedAngles[i] = nil
					end
				end
			end

			Wait(sleep)
		end
	end)
end