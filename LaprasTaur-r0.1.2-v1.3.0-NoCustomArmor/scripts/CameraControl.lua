-- Model setup
local model     = models.LaprasTaur
local upperRoot = model.Player.UpperBody
local pokeball  = models.Pokeball

-- Config setup
config:name("LaprasTaur")
local camPos = config:load("CameraPos") or false
local camRot = config:load("CameraRot") or false
local eyePos = false

-- Variable setup
local pose      = require("scripts.Posing")
local ball      = require("scripts.Pokeball")
local vehicle   = require("scripts.Vehicles")
local collision = false

-- Startup camera pos
local trueHeadPos = 0
function events.ENTITY_INIT()
	trueHeadPos = player:getPos()
end

function events.POST_RENDER(delta, context)
	if context == "FIRST_PERSON" or context == "RENDER" or (not client.isHudEnabled() and context ~= "MINECRAFT_GUI") then
		-- Pos checking
		local playerPos = player:getPos(delta)
		trueHeadPos     = (upperRoot.Head:partToWorldMatrix(delta):apply() * ball.scale) + (pokeball:partToWorldMatrix(delta):apply(0, 2.25, 0) * math.map(ball.scale, 0, 1, 1, 0))
		
		-- Pehkui scaling
		local nbt   = player:getNbt()
		local types = nbt["pehkui:scale_data_types"]
		local scale = (
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
		
		local offsetScale = vec(modelWidth, modelHeight, modelWidth) * scale
		
		-- Camera offset & rotation setup
		local posOffset = (trueHeadPos - playerPos) * (context == "FIRST_PERSON" and offsetScale or 1) + vec(0, -player:getEyeHeight() + ((3/16) * offsetScale.y), 0)
		local rotOffset = -upperRoot:getOffsetRot(delta) + upperRoot.Head:getAnimRot(delta)
		
		-- Block gathering/collision checking (checks for full blocks)
		local blockPos = playerPos + posOffset + vec(0, player:getEyeHeight() - ((3/16) * offsetScale.y), 0)
		local range    = eyePos and 1 or 0.25
		local blocks   = world.getBlocks(blockPos.x - range, blockPos.y, blockPos.z - range, blockPos.x + range, blockPos.y + 0.5, blockPos.z + range)
		for _, block in ipairs(blocks) do
			if block:isSolidBlock() then
				collision = true
				break
			else
				collision = false
			end
		end
		
		-- Renders offset & rotation
		local posOffsetApply = not collision and not player:riptideSpinning()
		renderer:offsetCameraPivot(camPos and posOffsetApply and posOffset or 0)
			:offsetCameraRot(camRot and (renderer:isCameraBackwards() and rotOffset / 2 or rotOffset) or 0)
			:setEyeOffset(eyePos and camPos and posOffsetApply and posOffset or 0)
		
		-- Nameplate Placement
		nameplate.ENTITY:setPivot(posOffset + vec(0, player:getBoundingBox().y + (vehicle.isVehicle and (33/16) or (9/16)), 0))
			:setScale(ball.scale)
		
		-- Disables head if sleeping in first person
		upperRoot.Head:setVisible(not(pose.sleep and renderer:isFirstPerson()))
	end
end

-- Camera pos toggler
local function setPos(boolean)
	camPos = boolean
	config:save("CameraPos", camPos)
end

-- Camera rot toggler
local function setRot(boolean)
	camRot = boolean
	config:save("CameraRot", camRot)
end

-- Eye pos toggler
local function setEye(boolean)
	eyePos = boolean
end

-- Sync variables
local function syncCamera(a, b, c)
	camPos = a
	camRot = b
	eyePos = c
end

-- Setup pings
pings.setCameraPos = setPos
pings.setCameraRot = setRot
pings.setCameraEye = setEye
pings.syncCamera   = syncCamera

-- Sync on tick
if host:isHost() then
	function events.TICK()
		if world.getTime() % 200 == 0 then
			pings.syncCamera(camPos, camRot, eyePos)
		end
	end
end

-- Activate actions
setPos(camPos)
setRot(camRot)

-- Table setup
local t = {}

-- Action wheel pages
t.posPage = action_wheel:newAction("CameraPos")
	:title("§9§lCamera Position Toggle\n\n§bSets the camera position to where your avatar's head is.\nIf your head is inside a block, the camera will default to its original position.\nThis is done to prevent x-ray.")
	:hoverColor(vectors.hexToRGB("5EB7DD"))
	:toggleColor(vectors.hexToRGB("4078B0"))
	:item("minecraft:skeleton_skull")
	:toggleItem(('minecraft:player_head{"SkullOwner":"%s"}'):format(avatar:getEntityName()))
	:onToggle(pings.setCameraPos)
	:toggled(camPos)

t.rotPage = action_wheel:newAction("CameraRot")
	:title("§9§lCamera Rotation Toggle\n\n§bSets the camera rotation to match the avatar's head.")
	:hoverColor(vectors.hexToRGB("5EB7DD"))
	:toggleColor(vectors.hexToRGB("4078B0"))
	:item("minecraft:quartz")
	:toggleItem("minecraft:observer")
	:onToggle(pings.setCameraRot)
	:toggled(camRot)
	
t.eyePage = action_wheel:newAction("OffsetEye")
	:title("§9§lEye Position Toggle\n\n§bSets the eye position to match the avatar's head.\nRequires camera position toggle.\n\n§4§lWARNING: §cThis feature is dangerous!\nIt can and will be flagged on servers with anticheat!\nFurthermore, \"In Wall\" damage is likely, so the x-ray prevention range is increased.\nThis setting will §c§lNOT §cbe saved between sessions for your safety.\n\nPlease use with extreme caution!")
	:hoverColor(vectors.hexToRGB("FF0000"))
	:toggleColor(vectors.hexToRGB("7F0000"))
	:item("minecraft:ender_pearl")
	:toggleItem("minecraft:ender_eye")
	:onToggle(pings.setCameraEye)

-- Return action wheel pages
return t