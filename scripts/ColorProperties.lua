-- Required scripts
local pokemonParts = require("lib.GroupIndex")(models.models.LaprasTaur)
local itemCheck    = require("lib.ItemCheck")

-- Config setup
config:name("LaprasTaur")
local shiny = config:load("ColorShiny") or false

-- All shiny parts
local shinyParts = {
	
	pokemonParts.Ears,
	pokemonParts.Horn,
	
	pokemonParts.EarsSkull,
	pokemonParts.HornSkull,
	
	pokemonParts.HornPortrait,
	
	pokemonParts.Neck.Neck,
	pokemonParts.Main.Main,
	
	pokemonParts.Shell.External,
	pokemonParts.Shell.Internal,
	pokemonParts.SpikesParts,
	
	pokemonParts.FrontLeftFlipper.Flipper,
	pokemonParts.FrontLeftFlipperTip.Flipper,
	pokemonParts.FrontRightFlipper.Flipper,
	pokemonParts.FrontRightFlipperTip.Flipper,
	pokemonParts.BackLeftFlipper.Flipper,
	pokemonParts.BackLeftFlipperTip.Flipper,
	pokemonParts.BackRightFlipper.Flipper,
	pokemonParts.BackRightFlipperTip.Flipper,
	
	pokemonParts.Tail.Tail,
	pokemonParts.TailTip.Tail
	
}

-- Table setup
local t = {}

function events.TICK()
	
	-- Set colors
	t.hover     = vectors.hexToRGB(shiny and "9775CE" or "5EB7DD")
	t.active    = vectors.hexToRGB(shiny and "704391" or "4078B0")
	t.primary   = (shiny and "§5" or "§9").."§l"
	t.secondary = shiny and "§d" or "§b"
	
	-- Shiny textures
	local textureType = shiny and textures["textures.lapras_shiny"] or textures["textures.lapras"]
	for _, part in ipairs(shinyParts) do
		part:primaryTexture("Custom", textureType)
	end
	
	-- Glowing outline
	renderer:outlineColor(vectors.hexToRGB(shiny and "9775CE" or "5EB7DD"))
	
	-- Avatar color
	avatar:color(vectors.hexToRGB(shiny and "9775CE" or "5EB7DD"))
	
end

-- Shiny toggle
local function setShiny(boolean)
	
	shiny = boolean
	config:save("ColorShiny", shiny)
	if player:isLoaded() and shiny then
		sounds:playSound("block.amethyst_block.chime", player:getPos())
	end
	
end

-- Sync variables
local function syncColor(a)
	
	shiny = a
	
end

-- Pings setup
pings.setColorShiny = setShiny
pings.syncColor     = syncColor

-- Sync on tick
if host:isHost() then
	function events.TICK()
		
		if world.getTime() % 200 == 0 then
			pings.syncColor(shiny)
		end
		
	end
end

-- Activate actions
setShiny(shiny)

t.shinyPage = action_wheel:newAction()
	:item(itemCheck("gunpowder"))
	:toggleItem(itemCheck("glowstone_dust"))
	:onToggle(pings.setColorShiny)
	:toggled(shiny)

-- Update action page info
function events.TICK()
	
	t.shinyPage
		:title(t.primary.."Toggle Shiny Textures\n\n"..t.secondary.."Set the lower body to use shiny textures over the default textures.")
		:hoverColor(t.hover)
		:toggleColor(t.active)
	
end

-- Return table
return t