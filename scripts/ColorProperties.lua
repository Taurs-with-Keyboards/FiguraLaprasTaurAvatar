-- Required scripts
local pokemonParts = require("lib.GroupIndex")(models.models.LaprasTaur)
local itemCheck    = require("lib.ItemCheck")

-- Config setup
config:name("LaprasTaur")
local shiny = config:load("ShinyToggle") == nil and vec(client.uuidToIntArray(avatar:getUUID())).x % 4096 == 0 or config:load("ShinyToggle")

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
	pokemonParts.SpikeMF.Spike,
	pokemonParts.SpikeMM.Spike,
	pokemonParts.SpikeMB.Spike,
	pokemonParts.SpikeLS.Spike,
	pokemonParts.SpikeLF.Spike,
	pokemonParts.SpikeLB.Spike,
	pokemonParts.SpikeRS.Spike,
	pokemonParts.SpikeRF.Spike,
	pokemonParts.SpikeRB.Spike,
	
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
	t.active    = vectors.hexToRGB(shiny and "F3C9B9" or "EFDBBC")
	t.primary   = "#"..(shiny and "9775CE" or "5EB7DD")
	t.secondary = "#"..(shiny and "F3C9B9" or "EFDBBC")
	
	-- Shiny textures
	local textureType = shiny and (textures["textures.lapras_shiny"] or textures["models.LaprasTaur.lapras_shiny"]) or (textures["textures.lapras"] or textures["models.LaprasTaur.lapras"])
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
		:title(toJson(
			{
				"",
				{text = "Toggle Shiny Textures\n\n", bold = true, color = t.primary},
				{text = "Set the lower body to use shiny textures over the default textures.", color = t.secondary}
			}
		))
		:hoverColor(t.hover)
		:toggleColor(t.active)
	
end

-- Return table
return t