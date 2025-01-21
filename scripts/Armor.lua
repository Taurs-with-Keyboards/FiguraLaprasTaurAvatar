-- Required scripts
local pokemonParts = require("lib.GroupIndex")(models.models.LaprasTaur)
local laprasArmor  = require("lib.KattArmor")()
local itemCheck    = require("lib.ItemCheck")
local color        = require("scripts.ColorProperties")

-- Setting the leggings to layer 1
laprasArmor.Armor.Leggings:setLayer(1)

-- Armor parts
laprasArmor.Armor.Helmet
	:addParts(pokemonParts.headArmorHelmet.Helmet)
	:addTrimParts(pokemonParts.headArmorHelmet.Trim)
laprasArmor.Armor.Chestplate
	:addParts(
		pokemonParts.bodyArmorChestplate.Chestplate,
		pokemonParts.leftArmArmorChestplate.Chestplate,
		pokemonParts.rightArmArmorChestplate.Chestplate,
		pokemonParts.leftArmArmorChestplateFP.Chestplate,
		pokemonParts.rightArmArmorChestplateFP.Chestplate,
		pokemonParts.ShellArmorChestplate.Chestplate,
		pokemonParts.SpikeMFArmorChestplate.Chestplate,
		pokemonParts.SpikeMMArmorChestplate.Chestplate,
		pokemonParts.SpikeMBArmorChestplate.Chestplate,
		pokemonParts.SpikeLSArmorChestplate.Chestplate,
		pokemonParts.SpikeLFArmorChestplate.Chestplate,
		pokemonParts.SpikeLBArmorChestplate.Chestplate,
		pokemonParts.SpikeRSArmorChestplate.Chestplate,
		pokemonParts.SpikeRFArmorChestplate.Chestplate,
		pokemonParts.SpikeRBArmorChestplate.Chestplate
	)
	:addTrimParts(
		pokemonParts.bodyArmorChestplate.Trim,
		pokemonParts.leftArmArmorChestplate.Trim,
		pokemonParts.rightArmArmorChestplate.Trim,
		pokemonParts.leftArmArmorChestplateFP.Trim,
		pokemonParts.rightArmArmorChestplateFP.Trim,
		pokemonParts.ShellArmorChestplate.Trim,
		pokemonParts.SpikeMFArmorChestplate.Trim,
		pokemonParts.SpikeMMArmorChestplate.Trim,
		pokemonParts.SpikeMBArmorChestplate.Trim,
		pokemonParts.SpikeLSArmorChestplate.Trim,
		pokemonParts.SpikeLFArmorChestplate.Trim,
		pokemonParts.SpikeLBArmorChestplate.Trim,
		pokemonParts.SpikeRSArmorChestplate.Trim,
		pokemonParts.SpikeRFArmorChestplate.Trim,
		pokemonParts.SpikeRBArmorChestplate.Trim
	)
laprasArmor.Armor.Leggings
	:addParts(
		pokemonParts.bodyArmorLeggings.Leggings,
		pokemonParts.NeckArmorLeggings.Leggings,
		pokemonParts.MainArmorLeggings.Leggings
	)
	:addTrimParts(
		pokemonParts.bodyArmorLeggings.Trim,
		pokemonParts.NeckArmorLeggings.Trim,
		pokemonParts.MainArmorLeggings.Trim
	)
laprasArmor.Armor.Boots
	:addParts(
		pokemonParts.FrontLeftFlipperArmorBoot.Boot,
		pokemonParts.FrontLeftFlipperTipArmorBoot.Boot,
		pokemonParts.FrontRightFlipperArmorBoot.Boot,
		pokemonParts.FrontRightFlipperTipArmorBoot.Boot,
		pokemonParts.BackLeftFlipperArmorBoot.Boot,
		pokemonParts.BackLeftFlipperTipArmorBoot.Boot,
		pokemonParts.BackRightFlipperArmorBoot.Boot,
		pokemonParts.BackRightFlipperTipArmorBoot.Boot
	)
	:addTrimParts(
		pokemonParts.FrontLeftFlipperArmorBoot.Trim,
		pokemonParts.FrontLeftFlipperTipArmorBoot.Trim,
		pokemonParts.FrontRightFlipperArmorBoot.Trim,
		pokemonParts.FrontRightFlipperTipArmorBoot.Trim,
		pokemonParts.BackLeftFlipperArmorBoot.Trim,
		pokemonParts.BackLeftFlipperTipArmorBoot.Trim,
		pokemonParts.BackRightFlipperArmorBoot.Trim,
		pokemonParts.BackRightFlipperTipArmorBoot.Trim
	)

-- Leather armor
laprasArmor.Materials.leather
	:setTexture(textures["textures.armor.leatherArmor"] or textures["models.LaprasTaur.leatherArmor"])
	:addParts(laprasArmor.Armor.Helmet,
		pokemonParts.headArmorHelmet.Leather
	)
	:addParts(laprasArmor.Armor.Chestplate,
		pokemonParts.bodyArmorChestplate.Leather,
		pokemonParts.leftArmArmorChestplate.Leather,
		pokemonParts.rightArmArmorChestplate.Leather,
		pokemonParts.leftArmArmorChestplateFP.Leather,
		pokemonParts.rightArmArmorChestplateFP.Leather,
		pokemonParts.ShellArmorChestplate.Leather,
		pokemonParts.SpikeMFArmorChestplate.Leather,
		pokemonParts.SpikeMMArmorChestplate.Leather,
		pokemonParts.SpikeMBArmorChestplate.Leather,
		pokemonParts.SpikeLSArmorChestplate.Leather,
		pokemonParts.SpikeLFArmorChestplate.Leather,
		pokemonParts.SpikeLBArmorChestplate.Leather,
		pokemonParts.SpikeRSArmorChestplate.Leather,
		pokemonParts.SpikeRFArmorChestplate.Leather,
		pokemonParts.SpikeRBArmorChestplate.Leather
	)
	:addParts(laprasArmor.Armor.Leggings,
		pokemonParts.bodyArmorLeggings.Leather,
		pokemonParts.NeckArmorLeggings.Leather,
		pokemonParts.MainArmorLeggings.Leather
	)
	:addParts(laprasArmor.Armor.Boots,
		pokemonParts.FrontLeftFlipperArmorBoot.Leather,
		pokemonParts.FrontLeftFlipperTipArmorBoot.Leather,
		pokemonParts.FrontRightFlipperArmorBoot.Leather,
		pokemonParts.FrontRightFlipperTipArmorBoot.Leather,
		pokemonParts.BackLeftFlipperArmorBoot.Leather,
		pokemonParts.BackLeftFlipperTipArmorBoot.Leather,
		pokemonParts.BackRightFlipperArmorBoot.Leather,
		pokemonParts.BackRightFlipperTipArmorBoot.Leather
	)

-- Chainmail armor
laprasArmor.Materials.chainmail
	:setTexture(textures["textures.armor.chainmailArmor"] or textures["models.LaprasTaur.chainmailArmor"])

-- Iron armor
laprasArmor.Materials.iron
	:setTexture(textures["textures.armor.ironArmor"] or textures["models.LaprasTaur.ironArmor"])

-- Golden armor
laprasArmor.Materials.golden
	:setTexture(textures["textures.armor.goldenArmor"] or textures["models.LaprasTaur.goldenArmor"])

-- Diamond armor
laprasArmor.Materials.diamond
	:setTexture(textures["textures.armor.diamondArmor"] or textures["models.LaprasTaur.diamondArmor"])

-- Netherite armor
laprasArmor.Materials.netherite
	:setTexture(textures["textures.armor.netheriteArmor"] or textures["models.LaprasTaur.netheriteArmor"])

-- Turtle helmet
laprasArmor.Materials.turtle
	:setTexture(textures["textures.armor.turtleHelmet"] or textures["models.LaprasTaur.turtleHelmet"])
	:addParts(laprasArmor.Armor.Helmet,
		pokemonParts.TurtleHelmet
	)

-- Trims
-- Bolt
laprasArmor.TrimPatterns.bolt
	:setTexture(textures["textures.armor.trims.boltTrim"] or textures["models.LaprasTaur.boltTrim"])

-- Coast
laprasArmor.TrimPatterns.coast
	:setTexture(textures["textures.armor.trims.coastTrim"] or textures["models.LaprasTaur.coastTrim"])

-- Dune
laprasArmor.TrimPatterns.dune
	:setTexture(textures["textures.armor.trims.duneTrim"] or textures["models.LaprasTaur.duneTrim"])

-- Eye
laprasArmor.TrimPatterns.eye
	:setTexture(textures["textures.armor.trims.eyeTrim"] or textures["models.LaprasTaur.eyeTrim"])

-- Flow
laprasArmor.TrimPatterns.flow
	:setTexture(textures["textures.armor.trims.flowTrim"] or textures["models.LaprasTaur.flowTrim"])

-- Host
laprasArmor.TrimPatterns.host
	:setTexture(textures["textures.armor.trims.hostTrim"] or textures["models.LaprasTaur.hostTrim"])

-- Raiser
laprasArmor.TrimPatterns.raiser
	:setTexture(textures["textures.armor.trims.raiserTrim"] or textures["models.LaprasTaur.raiserTrim"])

-- Rib
laprasArmor.TrimPatterns.rib
	:setTexture(textures["textures.armor.trims.ribTrim"] or textures["models.LaprasTaur.ribTrim"])

-- Sentry
laprasArmor.TrimPatterns.sentry
	:setTexture(textures["textures.armor.trims.sentryTrim"] or textures["models.LaprasTaur.sentryTrim"])

-- Shaper
laprasArmor.TrimPatterns.shaper
	:setTexture(textures["textures.armor.trims.shaperTrim"] or textures["models.LaprasTaur.shaperTrim"])

-- Silence
laprasArmor.TrimPatterns.silence
	:setTexture(textures["textures.armor.trims.silenceTrim"] or textures["models.LaprasTaur.silenceTrim"])

-- Snout
laprasArmor.TrimPatterns.snout
	:setTexture(textures["textures.armor.trims.snoutTrim"] or textures["models.LaprasTaur.snoutTrim"])

-- Spire
laprasArmor.TrimPatterns.spire
	:setTexture(textures["textures.armor.trims.spireTrim"] or textures["models.LaprasTaur.spireTrim"])

-- Tide
laprasArmor.TrimPatterns.tide
	:setTexture(textures["textures.armor.trims.tideTrim"] or textures["models.LaprasTaur.tideTrim"])

-- Vex
laprasArmor.TrimPatterns.vex
	:setTexture(textures["textures.armor.trims.vexTrim"] or textures["models.LaprasTaur.vexTrim"])

-- Ward
laprasArmor.TrimPatterns.ward
	:setTexture(textures["textures.armor.trims.wardTrim"] or textures["models.LaprasTaur.wardTrim"])

-- Wayfinder
laprasArmor.TrimPatterns.wayfinder
	:setTexture(textures["textures.armor.trims.wayfinderTrim"] or textures["models.LaprasTaur.wayfinderTrim"])

-- Wild
laprasArmor.TrimPatterns.wild
	:setTexture(textures["textures.armor.trims.wildTrim"] or textures["models.LaprasTaur.wildTrim"])

-- Config setup
config:name("LaprasTaur")
local helmet     = config:load("ArmorHelmet")
local chestplate = config:load("ArmorChestplate")
local leggings   = config:load("ArmorLeggings")
local boots      = config:load("ArmorBoots")
local shell      = config:load("ArmorShell")
if helmet     == nil then helmet     = true end
if chestplate == nil then chestplate = true end
if leggings   == nil then leggings   = true end
if boots      == nil then boots      = true end
if shell      == nil then shell      = true end

-- All helmet parts
local helmetGroups = {
	
	pokemonParts.headArmorHelmet,
	pokemonParts.HelmetItemPivot
	
}

-- All chestplate parts
local chestplateGroups = {
	
	pokemonParts.bodyArmorChestplate,
	pokemonParts.leftArmArmorChestplate,
	pokemonParts.rightArmArmorChestplate,
	pokemonParts.leftArmArmorChestplateFP,
	pokemonParts.rightArmArmorChestplateFP
	
}

-- All shell armor parts
local chestplateShellGroups = {
	
	pokemonParts.ShellArmorChestplate,
	pokemonParts.SpikeMFArmorChestplate,
	pokemonParts.SpikeMMArmorChestplate,
	pokemonParts.SpikeMBArmorChestplate,
	pokemonParts.SpikeLSArmorChestplate,
	pokemonParts.SpikeLFArmorChestplate,
	pokemonParts.SpikeLBArmorChestplate,
	pokemonParts.SpikeRSArmorChestplate,
	pokemonParts.SpikeRFArmorChestplate,
	pokemonParts.SpikeRBArmorChestplate
	
}

-- All leggings parts
local leggingsGroups = {
	
	pokemonParts.bodyArmorLeggings,
	pokemonParts.NeckArmorLeggings,
	pokemonParts.MainArmorLeggings
	
}

-- All boots parts
local bootsGroups = {
	
	pokemonParts.FrontLeftFlipperArmorBoot,
	pokemonParts.FrontLeftFlipperTipArmorBoot,
	
	pokemonParts.FrontRightFlipperArmorBoot,
	pokemonParts.FrontRightFlipperTipArmorBoot,
	
	pokemonParts.BackLeftFlipperArmorBoot,
	pokemonParts.BackLeftFlipperTipArmorBoot,
	
	pokemonParts.BackRightFlipperArmorBoot,
	pokemonParts.BackRightFlipperTipArmorBoot
	
}

function events.TICK()
	
	for _, part in ipairs(helmetGroups) do
		part:visible(helmet)
	end
	
	for _, part in ipairs(chestplateGroups) do
		part:visible(chestplate)
	end
	
	for _, part in ipairs(leggingsGroups) do
		part:visible(leggings)
	end
	
	for _, part in ipairs(bootsGroups) do
		part:visible(boots)
	end
	
	for _, part in ipairs(chestplateShellGroups) do
		part:visible(shell)
	end
	
end

-- Armor all toggle
local function setAll(boolean)
	
	helmet     = boolean
	chestplate = boolean
	leggings   = boolean
	boots      = boolean
	shell      = boolean
	config:save("ArmorHelmet", helmet)
	config:save("ArmorChestplate", chestplate)
	config:save("ArmorLeggings", leggings)
	config:save("ArmorBoots", boots)
	config:save("ArmorShell", shell)
	if player:isLoaded() then
		sounds:playSound("item.armor.equip_generic", player:getPos(), 0.5)
	end
	
end

-- Armor helmet toggle
local function setHelmet(boolean)
	
	helmet = boolean
	config:save("ArmorHelmet", helmet)
	if player:isLoaded() then
		sounds:playSound("item.armor.equip_generic", player:getPos(), 0.5)
	end
	
end

-- Armor chestplate toggle
local function setChestplate(boolean)
	
	chestplate = boolean
	config:save("ArmorChestplate", chestplate)
	if player:isLoaded() then
		sounds:playSound("item.armor.equip_generic", player:getPos(), 0.5)
	end
	
end

-- Armor leggings toggle
local function setLeggings(boolean)
	
	leggings = boolean
	config:save("ArmorLeggings", leggings)
	if player:isLoaded() then
		sounds:playSound("item.armor.equip_generic", player:getPos(), 0.5)
	end
	
end

-- Armor boots toggle
local function setBoots(boolean)
	
	boots = boolean
	config:save("ArmorBoots", boots)
	if player:isLoaded() then
		sounds:playSound("item.armor.equip_generic", player:getPos(), 0.5)
	end
	
end

-- Armor shell toggle
local function setShell(boolean)
	
	shell = boolean
	config:save("ArmorShell", shell)
	if player:isLoaded() then
		sounds:playSound("item.armor.equip_generic", player:getPos(), 0.5)
	end
	
end

-- Sync variables
local function syncArmor(a, b, c, d, e)
	
	helmet     = a
	chestplate = b
	leggings   = c
	boots      = d
	shell      = e
	
end

-- Pings setup
pings.setArmorAll        = setAll
pings.setArmorHelmet     = setHelmet
pings.setArmorChestplate = setChestplate
pings.setArmorLeggings   = setLeggings
pings.setArmorBoots      = setBoots
pings.setArmorShell      = setShell
pings.syncArmor          = syncArmor

-- Sync on tick
if host:isHost() then
	function events.TICK()
		
		if world.getTime() % 200 == 0 then
			pings.syncArmor(helmet, chestplate, leggings, boots, shell)
		end
		
	end
end

-- Activate actions
setHelmet(helmet)
setChestplate(chestplate)
setLeggings(leggings)
setBoots(boots)
setShell(shell)

-- Setup table
local t = {}

-- Action wheel pages
t.allPage = action_wheel:newAction()
	:item(itemCheck("armor_stand"))
	:toggleItem(itemCheck("netherite_chestplate"))
	:onToggle(pings.setArmorAll)

t.helmetPage = action_wheel:newAction()
	:item(itemCheck("iron_helmet"))
	:toggleItem(itemCheck("diamond_helmet"))
	:onToggle(pings.setArmorHelmet)

t.chestplatePage = action_wheel:newAction()
	:item(itemCheck("iron_chestplate"))
	:toggleItem(itemCheck("diamond_chestplate"))
	:onToggle(pings.setArmorChestplate)

t.leggingsPage = action_wheel:newAction()
	:item(itemCheck("iron_leggings"))
	:toggleItem(itemCheck("diamond_leggings"))
	:onToggle(pings.setArmorLeggings)

t.bootsPage = action_wheel:newAction()
	:item(itemCheck("iron_boots"))
	:toggleItem(itemCheck("diamond_boots"))
	:onToggle(pings.setArmorBoots)

t.shellPage = action_wheel:newAction()
	:item(itemCheck("scute"))
	:toggleItem(itemCheck("turtle_helmet"))
	:onToggle(pings.setArmorShell)

-- Update action page info
function events.TICK()
	
	t.allPage
		:title(toJson
			{"",
			{text = "Toggle All Armor\n\n", bold = true, color = color.primary},
			{text = "Toggles visibility of all armor parts.", color = color.secondary}}
		)
		:hoverColor(color.hover)
		:toggleColor(color.active)
		:toggled(helmet and chestplate and leggings and boots and shell)
	
	t.helmetPage
		:title(toJson
			{"",
			{text = "Toggle Helmet\n\n", bold = true, color = color.primary},
			{text = "Toggles visibility of helmet parts.", color = color.secondary}}
		)
		:hoverColor(color.hover)
		:toggleColor(color.active)
		:toggled(helmet)
	
	t.chestplatePage
		:title(toJson
			{"",
			{text = "Toggle Chestplate\n\n", bold = true, color = color.primary},
			{text = "Toggles visibility of chestplate parts.", color = color.secondary}}
		)
		:hoverColor(color.hover)
		:toggleColor(color.active)
		:toggled(chestplate)
	
	t.leggingsPage
		:title(toJson
			{"",
			{text = "Toggle Leggings\n\n", bold = true, color = color.primary},
			{text = "Toggles visibility of leggings parts.", color = color.secondary}}
		)
		:hoverColor(color.hover)
		:toggleColor(color.active)
		:toggled(leggings)
	
	t.bootsPage
		:title(toJson
			{"",
			{text = "Toggle Boots\n\n", bold = true, color = color.primary},
			{text = "Toggles visibility of boots.", color = color.secondary}}
		)
		:hoverColor(color.hover)
		:toggleColor(color.active)
		:toggled(boots)
	
	t.shellPage
		:title(toJson
			{"",
			{text = "Toggle Shell Armor\n\n", bold = true, color = color.primary},
			{text = "Toggles visibility of armor on shell.", color = color.secondary}}
		)
		:hoverColor(color.hover)
		:toggleColor(color.active)
		:toggled(shell)
	
end

-- Return action wheel pages
return t