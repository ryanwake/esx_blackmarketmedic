ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(100)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

Citizen.CreateThread(function()
    for k,v in pairs(Config.Peds) do
        RequestModel(v.ped)
        while not HasModelLoaded(v.ped) do
            Wait(1)
        end

        local seller = CreatePed(1, v.ped, v.x, v.y, v.z, v.h, false, true)
        SetBlockingOfNonTemporaryEvents(seller, true)
        SetPedDiesWhenInjured(seller, false)
        SetPedCanPlayAmbientAnims(seller, true)
        SetPedCanRagdollFromPlayerImpact(seller, false)
        SetEntityInvincible(seller, true)
        FreezeEntityPosition(seller, true)
        TaskStartScenarioInPlace(seller, "WORLD_HUMAN_CLIPBOARD", 0, true)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if Config.ShowMarkers then
            local coords = GetEntityCoords(GetPlayerPed(-1))
            
            for k,v in pairs(Config.Markers) do
                if GetDistanceBetweenCoords(coords, v.coords, true) < Config.DrawDistance then
                    DrawMarker(Config.MarkerType, v.coords, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.ZoneSize.x, Config.ZoneSize.y, Config.ZoneSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		if GetDistanceBetweenCoords(coords, Config.Markers.Doctor.coords, true) < 2 then
            ESX.ShowHelpNotification("Press ~INPUT_CONTEXT~ to have the doctor treat your friend ($25,000 dirty money)")

            if IsControlJustReleased(0, 38) then
                BlackMarketRevive()
            end
		else
			Citizen.Wait(3000)
		end
	end
end)

function BlackMarketRevive() 
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    local closestPlayerPed = GetPlayerPed(closestPlayer)
    print(closestPlayerPed)
    if IsPedDeadOrDying(closestPlayerPed, 1) then
        local playerPed = PlayerPedId()

        ESX.ShowNotification('The doctor is working.')
        TriggerServerEvent('BlackMarketMedic:withdraw', GetPlayerServerId(closestPlayer))
    else
        ESX.ShowNotification('There is no one unconscious nearby.')
    end
end