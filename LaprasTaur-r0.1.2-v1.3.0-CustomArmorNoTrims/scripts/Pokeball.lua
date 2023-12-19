-- Models setup
local pokeball = models.Pokeball
local model    = models.LaprasTaur

-- Animation setup
local anims = animations.Pokeball

-- Table setup
local t = {}

-- Config setup
config:name("LaprasTaur")
local toggle = config:load("PokeballToggle") or false

-- Variables
local isInBall  = toggle
local wasInBall = toggle
local staticRot = 0
t.scale         = 0
local vehicle   = require("scripts.Vehicles")
local hasPower  = require("lib.OriginsAPI").hasPower

-- Lerping variables
local startScale = toggle and 0 or 1
local scaleCurrent, scaleNextTick, scaleTarget, scaleCurrentPos = startScale, startScale, startScale, startScale
local posCurrent,   posNextTick,   posTarget,   posCurrentPos   = 0, 0, 0, 0
function events.TICK()
	-- Pokeball check
	isInBall = ((toggle and not vehicle.isVehicle) or (not hasPower(player, "origins:lapras_dismount") and (vehicle.vehicle and not(vehicle.boat or vehicle.chest_boat)) or (vehicle.isPassenger or vehicle.player))) or false
	
	-- Compare states
	if isInBall ~= wasInBall then
		-- Pokeball sounds
		if isInBall     then sounds:stopSound() sounds:playSound("cobblemon:poke_ball.recall",   player:getPos(), 0.15) end
		if not isInBall then sounds:stopSound() sounds:playSound("cobblemon:poke_ball.send_out", player:getPos(), 0.15) end
		
		if isInBall then 
			staticRot = -player:getRot().y
		end
		
		-- Animations
		anims.open:setPlaying(not isInBall)
		anims.close:setPlaying(isInBall)
	end
	
	-- Pos lerp
	posCurrent  = posNextTick
	posNextTick = math.lerp(posNextTick, posTarget, 0.25)
	
	-- Scaling lerp
	scaleCurrent  = scaleNextTick
	scaleNextTick = math.lerp(scaleNextTick, scaleTarget, 0.2)
	
	-- Store previous states
	wasInBall = isInBall
end

-- Rendering stuff
function events.RENDER(delta, context)
	if context == "FIRST_PERSON" or context == "RENDER" or (not client.isHudEnabled() and context ~= "MINECRAFT_GUI") then
		-- Vehicle pos table
		local statePos = {
			{ state = vehicle.player,        pos = 10  },
			{ state = (vehicle.boat or vehicle.chest_boat) and
				vehicle.isPassenger,         pos = 14  },
			{ state = vehicle.boat,          pos = 8   },
			{ state = vehicle.chest_boat,    pos = 0   },
			{ state = vehicle.minecart,      pos = 9   },
			{ state = vehicle.horse,         pos = 10  },
			{ state = vehicle.donkey,        pos = 10  },
			{ state = vehicle.mule,          pos = 10  },
			{ state = vehicle.zombieHorse,   pos = 8   },
			{ state = vehicle.skeletonHorse, pos = 11  },
			{ state = vehicle.pig,           pos = 10  },
			{ state = vehicle.strider,       pos = 10  },
			{ state = vehicle.camel,         pos = 9   },
		}
		
		-- Base position check
		for _, case in ipairs(statePos) do
			if case.state then
				posTarget = case.pos
				break
			elseif vehicle.vehicle then
				-- Unsupported cases
				posTarget = 10 -- Assumption
			else
				posTarget = 0
			end
		end
		
		-- Pos lerp
		posCurrentPos = math.lerp(posCurrent, posNextTick, delta)
		
		-- Scaling target and lerp
		scaleTarget     = isInBall and 0 or 1
		scaleCurrentPos = math.lerp(scaleCurrent, scaleNextTick, delta)
		
		-- Apply scale, color, & pos
		-- Lapras
		model:setScale(scaleCurrentPos)
			:setColor(1, scaleCurrentPos, scaleCurrentPos)
			:setPos(vec(0, posCurrentPos, 0))
		
		-- Pokeball
		pokeball:setVisible(context ~= "FIRST_PERSON")
			:setScale(math.map(scaleCurrentPos, 0, 1, 1, 0) * (vehicle.player and 0.5 or 1))
			:setPos(vec(0, posCurrentPos, 0))
			:setRot(vehicle.player and 0 or vec(0, staticRot + player:getBodyYaw(delta), 0))
		
		-- Shadow
		renderer:setShadowRadius(math.map(scaleCurrentPos, 0, 1, 0.2, 1.25))
		
		t.scale = scaleCurrentPos
	end
end

-- Keybind animations/blockers
local function forwardWobble()
	anims.wobbleForward:play()
end

local function backWobble()
	anims.wobbleBack:play()
end

local function rightWobble()
	anims.wobbleRight:play()
end

local function leftWobble()
	anims.wobbleLeft:play()
end

-- Keybind ping setup
pings.playForwardWobble = forwardWobble
pings.playBackWobble    = backWobble
pings.playRightWobble   = rightWobble
pings.playLeftWobble    = leftWobble

if host:isHost() then
	local cantMove  = (toggle or vehicle.isPassenger or vehicle.player)
	local kbForward = keybinds:newKeybind("Pokeball Forward Blocker"):onPress(function() if cantMove and not anims.wobbleForward:isPlaying() then pings.playForwardWobble() end return cantMove end)
	local kbBack    = keybinds:newKeybind("Pokeball Back Blocker"   ):onPress(function() if cantMove and not anims.wobbleBack:isPlaying() then pings.playBackWobble() end return cantMove end)
	local kbRight   = keybinds:newKeybind("Pokeball Right Blocker"  ):onPress(function() if cantMove and not anims.wobbleRight:isPlaying() then pings.playRightWobble() end return cantMove end)
	local kbLeft    = keybinds:newKeybind("Pokeball Left Blocker"   ):onPress(function() if cantMove and not anims.wobbleLeft:isPlaying() then pings.playLeftWobble() end return cantMove end)
	local kbJump    = keybinds:newKeybind("Pokeball Jump Blocker"   ):onPress(function() return cantMove and player:isInWater() end)
	local kbCrouch  = keybinds:newKeybind("Pokeball Crouch Blocker" ):onPress(function() return toggle end)
	local kbAttack  = keybinds:newKeybind("Pokeball Attack Blocker" ):onPress(function() return cantMove end)
	local kbUse     = keybinds:newKeybind("Pokeball Use Blocker"    ):onPress(function() return cantMove end)

	-- Keybind maintainer (Prevents changes)
	function events.TICK()
		cantMove = (toggle or vehicle.isPassenger or vehicle.player)
		kbForward:setKey(keybinds:getVanillaKey("key.forward"))
		kbBack:setKey(keybinds:getVanillaKey("key.back"))
		kbRight:setKey(keybinds:getVanillaKey("key.right"))
		kbLeft:setKey(keybinds:getVanillaKey("key.left"))
		kbJump:setKey(keybinds:getVanillaKey("key.jump"))
		kbCrouch:setKey(keybinds:getVanillaKey("key.sneak"))
		kbAttack:setKey(keybinds:getVanillaKey("key.attack"))
		kbUse:setKey(keybinds:getVanillaKey("key.use"))
	end
end

-- Store texture
avatar:store("PokeballTexture", textures["textures.misc.pokeballModel"])

-- Pokeball toggler
local function setPokeball(boolean)
	toggle = boolean
	config:save("PokeballToggle", toggle)
end

-- Sync variable
local function syncPokeball(a)
	toggle = a
end

-- Ping setup
pings.setPokeball  = setPokeball
pings.syncPokeball = syncPokeball

-- Sync on tick
if host:isHost() then
	function events.TICK()
		if world.getTime() % 200 == 0 then
			pings.syncPokeball(toggle)
		end
	end
end

-- Activate action
setPokeball(toggle)

-- Return action wheel page
t.togglePage = action_wheel:newAction("Pokeball")
	:title("§9§lToggle Pokeball\n\n§bAuto activates/deactivates on vehicles.")
	:hoverColor(vectors.hexToRGB("5EB7DD"))
	:toggleColor(vectors.hexToRGB("4078B0"))
	:texture(textures["textures.misc.pokeballIcon"])
	:onToggle(pings.setPokeball)
	:toggled(toggle)

-- Return action wheel page (and toggle)
return t