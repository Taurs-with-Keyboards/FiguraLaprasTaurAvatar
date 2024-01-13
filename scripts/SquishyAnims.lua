-- Required scripts
local model   = require("scripts.ModelParts")
local squapi  = require("lib.SquAPI")
local pose    = require("scripts.Posing")
local vehicle = require("scripts.Vehicles")

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

squapi.smoothTorso(model.upper, 0.3)
squapi.smoothTorso(model.front, 0.4)

squapi.crouch(anims.crouch, _, anims.crawl)

function events.render(delta, context)
	
	model.head:rot(-calculateParentRot(model.head:getParent()))
		:pos(pose.crawl and -vanilla_model.HEAD:getOriginPos() or nil)
	
	model.body:rot(pose.crawl and -vanilla_model.BODY:getOriginRot() or nil)
	model.upper:offsetRot(pose.crawl and 0 or model.upper:getOffsetRot())
	model.front:offsetRot(model.front:getOffsetRot()._y_)
	
end

-- Ear Animations
squapi.ear(model.ears.LeftEar, model.ears.RightEar, false, _, 0.35, true, -0.5, 0.05, 0.1)

-- LowerBody Physics
squapi.lapras  = squapi.bounceObject:new()
squapi.flipper = squapi.bounceObject:new()

function events.render(delta, context)
	local yvel = squapi.yvel()
	
	model.main:offsetRot(squapi.lapras.pos, 0, 0)
	
	model.frontLeftFlipper:offsetRot(0, 0, squapi.flipper.pos*2)
	model.frontLeftFlipper.FrontLeftFlipperTip:offsetRot(0, 0, squapi.flipper.pos*1.5)
	
	model.frontRightFlipper:offsetRot(0, 0, -squapi.flipper.pos*2)
	model.frontRightFlipper.FrontRightFlipperTip:offsetRot(0, 0, -squapi.flipper.pos*1.5)
	
	model.backLeftFlipper:offsetRot(0, 0, squapi.flipper.pos*2)
	model.backLeftFlipper.BackLeftFlipperTip:offsetRot(0, 0, squapi.flipper.pos*1.5)
	
	model.backRightFlipper:offsetRot(0, 0, -squapi.flipper.pos*2)
	model.backRightFlipper.BackRightFlipperTip:offsetRot(0, 0, -squapi.flipper.pos*1.5)
	
	local strech  = not (pose.stand or pose.crouch or pose.swim or pose.sleep) or (pose.climb and not player:isOnGround())
	
	local laprasTarget = strech and 90 or vehicle.hasPassenger and 0 or yvel * (pose.swim and 80 or 40) + (pose.swim and 80 or 0)
	if laprasTarget < -20 then laprasTarget = -20 end
	local flipperTarget = pose.climb and 35 or (strech or pose.swim) and 0 or yvel * 40
	if flipperTarget < -30 then flipperTarget = -30 end
	
	squapi.lapras:doBounce(laprasTarget, player:isInWater() and 0.001 or 0.02, .1)
	squapi.flipper:doBounce(flipperTarget, player:isInWater() and 0.001 or 0.01, .1)
end