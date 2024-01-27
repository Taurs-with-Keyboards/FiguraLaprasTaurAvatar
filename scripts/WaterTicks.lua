-- Config setup
config:name("LaprasTaur")

-- Table setup
local t = {
	wet   = 0, -- Rain
	water = 0, -- In Water
	under = 0  -- Underwater
}

-- Set variable start on init
function events.ENTITY_INIT()
	
	local apply = config:load("FallSoundDryTimer") or 400
	for k, v in pairs(t) do
		t[k] = apply
	end
	
end

-- Check if a splash potion is broken near the player
local splash = false
function events.ON_PLAY_SOUND(id, pos, vol, pitch, loop, category, path)
	
	if player:isLoaded() then
		local atPos      = pos < player:getPos() + 2 and pos > player:getPos() - 2
		local splashID   = id == "minecraft:entity.splash_potion.break" or id == "minecraft:entity.lingering_potion.break"
		splash = atPos and splashID and path
	end
	
end

-- Each tick add one to each timer. Reset if confition met.
function events.TICK()
	
	-- Add if not currently riptiding.
	if not player:riptideSpinning() then
		t.wet   = t.wet   + 1
		t.water = t.water + 1
		t.under = t.under + 1
	end
	
	-- Check for if player touches any liquid
	if player:isWet() or splash or player:isInLava() then
		t.wet   = 0
		splash  = false
	end
	
	-- Check for if player is in water
	if player:isInWater() or player:isInLava() then
		t.water = 0
	end
	
	-- Check for if player has gone underwater 
	if player:isUnderwater() or player:isInLava() then
		t.under = 0
	end
	
end

-- Return table
return t