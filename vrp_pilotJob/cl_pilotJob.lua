local type = "private"
local collectedPassengers = false
local passengerCount = 0
local correctVehicle = true
local gotPlane = false
local deliveryPart1 = false
local deliveryPart2 = false
local completed = false
local plane

Citizen.CreateThread(function()
    local pos = Config.startJob
    while true do
        Wait(0)
        local playerPos = GetEntityCoords(PlayerPedId(), true)
        local distance = Vdist(playerPos.x, playerPos.y, playerPos.z, pos.x, pos.y, pos.z)
        DrawMarker(33, pos.x, pos.y, pos.z, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 0, 0, 255, 128, 1, 0, 2, 1, 0, 0, 0)

        if distance < 1 then
            SetNotificationTextEntry( "STRING" )
            AddTextComponentString("Press ~g~E~w~ to get your plane")
            DrawNotification( false, false )
            if IsControlJustReleased(0, 51) and not gotPlane then
                local chance = math.random(1,2)
                if chance == 1 then
                    type = "private"
                else
                    type = "commercial"
                end
                spawn_plane(type)

            elseif IsControlJustReleased(0, 51) and gotPlane then
                SetNotificationTextEntry( "STRING" )
                AddTextComponentString("Already got a plane out")
                DrawNotification( false, false )
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        local pos = Config.deletePlane
        local playerPos = GetEntityCoords(PlayerPedId(), true)
        local distance = Vdist(playerPos.x, playerPos.y, playerPos.z, pos.x, pos.y, pos.z)
        DrawMarker(27, pos.x, pos.y, pos.z, 0, 0, 0, 0, 0, 0, 30.0, 30.0, 30.0, 0, 0, 255, 128, 0, 0, 2, 0, 0, 0, 0)
        if distance < 50 then
            if IsControlJustReleased(0, 51) then
                SetEntityAsMissionEntity(plane, true, true)
                DeleteVehicle(plane)
                reset()
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do -- keeps checking for if you are in your plane and whether you've collected passengers or not
        Citizen.Wait(0)
        if gotPlane and not collectedPassengers then
            while true do
                Wait(0)
                local playerPos = GetEntityCoords(PlayerPedId(), true)
                for k, v in pairs(Config.pickupLocs) do
                    local pos = v
                    local distance = Vdist(playerPos.x, playerPos.y, playerPos.z, pos.x, pos.y, pos.z)
                    DrawMarker(27, pos.x, pos.y, pos.z, 0, 0, 0, 0, 0, 0, 30.0, 30.0, 30.0, 0, 0, 255, 128, 0, 0, 2, 0, 0, 0, 0)
                    if distance < 50 and not collectedPassengers then
                        --Citizen.Wait(1)
                        DrawMarker(27, pos.x, pos.y, pos.z, 0, 0, 0, 0, 0, 0, 30.0, 30.0, 30.0, 0, 0, 255, 128, 0, 0, 2, 0, 0, 0, 0)
                        SetNotificationTextEntry( "STRING" )
                        AddTextComponentString("Press ~g~E~w~ to pickup passengers")
                        DrawNotification( false, false )
                        if IsControlJustReleased(0, 51) and not collectedPassengers then
                            if type == "private" and correctVehicle then
                                while passengerCount <= 50 and distance < 50 do
                                    playerPos = GetEntityCoords(PlayerPedId(), true)
                                    distance = Vdist(playerPos.x, playerPos.y, playerPos.z, pos.x, pos.y, pos.z)
                                    Citizen.Wait(1000)
                                    passengerCount = passengerCount + 1
                                    SetNotificationTextEntry( "STRING" )
                                    AddTextComponentString("Boarding Passengers, Do Not Leave Until All Have Boarded")
                                    DrawNotification( false, false )
                                end
                                collectedPassengers = true
                                deliveryPart1 = true
                            elseif type == "commercial" and correctVehicle then
                                while passengerCount <= 100 and distance < 50 do
                                    playerPos = GetEntityCoords(PlayerPedId(), true)
                                    distance = Vdist(playerPos.x, playerPos.y, playerPos.z, pos.x, pos.y, pos.z)
                                    Citizen.Wait(1000)
                                    passengerCount = passengerCount + 1
                                    SetNotificationTextEntry( "STRING" )
                                    AddTextComponentString("Boarding Passengers, Do Not Leave Until All Have Boarded")
                                    DrawNotification( false, false )
                                end
                                collectedPassengers = true
                                deliveryPart1 = true
                            elseif not correctVehicle then
                                SetNotificationTextEntry( "STRING" )
                                AddTextComponentString("Not in your plane")
                                DrawNotification( false, false )
                            end
                        elseif IsControlJustReleased(0, 51) and collectedPassengers then
                            SetNotificationTextEntry( "STRING" )
                            AddTextComponentString("Your plane is full")
                            DrawNotification( false, false )
                        end
                        if collectedPassengers == true then
                            break
                        end
                    elseif distance > 50 and not collectedPassengers then
                        SetNotificationTextEntry( "STRING" )
                        AddTextComponentString("Pickup passengers from one of the boarding points")
                        DrawNotification( false, false )
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        TriggerServerEvent('pilotjob:checkVehicle', false)
    end
end)

Citizen.CreateThread(function()
    local blip
    local blip2
    while true do
        Citizen.Wait(5000)
        while gotPlane and collectedPassengers and deliveryPart1 and not deliveryPart2 do
            Citizen.Wait(0)
            SetNotificationTextEntry( "STRING" )
            AddTextComponentString("Deliver to the Military Base")
            DrawNotification( false, false )
            local pos = Config.deliveryLocs.One
            DrawMarker(27, pos.x, pos.y, pos.z, 0, 0, 0, 0, 0, 0, 30.0, 30.0, 30.0, 0, 0, 255, 128, 0, 0, 2, 0, 0, 0, 0)
            blip = AddBlipForCoord(pos.x, pos.y, pos.z)
            local playerPos = GetEntityCoords(PlayerPedId(), true)
            local distance = Vdist(playerPos.x, playerPos.y, playerPos.z, pos.x, pos.y, pos.z)

            if distance < 50 then
                SetNotificationTextEntry( "STRING" )
                AddTextComponentString("Press ~g~E~w~ to dropoff passengers")
                DrawNotification( false, false )
                if IsControlJustReleased(0, 51) and correctVehicle then
                    dropoff_passengers()
                elseif IsControlJustReleased(0, 51) and not correctVehicle then
                    SetNotificationTextEntry( "STRING" )
                    AddTextComponentString("Not your plane")
                    DrawNotification( false, false )
                end
            end
        end
        RemoveBlip(blip)
        while gotPlane and collectedPassengers and deliveryPart1 and deliveryPart2 and not completed do
            Citizen.Wait(0)
            SetNotificationTextEntry( "STRING" )
            AddTextComponentString("Deliver to the Sandy Airfield")
            DrawNotification( false, false )
            local pos = Config.deliveryLocs.Two
            DrawMarker(27, pos.x, pos.y, pos.z, 0, 0, 0, 0, 0, 0, 30.0, 30.0, 30.0, 0, 0, 255, 128, 0, 0, 2, 0, 0, 0, 0)
            blip2 = AddBlipForCoord(pos.x, pos.y, pos.z)
            local playerPos = GetEntityCoords(PlayerPedId(), true)
            local distance = Vdist(playerPos.x, playerPos.y, playerPos.z, pos.x, pos.y, pos.z)

            if distance < 50 then
                SetNotificationTextEntry( "STRING" )
                AddTextComponentString("Press ~g~E~w~ to dropoff passengers")
                DrawNotification( false, false )
                if IsControlJustReleased(0, 51) and correctVehicle then
                    dropoff_passengers()
                    RemoveBlip(blip)
                elseif IsControlJustReleased(0, 51) and not correctVehicle then
                    SetNotificationTextEntry( "STRING" )
                    AddTextComponentString("Not your plane")
                    DrawNotification( false, false )
                end
            end
        end
        RemoveBlip(blip)
        RemoveBlip(blip2)
    end
end)

RegisterNetEvent('pilotjob:checkVehicleResult')
AddEventHandler('pilotjob:checkVehicleResult', function(vehicleName, set)
    if set == true then
        vehicle = vehicleName
        print("set vehicle to "..vehicle)
    end
    if vehicleName == vehicle then
        correctVehicle = true
    end
end)

function reset()
    collectedPassengers = false
    passengerCount = 0
    correctVehicle = true
    gotPlane = false
    deliveryPart1 = false
    deliveryPart2 = false
    completed = false
end

function dropoff_passengers()
    if type == "private" and deliveryPart1 and not deliveryPart2 then
        while passengerCount >= 25 do
            passengerCount = passengerCount - 1
            TriggerServerEvent('pilotjob:receivePayment')
            Citizen.Wait(1000)
        end
        deliveryPart1 = true
        deliveryPart2 = true
    elseif type == "private" and deliveryPart1 and deliveryPart2 then
        while passengerCount > 0 do
            passengerCount = passengerCount - 1
            TriggerServerEvent('pilotjob:receivePayment')
            Citizen.Wait(1000)
        end
        SetNotificationTextEntry( "STRING" )
        AddTextComponentString("Job Completed")
        DrawNotification( false, false )
        reset()
        completed = true
    elseif type == "commercial" and deliveryPart1 and not deliveryPart2 then
        while passengerCount >= 50 do
            passengerCount = passengerCount - 1
            TriggerServerEvent('pilotjob:receivePayment')
            Citizen.Wait(1000)
        end
        deliveryPart1 = true
        deliveryPart2 = true
    elseif type == "commercial" and deliveryPart1 and deliveryPart2 then
        while passengerCount > 0 do
            passengerCount = passengerCount - 1
            TriggerServerEvent('pilotjob:receivePayment')
            Citizen.Wait(1000)
        end
        SetNotificationTextEntry( "STRING" )
        AddTextComponentString("Job Completed")
        DrawNotification( false, false )
        reset()
        completed = true
    end
end

function spawn_plane(type)
    local pos = Config.planeSpawn
    
    if type == "private" then
        local modelHash = GetHashKey(Config.privatePlane)
        while not HasModelLoaded(modelHash) do
            RequestModel(modelHash)
            Citizen.Wait(1000)
            print("loading model")
        end
        plane = CreateVehicle(modelHash, pos.x, pos.y, pos.z, pos.heading, true, false)
    else
        local modelHash = GetHashKey(Config.commercialPlane)
        while not HasModelLoaded(modelHash) do
            RequestModel(modelHash)
            Citizen.Wait(1000)
            print("loading model")
        end
        plane = CreateVehicle(modelHash, pos.x, pos.y, pos.z, pos.heading, true, false)
    end

    Citizen.Wait(1000)
    TaskWarpPedIntoVehicle(GetPlayerPed(-1), plane, -1)
    local id = NetworkGetNetworkIdFromEntity(plane)
    SetNetworkIdCanMigrate(id, true)
    SetModelAsNoLongerNeeded(modelHash)
    collectedPassengers = false
    gotPlane = true
    TriggerServerEvent('pilotjob:checkVehicle', true)

end