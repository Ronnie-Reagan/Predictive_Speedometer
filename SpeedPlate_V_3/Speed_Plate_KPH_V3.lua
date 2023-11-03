-- Speed Plate V3 KPH

--DACANADACANADACANADACANADACANADACANADACANADACANADACANADACANADACANAD
--ACANADACANADACAN                                   NADACANADACANADA
--CANADACANADACANA                 A                 ADACANADACANADAC
--ANADACANADACANAD                ADA                DACANADACANADACA
--NADACANADACANADA           AC  ADACA  DA           ACANADACANADACAN
--ADACANADACANADAC            ANADACANADA            CANADACANADACANA
--DACANADACANADACA        DA   ADACANADA   AD        ANADACANADACANAD
--ACANADACANADACAN    ANADACAN  ACANADA  NADACANA    NADACANADACANADA
--CANADACANADACANA     ADACANADACANADACANADACANA     ADACANADACANADAC
--ANADACANADACANAD   NADACANADACANADACANADACANADAC   DACANADACANADACA
--NADACANADACANADA      CANADACANADACANADACANAD      ACANADACANADACAN
--ADACANADACANADAC         DACANADACANADACAN         CANADACANADACANA
--DACANADACANADACA           ANADACANADACA           ANADACANADACANAD
--ACANADACANADACAN         CANADACANADACANAD         NADACANADACANADA
--CANADACANADACANA                 A                 ADACANADACANADAC
--ANADACANADACANAD                 D                 DACANADACANADACA
--NADACANADACANADA                 A                 ACANADACANADACAN
--ADACANADACANADAC                                   CANADACANADACANA
--DACANADACANADACANADACANADACANADACANADACANADACANADACANADACANADACANAD
--
--Love From Canada.
speeds = {}
maxDataPoints = 5
mode = 3.6
modeStr = "KPH"

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

function OnScriptsLoaded()
    while true do
        if localplayer and localplayer:is_in_vehicle() then
            local veh = localplayer:get_current_vehicle()
            local currentSpeed = getCurrentSpeed(veh)

            table.insert(speeds, currentSpeed)
            if #speeds > maxDataPoints then
                table.remove(speeds, 1)
            end
            local predictedSpeed = getWeightedAverage(speeds)
            local displayedSpeed = math.floor(predictedSpeed * mode)
            
            local speedStr = string.format("%3s", displayedSpeed > 0 and tostring(displayedSpeed) or "")
            local plateText = speedStr .. "  " .. modeStr
            veh:set_number_plate_text(plateText)
        end
    end
end

menu.register_callback('OnScriptsLoaded', OnScriptsLoaded)