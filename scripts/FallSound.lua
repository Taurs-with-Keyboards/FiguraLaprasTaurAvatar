-- Required scripts
local model      = require("scripts.ModelParts")
local waterTicks = require("scripts.WaterTicks")
local ground     = require("lib.GroundCheck")

-- Config setup
config:name("LaprasTaur")
local fallSound = config:load("FallSoundToggle")
local canDry    = config:load("FallSoundDry")
local dryTimer  = config:load("FallSoundDryTimer") or 400
if fallSound == nil then fallSound = true end
if canDry    == nil then canDry = true end

-- Variables setup
local wasInAir = false

-- Get the average of a vector
local function average(vec)
	
	local sum = 0
	for _, v in ipairs{vec:unpack()} do
		sum = sum + v
	end
	return sum / #vec
	
end

function events.TICK()
	
	-- Play sound if conditions are met
	if fallSound and wasInAir and ground() and not player:getVehicle() and not player:isInWater() then
		if average(model.pokeball:getScale()) > 0.5 then
			sounds:playSound("cobblemon:poke_ball.hit", player:getPos(), 0.25)
		else
			local vel    = math.abs(-player:getVelocity().y + 1)
			local dry    = canDry and (dryTimer - waterTicks) / dryTimer or 1
			local volume = math.clamp((vel * dry) / 2, 0, 1)
			
			if volume ~= 0 then
				sounds:playSound("minecraft:entity.puffer_fish.flop", player:getPos(), volume, math.map(volume, 1, 0, 0.45, 0.65))
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