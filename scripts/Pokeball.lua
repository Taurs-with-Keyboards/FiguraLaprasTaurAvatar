-- Required scripts
local model   = require("scripts.ModelParts")
local vehicle = require("scripts.Vehicles")
local squapi  = require("lib.SquAPI")

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

-- Keybind
local toggleBind   = config:load("PokeballToggleKeybind") or "key.keyboard.keypad.1"
local setToggleKey = keybinds:newKeybind("Pokeball Toggle"):onPress(function() pings.setPokeball(not toggle) end):key(toggleBind)

-- Keybind updater
function events.TICK()
	
	local key = setToggleKey:getKey()
	if key ~= toggleBind then
		toggleBind = key
		config:save("PokeballToggleKeybind", key)
	end
	
end

-- Sync on tick
if host:isHost() then
	function events.TICK()
		if world.getTime() % 200 == 0 then
			pings.syncPokeball(toggle)
		end
	end
end

local lean        = 15
local leanForward = 0
local leanBack    = 0
local leanLeft    = 0
local leanRight   = 0

-- Keybind animations/blockers
local function forwardTilt(bool)
	
	leanForward = bool and lean or 0
	
end

local function backTilt(bool)
	
	leanBack = bool and lean or 0
	
end

local function leftTilt(bool)
	
	leanLeft = bool and lean or 0
	
end

local function rightTilt(bool)
	
	leanRight = bool and lean or 0
	
end

-- Keybind ping setup
pings.pokeballForwardTilt = forwardTilt
pings.pokeballBackTilt    = backTilt
pings.pokeballLeftTilt    = leftTilt
pings.pokeballRightTilt   = rightTilt

local stop
local kbForward = keybinds:newKeybind("Pokeball Tilt Forward") :onPress(function() pings.pokeballForwardTilt(true) return stop end):onRelease(function() pings.pokeballForwardTilt(false) end)
local kbBack    = keybinds:newKeybind("Pokeball Tilt Backward"):onPress(function() pings.pokeballBackTilt(true)    return stop end):onRelease(function() pings.pokeballBackTilt(false)    end)
local kbLeft    = keybinds:newKeybind("Pokeball Tilt Left")    :onPress(function() pings.pokeballLeftTilt(true)    return stop end):onRelease(function() pings.pokeballLeftTilt(false)    end)
local kbRight   = keybinds:newKeybind("Pokeball Tilt Right")   :onPress(function() pings.pokeballRightTilt(true)   return stop end):onRelease(function() pings.pokeballRightTilt(false)   end)
local kbJump    = keybinds:newKeybind("Pokeball Block Jump")   :onPress(function() return stop and player:isInWater() end)
local kbCrouch  = keybinds:newKeybind("Pokeball Block Crouch") :onPress(function() return toggle end)
local kbAttack  = keybinds:newKeybind("Pokeball Block Attack") :onPress(function() return stop end)
local kbUse     = keybinds:newKeybind("Pokeball Block Use")    :onPress(function() return stop end)

-- Keybind maintainer (Prevents changes)
function events.TICK()
	
	stop         = (toggle or vehicle.isPassenger or vehicle.player)
	local enable = scale.currentPos < 0.5
	
	kbForward:key(keybinds:getVanillaKey("key.forward")):enabled(enable)
	kbBack   :key(keybinds:getVanillaKey("key.back")   ):enabled(enable)
	kbRight  :key(keybinds:getVanillaKey("key.right")  ):enabled(enable)
	kbLeft   :key(keybinds:getVanillaKey("key.left")   ):enabled(enable)
	kbJump   :key(keybinds:getVanillaKey("key.jump")   ):enabled(enable)
	kbCrouch :key(keybinds:getVanillaKey("key.sneak")  ):enabled(enable)
	kbAttack :key(keybinds:getVanillaKey("key.attack") ):enabled(enable)
	kbUse    :key(keybinds:getVanillaKey("key.use")    ):enabled(enable)
	
end

-- Pokeball physics
squapi.pokeball = squapi.bounceObject:new()

function events.RENDER(delta, context)
	
	model.pokeball:offsetRot(squapi.pokeball.pos)
	
	local target = vec(leanBack - leanForward, 0, leanRight - leanLeft)
	
	squapi.pokeball:doBounce(target, 0.01, .075)
	
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