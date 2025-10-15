local vehiclesWithBrake = {} -- track which vehicles have brake engaged

-- Notification helper
local function ShowNotification(msg)
    if Config.Notify then
        SetNotificationTextEntry("STRING")
        AddTextComponentString(msg)
        DrawNotification(false, false)
    end
end

local function mpsToMph(speed)
    return speed * 2.23694
end

-- Key detection thread (responsive)
Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) then
            local veh = GetVehiclePedIsIn(ped, false)
            local plate = GetVehicleNumberPlateText(veh)
            if vehiclesWithBrake[plate] == nil then vehiclesWithBrake[plate] = false end

            local speedMph = mpsToMph(GetEntitySpeed(veh))

            -- Auto-release brake if moving faster than threshold
            if vehiclesWithBrake[plate] and speedMph > Config.EngageSpeed then
                vehiclesWithBrake[plate] = false
                ShowNotification("Parking brake released automatically")
            end

            -- Toggle parking brake with G
            if IsControlJustReleased(0, Config.ParkingBrakeKey) then
                if speedMph <= Config.EngageSpeed then
                    vehiclesWithBrake[plate] = not vehiclesWithBrake[plate]
                    local status = vehiclesWithBrake[plate] and "engaged" or "released"
                    ShowNotification("Parking brake " .. status)
                else
                    ShowNotification("Speed too high to engage parking brake")
                end
            end
        end
        Citizen.Wait(0) -- run every frame for instant key press
    end
end)

-- Rolling thread (smooth forward movement when outside)
Citizen.CreateThread(function()
    while true do
        for vehPlate, engaged in pairs(vehiclesWithBrake) do
            if not engaged then
                local veh = nil
                for _, v in ipairs(GetGamePool("CVehicle")) do
                    if GetVehicleNumberPlateText(v) == vehPlate then
                        veh = v
                        break
                    end
                end

                if veh and DoesEntityExist(veh) and not IsEntityDead(veh) then
                    local vel = GetEntityVelocity(veh)
                    local forward = GetEntityForwardVector(veh)
                    local targetSpeed = Config.RollSpeed

                    -- Only apply if vehicle is nearly stopped
                    if math.abs(vel.x) < Config.RollTolerance and math.abs(vel.y) < Config.RollTolerance then
                        local newVelX = vel.x + forward.x * targetSpeed
                        local newVelY = vel.y + forward.y * targetSpeed
                        SetEntityVelocity(veh, newVelX, newVelY, vel.z)
                    end
                end
            end
        end
        Citizen.Wait(Config.CheckInterval)
    end
end)
