local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
 
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vrp_pilotJob")

RegisterServerEvent('pilotjob:checkVehicle')
AddEventHandler('pilotjob:checkVehicle', function(set)
    local _source = source
    vehicleName = GetVehiclePedIsIn(GetPlayerPed(_source), false)
    if set == true then
        TriggerClientEvent('pilotjob:checkVehicleResult', _source, vehicleName, true)
    else
        TriggerClientEvent('pilotjob:checkVehicleResult', _source, vehicleName, false)
    end
end)

RegisterServerEvent('pilotjob:receivePayment')
AddEventHandler('pilotjob:receivePayment', function()
    local _source = source
    local user_id = vRP.getUserId({_source})
    vRP.giveBankMoney({user_id, Config.payPerPassenger})
end)