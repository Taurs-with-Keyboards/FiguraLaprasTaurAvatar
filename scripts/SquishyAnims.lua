-- Required scripts
local model   = require("scripts.ModelParts")
local squapi  = require("lib.SquAPI")
local pose    = require("scripts.Posing")
local ground  = require("lib.GroundCheck")

-- Animation setup
local anims = animations.LaprasTaur

-- Calculate parent's rotations
local function calculateParentRot(m)
	
	local parent = m:getParent()
	if not parent then
		return m:getTrueRot()
	end
	return calculateParentRot(parent) + m:getTrueRot()
	
end

-- Squishy smooth torso
squapi.smoothTorso(model.upper, 0.3)
squapi.smoothTorso(model.front, 0.4)

-- Squishy crounch
squapi.crouch(anims.crouch)

-- Ear animations
squapi.ear(model.ears.LeftEar, model.ears.RightEar, false, _, 0.35, true, -0.5, 0.05, 0.1)

-- LowerBody physics
squapi.lapras  = squapi.bounceObject:new()
squapi.flipper = squapi.bounceObject:new()

function events.RENDER(delta, context)
	
	-- Variables
	local yvel     = squapi.yvel()
	local onGround = ground()
	local water    = player:isInWater()
	local dir      = math.map(math.abs(player:getLookDir()[2]), 0, 1, 1, -1)
	local extend   = pose.swim or pose.elytra or pose.crawl or (pose.climb and not onGround)
	local stiff    = water and 0.001 or 0.02
	local bounce   = water and 0.05 or 0.1
	
	-- Bounce off ground
	if onGround and not extend then
		squapi.lapras.vel  = -math.abs(squapi.lapras.vel)
		squapi.flipper.vel = -math.abs(squapi.flipper.vel)
	end
	
	-- Rotations
	local laprasRot  = vec(squapi.lapras.pos,  0, 0)
	local flipperRot = vec(0, 0, squapi.flipper.pos)
	
	-- Apply
	model.main:offsetRot(laprasRot)
	
	model.frontLeftFlipper:offsetRot(flipperRot)
	model.frontLeftFlipper.FrontLeftFlipperTip:offsetRot(flipperRot)
	
	model.frontRightFlipper:offsetRot(-flipperRot)
	model.frontRightFlipper.FrontRightFlipperTip:offsetRot(-flipperRot)
	
	model.backLeftFlipper:offsetRot(flipperRot)
	model.backLeftFlipper.BackLeftFlipperTip:offsetRot(flipperRot)
	
	model.backRightFlipper:offsetRot(-flipperRot)
	model.backRightFlipper.BackRightFlipperTip:offsetRot(-flipperRot)
	
	-- Targets
	local laprasTarget  = (extend and 90 or 0) + math.clamp(yvel * (extend and 80 * dir or 40), -20, 20)
	local flipperTarget = pose.climb and 60 or math.clamp(yvel * 80 * (extend and dir or 1), -60, 60)
	
	-- Do bounce
	squapi.lapras:doBounce(laprasTarget,   stiff, bounce)
	squapi.flipper:doBounce(flipperTarget, stiff, bounce)
	
end

function events.RENDER(delta, context)
	
	-- Set upper pivot to proper pos when crouching
	model.upper:offsetPivot(anims.crouch:isPlaying() and vec(0, 0, 5) or 0)
	
	-- Offset smooth torso in various parts
	-- Note: acts strangely with `model.body` and when sleeping
	for _, group in ipairs(model.upper:getChildren()) do
		if group ~= model.body and not pose.sleep then
			group:offsetRot(-calculateParentRot(group:getParent()))
		end
	end
	
	-- Remove jank caused by crawling
	model.body:offsetRot(pose.crawl and -vanilla_model.BODY:getOriginRot() or 0)
	model.upper:offsetRot(pose.crawl and 0 or model.upper:getOffsetRot())
	
	-- Prevent smooth torso movement on x and z axis for front, as well as rotating too far
	local frontRot = model.front:getOffsetRot()
	model.front:offsetRot(0, math.clamp(frontRot.y, -20, 20), 0)
	
end