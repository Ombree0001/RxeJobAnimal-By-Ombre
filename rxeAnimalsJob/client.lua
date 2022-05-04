local ESX = nil
local societyAnimaleriemoney = nil
local come, model, isAttached, inanimation, balle, ped, getball, isInVehicle, PetSelected, PlayerData = false, nil, false, false, false, {}, false, false, {}, {}

Citizen.CreateThread(function()
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

	while ESX == nil do Citizen.Wait(100) end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()

	Citizen.Wait(5000)
	DoRequestModel(-1788665315) -- chien
	DoRequestModel(1462895032) -- chat
	DoRequestModel(1682622302) -- loup
	DoRequestModel(-541762431) -- lapin
	DoRequestModel(1318032802) -- husky
	DoRequestModel(-1323586730) -- cochon
	DoRequestModel(1125994524) -- caniche
	DoRequestModel(1832265812) -- carlin
	DoRequestModel(882848737) -- retriever
	DoRequestModel(1126154828) -- berger
	DoRequestModel(-1384627013) -- westie
	DoRequestModel(351016938)  -- rottweiler
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)  
	PlayerData.job = job  
	Citizen.Wait(5000) 
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)


Citizen.CreateThread(function()
	local blip = AddBlipForCoord(Config.Pos.Blips)

	SetBlipSprite(blip, 463)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 0.9)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Animalerie")
	EndTextCommandSetBlipName(blip)
end)


local function rAnimalerieKeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    blockinput = true
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Wait(0)
    end 
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        blockinput = false
        return result
    else
        Wait(500)
        blockinput = false
        return nil
    end
end

function MenuAnimalerieJob()
    local main = RageUI.CreateMenu('Animalerie', '~b~Vente')
	local submain = RageUI.CreateSubMenu(main, 'Animalerie', '~b~Vente')
	local Annonces = RageUI.CreateSubMenu(main, 'Animalerie', '~b~Annonces')
    RageUI.Visible(main, not RageUI.Visible(main))

    while main do
        Citizen.Wait(0)
        RageUI.IsVisible(main, true, true, true, function()

			RageUI.Separator("~b~↓ Annonce ↓")

			RageUI.ButtonWithStyle("Annonces", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
			end, Annonces)

			RageUI.Separator("~b~↓ Catalogue ↓")

			for k,v in pairs(Config.PetShop) do
				RageUI.ButtonWithStyle(v.label,nil, {RightLabel = "~g~"..v.price.."$"}, true, function(Hovered, Active, Selected)
					if Selected then
						PetSelected.Name = v.pet
						PetSelected.Label = v.label
						PetSelected.Price = v.price
					end
				end, submain)
			end

	end, function()
	end)

		RageUI.IsVisible(Annonces, true, true, true, function()
			
			RageUI.ButtonWithStyle("Ouvert","Indiquez que l'entreprise ouvre", {RightLabel = ""}, not cooldown, function(Hovered, Active, Selected)
				if Selected then
					TriggerServerEvent('Annonce:MoiSaMGL', true, false, false)
					cooldowncool(2500)
				end
			end)
	
			RageUI.ButtonWithStyle("Fermer","Indiquez que l'entreprise ferme", {RightLabel = ""}, not cooldown, function(Hovered, Active, Selected)
				if Selected then
					TriggerServerEvent('Annonce:MoiSaMGL', false, true, false)
					cooldowncool(2500)
				end
			end)

			RageUI.ButtonWithStyle("Pause","Indiquez que l'entreprise se met en pause", {RightLabel = ""}, not cooldown, function(Hovered, Active, Selected)
				if Selected then
					TriggerServerEvent('Annonce:MoiSaMGL', false, false, true)
					cooldowncool(2500)
				end
			end)

			RageUI.ButtonWithStyle("Personnalisé","Annonce personnalisé", {RightLabel = ""}, not cooldown, function(Hovered, Active, Selected)
				if Selected then
					local msg = rAnimalerieKeyboardInput("Votre annonce?", "", 30)

					ExecuteCommand("annonceanimal "..msg)
					cooldowncool(2500)

				end
			end)

        end, function()
        end)

		RageUI.IsVisible(submain, true, true, true, function()

		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

		RageUI.Separator("~b~Animal de compagnie ~s~→ ~b~"..PetSelected.Label)

		RageUI.Separator("~g~Prix ~s~→ ~g~"..PetSelected.Price.."~s~$")

		RageUI.Separator("~r~↓ Vente proche ↓")

		RageUI.ButtonWithStyle("Vendre", nil, {RightLabel = "→"}, closestPlayer ~= -1 and closestDistance <= 3.0, function(Hovered, Active, Selected)
			if Selected then
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				if closestPlayer == -1 or closestDistance > 3.0 then
					ESX.ShowNotification("<C>Personne autour ~r~!")
				else
					ESX.TriggerServerCallback("rAnimalerie:buyPet", function(Good) 
						if Good then
							RageUI.CloseAll()
						end
					end, PetSelected.Name, GetPlayerServerId(closestPlayer))
				end
			end
		end)

		RageUI.Separator("~b~↓ Acheter (Moi) ↓")

		RageUI.ButtonWithStyle("Acheter",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
			if Selected then
				ESX.TriggerServerCallback("rAnimalerie:buyPet", function(Good) 
						if Good then
							RageUI.CloseAll()
						end
				end, PetSelected.Name, GetPlayerServerId(PlayerId()))
			end
		end)

        end, function()
        end)

        if not RageUI.Visible(main) and not RageUI.Visible(submain) and not RageUI.Visible(Annonces) then
            main = RMenu:DeleteType(main, true)
        end
    end
end

local namepet = nil

function MenuGestAnimal()
    local MenuA = RageUI.CreateMenu('Animal', 'Gestion')
    RageUI.Visible(MenuA, not RageUI.Visible(MenuA))
    while MenuA do
        Citizen.Wait(0)
        RageUI.IsVisible(MenuA, true, true, true, function()

			if not come then
				RageUI.ButtonWithStyle("Appeller votre animal",nil, {RightLabel = "→→"}, not cooldown, function(Hovered, Active, Selected)
					if Selected then
						cooldowncool(1000)
						ESX.TriggerServerCallback('rAnimalerie:getPet', function(pet)
							namepet = pet
							if pet == 'chien' then
								model = -1788665315
								come = true
								openchien()
							elseif pet == 'chat' then
								model = 1462895032
								come = true
								openchien()
							elseif pet == 'loup' then
								model = 1682622302
								come = true
								openchien()
							elseif pet == 'lapin' then
								model = -541762431
								come = true
								openchien()
							elseif pet == 'husky' then
								model = 1318032802
								come = true
								openchien()
							elseif pet == 'cochon' then
								model = -1323586730
								come = true
								openchien()
							elseif pet == 'caniche' then
								model = 1125994524
								come = true
								openchien()
							elseif pet == 'carlin' then
								model = 1832265812
								come = true
								openchien()
							elseif pet == 'retriever' then
								model = 882848737
								come = true
								openchien()
							elseif pet == 'berger' then
								model = 1126154828
								come = true
								openchien()
							elseif pet == 'westie' then
								model = -1384627013
								come = true
								openchien()
							elseif pet == 'rottweiler' then
								model = 351016938
								come = true
								openchien()
							else
								RageUI.Text({ message = "~r~Aucun animal de compagnie", time_display = 3500 })
							end
						end)
					end
				end)

			else

				RageUI.Separator("~b~Vous possedez un : ~s~"..namepet)

				RageUI.ButtonWithStyle("Attacher / Détacher votre animal", nil, {RightLabel = "→"},not cooldown, function(Hovered, Active, Selected)
                    if (Selected) then
						cooldowncool(1000)
						if not IsPedSittingInAnyVehicle(ped) then
							if isAttached == false then
								attached()
								isAttached = true
								ESX.ShowNotification("<C>~g~Chien attacher !~s~")
							else
								detached()
								isAttached = false
								ESX.ShowNotification("<C>~r~Chien détacher !~s~")
							end
							else
							ESX.ShowNotification("<C>~r~On attache pas un animal dans un vehicule !~s~")
						end
                    end
                end)

				if isInVehicle then
					RageUI.ButtonWithStyle("Faire descendre votre animal dans le véhicule", nil, {RightLabel = "→"},not cooldown, function(Hovered, Active, Selected)
						if (Selected) then
							cooldowncool(1000)
							local playerPed = PlayerPedId()
							local vehicle  = GetVehiclePedIsUsing(playerPed)
							local coords   = GetEntityCoords(playerPed)
							local coords2  = GetEntityCoords(ped)
							local distance = GetDistanceBetweenCoords(coords, coords2, true)

							if not isInVehicle then
								if IsPedSittingInAnyVehicle(playerPed) then
									if distance < 8 then
										attached()
										Citizen.Wait(200)
										if IsVehicleSeatFree(vehicle, 1) then
											SetPedIntoVehicle(ped, vehicle, 1)
											isInVehicle = true
										elseif IsVehicleSeatFree(vehicle, 2) then
											isInVehicle = true
											SetPedIntoVehicle(ped, vehicle, 2)
										elseif IsVehicleSeatFree(vehicle, 0) then
											isInVehicle = true
											SetPedIntoVehicle(ped, vehicle, 0)
										end


									else
										ESX.ShowNotification("<C>~r~Votre animal est trop loin du véhicule ! ~s~")
									end

								else
									ESX.ShowNotification("<C>Vous devez être dans un vehicule !")
								end
							else
								if not IsPedSittingInAnyVehicle(playerPed) then
									SetEntityCoords(ped, coords,1,0,0,1)
									Citizen.Wait(100)
									detached()
									isInVehicle = false

								else
									ESX.ShowNotification("<C>Vous êtes toujours dans un véhicule")
								end
							end
						end
					end)
				else
					RageUI.ButtonWithStyle("Mettre dans le coffre du véhicule", nil, {RightLabel = "→"},not cooldown, function(Hovered, Active, Selected)
						if (Selected) then
							cooldowncool(1000)
							local playerPed = PlayerPedId()
							local vehicle  = GetVehiclePedIsUsing(playerPed)
							local coords   = GetEntityCoords(playerPed)
							local coords2  = GetEntityCoords(ped)
							local distance = GetDistanceBetweenCoords(coords, coords2, true)

							if not isInVehicle then
								if IsPedSittingInAnyVehicle(playerPed) then
									if distance < 8 then
										attached()
										Citizen.Wait(200)
										if IsVehicleSeatFree(vehicle, 1) then
											SetPedIntoVehicle(ped, vehicle, 1)
											isInVehicle = true
										elseif IsVehicleSeatFree(vehicle, 2) then
											isInVehicle = true
											SetPedIntoVehicle(ped, vehicle, 2)
										elseif IsVehicleSeatFree(vehicle, 0) then
											isInVehicle = true
											SetPedIntoVehicle(ped, vehicle, 0)
										end

									else
										ESX.ShowNotification("<C>~r~Votre animal est trop loin du véhicule ! ~s~")
									end

								else
									ESX.ShowNotification("<C>Vous devez être dans un vehicule !")
								end
							else
								if not IsPedSittingInAnyVehicle(playerPed) then
									SetEntityCoords(ped, coords,1,0,0,1)
									Citizen.Wait(100)
									detached()
									isInVehicle = false

								else
									ESX.ShowNotification("<C>Vous êtes toujours dans un véhicule")
								end
							end
						end
					end)
				end

				RageUI.ButtonWithStyle("Donner un ordre", nil, {RightLabel = "→"},not cooldown, function(Hovered, Active, Selected)
                    if (Selected) then
						GivePetOrders()
                        RageUI.CloseAll()
                    end
                end)
				
			end
        end)

        if not RageUI.Visible(MenuA) then
            MenuA = RMenu:DeleteType("MenuA", true)
        end
    end
end

function GivePetOrders()
    local PetOrdre = RageUI.CreateMenu("Animal", "Ordre")
	ESX.TriggerServerCallback('rAnimalerie:getPet', function(pet)
    RageUI.Visible(PetOrdre, not RageUI.Visible(PetOrdre))
        while PetOrdre do
            Citizen.Wait(0)
                RageUI.IsVisible(PetOrdre, true, true, true, function()

					if not inanimation then
					if pet ~= 'chat' then
						RageUI.ButtonWithStyle("Aller chercher la balle", nil, {RightLabel = "→"}, not cooldown, function(Hovered, Active, Selected)
							if (Selected) then
								cooldowncool(1000)
								local pedCoords = GetEntityCoords(ped)
								object = GetClosestObjectOfType(pedCoords, 190.0, GetHashKey('w_am_baseball'))
								if DoesEntityExist(object) then
									balle = true
									objCoords = GetEntityCoords(object)
									TaskGoToCoordAnyMeans(ped, objCoords, 5.0, 0, 0, 786603, 0xbf800000)
									local GroupHandle = GetPlayerGroup(PlayerId())
									SetGroupSeparationRange(GroupHandle, 1.9)
									SetPedNeverLeavesGroup(ped, false)
									RageUI.CloseAll()
								else
									ESX.ShowNotification("<C>~r~Aucune balle à proximité !")
								end
							end
						end)
					end

					RageUI.ButtonWithStyle("Venir au pied", nil, {RightLabel = "→"},not cooldown, function(Hovered, Active, Selected)
						if (Selected) then
							cooldowncool(1000)
							local coords = GetEntityCoords(PlayerPedId())
				            TaskGoToCoordAnyMeans(ped, coords, 5.0, 0, 0, 786603, 0xbf800000)
							RageUI.CloseAll()
						end
					end)

					RageUI.ButtonWithStyle("Mettre dans la niche", nil, {RightLabel = "→"},not cooldown, function(Hovered, Active, Selected)
						if (Selected) then
							cooldowncool(1000)
							local GroupHandle = GetPlayerGroup(PlayerId())
							local coords      = GetEntityCoords(PlayerPedId())
			
							ESX.ShowNotification("<C>~g~Vous avez mis votre animal dans la niche !")
			
							SetGroupSeparationRange(GroupHandle, 1.9)
							SetPedNeverLeavesGroup(ped, false)
							TaskGoToCoordAnyMeans(ped, coords.x + 40, coords.y, coords.z, 5.0, 0, 0, 786603, 0xbf800000)
			
							Citizen.Wait(5000)
							DeleteEntity(ped)
							come = false
							RageUI.CloseAll()
						end
					end)

					if pet == 'chien' then

						RageUI.ButtonWithStyle("Assis", nil, {RightLabel = "→"},not cooldown, function(Hovered, Active, Selected)
							if (Selected) then
								cooldowncool(1000)
								DoRequestAnimSet('creatures@rottweiler@amb@world_dog_sitting@base')
				                TaskPlayAnim(ped, 'creatures@rottweiler@amb@world_dog_sitting@base', 'base' ,8.0, -8, -1, 1, 0, false, false, false)
				                inanimation = true
								RageUI.CloseAll()
							end
						end)

						RageUI.ButtonWithStyle("Coucher", nil, {RightLabel = "→"},not cooldown, function(Hovered, Active, Selected)
							if (Selected) then
								cooldowncool(1000)
								DoRequestAnimSet('creatures@rottweiler@amb@sleep_in_kennel@')
				                TaskPlayAnim(ped, 'creatures@rottweiler@amb@sleep_in_kennel@', 'sleep_in_kennel' ,8.0, -8, -1, 1, 0, false, false, false)
				                inanimation = true
								RageUI.CloseAll()
							end
						end)

					elseif pet == 'chat' then

						RageUI.ButtonWithStyle("Coucher", nil, {RightLabel = "→"},not cooldown, function(Hovered, Active, Selected)
							if (Selected) then
								cooldowncool(1000)
								DoRequestAnimSet('creatures@cat@amb@world_cat_sleeping_ground@idle_a')
				                TaskPlayAnim(ped, 'creatures@cat@amb@world_cat_sleeping_ground@idle_a', 'idle_a' ,8.0, -8, -1, 1, 0, false, false, false)
				                inanimation = true
								RageUI.CloseAll()
							end
						end)


					elseif pet == 'loup' then

						RageUI.ButtonWithStyle("Coucher", nil, {RightLabel = "→"},not cooldown, function(Hovered, Active, Selected)
							if (Selected) then
								cooldowncool(1000)
								DoRequestAnimSet('creatures@coyote@amb@world_coyote_rest@idle_a')
				                TaskPlayAnim(ped, 'creatures@coyote@amb@world_coyote_rest@idle_a', 'idle_a' ,8.0, -8, -1, 1, 0, false, false, false)
				                inanimation = true
								RageUI.CloseAll()
							end
						end)

					elseif pet == 'carlin' then


						RageUI.ButtonWithStyle("Assis", nil, {RightLabel = "→"},not cooldown, function(Hovered, Active, Selected)
							if (Selected) then
								cooldowncool(1000)
								DoRequestAnimSet('creatures@carlin@amb@world_dog_sitting@idle_a')
				                TaskPlayAnim(ped, 'creatures@carlin@amb@world_dog_sitting@idle_a', 'idle_b' ,8.0, -8, -1, 1, 0, false, false, false)
				                inanimation = true
								RageUI.CloseAll()
							end
						end)

					elseif pet == 'retriever' then


						RageUI.ButtonWithStyle("Assis", nil, {RightLabel = "→"},not cooldown, function(Hovered, Active, Selected)
							if (Selected) then
								cooldowncool(1000)
								DoRequestAnimSet('creatures@retriever@amb@world_dog_sitting@idle_a')
				                TaskPlayAnim(ped, 'creatures@retriever@amb@world_dog_sitting@idle_a', 'idle_c' ,8.0, -8, -1, 1, 0, false, false, false)
				                inanimation = true
								RageUI.CloseAll()
							end
						end)

					elseif pet == 'rottweiler' then


						RageUI.ButtonWithStyle("Assis", nil, {RightLabel = "→"},not cooldown, function(Hovered, Active, Selected)
							if (Selected) then
								cooldowncool(1000)
								DoRequestAnimSet('creatures@rottweiler@amb@world_dog_sitting@idle_a')
				                TaskPlayAnim(ped, 'creatures@rottweiler@amb@world_dog_sitting@idle_a', 'idle_c' ,8.0, -8, -1, 1, 0, false, false, false)
				                inanimation = true
								RageUI.CloseAll()
							end
						end)

					end

				else

					RageUI.ButtonWithStyle("Debout", nil, {RightLabel = "→"},not cooldown, function(Hovered, Active, Selected)
						if (Selected) then
							cooldowncool(1000)
							ClearPedTasks(ped)
				            inanimation = false
							RageUI.CloseAll()
						end
					end)

				end

                end, function()
                end)
            if not RageUI.Visible(PetOrdre) then
            PetOrdre = RMenu:DeleteType("PetOrdre", true)
        end
    end
end)
end




function attached()
	local GroupHandle = GetPlayerGroup(PlayerId())
	SetGroupSeparationRange(GroupHandle, 1.9)
	SetPedNeverLeavesGroup(ped, false)
	FreezeEntityPosition(ped, true)
end

function detached()
	local GroupHandle = GetPlayerGroup(PlayerId())
	SetGroupSeparationRange(GroupHandle, 999999.9)
	SetPedNeverLeavesGroup(ped, true)
	SetPedAsGroupMember(ped, GroupHandle)
	FreezeEntityPosition(ped, false)
end

function openchien()
	local playerPed = PlayerPedId()
	local LastPosition = GetEntityCoords(playerPed)
	local GroupHandle = GetPlayerGroup(PlayerId())

	DoRequestAnimSet('rcmnigel1c')

	TaskPlayAnim(playerPed, 'rcmnigel1c', 'hailing_whistle_waive_a' ,8.0, -8, -1, 120, 0, false, false, false)

	Citizen.SetTimeout(5000, function()
		ped = CreatePed(28, model, LastPosition.x +1, LastPosition.y +1, LastPosition.z -1, 1, 1)

		SetPedAsGroupLeader(playerPed, GroupHandle)
		SetPedAsGroupMember(ped, GroupHandle)
		SetPedNeverLeavesGroup(ped, true)
		SetPedCanBeTargetted(ped, false)
		SetEntityAsMissionEntity(ped, true,true)
		Citizen.Wait(5)
		attached()
		Citizen.Wait(5)
		detached()
	end)
end

function DoRequestAnimSet(anim)
	RequestAnimDict(anim)
	while not HasAnimDictLoaded(anim) do
		Citizen.Wait(1)
	end
end

function DoRequestModel(model)
	RequestModel(model)
	while not HasModelLoaded(model) do
		Citizen.Wait(1)
	end
end


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(30)

		if balle then
			local coords1 = GetEntityCoords(PlayerPedId())
			local coords2 = GetEntityCoords(ped)
			local distance  = GetDistanceBetweenCoords(objCoords, coords2, true)
			local distance2 = GetDistanceBetweenCoords(coords1, coords2, true)

			if distance < 0.5 then
				local boneIndex = GetPedBoneIndex(ped, 17188)
				AttachEntityToEntity(object, ped, boneIndex, 0.120, 0.010, 0.010, 5.0, 150.0, 0.0, true, true, false, true, 1, true)
				TaskGoToCoordAnyMeans(ped, coords1, 5.0, 0, 0, 786603, 0xbf800000)
				balle = false
				getball = true
			end
		end

		if getball then
			local coords1 = GetEntityCoords(PlayerPedId())
			local coords2 = GetEntityCoords(ped)
			local distance2 = GetDistanceBetweenCoords(coords1, coords2, true)

			if distance2 < 1.5 then
				DetachEntity(object,false,false)
				Citizen.Wait(50)
				SetEntityAsMissionEntity(object)
				DeleteEntity(object)
				GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_BALL"), 1, false, true)
				local GroupHandle = GetPlayerGroup(PlayerId())
				SetGroupSeparationRange(GroupHandle, 999999.9)
				SetPedNeverLeavesGroup(ped, true)
				SetPedAsGroupMember(ped, GroupHandle)
				getball = false
			end
		end
	end
end)


function MenuCoffreAnimalerie()
    local MCoffre = RageUI.CreateMenu("Coffre", "~b~Interaction")
        RageUI.Visible(MCoffre, not RageUI.Visible(MCoffre))
            while MCoffre do
            Citizen.Wait(0)
            RageUI.IsVisible(MCoffre, true, true, true, function()

				RageUI.Separator("↓ ~b~Gestion des stocks~s~ ↓")

                RageUI.ButtonWithStyle("Prendre objets",nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        CoffreRetirer()
                        RageUI.GoBack()
                    end
                end)
                
                RageUI.ButtonWithStyle("Déposer objets",nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        CoffreDeposer()
                        RageUI.GoBack()
                    end
                end)

                end, function()
                end)
            if not RageUI.Visible(MCoffre) then
				MCoffre = RMenu:DeleteType("Coffre", true)
        end
    end
end

itemstock = {}
function CoffreRetirer()
    local StockCoffre = RageUI.CreateMenu("Coffre", "~b~Retirer")
    ESX.TriggerServerCallback('rAnimalerie:getStockItems', function(items) 
    itemstock = items
    RageUI.Visible(StockCoffre, not RageUI.Visible(StockCoffre))
        while StockCoffre do
            Citizen.Wait(0)
                RageUI.IsVisible(StockCoffre, true, true, true, function()
                        for k,v in pairs(itemstock) do 
                            if v.count > 0 then
                            RageUI.ButtonWithStyle("~r~→~s~ "..v.label, nil, {RightLabel = v.count}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    local cbRetirer = rAnimalerieKeyboardInput("Combien ?", "", 15)
                                    TriggerServerEvent('rAnimalerie:getStockItem', v.name, tonumber(cbRetirer), societe)
                                    CoffreRetirer()
                                end
                            end)
                        end
                    end
                end, function()
                end)
            if not RageUI.Visible(StockCoffre) then
            StockCoffre = RMenu:DeleteType("Coffre", true)
        end
    end
    end)
end

function CoffreDeposer()
    local StockPlayer = RageUI.CreateMenu("Coffre", "~b~Déposer")
    ESX.TriggerServerCallback('rAnimalerie:getPlayerInventory', function(inventory)
        RageUI.Visible(StockPlayer, not RageUI.Visible(StockPlayer))
    while StockPlayer do
        Citizen.Wait(0)
            RageUI.IsVisible(StockPlayer, true, true, true, function()
                for i=1, #inventory.items, 1 do
                    if inventory ~= nil then
                         local item = inventory.items[i]
                            if item.count > 0 then
                                        RageUI.ButtonWithStyle("~r~→~s~ "..item.label, nil, {RightLabel = item.count}, true, function(Hovered, Active, Selected)
                                            if Selected then
                                            local cbDeposer = rAnimalerieKeyboardInput("Combien ?", '' , 15)
                                            TriggerServerEvent('rAnimalerie:putStockItems', item.name, tonumber(cbDeposer), societe)
                                            CoffreDeposer()
                                        end
                                    end)
                            end
                    end
                end
                    end, function()
                    end)
                if not RageUI.Visible(StockPlayer) then
                StockPlayer = RMenu:DeleteType("Coffre", true)
            end
        end
    end)
end


Citizen.CreateThread(function()
    while true do
        local Timer = 500
		if ESX.PlayerData.job and ESX.PlayerData.job.name == Config.JobName or ESX.PlayerData.job2 and ESX.PlayerData.job2.name == Config.JobName then  
		local plyPos = GetEntityCoords(PlayerPedId())
		local dist = #(plyPos-Config.Pos.MenuCoffre)
        if dist <= Config.Marker.DrawDistance then
            Timer = 0
			DrawMarker(Config.Marker.Type, Config.Pos.MenuCoffre, nil, nil, nil, -90, nil, nil, Config.Marker.Size.x, Config.Marker.Size.y, Config.Marker.Size.z, Config.Marker.Color.R, Config.Marker.Color.G, Config.Marker.Color.B, 200)
            end
                if dist <= Config.Marker.DrawInteract then
                Timer = 0   
					RageUI.Text({ message = "Appuyez sur ~b~[E]~s~ pour ouvrir →→ ~b~Coffre", time_display = 1 })
                    if IsControlJustPressed(1,51) then           
						MenuCoffreAnimalerie()
                    end
                end
            end
        Citizen.Wait(Timer)
     end
end)

local societypolicemoney = nil

function MenuBossAnimalerie()
  local Mboss = RageUI.CreateMenu("Actions Patron", "~b~Animalerie")

    RageUI.Visible(Mboss, not RageUI.Visible(Mboss))

            while Mboss do
                Citizen.Wait(0)
                    RageUI.IsVisible(Mboss, true, true, true, function()

					if societypolicemoney ~= nil then
						RageUI.Separator("~b~Argent société : ~s~"..societypolicemoney.."$")
					end

                    RageUI.ButtonWithStyle("Retirer de l'argent",nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local amount = rAnimalerieKeyboardInput("Montant", "", 10)
                            amount = tonumber(amount)
                            if amount == nil then
                                RageUI.Popup({message = "Montant invalide"})
                            else
								TriggerServerEvent("rAnimalerie:withdrawMoney", amount)
                                RefreshAnimalerieMoney()
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Déposer de l'argent",nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local amount = rAnimalerieKeyboardInput("Montant", "", 10)
                            amount = tonumber(amount)
                            if amount == nil then
                                RageUI.Popup({message = "Montant invalide"})
                            else
								TriggerServerEvent("rAnimalerie:depositMoney", amount)
                                RefreshAnimalerieMoney()
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Accéder aux actions de Management",nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            AbossAnimalerie()
                            RageUI.CloseAll()
                        end
                    end)
                end, function()
            end)
            if not RageUI.Visible(Mboss) then
            Mboss = RMenu:DeleteType("Mboss", true)
        end
    end
end   

function RefreshpoliceMoney()
    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
        ESX.TriggerServerCallback('five_society:getSocietyMoney', function(money)
            UpdateSocietypoliceMoney(money)
        end, ESX.PlayerData.job.name)
    end
end

function UpdateSocietypoliceMoney(money)
    societypolicemoney = ESX.Math.GroupDigits(money)
end

if Config.ESXSociety then
	function AbossAnimalerie()
		TriggerEvent("esx_society:openBossMenu", Config.JobName, function(data, menu)
			menu.close()
		end, {wash = false})
	end
end

if not Config.ESXSociety then
	function AbossAnimalerie()
		TriggerEvent(Config.TriggerOpenBoss)
	end
end

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        if ESX.PlayerData.job and ESX.PlayerData.job.name == Config.JobName and ESX.PlayerData.job.grade_name == 'boss' or ESX.PlayerData.job2 and ESX.PlayerData.job2.name == Config.JobName and ESX.PlayerData.job2.grade_name == 'boss' then 
        local plyPos = GetEntityCoords(PlayerPedId())
        local dist3 = #(plyPos-Config.Pos.Boss)
        if dist3 <= Config.Marker.DrawDistance then
            Timer = 0
			DrawMarker(Config.Marker.Type, Config.Pos.Boss, nil, nil, nil, -90, nil, nil, Config.Marker.Size.x, Config.Marker.Size.y, Config.Marker.Size.z, Config.Marker.Color.R, Config.Marker.Color.G, Config.Marker.Color.B, 200)
            end
                if dist3 <= Config.Marker.DrawInteract then
                Timer = 0   
                RageUI.Text({ message = "Appuyez sur ~b~[E]~s~ pour ouvrir →→ ~b~Action patron", time_display = 1 })
                    if IsControlJustPressed(1,51) then
						RefreshpoliceMoney()
						MenuBossAnimalerie()
                    end
                end
            end
        Citizen.Wait(Timer)
     end
end)


Keys.Register(Config.OpenGestionAnimal, 'Animalerie', 'Open gestion pets', function()
	MenuGestAnimal()
end)


function cooldowncool(time)
	cooldown = true
	Citizen.SetTimeout(time,function()
		cooldown = false
	end)
end


Citizen.CreateThread(function()
    while true do
        local Timer = 500
        local plyPos = GetEntityCoords(PlayerPedId())
        local dist = #(plyPos-Config.Pos.DeleteVeh)
		if IsPedSittingInAnyVehicle(PlayerPedId()) then
        if ESX.PlayerData.job and ESX.PlayerData.job.name == Config.JobName then
			if dist <= Config.Marker.DrawDistance then
			Timer = 0
			DrawMarker(Config.Marker.Type, Config.Pos.DeleteVeh, nil, nil, nil, -90, nil, nil, Config.Marker.Size.x, Config.Marker.Size.y, Config.Marker.Size.z, Config.Marker.Color.R, Config.Marker.Color.G, Config.Marker.Color.B, 200)
			end
			if dist <= Config.Marker.DrawInteract then
				Timer = 0
					RageUI.Text({ message = "Appuyez sur ~b~[E]~s~ pour ranger votre véhicule", time_display = 1 })
				if IsControlJustPressed(1,51) then
					local veh,dist4 = ESX.Game.GetClosestVehicle(playerCoords)
						if dist4 < 5 then
							DeleteEntity(veh)
							ESX.ShowNotification("<C>~g~Véhicule ranger avec succès")
						end 
            		end
         		end
        	end
		end
    	Citizen.Wait(Timer)
 	end
end)

function OpenGarage()
	local garageanim = RageUI.CreateMenu("Garage", "~b~Animalerie", Config.MenuPositionX, Config.MenuPositionY)
	RageUI.Visible(garageanim, not RageUI.Visible(garageanim))
		while garageanim do
		Citizen.Wait(0)
		RageUI.IsVisible(garageanim, true, true, true, function()

		RageUI.Separator("↓ ~b~Véhicule(s) disponible~s~ ↓")

			for k,v in pairs(Config.ListVeh) do
					RageUI.ButtonWithStyle(v.nom, nil, {RightLabel = "→"}, not cooldown, function(Hovered, Active, Selected)
					if (Selected) then
					Citizen.Wait(1)  
					SpawnCar(v.model)
					cooldowncool(3500)
					RageUI.CloseAll()
					end
				end)
			end 
            
		end, function() 
		end)

		if not RageUI.Visible(garageanim) then
			garageanim = RMenu:DeleteType(garageanim, true)
		end
	end
end

function SpawnCar(car)
    local car = GetHashKey(car)
    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(0)
    end
    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local vehicle = CreateVehicle(car, Config.Pos.SpawnVeh, Config.Pos.SpawnHeading, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
    SetPedIntoVehicle(GetPlayerPed(-1),vehicle,-1)
end

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        local plyPos = GetEntityCoords(PlayerPedId())
        local dist = #(plyPos-Config.Pos.Garage)
        if ESX.PlayerData.job and ESX.PlayerData.job.name == Config.JobName then
				if dist <= Config.Marker.DrawDistance then
				Timer = 0
				DrawMarker(Config.Marker.Type, Config.Pos.Garage, nil, nil, nil, -90, nil, nil, Config.Marker.Size.x, Config.Marker.Size.y, Config.Marker.Size.z, Config.Marker.Color.R, Config.Marker.Color.G, Config.Marker.Color.B, 200)
				end
				if dist <= Config.Marker.DrawInteract then
					Timer = 0
					RageUI.Text({ message = "Appuyez sur ~b~[E]~s~ pour ouvrir →→ ~b~Garage", time_display = 1 })
					if IsControlJustPressed(1,51) then
						OpenGarage()
					end
				end
			end
		Citizen.Wait(Timer)
	end
end)

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        local plyPos = GetEntityCoords(PlayerPedId())
        local dist = #(plyPos-Config.Pos.MenuVente)
        if ESX.PlayerData.job and ESX.PlayerData.job.name == Config.JobName then
        if dist <= Config.Marker.DrawDistance then
         Timer = 0
		 DrawMarker(6, Config.Pos.MenuVente, nil, nil, nil, -90, nil, nil, Config.Marker.Size.x, Config.Marker.Size.y, Config.Marker.Size.z, Config.Marker.Color.R, Config.Marker.Color.G, Config.Marker.Color.B, 200)
        end
         if dist <= Config.Marker.DrawInteract then
            Timer = 0
                RageUI.Text({ message = "Appuyez sur ~b~[E]~s~ pour ouvrir →→ ~b~Vente", time_display = 1 })
            if IsControlJustPressed(1,51) then
                MenuAnimalerieJob()
            end
         end
        end
    Citizen.Wait(Timer)
 end
end)