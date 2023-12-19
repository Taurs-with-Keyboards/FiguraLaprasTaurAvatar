-- Models setup
local pokeball = models.PokeBall
local lapras   = models.LaprasTaur

-- Animation setup
local anim = animations.PokeBall

-- Variables
local isInBall  = false
local wasInBall
local toggle    = false
local vehicle   = require("scripts.Vehicles")
local scaleCurrent, scaleNextTick, scaleTarget, scaleCurrentPos = 1,1,1,1
function events.TICK()
  -- Pokeball check
  isInBall = toggle or vehicle.minecart or vehicle.horse or vehicle.pig or vehicle.strider or vehicle.isPassenger
  
  -- Model visibility
  pokeball:setVisible(lapras:getScale():length() < 1)
  
  -- Compare states
  if isInBall ~= wasInBall then
    -- Pokeball sounds
    if isInBall     and player:isLoaded() then sounds:stopSound() sounds:playSound("cobblemon:poke_ball.recall", player:getPos(), 0.15) end
    if not isInBall and player:isLoaded() then sounds:stopSound() sounds:playSound("cobblemon:poke_ball.send_out", player:getPos(), 0.15) end
    
    -- Animations
    anim.open:setPlaying(not isInBall)
    anim.close:setPlaying(isInBall)
  end
  
  -- Model changes
  pokeball:setPos(vehicle.vehicle and vec(0, 14, 0) or 0)
    :setRot(vehicle.vehicle and vec(30, 0, 0) or vec(15, 0, 0))
  
  -- Scaling lerp
  scaleCurrent  = scaleNextTick
  scaleNextTick = math.lerp(scaleNextTick, scaleTarget, 0.2)
  
  -- Store previous state
  wasInBall = isInBall
  
  toggle = toggle and player:getVelocity().xz:length() == 0
end

-- Scaling
function events.RENDER(delta, context)
  if context == "RENDER" or context == "FIRST_PERSON" or not client.isHudEnabled() then
    -- Target and lerp
    scaleTarget     = isInBall and 0 or 1
    scaleCurrentPos = math.lerp(scaleCurrent, scaleNextTick, delta)
    
    -- Set scale
    lapras:scale(scaleCurrentPos)
    renderer:setShadowRadius(math.map(scaleCurrentPos, 0, 1, 0.2, 1.25))
  end
end

-- Pokeball toggler
local function setPokeball(x)
  toggle = x and player:getVelocity().xz:length() == 0
end

-- Ping setup
pings.setPokeball = setPokeball

-- Return action wheel page
return action_wheel:newAction()
  :title("Activate Pokeball\n\nLeft click activates, Right click disables.\nHorizontal movement will decativate it. Auto activates/deactivates on vehicles.")
  :hoverColor(vectors.hexToRGB("5EB7DD"))
  :texture(textures["textures.misc.dive_ball_icon"])
  :onLeftClick(function() pings.setPokeball(true) end)
  :onRightClick(function() pings.setPokeball(false) end)