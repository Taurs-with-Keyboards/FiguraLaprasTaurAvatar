-- Model setup
local model     = models.LaprasTaur
local modelRoot = model.Player

-- Arm setup
local leftArm  = modelRoot.UpperBody.LeftArm
local rightArm = modelRoot.UpperBody.RightArm

-- Variables setup
local pose    = require("scripts.Posing")
local vehicle = require("scripts.Vehicles")
local ticks   = require("scripts.WaterTicks")

local armMovement = require("Config").armMovement
function events.RENDER(delta, context)
  -- Variables
  local idleTimer = world.getTime(delta)
  
  local handedness  = player:isLeftHanded()
  local activeness  = player:getActiveHand()
  local leftActive  = not handedness and "OFF_HAND" or "MAIN_HAND"
  local rightActive = handedness and "OFF_HAND" or "MAIN_HAND"
  local leftSwing   = player:getSwingArm() == leftActive
  local rightSwing  = player:getSwingArm() == rightActive
  local leftItem    = player:getHeldItem(not handedness)
  local rightItem   = player:getHeldItem(handedness)
  local using       = player:isUsingItem()
  local usingL      = activeness == leftActive and leftItem:getUseAction()
  local usingR      = activeness == rightActive and rightItem:getUseAction()
  local crossL      = leftItem.tag and leftItem.tag["Charged"] == 1
  local crossR      = rightItem.tag and rightItem.tag["Charged"] == 1
  
  local firstPerson = context == "FIRST_PERSON"
  local shouldMove  = pose.swim or pose.elytra or pose.crawl or vehicle.minecart
  
  local idleRot    = vec(math.deg(math.sin(idleTimer * 0.067) * 0.05), 0, math.deg(math.cos(idleTimer * 0.09) * 0.05 + 0.05))
  local armPos     = firstPerson and vec(0, -8, 17) or 0
  local animOffset = firstPerson and modelRoot:getPos() or 0
  
  -- Left arm
  local leftArmStop = not armMovement and not shouldMove and not leftSwing and not ((crossL or crossR) or (using and usingL ~= "NONE")) and not firstPerson
  leftArm:setRot(leftArmStop and -idleRot - vanilla_model.LEFT_ARM:getOriginRot(delta) or nil)
    :setPos(armPos - animOffset)
  
  -- Right arm
  local rightArmStop = not armMovement and not shouldMove and not rightSwing and not ((crossL or crossR) or (using and usingR ~= "NONE")) and not firstPerson
  rightArm:setRot(rightArmStop and idleRot - vanilla_model.RIGHT_ARM:getOriginRot(delta) or nil)
    :setPos(armPos - animOffset)
  
  -- Keep arms still when upperbody rotates.
  modelRoot.UpperBody:setRot(firstPerson and -modelRoot.UpperBody:getOffsetRot(delta) or 0)
end