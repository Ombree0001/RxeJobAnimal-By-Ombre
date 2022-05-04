ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_society:registerSociety', 'animal', 'Animalerie', 'society_animal', 'society_animal', 'society_animal', {type = 'public'})

ESX.RegisterServerCallback('rAnimalerie:buyPet', function(source, cb, pet, target)
    local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	local targetPlayer = ESX.GetPlayerFromId(target)
	local price = GetPriceFromPet(pet)

	if price == 0 then
		print(("rAnimalerie: %s tenté de vendre un animal invalide !"):format(xPlayer.identifier))
		cb(false)
	end

	if targetPlayer.getMoney() >= price then
		targetPlayer.removeMoney(price)

		MySQL.Async.execute('UPDATE users SET pet = @pet WHERE identifier = @identifier', {
			['@identifier'] = targetPlayer.identifier,
			['@pet'] = pet
		}, function(rowsChanged)
            TriggerClientEvent('esx:showNotification', _src, "<C>Vous venez vendre un "..pet.." pour ~g~$"..ESX.Math.GroupDigits(price).. "~s~ a "..targetPlayer.getName())
			TriggerClientEvent('esx:showNotification', targetPlayer.source, "<C>Vous avez recu votre "..pet.." pour ~g~$"..ESX.Math.GroupDigits(price))
			rxeLogsDiscord("**[VENTE]** "..xPlayer.getName().." a vendu un "..pet.." à "..targetPlayer.getName().." pour "..ESX.Math.GroupDigits(price), Config.Logs.vente)
			cb(true)
		end)
	else
		TriggerClientEvent('esx:showNotification', _src, "<C>La personne n'a pas assez d'argent")
		cb(false)
	end
end)

ESX.RegisterServerCallback('rAnimalerie:getPet', function(source, cb)
	local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)

	MySQL.Async.fetchAll('SELECT pet FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		if result[1].pet ~= nil then
			cb(result[1].pet)
		else
			cb('')
		end
	end)
end)

function GetPriceFromPet(pet)
	for i=1, #Config.PetShop, 1 do
		if Config.PetShop[i].pet == pet then
			return Config.PetShop[i].price
		end
	end

	return 0
end

RegisterServerEvent('Annonce:MoiSaMGL')
AddEventHandler('Annonce:MoiSaMGL', function(open, close, pause)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if open then
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], '~b~<C>Information', '<C>Animalerie', "<C>~g~Ouvert", 'CHAR_CHOP', 8)
		elseif close then
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], '~b~<C>Information', '<C>Animalerie', "<C>~r~Fermer", 'CHAR_CHOP', 8)
		elseif pause then
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], '~b~<C>Information', '<C>Animalerie', "<C>~o~Pause", 'CHAR_CHOP', 8)
		end
	end
end)

RegisterCommand('annonceanimal', function(source, args, rawCommand)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
		if xPlayer.job.name == Config.JobName then
			local src = source
			local msg = rawCommand:sub(14)
			local args = msg
			if player ~= false then
				local name = GetPlayerName(source)
				local xPlayers	= ESX.GetPlayers()
			for i=1, #xPlayers, 1 do
				local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
				TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], '~b~<C>Information', '<C>Animalerie', '<C>'..msg..'', 'CHAR_CHOP', 0)
			end
		else
			TriggerClientEvent('esx:showAdvancedNotification', _source, 'Avertisement', '<C>~r~Erreur' , '<C>Pas accès à cette commande', 'CHAR_CHOP', 0)
		end
    else
    TriggerClientEvent('esx:showAdvancedNotification', _source, 'Avertisement', '<C>~r~Erreur' , '<C>Pas accès à cette commande', 'CHAR_CHOP', 0)
    end
end, false)

ESX.RegisterServerCallback('rAnimalerie:getStockItems', function(source, cb, society)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_animal', function(inventory)
		cb(inventory.items)
	end)
end)

RegisterNetEvent('rAnimalerie:getStockItem')
AddEventHandler('rAnimalerie:getStockItem', function(itemName, count, society)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_animal', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and inventoryItem.count >= count then
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showAdvancedNotification', _source, '<C>Coffre', '<C>~o~Informations~s~', '<C>Vous avez retiré ~r~'..inventoryItem.label.." x"..count, 'CHAR_MP_FM_CONTACT', 8)
				rxeLogsDiscord("**[COFFRE]** "..xPlayer.getName().." a retiré "..inventoryItem.label.." x"..count.." du coffre", Config.Logs.coffre)
		else
			TriggerClientEvent('esx:showAdvancedNotification', _source, '<C>Coffre', '<C>~o~Informations~s~', "<C>Quantité ~r~invalide", 'CHAR_MP_FM_CONTACT', 9)
		end
	end)
end)

ESX.RegisterServerCallback('rAnimalerie:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb({items = items})
end)

RegisterNetEvent('rAnimalerie:putStockItems')
AddEventHandler('rAnimalerie:putStockItems', function(itemName, count, society)
	local _src = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_animal', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- does the player have enough of the item?
		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('esx:showAdvancedNotification', _src, '<C>Coffre', '<C>~o~Informations~s~', '<C>Vous avez déposé ~g~'..inventoryItem.label.." x"..count, 'CHAR_MP_FM_CONTACT', 8)
			rxeLogsDiscord("**[COFFRE]** "..xPlayer.getName().." a déposé "..inventoryItem.label.." x"..count.." dans le coffre", Config.Logs.coffre)
		else
			TriggerClientEvent('esx:showAdvancedNotification', _src, '<C>Coffre', '<C>~o~Informations~s~', "<C>Quantité ~r~invalide", 'CHAR_MP_FM_CONTACT', 9)
		end
	end)
end)

RegisterServerEvent('rAnimalerie:withdrawMoney')
AddEventHandler('rAnimalerie:withdrawMoney', function(amount)
    local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	TriggerEvent('esx_addonaccount:getSharedAccount', "society_animal", function(account)
		if amount > 0 and account.money >= amount then
			account.removeMoney(amount)
			xPlayer.addMoney(amount)
			TriggerClientEvent('esx:showNotification', _src, "<C>Vous avez retiré ~r~$"..ESX.Math.GroupDigits(amount))
			rxeLogsDiscord("**[BOSS]** "..xPlayer.getName().." a retiré $"..ESX.Math.GroupDigits(amount).." du coffre de l'entreprise", Config.Logs.boss)
		else
			TriggerClientEvent('esx:showNotification', _src, "<C>Montant invalide")
		end
	end)
end)

RegisterServerEvent('rAnimalerie:depositMoney')
AddEventHandler('rAnimalerie:depositMoney', function(amount)
    local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	if amount > 0 and xPlayer.getMoney() >= amount then
		TriggerEvent('esx_addonaccount:getSharedAccount', "society_animal", function(account)
			xPlayer.removeMoney(amount)
			TriggerClientEvent('esx:showNotification', _src, "<C>Vous avez déposé ~g~$"..ESX.Math.GroupDigits(amount))
			rxeLogsDiscord("**[BOSS]** "..xPlayer.getName().." a déposé $"..ESX.Math.GroupDigits(amount).." dans le coffre de l'entreprise", Config.Logs.boss)
			account.addMoney(amount)
		end)
	else
		TriggerClientEvent('esx:showNotification', _src, "<C>Montant invalide")
	end
end)

function rxeLogsDiscord(message,url)
    local DiscordWebHook = url
    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({username = "Logs Animalerie", content = message}), { ['Content-Type'] = 'application/json' })
end


RegisterServerEvent('rAnimalerie:logsEvent')
AddEventHandler('rAnimalerie:logsEvent', function(message, url)
	rxeLogsDiscord(message,url)
end)