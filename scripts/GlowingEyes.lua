-- Model setup
local model     = models.LaprasTaur
local modelEyes = model.Player.UpperBody.Head.Eyes

-- Variables
local glowingEyes     = require("Config").glowingEyes
local syncedVariables = require("scripts.SyncedVariables")

-- Glowing eyes toggler
function setEyeRenderType(boolean)
  local type = boolean and "EYES" or "NONE"
  modelEyes:setSecondaryRenderType(type)
end

-- Ping setup
pings.setEyeRenderType = setEyeRenderType

if glowingEyes == nil then
  -- Origins based toggle
  local getPowerData = require("lib.OriginsAPI").getPowerData
  function events.TICK()
    modelEyes:setSecondaryRenderType((syncedVariables.nV or getPowerData(player, "origins:water_vision") == 1) and "EYES" or "NONE")
  end
else
  -- Action wheel based toggle
  modelEyes:setSecondaryRenderType(glowingEyes and "EYES" or "NONE")
  return action_wheel:newAction()
      :title("Toggle Glowing Eyes")
      :hoverColor(vectors.hexToRGB("5EB7DD"))
      :toggleColor(vectors.hexToRGB("4078B0"))
      :item("minecraft:ender_pearl")
      :toggleItem("minecraft:ender_eye")
      :onToggle(pings.setEyeRenderType)
      :toggled(glowingEyes)
end
