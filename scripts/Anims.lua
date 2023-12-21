-- Model setup
local model     = models.LaprasTaur
local upperRoot = model.Player.UpperBody
local lowerRoot = model.Player.LowerBody
local anims     = animations.LaprasTaur

-- Variables
local pose  = require("scripts.Posing")
local ticks = require("scripts.WaterTicks")
local g     = require("scripts.GroundCheck")

-- Table setup
local t = {}

t.animTime = 0

-- Base Animations
do
	-- Animation variables
	local time  = 0
	local _time = time
	local posCurrent, posNextTick, posTarget, posCurrentPos = 0, 0, 0, 0
	
	function events.TICK()
		-- Animation timer setup
		_time = time
		
		-- Animation velocity control
		local fbVel     = math.clamp(player:getVelocity():dot((player:getLookDir().x_z):normalize()),         -0.25, 0.25)
		local lrVel     = math.clamp(math.abs(player:getVelocity():cross(player:getLookDir().x_z:normalize()).y), 0, 0.25)
		local animSpeed = (fbVel >= -0.05 and math.max(fbVel, lrVel) or math.min(fbVel, lrVel)) * 0.005
		
		-- Animation timeline
		time = time + (animSpeed + (fbVel > -0.05 and 0.0005 or -0.0005))
		
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
			
			-- Animation timeline renderer
			t.animTime = math.lerp(_time, time, delta)
			
			-- Animations
			anims.groundIdle:playing(groundIdleState)
			anims.groundWalk:playing(groundWalkState)
			anims.waterIdle:playing(waterIdleState)
			anims.waterSwim:playing(waterSwimState)
			anims.underwaterIdle:playing(underwaterIdleState)
			anims.underwaterSwim:playing(underwaterSwimState)
			anims.sleep:playing(pose.sleep)
			
			-- Pos state table
			local statePos = {
				{ state = pose.climb,   pos = vec(0, 0, 25)  },
				{ state = pose.elytra,  pos = vec(0, 0, 15)  },
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
			local animPos = model.Player:getAnimPos()
			model.Player:pos(posCurrentPos + ((pose.swim or pose.climb or pose.crawl) and vec(0, animPos.z - animPos.y, animPos.y - animPos.z) or 0))
			
			-- Misc animations
			local lE = vanilla_model.LEFT_ELYTRA:getOriginRot()
			local rE = vanilla_model.RIGHT_ELYTRA:getOriginRot()
			lowerRoot.LowerBodyMain.FrontLeftFlipper:rot(pose.elytra and vec(lE.y, (lE.z * 0.75) + 67.5, lE.x) or nil)
			lowerRoot.LowerBodyMain.FrontRightFlipper:rot(pose.elytra and vec(rE.y, (rE.z * 0.75) - 67.5, -rE.x) or nil)
			lowerRoot.LowerBodyMain.BackLeftFlipper:rot(pose.elytra and vec(lE.y, (lE.z * 0.75) + 67.5, lE.x) or nil)
			lowerRoot.LowerBodyMain.BackRightFlipper:rot(pose.elytra and vec(rE.y, (rE.z * 0.75) - 67.5, -rE.x) or nil)
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
			lowerRoot.LowerBodyFront.Front:scale(scale)
		end
	end
end

-- Parrot control
do
	local parts = {
		lowerRoot.LowerBodyMain.LeftParrotPivot,
		lowerRoot.LowerBodyMain.RightParrotPivot,
	}
	
	function events.RENDER(delta, context)
		if context == "RENDER" or context == "FIRST_PERSON" or (not client.isHudEnabled() and context ~= "MINECRAFT_GUI") then
			for _, parrot in pairs(parts) do
				parrot:rot(-lowerRoot.LowerBodyMain:getTrueRot().x__ + -lowerRoot:getTrueRot().x__)
			end
		end
	end
end

-- Fixing spyglass jank
function events.RENDER(delta, context)
	if context == "RENDER" or context == "FIRST_PERSON" or (not client.isHudEnabled() and context ~= "MINECRAFT_GUI") then
		local rot = vanilla_model.HEAD:getOriginRot()
		rot.x = math.clamp(rot.x, -90, 30)
		upperRoot.Spyglass:rot(rot)
			:pos(pose.crouch and vec(0, -4, 0) or nil)
	end
end

-- GS Blending Setup
do
	require("lib.GSAnimBlend")
	
	local blendAnims = {
		{ anim = anims.groundIdle,     ticks = 7, type = "easeOutQuad" },
		{ anim = anims.groundWalk,     ticks = 7, type = "easeOutQuad" },
		{ anim = anims.waterIdle,      ticks = 7, type = "easeOutQuad" },
		{ anim = anims.waterSwim,      ticks = 7, type = "easeOutQuad" },
		{ anim = anims.underwaterIdle, ticks = 7, type = "easeOutQuad" },
		{ anim = anims.underwaterSwim, ticks = 7, type = "easeOutQuad" },
		{ anim = anims.crawl,          ticks = 7, type = "easeOutQuad" },
		{ anim = anims.sleep,          ticks = 7, type = "easeOutQuad" }
	}
	
	for _, blend in ipairs(blendAnims) do
		blend.anim:blendTime(blend.ticks):onBlend(blend.type)
	end
	
end

-- Returns table
return t