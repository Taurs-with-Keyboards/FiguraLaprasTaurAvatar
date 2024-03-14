-- Required scripts
local parts      = require("lib.GroupIndex")(models)
local average       = require("lib.Average")
local ground        = require("lib.GroundCheck")
local itemCheck     = require("lib.ItemCheck")
local effects       = require("scripts.SyncedVariables")
local color         = require("scripts.ColorProperties")

-- Config setup
config:name("LaprasTaur")
local fallSound = config:load("FallSoundToggle")
local canDry    = config:load("FallSoundDry")
local dryTimer  = config:load("FallSoundDryTimer") or 400
if fallSound == nil then fallSound = true end
if canDry    == nil then canDry = true end

-- Variables setup
local wasInAir = false
local wetTicks = 0

-- Check if a splash potion is broken near the player
function events.ON_PLAY_SOUND(id, pos, vol, pitch, loop, category, path)
	
	if player:isLoaded() then
		local atPos    = pos < player:getPos() + 3 and pos > player:getPos() - 3
		local splashID = id == "minecraft:entity.splash_potion.break" or id == "minecraft:entity.lingering_potion.break"
		wetTicks = atPos and splashID and path and 0 or wetTicks
	end
	
end

function events.TICK()
	
	-- Manipulate tick timer
	wetTicks = not player:isWet() and wetTicks + 1 or 0
	
	-- Play sound if conditions are met
	if fallSound and wasInAir and ground() and not player:getVehicle() and not player:isInWater() and not effects.cF then
		if average(pokeballParts.Pokeball:getScale():unpack()) >= 0.5 then
			sounds:playSound("cobblemon:poke_ball.hit", player:getPos(), 0.25)
		else
			local vel    = math.abs(-player:getVelocity().y + 1)
			local dry    = canDry and (dryTimer - wetTicks) / dryTimer or 1
			local volume = math.clamp((vel * dry) / 2, 0, 1)
			
			if volume ~= 0 then
				sounds:playSound("minecraft:entity.puffer_fish.flop", player:getPos(), volume, math.map(volume, 1, 0, 0.35, 0.55))
			end
		end
	end
	wasInAir = not ground()
	
end

-- Sound toggle
local function setToggle(boolean)

	fallSound = boolean
	config:save("FallSoundToggle", fallSound)
	if host:isHost() and player:isLoaded() and fallSound then
		sounds:playSound("minecraft:entity.puffer_fish.flop", player:getPos(), 0.35, 0.6)
	end
	
end

-- Dry toggle
local function setDry(boolean)
	
	canDry = boolean
	config:save("FallSoundDry", canDry)
	
end

-- Set timer
local function setDryTimer(x)
	
	dryTimer = math.clamp(dryTimer + (x * 20), 100, 6000)
	config:save("FallSoundDryTimer", dryTimer)
	
end

-- Sync variables
local function syncFallSound(a, b, x)
	
	fallSound = a
	canDry = b
	dryTimer = x
	
end

-- Pings setup
pings.setFallSoundToggle = setToggle
pings.setFallSoundDry    = setDry
pings.syncFallSound      = syncFallSound

-- Sync on tick
if host:isHost() then
	function events.TICK()
		
		if world.getTime() % 200 == 0 then
			pings.syncFallSound(fallSound, canDry, dryTimer)
		end
		
	end
end

-- Activate actions
setToggle(fallSound)
setDry(canDry)

-- Table setup
local t = {}

-- Action wheel pages
t.soundPage = action_wheel:newAction()
	:item(itemCheck("sponge"))
	:toggleItem(itemCheck("wet_sponge"))
	:onToggle(pings.setFallSoundToggle)
	:toggled(fallSound)

t.dryPage = action_wheel:newAction()
	:item(itemCheck("water_bucket"))
	:toggleItem(itemCheck("leather"))
	:onToggle(pings.setFallSoundDry)
	:onScroll(setDryTimer)
	:onRightClick(function() dryTimer = 400 config:save("FallSoundDryTimer", dryTimer) end)
	:toggled(canDry)

-- Update action page info
function events.TICK()
	
	t.soundPage
		:title(color.primary.."Toggle Falling Sound\n\n"..color.secondary.."Toggles floping sound effects when landing on the ground.\nWhen inside your pokeball, a different sound plays.")
		:hoverColor(color.hover)
		:toggleColor(color.active)
	
	t.dryPage
		:title(color.primary.."Toggle Drying/Timer\n\n"..color.secondary.."Toggles the ability to dry, and how long it takes to dry off.\n\n"
		.."§lCurrent drying timer: §a"..(canDry and ((dryTimer / 20).." Seconds") or "None")
		..color.secondary.."\n\nScrolling up adds time, Scrolling down subtracts time.\nRight click resets timer to 20 seconds.")
		:hoverColor(color.hover)
		:toggleColor(color.active)
	
end

-- Return action wheel pages
return t