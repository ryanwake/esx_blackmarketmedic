ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('BlackMarketMedic:withdraw')
AddEventHandler('BlackMarketMedic:withdraw', function(target)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	local accountMoney = 0
	accountMoney = xPlayer.getAccount('black_money').money
	if 25000 > accountMoney then
		TriggerClientEvent('esx:showNotification', _source, 'You cannot afford this.')
	else
		xPlayer.removeAccountMoney('black_money', 25000)
		TriggerClientEvent('esx_ambulancejob:revive', target)
		TriggerEvent('esx_ambulancejob:revive', source, target)
	end
end)