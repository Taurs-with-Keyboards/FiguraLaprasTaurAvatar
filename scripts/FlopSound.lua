-- Variables setup
local config  = require("Config")
local g       = require("scripts.GroundCheck")
local ticks   = require("scripts.WaterTicks")
local vehicle = require("scripts.Vehicles")

local landSound = config.landSound or false

-- Sound player
local wasInAir = false
function events.TICK()
  if landSound and wasInAir and g.ground and not vehicle.vehicle and not player:isInWater() then
    if models.PokeBall:getVisible() then
      sounds:playSound("cobblemon:poke_ball.hit", player:getPos(), 0.25)
    else
      local vel = player:getVelocity().y
      local volume = math.clamp((math.abs(-vel + 1) * ((config.waterTimer + -ticks.wet) / config.waterTimer)) / 2, 0, 1)
      if volume ~= 0 and player:isLoaded() then 
        sounds:playSound("minecraft:entity.puffer_fish.flop", player:getPos(), volume, 0.55)
      end
    end
  end
  wasInAir = not g.ground
end

-- Sound toggler
local function setFlopSound(boolean)
  landSound = boolean
  if player:isLoaded() then
    if landSound then
      if models.PokeBall:getVisible() then
        sounds:playSound("cobblemon:poke_ball.hit", player:getPos(), 0.5)
      else
        sounds:playSound("minecraft:entity.puffer_fish.flop", player:getPos(), 0.5)
      end
    end
  end
end

-- Setup ping
pings.setFlopSound = setFlopSound

-- Return action wheel page
setFlopSound(landSound)
return action_wheel:newAction()
  :title("Toggle Floping Sound\n\nGradually gets quieter over "..(config.waterTimer / 20).." second"..(config.waterTimer ~= 20 and "s" or "").." until it no longer\nmakes noise, unless the player reenters water or rain; resets.\n\nIf inside the pokeball, it will play another sound.")
  :hoverColor(vectors.hexToRGB("5EB7DD"))
  :toggleColor(vectors.hexToRGB("4078B0"))
  :item("minecraft:salmon")
  :toggleItem("minecraft:tropical_fish")
  :onToggle(pings.setFlopSound)
  :toggled(landSound)