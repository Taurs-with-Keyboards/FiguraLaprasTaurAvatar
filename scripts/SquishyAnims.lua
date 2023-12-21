-- Model setup
local model     = models.LaprasTaur
local upperRoot = model.Player.UpperBody
local lowerRoot = model.Player.LowerBody
local anims     = animations.LaprasTaur

-- Squishy API Animations
local squapi  = require("lib.SquAPI")
local pose    = require("scripts.Posing")
local vehicle = require("scripts.Vehicles")

squapi.smoothTorso(upperRoot, 0.3)
squapi.smoothTorso(lowerRoot.LowerBodyFront, 0.4)

squapi.crouch(anims.crouch, _, anims.crawl)

function events.render(delta, context)
	upperRoot.Head:pos(pose.crawl and -vanilla_model.HEAD:getOriginPos() or nil)
	upperRoot.Body:rot(pose.crawl and -vanilla_model.BODY:getOriginRot() or nil)
	upperRoot:offsetRot(pose.crawl and 0 or upperRoot:getOffsetRot())
	lowerRoot.LowerBodyFront:offsetRot(lowerRoot.LowerBodyFront:getOffsetRot()._y_)
end

-- Ear Animations
local ears = upperRoot.Head.Ears
squapi.ear(ears.LeftEar, ears.RightEar, false, _, 0.35, true, -0.5, 0.05, 0.1)

-- LowerBody Physics
local main = lowerRoot.LowerBodyMain

squapi.lapras  = squapi.bounceObject:new()
squapi.flipper = squapi.bounceObject:new()

function events.render(delta, context)
	local yvel = squapi.yvel()
	
	main:offsetRot(squapi.lapras.pos, 0, 0)
	
	main.FrontLeftFlipper:offsetRot(0, 0, squapi.flipper.pos*2)
	main.FrontLeftFlipper.FrontLeftFlipperTip:offsetRot(0, 0, squapi.flipper.pos*1.5)
	
	main.FrontRightFlipper:offsetRot(0, 0, -squapi.flipper.pos*2)
	main.FrontRightFlipper.FrontRightFlipperTip:offsetRot(0, 0, -squapi.flipper.pos*1.5)
	
	main.BackLeftFlipper:offsetRot(0, 0, squapi.flipper.pos*2)
	main.BackLeftFlipper.BackLeftFlipperTip:offsetRot(0, 0, squapi.flipper.pos*1.5)
	
	main.BackRightFlipper:offsetRot(0, 0, -squapi.flipper.pos*2)
	main.BackRightFlipper.BackRightFlipperTip:offsetRot(0, 0, -squapi.flipper.pos*1.5)
	
	local strech  = not (pose.stand or pose.crouch or pose.swim or pose.sleep) or (pose.climb and not player:isOnGround())
	
	local laprasTarget = strech and 90 or vehicle.hasPassenger and 0 or yvel * (pose.swim and 80 or 40) + (pose.swim and 80 or 0)
	if laprasTarget < -20 then laprasTarget = -20 end
	local flipperTarget = pose.climb and 35 or (strech or pose.swim) and 0 or yvel * 40
	if flipperTarget < -30 then flipperTarget = -30 end
	
	squapi.lapras:doBounce(laprasTarget, player:isInWater() and 0.001 or 0.02, .1)
	squapi.flipper:doBounce(flipperTarget, player:isInWater() and 0.001 or 0.01, .1)
end