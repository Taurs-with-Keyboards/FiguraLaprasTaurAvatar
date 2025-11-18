-- Kills script if squAPI or squAssets cannot be found
local s, squapi = pcall(require, "lib.SquAPI")
if not s then return {} end
local s, squassets = pcall(require, "lib.SquAssets")
if not s then return {} end

-- Required scripts
local parts   = require("lib.PartsAPI")
local lerp    = require("lib.LerpAPI")
local ground  = require("lib.GroundCheck")
local pose    = require("scripts.Posing")
local effects = require("scripts.SyncedVariables")

-- Animation setup
local anims = animations.LaprasTaur

-- Config setup
config:name("LaprasTaur")
local armsMove = config:load("SquapiArmsMove") or false

-- Calculate parent's rotations
local function calculateParentRot(m)
	
	local parent = m:getParent()
	if not parent then
		return m:getOffsetRot()
	end
	return calculateParentRot(parent) + m:getOffsetRot()
	
end

-- Lerp tables
local leftArmLerp  = lerp:new(armsMove and 1 or 0, 0.5)
local rightArmLerp = lerp:new(armsMove and 1 or 0, 0.5)

-- Squishy ears
local ears = squapi.ear:new(
	parts.group.LeftEar,
	parts.group.RightEar,
	0.35,  -- Range Multiplier (0.35)
	true,  -- Horizontal (true)
	-0.5,  -- Bend Strength (-0.5)
	false, -- Do Flick (false)
	400,   -- Flick Chance (400)
	0.05,  -- Stiffness (0.05)
	0.9    -- Bounce (0.9)
)

-- Head table
local headParts = {
	
	parts.group.UpperBody,
	parts.group.Neck3,
	parts.group.Neck2,
	parts.group.Neck
	
}

-- Squishy smooth torso
local head = squapi.smoothHead:new(
	headParts,
	0.7,  -- Strength (0.7)
	0.4,  -- Tilt (0.4)
	1,    -- Speed (1)
	false -- Keep Original Head Pos (false)
)

-- Head variable
local headStrength = head.strength[1] * #head.strength

-- Squishy vanilla arms
local leftArm = squapi.arm:new(
	parts.group.LeftArm,
	1,     -- Strength (1)
	false, -- Right Arm (false)
	true   -- Keep Position (true)
)

local rightArm = squapi.arm:new(
	parts.group.RightArm,
	1,    -- Strength (1)
	true, -- Right Arm (true)
	true  -- Keep Position (true)
)

-- Arm strength variables
local leftArmStrength  = leftArm.strength
local rightArmStrength = rightArm.strength

-- Body bounce
local lapras = squassets.BERP:new(0.01, 0.975, -25)
local laprasTarget = 0
local _onGround = true

-- Flipper parts tables
local flippers = {
	frontLeft = {
		parts.group.FrontLeftFlipper,
		parts.group.FrontLeftFlipper2,
		parts.group.FrontLeftFlipper3,
		parts.group.FrontLeftFlipper4
	},
	frontRight = {
		parts.group.FrontRightFlipper,
		parts.group.FrontRightFlipper2,
		parts.group.FrontRightFlipper3,
		parts.group.FrontRightFlipper4
	},
	backLeft = {
		parts.group.BackLeftFlipper,
		parts.group.BackLeftFlipper2,
		parts.group.BackLeftFlipper3,
		parts.group.BackLeftFlipper4
	},
	backRight = {
		parts.group.BackRightFlipper,
		parts.group.BackRightFlipper2,
		parts.group.BackRightFlipper3,
		parts.group.BackRightFlipper4
	}
}

function events.TICK()
	
	-- Arm variables
	local handedness  = player:isLeftHanded()
	local activeness  = player:getActiveHand()
	local leftActive  = not handedness and "OFF_HAND" or "MAIN_HAND"
	local rightActive = handedness and "OFF_HAND" or "MAIN_HAND"
	local leftSwing   = player:getSwingArm() == leftActive
	local rightSwing  = player:getSwingArm() == rightActive
	local leftItem    = player:getHeldItem(not handedness)
	local rightItem   = player:getHeldItem(handedness)
	local using       = player:isUsingItem()
	local usingL      = activeness == leftActive and leftItem:getUseAction() or "NONE"
	local usingR      = activeness == rightActive and rightItem:getUseAction() or "NONE"
	local bow         = using and (usingL == "BOW" or usingR == "BOW")
	local crossL      = leftItem.tag and leftItem.tag["Charged"] == 1
	local crossR      = rightItem.tag and rightItem.tag["Charged"] == 1
	
	-- Arm movement overrides
	local armShouldMove = pose.crawl
	
	-- Control targets based on variables
	leftArmLerp.target  = (armsMove or armShouldMove or leftSwing  or bow or ((crossL or crossR) or (using and usingL ~= "NONE"))) and 1 or 0
	rightArmLerp.target = (armsMove or armShouldMove or rightSwing or bow or ((crossL or crossR) or (using and usingR ~= "NONE"))) and 1 or 0
	
	-- Body lean overrides
	local bodyShouldBend = not (pose.sleep or anims.pushUp:isPlaying())
	for i in ipairs(head.strength) do
		head.strength[i] = (headStrength / #head.strength) * (bodyShouldBend and 1 or 0)
	end
	
	-- Variables
	local yvel = math.clamp(squassets.verticalVel(), -0.5, 0.5)
	local onGround = ground()
	
	-- Set targets
	if pose.crawl or pose.spin or effects.cF then
		laprasTarget = 0
	elseif not onGround then
		laprasTarget = yvel * 75
	elseif onGround ~= _onGround then
		laprasTarget = -laprasTarget
	end
	
	-- Limits
	if onGround then
		lapras.upper = 0
	else
		lapras.upper = 35
	end
	
	-- Stiffness and bounce
	if player:isInWater() then
		lapras.stiff = 0.005
		lapras.bounce = 0.99
	else
		lapras.stiff = 0.02
		lapras.bounce = 0.95
	end
	
	-- Store data
	_onGround = onGround
	
end

function events.RENDER(delta, context)
	
	-- Variables
	local idleTimer   = world.getTime(delta)
	local idleRot     = vec(math.deg(math.sin(idleTimer * 0.067) * 0.05), 0, math.deg(math.cos(idleTimer * 0.09) * 0.05 + 0.05))
	local firstPerson = context == "FIRST_PERSON"
	
	-- Adjust arm strengths
	leftArm.strength  = leftArmStrength  * leftArmLerp.currPos
	rightArm.strength = rightArmStrength * rightArmLerp.currPos
	
	-- Adjust arm characteristics after applied by squapi
	parts.group.LeftArm
		:offsetRot(
			parts.group.LeftArm:getOffsetRot()
			+ ((-idleRot + (vanilla_model.BODY:getOriginRot() * 0.75)) * math.map(leftArmLerp.currPos, 0, 1, 1, 0))
		)
		:pos(parts.group.LeftArm:getPos() * vec(1, 1, -1))
		:visible(not firstPerson)
	
	parts.group.RightArm
		:offsetRot(
			parts.group.RightArm:getOffsetRot()
			+ ((idleRot + (vanilla_model.BODY:getOriginRot() * 0.75)) * math.map(rightArmLerp.currPos, 0, 1, 1, 0))
		)
		:pos(parts.group.RightArm:getPos() * vec(1, 1, -1))
		:visible(not firstPerson)
	
	-- Set visible if in first person
	parts.group.LeftArmFP:visible(firstPerson)
	parts.group.RightArmFP:visible(firstPerson)
	
	-- Offset smooth torso in various parts
	-- Note: acts strangely with `parts.group.body`
	for _, group in ipairs(parts.group.UpperBody:getChildren()) do
		if group ~= parts.group.Body then
			group:rot(-calculateParentRot(group:getParent()))
		end
	end
	
	-- Calc body bounce
	lapras:berp(laprasTarget, delta)
	
	-- Apply body bounce
	parts.group.LowerBody:offsetRot(lapras.pos, 0, 0)
	for k, v in pairs(flippers) do
		local flipperRot = vec(0, 0, lapras.pos * (k:find("Right") and -1 or 1))
		for _, part in ipairs(v) do
			part:offsetRot(flipperRot)
		end
	end
	
end

-- Arm movement toggle
function pings.setSquapiArmsMove(boolean)
	
	armsMove = boolean
	config:save("SquapiArmsMove", armsMove)
	
end

-- Sync variable
function pings.syncSquapi(a)
	
	armsMove = a
	
end

-- Host only instructions
if not host:isHost() then return end

-- Sync on tick
function events.TICK()
	
	if world.getTime() % 200 == 0 then
		pings.syncSquapi(armsMove)
	end
	
end

-- Required scripts
local s, wheel, itemCheck, c = pcall(require, "scripts.ActionWheel")
if not s then return end -- Kills script early if ActionWheel.lua isnt found
pcall(require, "scripts.Anims") -- Tries to find script, not required

-- Check for if page already exists
local pageExists = action_wheel:getPage("Anims")

-- Pages
local parentPage = action_wheel:getPage("Main")
local animsPage  = pageExists or action_wheel:newPage("Anims")

-- Actions table setup
local a = {}

-- Actions
if not pageExists then
	a.pageAct = parentPage:newAction()
		:item(itemCheck("jukebox"))
		:onLeftClick(function() wheel:descend(animsPage) end)
end

a.armsAct = animsPage:newAction()
	:item(itemCheck("red_dye"))
	:toggleItem(itemCheck("rabbit_foot"))
	:onToggle(pings.setSquapiArmsMove)
	:toggled(armsMove)

-- Update actions
function events.RENDER(delta, context)
	
	if action_wheel:isEnabled() then
		if a.pageAct then
			a.pageAct
				:title(toJson(
					{text = "Animation Settings", bold = true, color = c.primary}
				))
		end
		
		a.armsAct
			:title(toJson(
				{
					"",
					{text = "Arm Movement Toggle\n\n", bold = true, color = c.primary},
					{text = "Toggles the movement swing movement of the arms.\nActions are not effected.", color = c.secondary}
				}
			))
		
		for _, act in pairs(a) do
			act:hoverColor(c.hover):toggleColor(c.active)
		end
		
	end
	
end