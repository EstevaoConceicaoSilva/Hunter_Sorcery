local DataStoreService = game:GetService("DataStoreService")
local RunService = game:GetService("RunService")

local DATASTORE_NAME = "production"
if RunService:IsStudio() then
	DATASTORE_NAME = "development"
end

local ProfileTemplate = require(script.ProfileTemplate)
local dataStore = DataStoreService:GetDataStore(DATASTORE_NAME)
local profilesInCache = {}
local module = {}

-- Função que auxiliar para copiar a tabela com as informações do jogador
local function copyTable(t)
	local copy = {}
	for k, v in pairs(t) do
		if type(v) == "table" then
			copy[k] = copyTable(v)
		else
			copy[k] = v
		end
	end
	return copy
end

-- Função para atualizar perfis antigos com chaves novas do Template
local function reconcile(target, template)
	for k, v in pairs(template) do
		if type(v) == "table" then
			if type(target[k]) ~= "table" then
				target[k] = copyTable(v)
			else
				reconcile(target[k], v)
			end
		elseif target[k] == nil or type(target[k]) ~= type(v) then
			target[k] = v
		end
	end
end

-- Função para remover dados antigos que não existem mais no Template
local DYNAMIC_KEYS = { Traits = true, Artifacts = true }

local function cleanup(target, template)
	for key, value in pairs(target) do
		if DYNAMIC_KEYS[key] then
			continue
		end -- ✅ não apaga listas dinâmicas
		if template[key] == nil then
			target[key] = nil
			print("🗑️ Dado fantasma removido: " .. tostring(key))
		elseif type(value) == "table" and type(template[key]) == "table" then
			cleanup(value, template[key])
		end
	end
end
-- para carregar ou criar perfil de jogadores
function module.loadProfile(player: Player)
	if profilesInCache[player.UserId] then
		return
	end
	local success, profile
	for attempt = 1, 3 do
		success, profile = pcall(function()
			return dataStore:GetAsync(player.UserId)
		end)
		if success then
			break
		end
		task.wait(2)
	end
	if not success then
		player:Kick("Erro ao carregar dados. Tente reconectar.")
		return
	end

	if not profile then
		print("Novo perfil criado para " .. player.Name)
		profile = copyTable(ProfileTemplate)
	else
		-- Adiciona o que falta (Gems, etc)
		reconcile(profile, ProfileTemplate)

		-- Remove o que não existe mais no template (Money solto, Races, etc)
		cleanup(profile, ProfileTemplate)
	end

	profilesInCache[player.UserId] = profile
end

function module.getProfile(player: Player)
	return profilesInCache[player.UserId]
end

function module.saveProfile(player: Player)
	local profile = profilesInCache[player.UserId]
	if not profile then
		warn("saveProfile: perfil nil para " .. player.Name)
		return
	end
	print("Salvando:", player.Name, "Money:", profile.Currencies.Money)
	local success, err = pcall(function()
		dataStore:SetAsync(player.UserId, profile)
	end)
	if not success then
		warn("Erro ao salvar: " .. err)
	else
		print("✅ Save concluído para " .. player.Name)
	end
end

-- No início do módulo, adicione um autosave:
task.spawn(function()
	while true do
		task.wait(60) -- salva tudo a cada 60s
		for userId, _ in pairs(profilesInCache) do
			local player = game.Players:GetPlayerByUserId(userId)
			if player then
				module.saveProfile(player)
			end
		end
	end
end)

function module.updateStatus(player: Player, key: string, newValue: any)
	local profile = profilesInCache[player.UserId]
	if not profile then
		warn("Perfil não carregado para " .. player.Name)
		return
	end

	-- Navega pelo caminho (ex: "currencies.gems")
	local keys = string.split(key, ".")
	local target = profile

	for i = 1, #keys - 1 do
		target = target[keys[i]]
		if type(target) ~= "table" then
			warn("Caminho inválido: " .. key)
			return
		end
	end

	local finalKey = keys[#keys]

	-- Chave não existe no perfil
	if target[finalKey] == nil then
		warn("A chave '" .. key .. "' não existe no perfil de " .. player.Name)
		return
	end

	-- Tipo incompatível
	if type(target[finalKey]) ~= type(newValue) then
		warn("Erro de Tipo: '" .. key .. "' esperava " .. type(target[finalKey]) .. " mas recebeu " .. type(newValue))
		return
	end
	-- Tudo certo, atualiza
	target[finalKey] = newValue
	print("✅ Status atualizado: " .. key .. " = " .. tostring(newValue))
end

function module.removeProfile(player: Player)
	module.saveProfile(player)
	profilesInCache[player.UserId] = nil
end

return module
