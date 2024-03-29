-- Required scripts
require("lib.GSAnimBlend")
local pokemonParts = require("lib.GroupIndex")(models.models.LaprasTaur)
local ground       = require("lib.GroundCheck")
local pose         = require("scripts.Posing")

-- Animations setup
local anims = animations["models.LaprasTaur"]
anims.napHold:priority(1)

-- Config setup
config:name("LaprasTaur")

-- Variables setup
local waterTicks      = 0
local underwaterTicks = 0
local canStretch      = false
local canFlip         = false

local extendRot = {
	current    = 0,
	nextTick   = 0,
	target     = 0,
	currentPos = 0
}

-- Parrot pivots
local parrots = {
	
	pokemonParts.LeftParrotPivot,
	pokemonParts.RightParrotPivot
	
}

-- Calculate parent's rotations
local function calculateParentRot(m)
	
	local parent = m:getParent()
	if not parent then
		return m:getTrueRot()
	end
	return calculateParentRot(parent) + m:getTrueRot()
	
end

function events.TICK()
	
	-- Player variables
	local vel = player:getVelocity()
	
	-- Water timers
	waterTicks      = not player:isInWater()    and waterTicks + 1      or 0
	underwaterTicks = not player:isUnderwater() and underwaterTicks + 1 or 0
	
	-- Animation variables
	local walking    = vel.xz:length() ~= 0
	local inWater    = waterTicks      < 20
	local underwater = underwaterTicks < 20
	local onGround   = ground()
	
	-- Animation states
	local groundIdle     = not walking and (not (inWater or player:getVehicle()) or onGround) and not ((pose.swim and inWater) or pose.elytra) or pose.spin or (pose.climb and vel:length() == 0)
	local groundWalk     =     walking and (not (inWater or player:getVehicle()) or onGround) and not ((pose.swim and inWater) or pose.elytra or pose.spin) or (pose.climb and vel:length() ~= 0)
	local waterIdle      = not walking and ((inWater or player:getVehicle()) and not onGround) and not pose.elytra and not underwater
	local waterSwim      =     walking and ((inWater or player:getVehicle()) and not onGround) and not pose.elytra and not underwater
	local underwaterIdle = vel:length() == 0 and underwater and (not onGround or pose.swim) and not pose.elytra
	local underwaterSwim = vel:length() ~= 0 and underwater and (not onGround or pose.swim) and not pose.elytra
	local extend         = pose.swim or pose.elytra
	local climb          = pose.climb and not onGround
	local elytra         = pose.elytra
	local sleep          = pose.sleep
	local breathe        = true
	
	-- Targets
	extendRot.target = extend and 1 or 0
	
	-- Tick lerp
	extendRot.current  = extendRot.nextTick
	extendRot.nextTick = math.lerp(extendRot.nextTick, extendRot.target, 0.2)
	
	-- Animations
	anims.groundIdle:playing(groundIdle)
	anims.groundWalk:playing(groundWalk)
	anims.waterIdle:playing(waterIdle)
	anims.waterSwim:playing(waterSwim)
	anims.underwaterIdle:playing(underwaterIdle)
	anims.underwaterSwim:playing(underwaterSwim)
	anims.extend:playing(extend)
	anims.climb:playing(climb)
	anims.elytra:playing(elytra)
	anims.breathe:playing(breathe)
	
	-- Allow root rotations
	local vanillaRot = not (anims.extend:isPlaying() or sleep)
	renderer:rootRotationAllowed(vanillaRot)
	
	-- Sleep animations
	if pose.sleep and not anims.napHold:isPlaying() then
		
		anims.napDown:play()
		
	elseif not pose.sleep and (anims.napDown:isPlaying() or anims.napHold:isPlaying()) then
		
		anims.napDown:stop()
		anims.napHold:stop()
		anims.napUp:play()
		
	end
	
	-- Stretch animations
	canStretch = onGround and vel:length() == 0
	if not canStretch then
		
		anims.stretch:stop()
		
	end
	
	-- Laugh animations
	canLaugh = vel:length() == 0
	if not canLaugh then
		
		anims.laugh:stop()
		
	end
	
	-- Flip animations
	canFlip = not onGround and #player:getPassengers() == 0
	if not canFlip then
		
		anims.frontFlip:stop()
		anims.backFlip:stop()
		
	end
	
end

-- Sleep rotations
local dirRot = {
	north = 0,
	east  = 270,
	south = 180,
	west  = 90
}

function events.RENDER(delta, context)
	
	-- Player variables
	local vel = player:getVelocity()
	local dir = player:getLookDir()
	
	-- Directional velocity
	local fbVel = player:getVelocity():dot((dir.x_z):normalize())
	local lrVel = player:getVelocity():cross(dir.x_z:normalize()).y
	local udVel = player:getVelocity().y
	
	-- Render lerp
	extendRot.currentPos = math.lerp(extendRot.current, extendRot.nextTick, delta)
	
	-- Animation speeds
	local moveSpeed = math.clamp(pose.climb and udVel * 15 or (fbVel < -0.05 and math.min(fbVel, math.abs(lrVel)) or math.max(fbVel, math.abs(lrVel))) * 15, -2, 2)
	local waterSpeed = player:isUnderwater() and 0.5 or 1
	anims.groundWalk:speed(moveSpeed)
	anims.waterSwim:speed(moveSpeed)
	anims.underwaterSwim:speed(moveSpeed)
	anims.breathe:speed(math.min(vel:length() * 15 + 1, 8))
	
	-- Simulate rotations when vanilla rotations are disabled
	-- Aka player rotations
	if not renderer:getRootRotationAllowed() then
		
		-- Sleep rotation
		if pose.sleep then
			
			-- Find block
			local block = world.getBlockState(player:getPos())
			local sleepRot = dirRot[block.properties["facing"]]
			
			-- Apply
			models:rot(0, sleepRot, 0)
			
		else
			
			local rot = ((player:getRot(delta) + 180) % 360 - 180)
			local yaw = ((player:getBodyYaw(delta) + 180) % 360 - 180)
			
			-- Apply
			models:rot(math.lerp(0, -rot.x, extendRot.currentPos), -yaw + 180, 0)
			
		end
		
	else
		
		-- Reset rotation
		models:rot(0)
		
	end
	
	-- Parrot rot offset
	for _, parrot in pairs(parrots) do
		parrot:rot(-calculateParentRot(parrot:getParent()))
	end
	
end

-- GS Blending Setup
local blendAnims = {
	{ anim = anims.groundIdle,     ticks = 7  },
	{ anim = anims.groundWalk,     ticks = 7  },
	{ anim = anims.waterIdle,      ticks = 7  },
	{ anim = anims.waterSwim,      ticks = 7  },
	{ anim = anims.underwaterIdle, ticks = 7  },
	{ anim = anims.underwaterSwim, ticks = 7  },
	{ anim = anims.extend,         ticks = 14 },
	{ anim = anims.climb,          ticks = 7  },
	{ anim = anims.elytra,         ticks = 7  },
	{ anim = anims.stretch,        ticks = 7  },
	{ anim = anims.laugh,          ticks = 7  },
	{ anim = anims.napDown,        ticks = 7  },
	{ anim = anims.napUp,          ticks = 7  }
}
	
for _, blend in ipairs(blendAnims) do
	blend.anim:blendTime(blend.ticks):onBlend("easeOutQuad")
end

-- Fixing spyglass jank
function events.RENDER(delta, context)
	
	local rot = vanilla_model.HEAD:getOriginRot()
	rot.x = math.clamp(rot.x, -90, 30)
	pokemonParts.Spyglass:rot(rot)
		:pos(pose.crouch and vec(0, -4, 0) or nil)
	
end

-- Play stretch anim
local function playStretch()
	
	if canStretch then
		anims.stretch:play()
	end
	
end

-- Play laugh anim
local function playLaugh()
	
	if canLaugh then
		anims.laugh:play()
	end
	
end

-- Play front flip anim
local function playFrontFlip()
	
	if canFlip and not anims.backFlip:isPlaying() then
		anims.frontFlip:play()
	end
	
end

-- Play back flip anim
local function playBackFlip()
	
	if canFlip and not anims.frontFlip:isPlaying() then
		anims.backFlip:play()
	end
	
end

-- Pings setup
pings.animPlayStretch   = playStretch
pings.animPlayLaugh     = playLaugh
pings.animPlayFrontFlip = playFrontFlip
pings.animPlayBackFlip  = playBackFlip

-- Stretch keybind
local stretchBind   = config:load("AnimStretchKeybind") or "key.keyboard.keypad.3"
local setStretchKey = keybinds:newKeybind("Stretch Animation"):onPress(pings.animPlayStretch):key(stretchBind)

-- Stretch keybind
local laughBind   = config:load("AnimLaughKeybind") or "key.keyboard.keypad.4"
local setLaughKey = keybinds:newKeybind("Laugh Animation"):onPress(pings.animPlayLaugh):key(laughBind)

-- FrontFlip keybind
local frontFlipBind   = config:load("AnimFrontFlipKeybind") or "key.keyboard.keypad.5"
local setFrontFlipKey = keybinds:newKeybind("Front Flip Animation"):onPress(pings.animPlayFrontFlip):key(frontFlipBind)

-- FrontFlip keybind
local backFlipBind   = config:load("AnimBackFlipKeybind") or "key.keyboard.keypad.6"
local setBackFlipKey = keybinds:newKeybind("Back Flip Animation"):onPress(pings.animPlayBackFlip):key(backFlipBind)

-- Keybind updaters
function events.TICK()
	
	local stretchKey   = setStretchKey:getKey()
	local laughKey     = setLaughKey:getKey()
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
	if frontFlipKey ~= frontFlipBind then
		frontFlipBind = frontFlipKey
		config:save("AnimFrontFLipKeybind", frontFlipKey)
	end
	if backFlipKey ~= backFlipBind then
		backFlipBind = backFlipKey
		config:save("AnimBackFLipKeybind", backFlipKey)
	end
	
end

-- Setup table
local t = {}

t.stretchPage = action_wheel:newAction()
	:item(itemCheck("scaffolding"))
	:onLeftClick(pings.animPlayStretch)

t.laughPage = action_wheel:newAction()
	:item(itemCheck("cookie"))
	:onLeftClick(pings.animPlayLaugh)

t.frontFlipPage = action_wheel:newAction()
	:item(itemCheck("music_disc_wait"))
	:onLeftClick(pings.animPlayFrontFlip)

t.backFlipPage = action_wheel:newAction()
	:item(itemCheck("music_disc_blocks"))
	:onLeftClick(pings.animPlayBackFlip)

-- Update action page info
function events.TICK()
	
	t.stretchPage
		:title(color.primary.."Play Stretch animation")
		:hoverColor(color.hover)
	
	t.laughPage
		:title(color.primary.."Play Laugh animation")
		:hoverColor(color.hover)
	
	t.frontFlipPage
		:title(color.primary.."Play Front Flip animation")
		:hoverColor(color.hover)
	
	t.backFlipPage
		:title(color.primary.."Play Back Flip animation")
		:hoverColor(color.hover)
	
end

-- Returns animation variables/action wheel pages
return t