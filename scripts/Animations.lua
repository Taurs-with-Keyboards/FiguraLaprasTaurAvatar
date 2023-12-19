-- Model setup
local model     = models.LaprasTaur
local modelRoot = model.Player
local lapras    = modelRoot.LowerBody
local anims     = animations.LaprasTaur

-- Variables
local pose    = require("scripts.Posing")
local ticks   = require("scripts.WaterTicks")
local g       = require("scripts.GroundCheck")
local vehicle = require("scripts.Vehicles")

-- Base Animations
do
  -- Animation variables
  local time    = 0
  local _time   = time
  local rotCurrent, rotNextTick, rotTarget, rotCurrentPos = 0, 0, 0, 0
  local posCurrent, posNextTick, posTarget, posCurrentPos = 0, 0, 0, 0
  
  function events.TICK()
    -- Animation timer setup
    _time = time
    
    -- Animation velocity control
    local fbVel     = math.clamp(player:getVelocity():dot((player:getLookDir().x_z):normalize()),            -0.25, 0.25)
    local lrVel     = math.clamp(math.abs(player:getVelocity():cross(player:getLookDir().x_z:normalize()).y), 0,    0.25)
    local animSpeed = (fbVel >= -0.05 and math.max(fbVel, lrVel) or math.min(fbVel, lrVel)) * 0.005
    
    -- Animation timeline
    time = time + (animSpeed + (fbVel > -0.05 and 0.0005 or -0.0005))
    
    -- Rot lerp
    rotCurrent  = rotNextTick
    rotNextTick = math.lerp(rotNextTick, rotTarget, 0.25)
    
    -- Pos lerp
    posCurrent  = posNextTick
    posNextTick = math.lerp(posNextTick, posTarget, 1)
  end
  
  local baseRot = vec(0, 0, 0)
  local basePos = vec(0, 0, 0)
  function events.RENDER(delta, context)
    if context == "RENDER" or context == "FIRST_PERSON" or (not client.isHudEnabled() and context ~= "MINECRAFT_GUI") then
      -- Animation modifiers
      local vel        = player:getVelocity()
      local walking    = vel.zx:length() ~= 0
      local inWater    = ticks.water      < 20
      local underwater = ticks.under      < 20
      
      -- Animation states
      local groundIdleState     = not walking       and (not inWater     or g.ground) and not ((pose.swim and inWater) or pose.elytra) and not vehicle.vehicle and not anims.underwaterSwim:isPlaying()
      local groundWalkState     =     walking       and (not inWater     or g.ground) and not ((pose.swim and inWater) or pose.elytra) and not vehicle.vehicle
      local waterIdleState      = not walking       and ((inWater  and  not g.ground) or vehicle.vehicle) and not underwater 
      local waterSwimState      =     walking       and ((inWater  and  not g.ground) or vehicle.vehicle) and not underwater
      local underwaterIdleState = vel:length() == 0 and underwater and (not g.ground or pose.swim)
      local underwaterSwimState = vel:length() ~= 0 and underwater and (not g.ground or pose.swim) and not anims.groundWalk:isPlaying()
      
      -- Animation timeline renderer
      animTime = math.lerp(_time, time, delta)
      
      -- Animations
      anims.groundIdle:setPlaying(groundIdleState)
      anims.groundWalk:setPlaying(groundWalkState)
      anims.waterIdle:setPlaying(waterIdleState)
      anims.waterSwim:setPlaying(waterSwimState)
      anims.underwaterIdle:setPlaying(underwaterIdleState)
      anims.underwaterSwim:setPlaying(underwaterSwimState)
      
      -- Rot state table
      local stateRot = {
        { state = pose.sleep,  rot = 70 },
        { state = pose.swim,   rot = 80 },
        { state = pose.elytra, rot = 80 },
        { state = pose.crawl,  rot = 90 },
        { state = pose.spin,   rot = 90 },
      }
      
      -- Pos state table
      local statePos = {
        { state = pose.crouch,  pos = vec(0, 2, 0)   },
        { state = pose.elytra,  pos = vec(0, 0, 33)  },
        { state = pose.crawl,   pos = vec(0, 0, 33)  },
        { state = pose.sleep,   pos = vec(0, 0, 15)  },
        { state = pose.spin,    pos = vec(0, 0, 22)  },
        { state = pose.swim and
          vehicle.isVehicle,    pos = vec(0, 15, 15) },
        { state = pose.swim,    pos = vec(0, 10, 25) },
      }
      
      -- Base rotation check
      for _, case in ipairs(stateRot) do
        if case.state then
          baseRot = vec(case.rot, 0, 0)
          break
        else
          baseRot = 0
        end
      end
      
      -- Base position check
      for _, case in ipairs(statePos) do
        if case.state then
          basePos = case.pos
          break
        elseif vehicle.hasPassenger then
          basePos = vec(0, -9, 10)
          break
        else
          basePos = 0
        end
      end
      
      -- Animation modifiers lerps
      rotTarget     = baseRot
      rotCurrentPos = math.lerp(rotCurrent, rotNextTick, delta)
      posTarget     = basePos
      posCurrentPos = math.lerp(posCurrent, posNextTick, delta)
      
      -- Animation modifiers application
      local animPos = modelRoot:getAnimPos(delta)
      local animRot = lapras:getAnimRot(delta)
      local passenger = vehicle.isVehicle or vehicle.hasPassenger
      lapras:setRot(rotCurrentPos + (passenger and -animRot or 0))
      modelRoot:setPos(posCurrentPos + (passenger and -animPos or (pose.swim or pose.crawl) and vec(0, animPos.z - animPos.y, animPos.y - animPos.z) or 0))
      
      -- Misc animations
      local crouch = player:isCrouching()
      lapras:setPos(pose.crawl and vec(0, 1, -1) or crouch and vec(0, 0, pose.elytra and 4 or 5) or 0)
    end
  end
end

-- Dynamic rotations
do
  -- Variables
  local pitchCurrent, pitchNextTick, pitchTarget, pitchCurrentPos = 0, 0, 0, 0
  local yawCurrent,   yawNextTick,   yawTarget,   yawCurrentPos   = 0, 0, 0, 0
  local rollCurrent,  rollNextTick,  rollTarget,  rollCurrentPos  = 0, 0, 0, 0
  
  -- Gradual values
  function events.TICK()
    pitchCurrent, yawCurrent, rollCurrent    = pitchNextTick, yawNextTick, rollNextTick
    pitchNextTick, yawNextTick, rollNextTick = math.lerp(pitchNextTick, pitchTarget, 0.75), math.lerp(yawNextTick, yawTarget, 0.25), math.lerp(rollNextTick, rollTarget, 0.35)
  end
  
  -- Pitch rotations parts
  local pitchParts = {
    lapras.Main,
  }
  
  -- Yaw rotations parts
  local yawParts = {
    modelRoot.UpperBody,
    lapras.Front,
  }
  
  -- Roll rotation parts
  local rollParts = {
    { part = lapras.Main.FlipperFrontRight,                   mult = -2.5 },
    { part = lapras.Main.FlipperFrontLeft,                    mult = 2.5  },
    { part = lapras.Main.FlipperBackRight,                    mult = -2.5 },
    { part = lapras.Main.FlipperBackLeft,                     mult = 2.5  },
    { part = lapras.Main.FlipperFrontRight.FlipperFrontRight, mult = -1   },
    { part = lapras.Main.FlipperFrontLeft.FlipperFrontLeft,   mult = 1    },
    { part = lapras.Main.FlipperBackRight.FlipperBackRight,   mult = -1   },
    { part = lapras.Main.FlipperBackLeft.FlipperBackLeft,     mult = 1    }
  }
  
  -- Rotation limits
  local pitchLimit = 20
  local yawLimit   = 26
  local rollLimit  = 20
  function events.RENDER(delta, context)
    if context == "RENDER" or context == "FIRST_PERSON" or (not client.isHudEnabled() and context ~= "MINECRAFT_GUI") then
      -- Variables
      local vel = player:getVelocity().y
      local pitchShouldRot = not vehicle.vehicle and not pose.spin and not player:isClimbing() and not pose.elytra
      local yawShouldRot   = pose.stand
      local rollShouldRot  = ticks.water >= 20
      
      -- Pitch lerps
      pitchTarget     = pitchShouldRot and player:getPassengers()[1] == nil and math.clamp(vel * 70, -pitchLimit, pitchLimit) or 0
      pitchCurrentPos = math.lerp(pitchCurrent, pitchNextTick, delta)
      
      -- Yaw lerps
      yawTarget       = yawShouldRot and math.clamp((vanilla_model.HEAD:getOriginRot(delta).y + 180) % 360 - 180, -yawLimit, yawLimit) or 0
      yawCurrentPos   = math.lerp(yawCurrent, yawNextTick, delta)
      
      -- Roll lerps
      rollTarget      = pose.sleep and -18 or rollShouldRot and math.clamp(vel * 70, -rollLimit, rollLimit) or 0
      rollCurrentPos  = math.lerp(rollCurrent, rollNextTick, delta)
      
      -- Pitch applications
      for _, part in ipairs(pitchParts) do
        part:setOffsetRot(pitchCurrentPos, 0, 0)
      end
      
      -- Yaw applications
      for _, part in ipairs(yawParts) do
        part:setOffsetRot(0, yawCurrentPos, 0)
      end
      
      -- Roll applications
      for _, part in ipairs(rollParts) do
        part.part:setOffsetRot(0, 0, rollCurrentPos * part.mult)
      end
    end
  end
end

-- Breathing control
do
  local speed = 0
  local lastSpeed = 0
  function events.TICK()
    lastSpeed = speed
    speed = speed + math.clamp((player:getVelocity():length() * 15 + 1) * 0.05, 0, 0.4)
  end
  
  function events.RENDER(delta, context)
    if context == "RENDER" or context == "FIRST_PERSON" or (not client.isHudEnabled() and context ~= "MINECRAFT_GUI") then
      local scale = math.sin(math.lerp(lastSpeed, speed, delta)) * 0.0125 + 1.0125
      lapras.Front.Front:setScale(scale)
    end
  end
end

-- Parrot control
do
  local parts = {
    lapras.Main.LeftParrotPivot,
    lapras.Main.RightParrotPivot,
  }
  
  function events.RENDER(delta, context)
    if context == "RENDER" or context == "FIRST_PERSON" or (not client.isHudEnabled() and context ~= "MINECRAFT_GUI") then
      for _, parrot in pairs(parts) do
        parrot:setRot(-lapras.Main:getOffsetRot().x__ + -lapras:getRot().x__)
      end
    end
  end
end

-- Fixing spyglass jank
function events.RENDER(delta, context)
  if context == "RENDER" or context == "FIRST_PERSON" or (not client.isHudEnabled() and context ~= "MINECRAFT_GUI") then
    local rot = vanilla_model.HEAD:getOriginRot()
    rot.x = math.clamp(rot.x, -90, 30)
    modelRoot.UpperBody.Spyglass:setRot(rot)
  end
end

-- GS Blending Setup
do
  require("lib.GSAnimBlend")
  
  anims.groundIdle:blendTime(7)
  anims.groundWalk:blendTime(7)
  anims.waterIdle:blendTime(7)
  anims.waterSwim:blendTime(7)
  anims.underwaterIdle:blendTime(7)
  anims.underwaterSwim:blendTime(7)
  
  anims.groundIdle:onBlend("easeOutQuad")
  anims.groundWalk:onBlend("easeOutQuad")
  anims.waterIdle:onBlend("easeOutQuad")
  anims.waterSwim:onBlend("easeOutQuad")
  anims.underwaterIdle:onBlend("easeOutQuad")
  anims.underwaterSwim:onBlend("easeOutQuad")
end