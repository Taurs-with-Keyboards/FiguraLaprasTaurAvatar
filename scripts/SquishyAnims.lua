-- Required scripts
local pokemonParts = require("lib.GroupIndex")(models.models.LaprasTaur)
local squapi       = require("lib.SquAPI")
local ground       = require("lib.GroundCheck")
local pose         = require("scripts.Posing")

-- Animation setup
local anims = animations["models.LaprasTaur"]

-- Calculate parent's rotations
local function calculateParentRot(m)
	
	local parent = m:getParent()
	if not parent then
		return m:getOffsetRot()
	end
	return calculateParentRot(parent) + m:getOffsetRot()
	
end


-- Squishy smooth Head + Neck
squapi.smoothHeadNeck(
	pokemonParts.UpperBody,
	pokemonParts.Neck,
	nil,
	0.4,
	false
)


-- Squishy crounch
squapi.crouch(anims.crouch)

-- Ear animations
squapi.ear(
	pokemonParts.LeftEar,
	pokemonParts.RightEar,
	false,
	nil,
	0.35,
	true,
	-0.5,
	0.05,
	0.1
)

-- Lerp offset table
local offset = {
	current    = 0,
	nextTick   = 0,
	target     = 0,
	currentPos = 0
}

-- Lerp shift table
local water = {
	current    = 0,
	nextTick   = 0,
	target     = 0,
	currentPos = 0
}

-- Ticks lerps
function events.TICK()
	
	-- Targets
	offset.target = (anims.frontFlip:isPlaying() or anims.backFlip:isPlaying() or anims.napDown:isPlaying() or anims.napHold:isPlaying() or pose.sleep) and 1 or 0
	water.target  = player:isInWater() and 1 or 0
	
	-- Tick lerp
	offset.current = offset.nextTick
	water.current  = water.nextTick
	offset.nextTick = math.lerp(offset.nextTick, offset.target, 0.2)
	water.nextTick  = math.lerp(water.nextTick,  water.target,  0.05)
	
end

-- LowerBody physics
squapi.lapras  = squapi.bounceObject:new()
squapi.flipper = squapi.bounceObject:new()

function events.RENDER(delta, context)
	
	-- Render lerp
	water.currentPos = math.lerp(water.current, water.nextTick, delta)
	
	-- Variables
	local yvel     = squapi.yvel()
	local yDir     = player:getLookDir()[2]
	local extend   = anims.extend:isPlaying()
	local onGround = ground()
	local upDir    = math.abs(math.max(yDir -1, -1))
	local extDir   = math.map(math.abs(yDir), 0, 1, 1, -1)
	local elyDir   = math.map(math.abs(yDir), 0, 1, 1, 0)
	local stopMove = anims.frontFlip:isPlaying() or anims.backFlip:isPlaying()
	local limit    = math.lerp(60,   20,    water.currentPos)
	local stiff    = math.lerp(0.02, 0.001, water.currentPos)
	local bounce   = math.lerp(0.1,  0.05,  water.currentPos)
	
	-- Rotations
	local laprasRot  = vec(squapi.lapras.pos,  0, 0)
	local flipperRot = vec(0, 0, squapi.flipper.pos)
	
	-- Bounce off ground
	if onGround and not extend then
		laprasRot  = -laprasRot:applyFunc(math.abs)
		flipperRot = -flipperRot:applyFunc(math.abs)
	end
	
	-- Apply
	pokemonParts.Main:offsetRot(laprasRot)
	
	pokemonParts.FrontLeftFlipper:offsetRot(flipperRot)
	pokemonParts.FrontLeftFlipperTip:offsetRot(flipperRot)
	
	pokemonParts.FrontRightFlipper:offsetRot(-flipperRot)
	pokemonParts.FrontRightFlipperTip:offsetRot(-flipperRot)
	
	pokemonParts.BackLeftFlipper:offsetRot(flipperRot)
	pokemonParts.BackLeftFlipperTip:offsetRot(flipperRot)
	
	pokemonParts.BackRightFlipper:offsetRot(-flipperRot)
	pokemonParts.BackRightFlipperTip:offsetRot(-flipperRot)
	
	-- Targets
	local laprasTarget  = stopMove and 0 or (math.clamp(yvel * (not extend and 40 or 80 * (pose.elytra and elyDir or extDir)), -20 * (not extend and upDir or 1), 20))
	local flipperTarget = stopMove and 0 or (pose.climb and 60 or math.clamp(yvel * 80 * (pose.elytra and elyDir or not extend and 1 or extDir), -limit, limit))
	
	-- Do bounce
	squapi.lapras:doBounce(laprasTarget,   stiff, bounce)
	squapi.flipper:doBounce(flipperTarget, stiff, bounce)
	
end

function events.RENDER(delta, context)
	
	-- Render lerp
	offset.currentPos = math.lerp(offset.current, offset.nextTick, delta)
	
	-- Set upper pivot to proper pos when crouching
	pokemonParts.UpperBody:offsetPivot(anims.crouch:isPlaying() and vec(0, 0, 5) or 0)
	
	-- Offset smooth torso itself
	pokemonParts.Neck:offsetRot(math.lerp(pokemonParts.Neck:getOffsetRot(), 0, offset.currentPos))
	pokemonParts.UpperBody:offsetRot(math.lerp(pokemonParts.UpperBody:getOffsetRot(), 0, offset.currentPos))
	
	-- Offset smooth torso in various parts
	-- Note: acts strangely with `pokemonParts.Body`
	for _, group in ipairs(pokemonParts.UpperBody:getChildren()) do
		if group ~= pokemonParts.Body then
			group:offsetRot(math.lerp(-((calculateParentRot(group:getParent()) + 180) % 360 - 180), 0, offset.currentPos))
		end
	end
	
	-- Remove jank caused by crawling
	pokemonParts.Body:offsetRot(pose.crawl and -vanilla_model.BODY:getOriginRot() or 0)
	pokemonParts.UpperBody:offsetRot(pose.crawl and 0 or pokemonParts.UpperBody:getOffsetRot())
	
end