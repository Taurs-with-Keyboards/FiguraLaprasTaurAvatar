-- Model setup
local model     = models.LaprasTaur
local upperRoot = model.Player.UpperBody

-- Config setup
config:name("LaprasTaur")
local camPos = config:load("CameraPos") or false
local eyePos = false

-- Variable setup
local pose    = require("scripts.Posing")
local vehicle = require("scripts.Vehicles")

-- Startup camera pos
local trueHeadPos = 0
function events.ENTITY_INIT()
	trueHeadPos = player:getPos()
end

-- Get the average of a vector
local function average(vec)
	local sum = 0
	for _, v in ipairs{vec:unpack()} do
		sum = sum + v
	end
	return sum / #vec
end

function events.POST_RENDER(delta, context)
	if context == "FIRST_PERSON" or context == "RENDER" or (not client.isHudEnabled() and context ~= "MINECRAFT_GUI") then
		
		-- Pos checking
		local playerPos = player:getPos(delta)
		trueHeadPos     = upperRoot.Head:partToWorldMatrix():apply()
		
		-- Pehkui scaling
		local nbt   = player:getNbt()
		local types = nbt["pehkui:scale_data_types"]
		local playerScale = (
			types and
			types["pehkui:base"] and
			types["pehkui:base"]["scale"] or 1)
		local modelWidth = (
			types and
			types["pehkui:model_width"] and
			types["pehkui:model_width"]["scale"] or 1)
		local modelHeight = (
			types and
			types["pehkui:model_height"] and
			types["pehkui:model_height"]["scale"] or 1)
		
		local offsetScale = vec(modelWidth, modelHeight, modelWidth) * playerScale
		
		-- Camera offset & rotation setup
		local posOffset = (trueHeadPos - playerPos) * (context == "FIRST_PERSON" and offsetScale or 1) + vec(0, -player:getEyeHeight() + ((3/16) * offsetScale.y), 0)
		
		-- Renders offset & rotation
		local posOffsetApply = not player:riptideSpinning()
		renderer:offsetCameraPivot(camPos and posOffsetApply and posOffset or 0)
			:eyeOffset(eyePos and camPos and posOffsetApply and posOffset or 0)
		
		-- Nameplate Placement
		nameplate.ENTITY:pivot(posOffset + vec(0, player:getBoundingBox().y + (vehicle.isVehicle and (33/16) or (9/16)), 0))
			:scale(model:getScale())
		
		-- Disables head if sleeping in first person
		upperRoot.Head:visible(not(pose.sleep and renderer:isFirstPerson()))
		
	end
end

-- Camera pos toggler
local function setPos(boolean)
	camPos = boolean
	config:save("CameraPos", camPos)
end

-- Eye pos toggler
local function setEye(boolean)
	eyePos = boolean
end

-- Sync variables
local function syncCamera(a, b)
	camPos = a
	eyePos = b
end

-- Setup pings
pings.setCameraPos = setPos
pings.setCameraEye = setEye
pings.syncCamera   = syncCamera

-- Sync on tick
if host:isHost() then
	function events.TICK()
		if world.getTime() % 200 == 0 then
			pings.syncCamera(camPos, eyePos)
		end
	end
end

-- Activate actions
setPos(camPos)

-- Table setup
local t = {}

-- Action wheel pages
t.posPage = action_wheel:newAction("CameraPos")
	:title("§9§lCamera Position Toggle\n\n§bSets the camera position to where your avatar's head is.")
	:hoverColor(vectors.hexToRGB("5EB7DD"))
	:toggleColor(vectors.hexToRGB("4078B0"))
	:item("minecraft:skeleton_skull")
	:toggleItem(('minecraft:player_head{"SkullOwner":"%s"}'):format(avatar:getEntityName()))
	:onToggle(pings.setCameraPos)
	:toggled(camPos)

t.eyePage = action_wheel:newAction("OffsetEye")
	:title("§9§lEye Position Toggle\n\n§bSets the eye position to match the avatar's head.\nRequires camera position toggle.\n\n§4§lWARNING: §cThis feature is dangerous!\nIt can and will be flagged on servers with anticheat!\nFurthermore, \"In Wall\" damage is possible.\nThis setting will §c§lNOT §cbe saved between sessions for your safety.\n\nPlease use with extreme caution!")
	:hoverColor(vectors.hexToRGB("FF0000"))
	:toggleColor(vectors.hexToRGB("7F0000"))
	:item("minecraft:ender_pearl")
	:toggleItem("minecraft:ender_eye")
	:onToggle(pings.setCameraEye)

-- Return action wheel pages
return t