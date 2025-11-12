-- Required scripts
require("lib.GSAnimBlend")
require("lib.Molang")
local parts   = require("lib.PartsAPI")
local lerp    = require("lib.LerpAPI")
local ground  = require("lib.GroundCheck")
local pose    = require("scripts.Posing")
local effects = require("scripts.SyncedVariables")

-- Animations setup
local anims = animations.LaprasTaur

-- Variables setup
local canStretch = false
local canLaugh   = false
local canPush    = false
local canFlip    = false

-- Lerp table
local extendLerp = lerp:new(0.2)

-- Parrot pivots
local parrots = {
	
	parts.group.LeftParrotPivot,
	parts.group.RightParrotPivot
	
}

-- Calculate parent's rotations
local function calculateParentRot(m)
	
	local parent = m:getParent()
	if not parent then
		return m:getTrueRot()
	end
	return calculateParentRot(parent) + m:getTrueRot()
	
end

-- Set staticYaw to Yaw on init
local _yaw = 0
function events.ENTITY_INIT()
	
	_yaw = player:getBodyYaw()
	
end

function events.TICK()
	
	-- Variables
	local vel        = player:getVelocity()
	local dir        = player:getLookDir()
	local inWater    = player:isInWater()
	local underwater = player:isUnderwater()
	local walking    = vel.xz:length() ~= 0
	local moving     = vel:length() ~= 0
	local onGround   = ground()
	
	-- Directional velocity
	local fbVel = player:getVelocity():dot((dir.x_z):normalize())
	local lrVel = player:getVelocity():cross(dir.x_z:normalize()).y
	local udVel = player:getVelocity().y
	
	-- Speed control
	local moveSpeed  = math.clamp((effects.cF and vel:length() or (pose.climb and udVel or fbVel < -0.05 and math.min(fbVel, math.abs(lrVel)) or math.max(fbVel, math.abs(lrVel)))) * 20, -4, 4)
	local pushSpeed  = inWater and 0.25 or math.max((15 - anims.pushUp:getTime()) / 15, 0.1)
	local waterSpeed = underwater and 0.75 or 1
	
	-- Animation speeds
	anims.groundWalk:speed(moveSpeed)
	anims.waterSwim:speed(moveSpeed)
	anims.underwaterSwim:speed(moveSpeed * 0.75)
	anims.stretch:speed(waterSpeed)
	anims.laugh:speed(waterSpeed)
	anims.pushUp:speed(pushSpeed)
	anims.frontFlip:speed(waterSpeed)
	anims.backFlip:speed(waterSpeed)
	
	-- Blend control
	local shakeBlend = math.clamp(math.map(anims.pushUp:getTime(), 0, 15, -1, 1), 0, 1)
	
	-- Animation blend
	anims.pushUpShake:blend(shakeBlend)
	
	-- Animation variables
	local groundAnim     = (onGround or pose.climb) and not ((pose.swim and inWater) or pose.elytra or pose.spin or anims.pushUp:isPlaying())
	local waterAnim      = (inWater or player:getVehicle()) and not (underwater or onGround or pose.elytra)
	local underwaterAnim = (underwater or effects.cF) and (not onGround or pose.swim) and not pose.elytra
	
	-- Animation states
	local groundIdle     = groundAnim and (not walking or (pose.climb and not moving))
	local groundWalk     = groundAnim and (walking or (pose.climb and moving))
	local waterIdle      = waterAnim and not walking
	local waterSwim      = waterAnim and walking
	local underwaterIdle = underwaterAnim and not moving
	local underwaterSwim = underwaterAnim and moving
	local extend         = pose.swim or pose.elytra or pose.spin
	local elytra         = pose.elytra
	local spin           = pose.spin
	local climb          = pose.climb
	local isAct          = anims.stretch:isPlaying() or anims.laugh:isPlaying() or anims.pushUp:isPlaying() or anims.frontFlip:isPlaying() or anims.backFlip:isPlaying()
	local sleep          = pose.sleep
	
	-- Animation actions
	local canAct = onGround and not (moving or (player:getBodyYaw() ~= _yaw))
	canStretch = canAct and (not isAct or anims.stretch:isPlaying())
	canLaugh   = canAct and (not isAct or anims.laugh:isPlaying())
	canPush    = canAct and not pose.crouch and (not isAct or anims.pushUp:isPlaying())
	canFlip    = not onGround and #player:getPassengers() == 0 and (not isAct or anims.frontFlip:isPlaying() or anims.backFlip:isPlaying())
	
	-- Stop Stretch animation
	if not canStretch then
		anims.stretch:stop()
	end
	
	-- Stop Laugh animation
	if not canLaugh then
		anims.laugh:stop()
	end
	
	-- Stop Pushup animation
	if not canPush then
		anims.pushUp:stop()
		anims.pushUpShake:stop()
	end
	
	-- Stop Flip animations
	if not canFlip then
		anims.frontFlip:stop()
		anims.backFlip:stop()
	end
	
	if (anims.napDown:isPlaying() or anims.napDown:getPlayState() == "HOLDING") and not sleep then
		anims.napUp:play()
	end
	
	-- Animations
	anims.groundIdle:playing(groundIdle)
	anims.groundWalk:playing(groundWalk)
	anims.waterIdle:playing(waterIdle)
	anims.waterSwim:playing(waterSwim)
	anims.underwaterIdle:playing(underwaterIdle)
	anims.underwaterSwim:playing(underwaterSwim)
	anims.extend:playing(extend)
	anims.elytra:playing(elytra)
	anims.spin:playing(spin)
	anims.climb:playing(climb)
	anims.napDown:playing(sleep)
	
	-- Lerp target
	extendLerp.target = extend and 1 or 0
	
	-- Store data
	_yaw = player:getBodyYaw()
	
end

-- Sleep rotations
local dirRot = {
	north = 0,
	east  = 270,
	south = 180,
	west  = 90
}

function events.RENDER(delta, context)
	
	-- Simulate rotations when vanilla rotations are disabled
	if (anims.extend:isPlaying() or pose.sleep) and not pose.spin then
		
		-- Disable vanilla rotation
		renderer:rootRotationAllowed(false)
		
		-- Sleep rotations
		if pose.sleep then
			
			-- Find block
			local block = world.getBlockState(player:getPos())
			local sleepRot = dirRot[block.properties["facing"]]
			
			-- Apply
			models:rot(0, sleepRot, 0)
			
		-- Vanilla rotations
		else
			
			-- Get rotation
			local rot = ((player:getRot(delta) + 180) % 360 - 180)
			local yaw = ((player:getBodyYaw(delta) + 180) % 360 - 180)
			
			-- Apply
			models:rot(math.lerp(0, -rot.x, extendLerp.currPos), -yaw + 180, 0)
			
		end
		
	else
		
		-- Enable vanilla rotation
		renderer:rootRotationAllowed(true)
		
		-- Reset
		models:rot(0)
		
	end
	
	-- Parrot rot offset
	for _, parrot in pairs(parrots) do
		parrot:rot(-calculateParentRot(parrot:getParent()) - vanilla_model.BODY:getOriginRot())
	end
	
	-- Crouch offset
	local bodyRot = vanilla_model.BODY:getOriginRot(delta)
	local crouchPos = vec(0, -math.sin(math.rad(bodyRot.x)) * 2, -math.sin(math.rad(bodyRot.x)) * 12)
	parts.group.UpperBody:offsetPivot(crouchPos):pos(-crouchPos.x_z + crouchPos._y_)
	parts.group.Player:pos(crouchPos.x_z + crouchPos._y_ * 2)
	
	-- Spyglass rotations
	local headRot = vanilla_model.HEAD:getOriginRot()
	headRot.x = math.clamp(headRot.x, -90, 30)
	parts.group.Spyglass:offsetRot(headRot)
		:pos(pose.crouch and vec(0, -4, 0) or nil)
	
end

-- GS Blending Setup
local blendAnims = {
	{ anim = anims.groundIdle,     ticks = {7,7}   },
	{ anim = anims.groundWalk,     ticks = {7,7}   },
	{ anim = anims.waterIdle,      ticks = {7,7}   },
	{ anim = anims.waterSwim,      ticks = {7,7}   },
	{ anim = anims.underwaterIdle, ticks = {7,7}   },
	{ anim = anims.underwaterSwim, ticks = {7,7}   },
	{ anim = anims.extend,         ticks = {14,14} },
	{ anim = anims.climb,          ticks = {7,7}   },
	{ anim = anims.elytra,         ticks = {7,7}   },
	{ anim = anims.stretch,        ticks = {7,7}   },
	{ anim = anims.laugh,          ticks = {7,7}   },
	{ anim = anims.pushUp,         ticks = {14,14} },
	{ anim = anims.napDown,        ticks = {7,7}   },
	{ anim = anims.napUp,          ticks = {7,7}   }
}
	
-- Apply GS Blending
for _, blend in ipairs(blendAnims) do
	if blend.anim ~= nil then
		blend.anim:blendTime(table.unpack(blend.ticks)):blendCurve("easeOutQuad")
	end
end

-- Play stretch anim
function pings.animPlayStretch()
	
	if canStretch then
		anims.stretch:play()
	end
	
end

-- Play laugh anim
function pings.animPlayLaugh()
	
	if canLaugh then
		anims.laugh:play()
	end
	
end

-- Play pushup anim
function pings.setAnimTogglePushUp(boolean)
	
	local play = canPush and boolean
	anims.pushUp:playing(play)
	anims.pushUpShake:playing(play and not player:isInWater())
	
end

-- Play front flip anim
function pings.animPlayFrontFlip()
	
	if canFlip and not anims.backFlip:isPlaying() then
		anims.frontFlip:play()
	end
	
end

-- Play back flip anim
function pings.animPlayBackFlip()
	
	if canFlip and not anims.frontFlip:isPlaying() then
		anims.backFlip:play()
	end
	
end

-- Host only instructions
if not host:isHost() then return end

-- Config setup
config:name("LaprasTaur")

-- Stretch keybind
local stretchBind   = config:load("AnimStretchKeybind") or "key.keyboard.keypad.3"
local setStretchKey = keybinds:newKeybind("Stretch Animation"):onPress(pings.animPlayStretch):key(stretchBind)

-- Stretch keybind
local laughBind   = config:load("AnimLaughKeybind") or "key.keyboard.keypad.4"
local setLaughKey = keybinds:newKeybind("Laugh Animation"):onPress(pings.animPlayLaugh):key(laughBind)

-- Pushup keybind
local pushUpBind   = config:load("AnimPushUpKeybind") or "key.keyboard.keypad.5"
local setPushUpKey = keybinds:newKeybind("Push Up Animation"):onPress(function() pings.setAnimTogglePushUp(not anims.pushUp:isPlaying()) end):key(pushUpBind)

-- FrontFlip keybind
local frontFlipBind   = config:load("AnimFrontFlipKeybind") or "key.keyboard.keypad.6"
local setFrontFlipKey = keybinds:newKeybind("Front Flip Animation"):onPress(pings.animPlayFrontFlip):key(frontFlipBind)

-- FrontFlip keybind
local backFlipBind   = config:load("AnimBackFlipKeybind") or "key.keyboard.keypad.7"
local setBackFlipKey = keybinds:newKeybind("Back Flip Animation"):onPress(pings.animPlayBackFlip):key(backFlipBind)

-- Keybind updaters
function events.TICK()
	
	local stretchKey   = setStretchKey:getKey()
	local laughKey     = setLaughKey:getKey()
	local pushUpKey    = setPushUpKey:getKey()
	local frontFlipKey = setFrontFlipKey:getKey()
	local backFlipKey  = setBackFlipKey:getKey()
	if stretchKey ~= stretchBind then
		stretchBind = stretchKey
		config:save("AnimStretchKeybind", stretchKey)
	end
	if laughKey ~= laughBind then
		laughBind = laughKey
		config:save("AnimLaughKeybind", laughKey)
	end
	if pushUpKey ~= pushUpBind then
		pushUpBind = pushUpKey
		config:save("AnimPushUpKeybind", pushUpKey)
	end
	if frontFlipKey ~= frontFlipBind then
		frontFlipBind = frontFlipKey
		config:save("AnimFrontFLipKeybind", frontFlipKey)
	end
	if backFlipKey ~= backFlipBind then
		backFlipBind = backFlipKey
		config:save("AnimBackFLipKeybind", backFlipKey)
	end
	
end

-- Required script
local s, wheel, itemCheck, c = pcall(require, "scripts.ActionWheel")
if not s then return end -- Kills script early if ActionWheel.lua isnt found

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

a.stretchPage = animsPage:newAction()
	:item(itemCheck("scaffolding"))
	:onLeftClick(pings.animPlayStretch)

a.laughPage = animsPage:newAction()
	:item(itemCheck("cookie"))
	:onLeftClick(pings.animPlayLaugh)

a.pushUpPage = animsPage:newAction()
	:item(itemCheck("stick"))
	:toggleItem(itemCheck("iron_ingot"))
	:onToggle(pings.setAnimTogglePushUp)

a.flipPage = animsPage:newAction()
	:item(itemCheck("music_disc_wait"))
	:onLeftClick(pings.animPlayFrontFlip)
	:onRightClick(pings.animPlayBackFlip)

-- Update actions
function events.RENDER(delta, context)
	
	if action_wheel:isEnabled() then
		if a.pageAct then
			a.pageAct
				:title(toJson(
					{text = "Animation Settings", bold = true, color = c.primary}
				))
		end
		
		a.stretchPage
			:title(toJson(
				{text = "Play Stretch animation", bold = true, color = c.primary}
			))
		
		a.laughPage
			:title(toJson(
				{text = "Play Laugh animation", bold = true, color = c.primary}
			))
		
		a.pushUpPage
			:title(toJson(
				{text = "Toggle Push Up animation", bold = true, color = c.primary}
			))
			:toggled(anims.pushUp:isPlaying())
		
		a.flipPage
			:title(toJson(
				{
					"",
					{text = "Play Flip animation\n\n", bold = true, color = c.primary},
					{text = "Left click to Frontflip, right click to Backflip.\nMust not be on the ground.", color = c.secondary}
				}
			))
		
		for _, act in pairs(a) do
			act:hoverColor(c.hover)
		end
		
	end
	
end