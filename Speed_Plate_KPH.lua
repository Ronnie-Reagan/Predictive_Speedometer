-- Plate Speed
speeds = {}  -- List to hold past speed values
maxDataPoints = 5  -- Number of past data points to consider for weighted moving average
mode = 2.23694         --3.6 for MPH or 2.23694 for KPH

local function getWeightedAverage(t)
    local weightedSum = 0
    local totalWeights = 0

    for i, v in ipairs(t) do
        weightedSum = weightedSum + v * i
        totalWeights = totalWeights + i
    end

    return weightedSum / totalWeights
end

local function getCurrentSpeed(veh)
    local velocity = veh:get_velocity()
    local speedms = math.sqrt(velocity.x^2 + velocity.y^2 + velocity.z^2)
    return speedms
end

local speedometerActive = true  -- Variable to track if the speedometer is active

function OnScriptsLoaded()
    while true do
        if speedometerActive and localplayer and localplayer:is_in_vehicle() then
            veh = localplayer:get_current_vehicle()
            local currentSpeed = getCurrentSpeed(veh)
    
            table.insert(speeds, currentSpeed)
            if #speeds > maxDataPoints then
                table.remove(speeds, 1)  -- Remove the oldest speed value
            end
            predictedSpeed = getWeightedAverage(speeds)
            displayedSpeed = math.floor(predictedSpeed * mode)
    
            if sharedVariable == "Script1" then
                veh:set_number_plate_text(tostring(displayedSpeed))
                sharedVariable = "Script2"  -- Signal to Script2 to wait
            else
                sharedVariable = "Script1"  -- Signal to Script1 to wait
            end
    
            sleep(0.01)  -- Sleep for a moment to give the other script a chance to run
        else
            sleep(0.01)  -- Sleep briefly when not in a vehicle or when the speedometer is not active
        end
    end
end
menu.register_callback('OnScriptsLoaded', OnScriptsLoaded)