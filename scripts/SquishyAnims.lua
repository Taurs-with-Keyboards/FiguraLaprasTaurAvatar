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
squapi.smoothTorso(lowerRoot.Front, 0.4)

squapi.crouch(anims.crouch, _, anims.crawl)

function events.render(delta, context)
	upperRoot.Head:pos(pose.crawl and -vanilla_model.HEAD:getOriginPos() or nil)
	upperRoot.Body:rot(pose.crawl and -vanilla_model.BODY:getOriginRot() or nil)
	upperRoot:offsetRot(pose.crawl and 0 or upperRoot:getOffsetRot())
	lowerRoot.Front:offsetRot(lowerRoot.Front:getOffsetRot()._y_)
end

-- Ear Animations
local ears = upperRoot.Head.Ears
squapi.ear(ears.LeftEar, ears.RightEar, false, _, 0.35, _, 1, 0.05, 0.1)

-- LowerBody Physics
local main = lowerRoot.Main

squapi.lapras  = squapi.bounceObject:new()
squapi.flipper = squapi.bounceObject:new()

function events.render(delta, context)
	local yvel = squapi.yvel()
	
	main:offsetRot(squapi.lapras.pos, 0, 0)
	
	main.FlipperFrontLeft:offsetRot(0, 0, squapi.flipper.pos*2)
	main.FlipperFrontLeft.Tip:offsetRot(0, 0, squapi.flipper.pos*1.5)
	
	main.FlipperFrontRight:offsetRot(0, 0, -squapi.flipper.pos*2)
	main.FlipperFrontRight.Tip:offsetRot(0, 0, -squapi.flipper.pos*1.5)
	
	main.FlipperBackLeft:offsetRot(0, 0, squapi.flipper.pos*2)
	main.FlipperBackLeft.Tip:offsetRot(0, 0, squapi.flipper.pos*1.5)
	
	main.FlipperBackRight:offsetRot(0, 0, -squapi.flipper.pos*2)
	main.FlipperBackRight.Tip:offsetRot(0, 0, -squapi.flipper.pos*1.5)
	
	local strech  = not (pose.stand or pose.crouch or pose.swim or pose.sleep) or (pose.climb and not player:isOnGround())
	
	local laprasTarget = strech and 90 or vehicle.hasPassenger and 0 or yvel * (pose.swim and 80 or 40) + (pose.swim and 80 or 0)
	if laprasTarget < -20 then laprasTarget = -20 end
	local flipperTarget = pose.climb and 35 or (strech or pose.swim) and 0 or yvel * 40
	if flipperTarget < -30 then flipperTarget = -30 end
	
	squapi.lapras:doBounce(laprasTarget, player:isInWater() and 0.001 or 0.02, .1)
	squapi.flipper:doBounce(flipperTarget, player:isInWater() and 0.001 or 0.01, .1)
end