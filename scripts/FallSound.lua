-- Config setup
config:name("LaprasTaur")
local fallSound = config:load("FallSoundToggle")
if fallSound == nil then fallSound = true end
local canDry = config:load("FallSoundDry")
if canDry == nil then canDry = true end
local dryTimer = config:load("FallSoundDryTimer") or 400

-- Variables setup
local ticks  = require("scripts.WaterTicks")
local ground = require("lib.GroundCheck")

-- Sound player
local wasInAir = false
function events.TICK()
	if fallSound and wasInAir and ground() and not player:getVehicle() and not player:isInWater() then
		if models.Pokeball:getScale():length() > 0.5 then
			sounds:playSound("cobblemon:poke_ball.hit", player:getPos(), 0.25)
		else
			local vel    = math.abs(-player:getVelocity().y + 1)
			local dry    = canDry and (dryTimer - ticks.wet) / dryTimer or 1
			local volume = math.clamp((vel * dry) / 2, 0, 1)
			if volume ~= 0 then
				sounds:playSound("minecraft:entity.puffer_fish.flop", player:getPos(), volume, math.map(volume, 1, 0, 0.45, 0.65))
			end
		end
	end
	wasInAir = not ground()
end

-- Sound toggler
local function setToggle(boolean)
	fallSound = boolean
	config:save("FallSoundToggle", fallSound)
	if host:isHost() and player:isLoaded() and fallSound then
		sounds:playSound("minecraft:entity.puffer_fish.flop", player:getPos(), 0.35, 0.6)
	end
end

-- Dry toggler
local function setDry(boolean)
	canDry = boolean
	config:save("FallSoundDry", canDry)
end

-- Set timer function
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

-- Setup ping
pings.setFallSoundToggle = setToggle
pings.setFallSoundDry    = setDry
pings.syncFallSound      = syncFallSound

-- Activate action
setToggle(fallSound)
setDry(canDry)

-- Sync on tick
if host:isHost() then
	function events.TICK()
		if world.getTime() % 200 == 0 then
			pings.syncFallSound(fallSound, canDry, dryTimer)
		end
	end
end

-- Table setup
local t = {}

-- Action wheel pages
t.soundPage = action_wheel:newAction("FallSound")
	:title("§9§lToggle Falling Sound\n\n§bToggles floping sound effects when landing on the ground.\nWhen inside your pokeball, a different sound plays.")
	:hoverColor(vectors.hexToRGB("5EB7DD"))
	:toggleColor(vectors.hexToRGB("4078B0"))
	:item("minecraft:sponge")
	:toggleItem("minecraft:wet_sponge")
	:onToggle(pings.setFallSoundToggle)
	:toggled(fallSound)

t.dryPage = action_wheel:newAction("FallSoundDrying")
	:hoverColor(vectors.hexToRGB("5EB7DD"))
	:toggleColor(vectors.hexToRGB("4078B0"))
	:item("minecraft:water_bucket")
	:toggleItem("minecraft:leather")
	:onToggle(pings.setFallSoundDry)
	:onScroll(setDryTimer)
	:onRightClick(function() dryTimer = 400 config:save("FallSoundDryTimer", dryTimer) end)
	:toggled(canDry)

-- Update dry page info
function events.TICK()
	t.dryPage
		:title("§9§lToggle Drying/Timer\n\n§3Current drying timer: "..
		(canDry and ("§b§l"..(dryTimer / 20).." §3Seconds") or "§bNone")..
		"\n\n§bToggles the gradual drying of your tail until your legs form again.\n\nScrolling up adds time, Scrolling down subtracts time.\nRight click resets timer to 20 seconds.")
end

return t