-- Variable setup
local spawnBubbles = require("Config").whirlPoolEffect

-- Bubble spawner
local numBubbles = 8
function events.TICK()
  if player:getPose() == "SWIMMING" and spawnBubbles and player:isInWater() then
    local worldMatrix = models:partToWorldMatrix()
    for i = 1, numBubbles do
      particles:newParticle("minecraft:bubble",
        (worldMatrix * matrices.rotation4(0, world.getTime() * 10 - 360/numBubbles * i)):apply(25, 25)
      )
    end
  end
end

if spawnBubbles == nil then
  
  -- Dolphin's grace
  local syncedVariables = require("scripts.SyncedVariables")
  function events.TICK()
    spawnBubbles = syncedVariables.dG
  end
  
else
  
  -- Bubbles toggle
  function setBubbles(boolean)
    spawnBubbles = boolean
    if player:isLoaded() then
      sounds:playSound("minecraft:block.bubble_column.upwards_inside", player:getPos(), 0.25)
    end
  end
  
  -- Ping setup
  pings.setBubbles = setBubbles
  
  -- Action wheel
  return action_wheel:newAction()
      :title("Toggle Whirlpool Effect")
      :hoverColor(vectors.hexToRGB("5EB7DD"))
      :toggleColor(vectors.hexToRGB("4078B0"))
      :item("minecraft:glass_bottle")
      :toggleItem("minecraft:potion{\"CustomPotionColor\":" .. tostring(0x5EB7DD) .. "}")
      :onToggle(pings.setBubbles)
      :toggled(spawnBubbles)
end