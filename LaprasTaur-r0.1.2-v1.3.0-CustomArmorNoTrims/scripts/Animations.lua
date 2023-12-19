-- Model setup
local model     = models.LaprasTaur
local upperRoot = model.Player.UpperBody
local lowerRoot = model.Player.LowerBody
local anims     = animations.LaprasTaur

-- Config setup
config:name("LaprasTaur")
local upperRot = config:load("AvatarUpperBodyRot")
if upperRot == nil then upperRot = true end

-- Variables
local pose  = require("scripts.Posing")
local ticks = require("scripts.WaterTicks")
local g     = require("scripts.GroundCheck")

-- Base Animations
do
	-- Animation variable
	local posCurrent, posNextTick, posTarget, posCurrentPos = 0, 0, 0, 0
	
	function events.TICK()
		-- Pos lerp
		posCurrent  = posNextTick
		posNextTick = math.lerp(posNextTick, posTarget, 0.25)
	end
	
	local basePos = vec(0, 0, 0)
	function events.RENDER(delta, context)
		if context == "FIRST_PERSON" or context == "RENDER" or (not client.isHudEnabled() and context ~= "MINECRAFT_GUI") then
			-- Animation modifiers
			local vel        = player:getVelocity()
			local walking    = vel.zx:length() ~= 0
			local inWater    = ticks.water     < 20
			local underwater = ticks.under     < 20
			
			-- Animation states
			local groundIdleState     = not walking and (not (inWater or player:getVehicle()) or g.ground) and not ((pose.swim and inWater) or pose.elytra) or pose.spin or (pose.climb and vel:length() == 0)
			local groundWalkState     =     walking and (not (inWater or player:getVehicle()) or g.ground) and not ((pose.swim and inWater) or pose.elytra or pose.spin) or (pose.climb and vel:length() ~= 0)
			local waterIdleState      = not walking and ((inWater or player:getVehicle()) and not g.ground) and not underwater
			local waterSwimState      =     walking and ((inWater or player:getVehicle()) and not g.ground) and not underwater
			local underwaterIdleState = vel:length() == 0 and underwater and (not g.ground or pose.swim)
			local underwaterSwimState = vel:length() ~= 0 and underwater and (not g.ground or pose.swim)
			
			-- Animations
			anims.groundIdle:setPlaying(groundIdleState)
			anims.groundWalk:setPlaying(groundWalkState)
			anims.waterIdle:setPlaying(waterIdleState)
			anims.waterSwim:setPlaying(waterSwimState)
			anims.underwaterIdle:setPlaying(underwaterIdleState)
			anims.underwaterSwim:setPlaying(underwaterSwimState)
			anims.sleep:setPlaying(pose.sleep)
			
			-- Pos state table
			local statePos = {
				{ state = pose.climb,   pos = vec(0, 0, 25)  },
				{ state = pose.crouch,  pos = vec(0, 2, 0)   },
				{ state = pose.elytra,  pos = vec(0, 0, 15)  },
				{ state = pose.crawl,   pos = vec(0, 0, 33)  },
				{ state = pose.sleep,   pos = vec(0, 0, 15)  },
				{ state = pose.spin,    pos = vec(0, 0, 16)  },
				{ state = pose.swim,    pos = vec(0, 20, 15) },
			}
			
			-- Base position check
			for _, case in ipairs(statePos) do
				if case.state then
					basePos = case.pos
					break
				else
					basePos = 0
				end
			end
			
			-- Pos Lerp
			posTarget     = basePos
			posCurrentPos = math.lerp(posCurrent, posNextTick, delta)
			
			-- Animation modifiers application
			local animPos = model.Player:getAnimPos(delta)
			model.Player:setPos(posCurrentPos + ((pose.swim or pose.climb or pose.crawl) and vec(0, animPos.z - animPos.y, animPos.y - animPos.z) or 0))
			
			-- Misc animations
			if pose.elytra then
				local lE = vanilla_model.LEFT_ELYTRA:getOriginRot(delta)
				local rE = vanilla_model.RIGHT_ELYTRA:getOriginRot(delta)
				lowerRoot.Main.FlipperFrontLeft:setRot(lE.y, (lE.z * 0.75) + 67.5, lE.x)
				lowerRoot.Main.FlipperFrontRight:setRot(rE.y, (rE.z * 0.75) - 67.5, -rE.x)
				lowerRoot.Main.FlipperBackLeft:setRot(lE.y, (lE.z * 0.75) + 67.5, lE.x)
				lowerRoot.Main.FlipperBackRight:setRot(rE.y, (rE.z * 0.75) - 67.5, -rE.x)
			end
			
			local crouch = player:isCrouching()
			lowerRoot:setPos(pose.crawl and vec(0, 1, -1) or crouch and vec(0, 0, pose.elytra and 4 or 5) or 0)
		end
	end
end

-- Yaw rotations
do
	-- Variables
	local yawCurrent, yawNextTick, yawTarget, yawCurrentPos = 0, 0, 0, 0
	
	-- Gradual values
	function events.TICK()
		yawCurrent  = yawNextTick
		yawNextTick = math.lerp(yawNextTick, yawTarget, 0.25)
	end
	
	-- Yaw rotations parts
	local yawParts = {
		upperRoot,
		lowerRoot.Front,
	}
	
	-- Application
	local yawLimit = 26
	function events.RENDER(delta, context)
		if context == "RENDER" or context == "FIRST_PERSON" or (not client.isHudEnabled() and context ~= "MINECRAFT_GUI") then
			-- Variables
			local vel = player:getVelocity().y
			local yawShouldRot = pose.stand and not pose.climb and upperRot
			
			-- Yaw lerps
			yawTarget     = yawShouldRot and math.clamp((vanilla_model.HEAD:getOriginRot(delta).y + 180) % 360 - 180, -yawLimit, yawLimit) or 0
			yawCurrentPos = math.lerp(yawCurrent, yawNextTick, delta)
			
			-- Yaw applications
			for _, part in ipairs(yawParts) do
				part:setOffsetRot(0, yawCurrentPos, 0)
			end
		end
	end
end

-- Breathing control
do
	local speed     = 0
	local lastSpeed = 0
	function events.TICK()
		lastSpeed = speed
		speed     = speed + math.clamp((player:getVelocity():length() * 15 + 1) * 0.05, 0, 0.4)
	end
	
	function events.RENDER(delta, context)
		if context == "RENDER" or context == "FIRST_PERSON" or (not client.isHudEnabled() and context ~= "MINECRAFT_GUI") then
			local scale = math.sin(math.lerp(lastSpeed, speed, delta)) * 0.0125 + 1.0125
			lowerRoot.Front.Front:setScale(scale)
		end
	end
end

-- Parrot control
do
	local parts = {
		lowerRoot.Main.LeftParrotPivot,
		lowerRoot.Main.RightParrotPivot,
	}
	
	function events.RENDER(delta, context)
		if context == "RENDER" or context == "FIRST_PERSON" or (not client.isHudEnabled() and context ~= "MINECRAFT_GUI") then
			for _, parrot in pairs(parts) do
				parrot:setRot(-lowerRoot.Main:getOffsetRot().x__ + -lowerRoot:getRot().x__)
			end
		end
	end
end

-- Fixing spyglass jank
function events.RENDER(delta, context)
	if context == "RENDER" or context == "FIRST_PERSON" or (not client.isHudEnabled() and context ~= "MINECRAFT_GUI") then
		local rot = vanilla_model.HEAD:getOriginRot()
		rot.x = math.clamp(rot.x, -90, 30)
		upperRoot.Spyglass:setRot(rot)
			:setPos(pose.crouch and vec(0, -4, 0) or nil)
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
	anims.sleep:blendTime(7)
	
	anims.groundIdle:onBlend("easeOutQuad")
	anims.groundWalk:onBlend("easeOutQuad")
	anims.waterIdle:onBlend("easeOutQuad")
	anims.waterSwim:onBlend("easeOutQuad")
	anims.underwaterIdle:onBlend("easeOutQuad")
	anims.underwaterSwim:onBlend("easeOutQuad")
	anims.sleep:onBlend("easeOutQuad")
end

-- UpperBody rot toggler
local function setUpperRot(boolean)
	upperRot = boolean
	config:save("AvatarUpperBodyRot", upperRot)
end

-- Sync variables
local function syncUpperRot(a)
	upperRot = a
end

-- Ping setup
pings.setUpperBodyRot     = setUpperRot
pings.syncAvatarUpperBody = syncUpperRot

-- Sync on tick
if host:isHost() then
	function events.TICK()
		if world.getTime() % 200 == 0 then
			pings.syncAvatarUpperBody(upperRot)
		end
	end
end

-- Activate action
setUpperRot(upperRot)

return action_wheel:newAction("UpperBodyRot")
	:title("§9§lUpperBody Rotation Toggle\n\n§bToggles the rotation of the upperbody.\nThis also controls the camera rotation.")
	:hoverColor(vectors.hexToRGB("5EB7DD"))
	:toggleColor(vectors.hexToRGB("4078B0"))
	:item("minecraft:music_disc_11")
	:toggleItem("minecraft:music_disc_wait")
	:onToggle(pings.setUpperBodyRot)
	:toggled(upperRot)