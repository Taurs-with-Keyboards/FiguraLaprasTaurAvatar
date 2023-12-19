
--███████╗ ██████╗ ██╗   ██╗██╗███████╗██╗  ██╗██╗   ██╗███████╗     █████╗ ██████╗ ██╗
--██╔════╝██╔═══██╗██║   ██║██║██╔════╝██║  ██║╚██╗ ██╔╝██╔════╝    ██╔══██╗██╔══██╗██║
--███████╗██║   ██║██║   ██║██║███████╗███████║ ╚████╔╝ ███████╗    ███████║██████╔╝██║
--╚════██║██║▄▄ ██║██║   ██║██║╚════██║██╔══██║  ╚██╔╝  ╚════██║    ██╔══██║██╔═══╝ ██║
--███████║╚██████╔╝╚██████╔╝██║███████║██║  ██║   ██║   ███████║    ██║  ██║██║     ██║
--╚══════╝ ╚══▀▀═╝  ╚═════╝ ╚═╝╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝    ╚═╝  ╚═╝╚═╝     ╚═╝
----------------------------------------------------------------------------------------

-- Author: Squishy
-- Discord tag: mrsirsquishy
-- Heavily Edited by: Total
-- Discord tag: totaltakeover

-- Version: 0.195
-- Legal: Do not Redistribute without explicit permission.

-- Don't be afraid to ask me for help, be afraid of not giving me enough info to help

local squapi = {}

--BOUNCY EARS
--guide:(note if it has a * that means you can leave it blank to use reccomended settings)
-- element: 		the ear element that you want to affect(models.[modelname].path)
-- *element2: 		the second element you'd like to use(second ear), set to nil or leave empty to ignore
-- *doearflick:		reccomended true. This adds the random chance for the ears to do a "flick" animation, set to false to disable.
-- *earflickchance:	how rare a flick should be. high values mean less liklihood, low values mean high liklihood.(200 reccomended)
-- *rangemultiplier at normal state of 1 the ears rotate from -90 to 90, this range will be multiplied by this, so a value of 0.5 would half the range
-- *earoffset:		how the ears are normally offset. set to 0 for them to normally point up, or set to 45 to have the ears be angled by 45 normally.
-- *bendstrength: 	how strong the ears bend when you move(jump, fall, run, etc.)
-- *earstiffness: 	how stiff the ears movement is(0-1)
-- *earbounce: 		how bouncy the ears are(0-1)

function squapi.ear(element, element2, doearflick, earflickchance, rangemultiplier, earoffset, bendstrength, earstiffness, earbounce)
	if doearflick == nil then doearflick = true end
	local earflickchance = earflickchance or 200
	local element2 = element2 or nil
	local bendstrength = bendstrength or 2
	local earstiffness = earstiffness or 0.025
	local earbounce = earbounce or 0.1
	local earoffset = earoffset or 0
	local rangemultiplier = rangemultiplier or 1
	
	local eary = squapi.bounceObject:new()
	local earx = squapi.bounceObject:new()
	local earx2 = squapi.bounceObject:new()
	
	local oldpose = "STANDING"
	function events.render(delta, context)
		local vel = squapi.getForwardVel()
		local yvel = squapi.yvel()
		local svel = squapi.getSideVelocity()
		local headrot = (vanilla_model.HEAD:getOriginRot()+180)%360-180
		
		local bend = bendstrength
		if headrot[1] < -22.5 then bend = -bend end
		
		--moves when player crouches
		local pose = player:getPose()
		if pose == "CROUCHING" and oldpose == "STANDING" then
			eary.vel = eary.vel + 3 * bendstrength
		elseif pose == "STANDING" and oldpose == "CROUCHING" then
			eary.vel = eary.vel - 3 * bendstrength
		end
		oldpose = pose

		--y vel change
		eary.vel = eary.vel + yvel * bend
		--x vel change
		eary.vel = eary.vel + vel * bend * 1.5

		if doearflick then
			if math.random(0, earflickchance) == 1 then
				if math.random(0, 1) == 1 then
					earx.vel = earx.vel + 50
				else
					earx2.vel = earx2.vel - 50
				end
			end
		end


		local rot1 = eary:doBounce(headrot[1] * rangemultiplier, earstiffness, earbounce)
		local rot2 = earx:doBounce(headrot[2] * rangemultiplier - svel*150*bendstrength, earstiffness, earbounce)
		local rot2b = earx2:doBounce(headrot[2] * rangemultiplier - svel*150*bendstrength, earstiffness, earbounce)
		local rot3 = rot2/4
		local rot3b = rot2b/4

		element:setOffsetRot(rot1 + earoffset, rot2/4, rot3)
		if element2 ~= nil then 
			element2:setOffsetRot(rot1 + earoffset, rot2b/4, rot3b) 
		end
	end
end

--CENTAUR PHYSICS
-- guide:
-- This has been heavily modified by Total.
-- Just download the original... please.
function squapi.centuarPhysics(centaurbody, frontleft, frontlefttip, frontright, frontrighttip, backleft, backlefttip, backright, backrighttip)
	squapi.taur = squapi.bounceObject:new()
	squapi.taurLegs = squapi.bounceObject:new()
	
	function events.render(delta, context)
		local yvel = squapi.yvel()
		local pose = player:getPose()
		
		centaurbody:setRot(squapi.taur.pos, 0, 0)
		frontleft:setRot(0, 0, squapi.taurLegs.pos*2)
		frontlefttip:setRot(0, 0, squapi.taurLegs.pos*1.5)
		frontright:setRot(0, 0, -squapi.taurLegs.pos*2)
		frontrighttip:setRot(0, 0, -squapi.taurLegs.pos*1.5)
		backleft:setRot(0, 0, squapi.taurLegs.pos*2)
		backlefttip:setRot(0, 0, squapi.taurLegs.pos*1.5)
		backright:setRot(0, 0, -squapi.taurLegs.pos*2)
		backrighttip:setRot(0, 0, -squapi.taurLegs.pos*1.5)
		
		local pose    = require("scripts.Posing")
		local vehicle = require("scripts.Vehicles")
		local strech  = not (pose.stand or pose.crouch or pose.swim or pose.sleep) or (pose.climb and not player:isOnGround())
		
		local mainTarget = strech and 80 or vehicle.hasPassenger and 0 or yvel * (pose.swim and 80 or 40) + (pose.swim and 80 or 0)
		if mainTarget < -20 then mainTarget = -20 end
		local legsTarget = pose.climb and 35 or (strech or pose.swim) and 0 or yvel * 40
		if legsTarget < -30 then legsTarget = -30 end
		squapi.taur:doBounce(mainTarget, player:isInWater() and 0.001 or 0.02, .1)
		squapi.taurLegs:doBounce(legsTarget, player:isInWater() and 0.001 or 0.01, .1)
	end
end

-- USEFUL CALLS ------------------------------------------------------------------------------------------

-- returns how fast the player moves forward, negative means backward
function squapi.getForwardVel()
	return player:getVelocity():dot((player:getLookDir().x_z):normalize())
end

-- returns y velocity
function squapi.yvel()
	return player:getVelocity()[2]
end

-- returns how fast player moves sideways, negative means left
function squapi.getSideVelocity()
	return player:getVelocity():dot((player:getLookDir().z_x):normalize())
end


--functions that are made for use through this code, or personal use. Not meant to be used outside but if you know what you're doing go ahead. 
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

--smooth bouncy stuff
squapi.bounceObject = {}
function squapi.bounceObject:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	self.vel = 0
	self.pos = 0
	return o
end	
function squapi.bounceObject:doBounce(target, stiff, bounce)
	local target = target or 2
	local dif = target - self.pos
	self.vel = self.vel + ((dif - self.vel * stiff) * stiff)
	self.pos = (self.pos + self.vel) + (dif * bounce)
	return self.pos
end

--1: dif is the distance between current and target
--2: lower vals of stiff mean that it is slower(lags behind more) 
--   This means slower acceleration. This acceleration is then added to vel.
--4: apply velocity to the current value, as well as adding bounce factor.
--5: returns the new value, as well as the velocity at that moment.

--Paramter details:
-- current: the current value(like position, rotation, etc.) of object that will be moved.
-- target: the target value - this is what it will bounce towards
-- stiff: how stiff it should be(between 0-1)
-- bounce: how bouncy it should be(between 0-1)
-- vel: the current velocity of the current value.

return squapi