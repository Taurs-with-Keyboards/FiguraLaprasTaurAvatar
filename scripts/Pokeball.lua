-- Models setup
local pokeball = models.PokeBall
local lapras   = models.LaprasTaur

-- Animation setup
local anim = animations.PokeBall

-- Variables
local isInBall     = false
local wasInBall
local toggle       = false
local vehicle      = require("scripts.Vehicles")
local hasPower     = require("lib.OriginsAPI").hasPower
local scaleCurrent, scaleNextTick, scaleTarget, scaleCurrentPos = 1,1,1,1
function events.TICK()
  -- Pokeball check
  toggle = toggle and not player:isInWater()
  isInBall = ((toggle and not vehicle.isVehicle) or (not hasPower(player, "origins:lapras_dismount") and (vehicle.vehicle and not(vehicle.boat or vehicle.chest_boat) or vehicle.isPassenger))) or false
  
  -- Compare states
  if isInBall ~= wasInBall then
    -- Pokeball sounds
    if isInBall     and player:isLoaded() then sounds:stopSound() sounds:playSound("cobblemon:poke_ball.recall", player:getPos(), 0.15) end
    if not isInBall and player:isLoaded() then sounds:stopSound() sounds:playSound("cobblemon:poke_ball.send_out", player:getPos(), 0.15) end
    
    -- Animations
    anim.open:setPlaying(not isInBall)
    anim.close:setPlaying(isInBall)
  end
  
  -- Scaling lerp
  scaleCurrent  = scaleNextTick
  scaleNextTick = math.lerp(scaleNextTick, scaleTarget, 0.2)
  
  -- Store previous state
  wasInBall = isInBall
end

-- Rendering stuff
local basePos = vec(0, 0, 0)
function events.RENDER(delta, context)
  if context == "RENDER" or context == "FIRST_PERSON" or not client.isHudEnabled() then
    -- Vehicle pos table
    local statePos = {
      { state = vehicle.hasPassenger,  pos = 0  },
      { state = vehicle.boat,          pos = 10 },
      { state = vehicle.chest_boat,    pos = 0  }, -- This cant happen
      { state = vehicle.minecart,      pos = 9  },
      { state = vehicle.horse,         pos = 10 },
      { state = vehicle.donkey,        pos = 10 },
      { state = vehicle.mule,          pos = 10 },
      { state = vehicle.zombieHorse,   pos = 8  },
      { state = vehicle.skeletonHorse, pos = 11 },
      { state = vehicle.pig,           pos = 10 },
      { state = vehicle.strider,       pos = 10 },
      { state = vehicle.camel,         pos = 9  },
    }
    
    -- Base position check
    for _, case in ipairs(statePos) do
      if case.state then
        basePos = vec(0, case.pos, 0)
        break
      elseif vehicle.vehicle then
        -- Unsupported case
        basePos = vec(0, 10, 0)
      else
        basePos = 0
      end
    end
    
    -- Pokeball
    pokeball:setVisible(lapras:getScale():length() < 1)
      :setPos(basePos)
    lapras:setPos(basePos)
    
    -- Scaling target and lerp
    scaleTarget     = isInBall and 0 or 1
    scaleCurrentPos = math.lerp(scaleCurrent, scaleNextTick, delta)
    
    -- Set scale
    lapras:scale(scaleCurrentPos)
    renderer:setShadowRadius(math.map(scaleCurrentPos, 0, 1, 0.2, 1.25))
  end
end

-- Keybind blockers
local blocker   = function() return toggle and not host:isFlying() end
local kbForward = keybinds:newKeybind("Pokeball Forward Blocker"):onPress(blocker)
local kbBack    = keybinds:newKeybind("Pokeball Back Blocker"   ):onPress(blocker)
local kbRight   = keybinds:newKeybind("Pokeball Right Blocker"  ):onPress(blocker)
local kbLeft    = keybinds:newKeybind("Pokeball Left Blocker"   ):onPress(blocker)
local kbCrouch  = keybinds:newKeybind("Pokeball Crouch Blocker" ):onPress(blocker)
local kbAttack  = keybinds:newKeybind("Pokeball Attack Blocker" ):onPress(blocker)
local kbUse     = keybinds:newKeybind("Pokeball Use Blocker"    ):onPress(blocker)

function events.TICK()
  kbForward:setKey(keybinds:getVanillaKey("key.forward"))
  kbBack:setKey(keybinds:getVanillaKey("key.back"))
  kbRight:setKey(keybinds:getVanillaKey("key.right"))
  kbLeft:setKey(keybinds:getVanillaKey("key.left"))
  kbCrouch:setKey(keybinds:getVanillaKey("key.sneak"))
  kbAttack:setKey(keybinds:getVanillaKey("key.attack"))
  kbUse:setKey(keybinds:getVanillaKey("key.use"))
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