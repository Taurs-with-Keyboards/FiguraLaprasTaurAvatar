-- Required script
local parts = require("lib.PartsAPI")

-- Config setup
config:name("LaprasTaur")
local shiny = config:load("ShinyToggle") == nil and vec(client.uuidToIntArray(avatar:getUUID())).x % 4096 == 0 or config:load("ShinyToggle")

-- All shiny parts
local shinyParts = parts:createTable(function(part) return part:getName():find("_[sS]hiny") end)

-- Variables
local wasShiny = not shiny
local initAvatarColor = vectors.hexToRGB(avatar:getColor() or "default")
local initGlowColor = renderer:getOutlineColor() or vec(1, 1, 1)

-- Textures
local normalTex = textures["textures.lapras"]       or textures["models.LaprasTaur.lapras"]
local shinyTex  = textures["textures.lapras_shiny"] or textures["models.LaprasTaur.lapras_shiny"]

function events.RENDER(delta, context)
	
	-- Shiny textures
	if shiny ~= wasShiny then
		for _, part in ipairs(shinyParts) do
			part:primaryTexture("CUSTOM", shiny and shinyTex or normalTex)
		end
	end
	
	-- Store data
	wasShiny = shiny
	
	-- Avatar color
	avatar:color(shiny and vectors.hexToRGB("9775CE") or initAvatarColor)
	
	-- Glowing outline
	renderer:outlineColor(shiny and vectors.hexToRGB("9775CE") or initGlowColor)
	
end

-- Shiny toggle
function pings.setShinyToggle(boolean)
	
	shiny = boolean
	config:save("ShinyToggle", shiny)
	if player:isLoaded() and shiny then
		sounds:playSound("block.amethyst_block.chime", player:getPos())
	end
	
end

-- Sync variable
function pings.syncShiny(a)
	
	shiny = a
	
end

-- Host only instructions
if not host:isHost() then return end

-- Required scripts
local itemCheck = require("lib.ItemCheck")
local s, c = pcall(require, "scripts.ColorProperties")

if s then
	
	-- Store init colors
	local temp = {}
	temp.hover     = c.hover
	temp.active    = c.active
	temp.primary   = c.primary
	temp.secondary = c.secondary
	
	function events.RENDER(delta, context)
		
		-- Update action wheel colors
		c.hover     = shiny and vectors.hexToRGB("9775CE") or temp.hover
		c.active    = shiny and vectors.hexToRGB("F3C9B9") or temp.active
		c.primary   = shiny and "#F3C9B9" or temp.primary
		c.secondary = shiny and "#9775CE" or temp.secondary
		
	end
	
else
	
	c = {}
	
end

-- Sync on tick
function events.TICK()
	
	if world.getTime() % 200 == 0 then
		pings.syncShiny(shiny)
	end
	
end

-- Table setup
local t = {}

-- Action
t.shinyAct = action_wheel:newAction()
	:item(itemCheck("gunpowder"))
	:toggleItem(itemCheck("glowstone_dust"))
	:onToggle(pings.setShinyToggle)

-- Update action
function events.RENDER(delta, context)
	
	if action_wheel:isEnabled() then
		t.shinyAct
			:title(toJson(
				{
					"",
					{text = "Toggle Shiny Textures\n\n", bold = true, color = c.primary},
					{text = "Toggles the usage of shiny textures for your pokemon parts.", color = c.secondary}
				}
			))
			:toggled(shiny)
		
		for _, act in pairs(t) do
			act:hoverColor(c.hover):toggleColor(c.active)
		end
		
	end
	
end

-- Return action
return t