local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GeneralConfig = require(ReplicatedStorage.GeneralConfigs.GeneralConfig)

local EventManager = {}

function EventManager.activateEvent(eventName)
	if GeneralConfig.Events[eventName] then
		GeneralConfig.Events[eventName].Active = true
		print("✅ Evento ativado: " .. eventName)
		return true
	end
	warn("❌ Evento não existe: " .. eventName)
	return false
end

function EventManager.deactivateEvent(eventName)
	if GeneralConfig.Events[eventName] then
		GeneralConfig.Events[eventName].Active = false
		print("❌ Evento desativado: " .. eventName)
		return true
	end
	return false
end

function EventManager.toggleEvent(eventName)
	if GeneralConfig.Events[eventName] then
		GeneralConfig.Events[eventName].Active = not GeneralConfig.Events[eventName].Active
		local status = GeneralConfig.Events[eventName].Active and "ATIVADO" or "DESATIVADO"
		print("🔄 Evento " .. eventName .. " " .. status)
		return GeneralConfig.Events[eventName].Active
	end
	return false
end

function EventManager.getExpMultiplier()
	local total = 0
	for _, eventData in pairs(GeneralConfig.Events) do
		if eventData.Active then
			if eventData.ExpMultiplier then
				total = total + eventData.ExpMultiplier
			end
			if eventData.Multiplier then
				total = total + eventData.Multiplier
			end
		end
	end
	return total
end

return EventManager
