-- Model setup
local model     = models.LaprasTaur
local modelEyes = model.Player.UpperBody.Head.Eyes

-- Variables
local config          = require("Config")
local glowingEyes     = config.glowingEyes
local waterOnly       = config.waterOnly

if glowingEyes == nil then
  
  -- Origins and Night Vision
  local getPowerData    = require("lib.OriginsAPI").getPowerData
  local syncedVariables = require("scripts.SyncedVariables")
  function events.TICK()
    local glow = syncedVariables.nV or (getPowerData(player, "origins:water_vision") == 1 and not (waterOnly and not player:isUnderwater()))
    modelEyes:setSecondaryRenderType(glow and "EYES" or "NONE")
  end
  
else
  
  -- Glowing eyes toggler
  function setEyeRenderType(boolean)
    glowingEyes = boolean
  end
  
  -- Ping setup
  pings.setEyeRenderType = setEyeRenderType
  
  -- Action wheel based toggle
  function events.TICK()
    local glow = glowingEyes and not (waterOnly and not player:isUnderwater())
    modelEyes:setSecondaryRenderType(glow and "EYES" or "NONE")
  end
  
  -- Action wheel
  return action_wheel:newAction()
      :title("Toggle Glowing Eyes")
      :hoverColor(vectors.hexToRGB("5EB7DD"))
      :toggleColor(vectors.hexToRGB("4078B0"))
      :item("minecraft:ender_pearl")
      :toggleItem("minecraft:ender_eye")
      :onToggle(pings.setEyeRenderType)
      :toggled(glowingEyes)
end
