-- Required scripts
local model   = require("scripts.ModelParts")
local vehicle = require("scripts.Vehicles")

-- Animations setup
local anims = animations.Pokeball

-- Config setup
config:name("LaprasTaur")
local toggle = config:load("PokeballToggle") or false

-- Variables setup
local isInBall  = toggle
local wasInBall = toggle
local staticYaw = 0

-- Lerp scale table
local scale = {
	current    = 0,
	nextTick   = 0,
	target     = 0,
	currentPos = 0
}

-- Lerp pos table
local pos = {
	current    = 0,
	nextTick   = 0,
	target     = 0,
	currentPos = 0
}

-- Set lerp start on init
function events.ENTITY_INIT()
	
	staticYaw = -player:getBodyYaw()
	
	local apply = toggle and 0 or 1
	for k, v in pairs(scale) do
		scale[k] = apply
	end
	
end

function events.TICK()
	
	-- Pokeball check
	isInBall = ((toggle and not vehicle.isVehicle) or (vehicle.vehicle and not(vehicle.boat or vehicle.chest_boat) or (vehicle.isPassenger or vehicle.player))) or false
	
	-- Compare states
	if isInBall ~= wasInBall then
		-- Pokeball sounds
		if isInBall     then sounds:stopSound() sounds:playSound("cobblemon:poke_ball.recall",   player:getPos(), 0.15) end
		if not isInBall then sounds:stopSound() sounds:playSound("cobblemon:poke_ball.send_out", player:getPos(), 0.15) end
		
		if isInBall then 
			staticYaw = -player:getBodyYaw()
		end
		
		-- Animations
		anims.open:playing(not isInBall)
		anims.close:playing(isInBall)
	end
	
	-- Pos lerp
	pos.current  = pos.nextTick
	pos.nextTick = math.lerp(pos.nextTick, pos.target, 0.25)
	
	-- Scaling lerp
	scale.current  = scale.nextTick
	scale.nextTick = math.lerp(scale.nextTick, scale.target, 0.2)
	
	-- Store previous states
	wasInBall = isInBall
	
end

-- Rendering stuff
function events.RENDER(delta, context)
	
	-- Vehicle pos table
	local statePos = {
		{ state = vehicle.player,        pos = 10  },
		{ state = (vehicle.boat or vehicle.chest_boat) and
			vehicle.isPassenger,         pos = 14  },
		{ state = vehicle.boat,          pos = 8   },
		{ state = vehicle.chest_boat,    pos = 8   },
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
			pos.target = case.pos
			break
		elseif vehicle.vehicle then
			-- Unsupported cases
			pos.target = 10 -- Assumption
		else
			pos.target = 0
		end
	end
	
	-- Pos lerp
	pos.currentPos = math.lerp(pos.current, pos.nextTick, delta)
	
	-- Scaling target and lerp
	scale.target     = isInBall and 0 or 1
	scale.currentPos = math.lerp(scale.current, scale.nextTick, delta)
	
	-- GUI part reset
	if context ~= "RENDER" and context ~= "FIRST_PERSON" and context ~= "OTHER" then
		
		model.model:pos(nil)
		
		model.pokeball:visible(nil)
			:pos(nil)
			:rot(nil)
			:parentType("NONE")
		
	end
	
	renderer:shadowRadius(math.map(scale.currentPos, 0, 1, 0.2, 1.25))
	
end

-- Application post GUI reset
function events.POST_RENDER(delta, context)
	
	model.model:scale(scale.currentPos)
		:color(1, scale.currentPos, scale.currentPos)
		:pos(0, pos.currentPos, 0)
	
	model.pokeball:visible(not renderer:isFirstPerson())
		:scale(math.map(scale.currentPos, 0, 1, 1, 0))
		:pos(player:getPos(delta) * 16 + vec(0, pos.currentPos, 0))
		:rot(vec(0, staticYaw + 180, 0))
		:parentType("WORLD")
	
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
	local kbBack    = keybinds:newKeybind("Pokeball Back Blocker")   :onPress(function() if cantMove and not anims.wobbleBack:isPlaying()    then pings.playBackWobble()    end return cantMove end)
	local kbRight   = keybinds:newKeybind("Pokeball Right Blocker")  :onPress(function() if cantMove and not anims.wobbleRight:isPlaying()   then pings.playRightWobble()   end return cantMove end)
	local kbLeft    = keybinds:newKeybind("Pokeball Left Blocker")   :onPress(function() if cantMove and not anims.wobbleLeft:isPlaying()    then pings.playLeftWobble()    end return cantMove end)
	local kbJump    = keybinds:newKeybind("Pokeball Jump Blocker")   :onPress(function() return cantMove and player:isInWater() end)
	local kbCrouch  = keybinds:newKeybind("Pokeball Crouch Blocker") :onPress(function() return toggle end)
	local kbAttack  = keybinds:newKeybind("Pokeball Attack Blocker") :onPress(function() return cantMove end)
	local kbUse     = keybinds:newKeybind("Pokeball Use Blocker")    :onPress(function() return cantMove end)

	-- Keybind maintainer (Prevents changes)
	function events.TICK()
		cantMove = (toggle or vehicle.isPassenger or vehicle.player)
		kbForward:key(keybinds:getVanillaKey("key.forward"))
		kbBack   :key(keybinds:getVanillaKey("key.back")   )
		kbRight  :key(keybinds:getVanillaKey("key.right")  )
		kbLeft   :key(keybinds:getVanillaKey("key.left")   )
		kbJump   :key(keybinds:getVanillaKey("key.jump")   )
		kbCrouch :key(keybinds:getVanillaKey("key.sneak")  )
		kbAttack :key(keybinds:getVanillaKey("key.attack") )
		kbUse    :key(keybinds:getVanillaKey("key.use")    )
	end
end

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

-- Table setup
local t = {}

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