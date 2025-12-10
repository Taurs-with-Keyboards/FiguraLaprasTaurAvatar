-- Kills script if squAPI or squAssets cannot be found
local s, squapi = pcall(require, "lib.SquAPI")
if not s then return {} end

-- Required scripts
local parts = require("lib.PartsAPI")
local lerp  = require("lib.LerpAPI")
local pose  = require("scripts.Posing")

-- Animation setup
local anims = animations.LaprasTaur

-- Calculate parent's rotations
local function calculateParentRot(m)
	
	local parent = m:getParent()
	if not parent then
		return m:getOffsetRot()
	end
	return calculateParentRot(parent) + m:getOffsetRot()
	
end

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

function events.TICK()
	
	-- Body lean overrides
	local bodyShouldBend = not (pose.sleep or anims.pushUp:isPlaying())
	for i in ipairs(head.strength) do
		head.strength[i] = (headStrength / #head.strength) * (bodyShouldBend and 1 or 0)
	end
	
end

function events.RENDER(delta, context)
	
	-- Offset smooth torso in various parts
	-- Note: acts strangely with `parts.group.body`
	for _, group in ipairs(parts.group.UpperBody:getChildren()) do
		if group ~= parts.group.Body then
			group:rot(-calculateParentRot(group:getParent()))
		end
	end
	
end