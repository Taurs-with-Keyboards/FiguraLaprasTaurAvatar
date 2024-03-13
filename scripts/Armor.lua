-- Required scripts
local parts     = require("lib.GroupIndex")(models)
local kattArmor = require("lib.KattArmor")()
local color        = require("scripts.ColorProperties")

-- Setting the leggings to layer 1
kattArmor.Armor.Leggings:setLayer(1)

-- Armor parts
kattArmor.Armor.Helmet
	:addParts(parts.headArmorHelmet.Helmet)
	:addTrimParts(parts.headArmorHelmet.Trim)
kattArmor.Armor.Chestplate
	:addParts(
		parts.bodyArmorChestplate.Chestplate,
		parts.leftArmArmorChestplate.Chestplate,
		parts.rightArmArmorChestplate.Chestplate,
		parts.leftArmArmorChestplateFP.Chestplate,
		parts.rightArmArmorChestplateFP.Chestplate,
		parts.ShellArmorChestplate.Chestplate,
		parts.SpikesChestplate
	)
	:addTrimParts(
		parts.bodyArmorChestplate.Trim,
		parts.leftArmArmorChestplate.Trim,
		parts.rightArmArmorChestplate.Trim,
		parts.leftArmArmorChestplateFP.Trim,
		parts.rightArmArmorChestplateFP.Trim,
		parts.ShellArmorChestplate.Trim,
		parts.SpikesTrim
	)
kattArmor.Armor.Leggings
	:addParts(
		parts.bodyArmorLeggings.Leggings,
		parts.FrontArmorLeggings.Leggings,
		parts.MainArmorLeggings.Leggings
	)
	:addTrimParts(
		parts.bodyArmorLeggings.Trim,
		parts.FrontArmorLeggings.Trim,
		parts.MainArmorLeggings.Trim
	)
kattArmor.Armor.Boots
	:addParts(
		parts.FrontLeftFlipperArmorBoot.Boot,
		parts.FrontLeftFlipperTipArmorBoot.Boot,
		parts.FrontRightFlipperArmorBoot.Boot,
		parts.FrontRightFlipperTipArmorBoot.Boot,
		parts.BackLeftFlipperArmorBoot.Boot,
		parts.BackLeftFlipperTipArmorBoot.Boot,
		parts.BackRightFlipperArmorBoot.Boot,
		parts.BackRightFlipperTipArmorBoot.Boot
	)
	:addTrimParts(
		parts.FrontLeftFlipperArmorBoot.Trim,
		parts.FrontLeftFlipperTipArmorBoot.Trim,
		parts.FrontRightFlipperArmorBoot.Trim,
		parts.FrontRightFlipperTipArmorBoot.Trim,
		parts.BackLeftFlipperArmorBoot.Trim,
		parts.BackLeftFlipperTipArmorBoot.Trim,
		parts.BackRightFlipperArmorBoot.Trim,
		parts.BackRightFlipperTipArmorBoot.Trim
	)

-- Leather armor
kattArmor.Materials.leather
	:setTexture(textures["textures.armor.leatherArmor"])
	:addParts(kattArmor.Armor.Helmet,
		parts.headArmorHelmet.Leather
	)
	:addParts(kattArmor.Armor.Chestplate,
		parts.bodyArmorChestplate.Leather,
		parts.leftArmArmorChestplate.Leather,
		parts.rightArmArmorChestplate.Leather,
		parts.leftArmArmorChestplateFP.Leather,
		parts.rightArmArmorChestplateFP.Leather,
		parts.ShellArmorChestplate.Leather,
		parts.SpikesLeather
	)
	:addParts(kattArmor.Armor.Leggings,
		parts.bodyArmorLeggings.Leather,
		parts.FrontArmorLeggings.Leather,
		parts.MainArmorLeggings.Leather
	)
	:addParts(kattArmor.Armor.Boots,
		parts.FrontLeftFlipperArmorBoot.Leather,
		parts.FrontLeftFlipperTipArmorBoot.Leather,
		parts.FrontRightFlipperArmorBoot.Leather,
		parts.FrontRightFlipperTipArmorBoot.Leather,
		parts.BackLeftFlipperArmorBoot.Leather,
		parts.BackLeftFlipperTipArmorBoot.Leather,
		parts.BackRightFlipperArmorBoot.Leather,
		parts.BackRightFlipperTipArmorBoot.Leather
	)

-- Chainmail armor
kattArmor.Materials.chainmail
	:setTexture(textures["textures.armor.chainmailArmor"])

-- Iron armor
kattArmor.Materials.iron
	:setTexture(textures["textures.armor.ironArmor"])

-- Golden armor
kattArmor.Materials.golden
	:setTexture(textures["textures.armor.goldenArmor"])

-- Diamond armor
kattArmor.Materials.diamond
	:setTexture(textures["textures.armor.diamondArmor"])

-- Netherite armor
kattArmor.Materials.netherite
	:setTexture(textures["textures.armor.netheriteArmor"])

-- Turtle helmet
kattArmor.Materials.turtle
	:setTexture(textures["textures.armor.turtleHelmet"])
	:addParts(kattArmor.Armor.Helmet,
		parts.TurtleHelmetSpikes
	)

-- Trims
-- Coast
kattArmor.TrimPatterns.coast
	:setTexture(textures["textures.armor.trims.coastTrim"])

-- Dune
kattArmor.TrimPatterns.dune
	:setTexture(textures["textures.armor.trims.duneTrim"])

-- Eye
kattArmor.TrimPatterns.eye
	:setTexture(textures["textures.armor.trims.eyeTrim"])

-- Host
kattArmor.TrimPatterns.host
	:setTexture(textures["textures.armor.trims.hostTrim"])

-- Raiser
kattArmor.TrimPatterns.raiser
	:setTexture(textures["textures.armor.trims.raiserTrim"])

-- Rib
kattArmor.TrimPatterns.rib
	:setTexture(textures["textures.armor.trims.ribTrim"])

-- Sentry
kattArmor.TrimPatterns.sentry
	:setTexture(textures["textures.armor.trims.sentryTrim"])

-- Shaper
kattArmor.TrimPatterns.shaper
	:setTexture(textures["textures.armor.trims.shaperTrim"])

-- Silence
kattArmor.TrimPatterns.silence
	:setTexture(textures["textures.armor.trims.silenceTrim"])

-- Snout
kattArmor.TrimPatterns.snout
	:setTexture(textures["textures.armor.trims.snoutTrim"])

-- Spire
kattArmor.TrimPatterns.spire
	:setTexture(textures["textures.armor.trims.spireTrim"])

-- Tide
kattArmor.TrimPatterns.tide
	:setTexture(textures["textures.armor.trims.tideTrim"])

-- Vex
kattArmor.TrimPatterns.vex
	:setTexture(textures["textures.armor.trims.vexTrim"])

-- Ward
kattArmor.TrimPatterns.ward
	:setTexture(textures["textures.armor.trims.wardTrim"])

-- Wayfinder
kattArmor.TrimPatterns.wayfinder
	:setTexture(textures["textures.armor.trims.wayfinderTrim"])

-- Wild
kattArmor.TrimPatterns.wild
	:setTexture(textures["textures.armor.trims.wildTrim"])

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
	
	parts.headArmorHelmet,
	parts.HelmetItemPivot
	
}

-- All chestplate parts
local chestplateGroups = {
	
	parts.bodyArmorChestplate,
	parts.leftArmArmorChestplate,
	parts.rightArmArmorChestplate,
	parts.leftArmArmorChestplateFP,
	parts.rightArmArmorChestplateFP
	
}

-- All shell armor parts
local chestplateShellGroups = {
	
	parts.ShellArmorChestplate,
	parts.SpikesArmorChestplate
	
}

-- All leggings parts
local leggingsGroups = {
	
	parts.bodyArmorLeggings,
	parts.FrontArmorLeggings,
	parts.MainArmorLeggings
	
}

-- All boots parts
local bootsGroups = {
	
	parts.FrontLeftFlipperArmorBoot,
	parts.FrontLeftFlipperTipArmorBoot,
	
	parts.FrontRightFlipperArmorBoot,
	parts.FrontRightFlipperTipArmorBoot,
	
	parts.BackLeftFlipperArmorBoot,
	parts.BackLeftFlipperTipArmorBoot,
	
	parts.BackRightFlipperArmorBoot,
	parts.BackRightFlipperTipArmorBoot
	
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
		sounds:playSound("minecraft:item.armor.equip_generic", player:getPos(), 0.5)
	end
	
end

-- Armor helmet toggle
local function setHelmet(boolean)
	
	helmet = boolean
	config:save("ArmorHelmet", helmet)
	if player:isLoaded() then
		sounds:playSound("minecraft:item.armor.equip_generic", player:getPos(), 0.5)
	end
	
end

-- Armor chestplate toggle
local function setChestplate(boolean)
	
	chestplate = boolean
	config:save("ArmorChestplate", chestplate)
	if player:isLoaded() then
		sounds:playSound("minecraft:item.armor.equip_generic", player:getPos(), 0.5)
	end
	
end

-- Armor leggings toggle
local function setLeggings(boolean)
	
	leggings = boolean
	config:save("ArmorLeggings", leggings)
	if player:isLoaded() then
		sounds:playSound("minecraft:item.armor.equip_generic", player:getPos(), 0.5)
	end
	
end

-- Armor boots toggle
local function setBoots(boolean)
	
	boots = boolean
	config:save("ArmorBoots", boots)
	if player:isLoaded() then
		sounds:playSound("minecraft:item.armor.equip_generic", player:getPos(), 0.5)
	end
	
end

-- Armor shell toggle
local function setShell(boolean)
	
	shell = boolean
	config:save("ArmorShell", shell)
	if player:isLoaded() then
		sounds:playSound("minecraft:item.armor.equip_generic", player:getPos(), 0.5)
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
t.allPage = action_wheel:newAction("AllArmorToggle")
	:item("minecraft:armor_stand")
	:toggleItem("minecraft:netherite_chestplate")
	:onToggle(pings.setArmorAll)

t.helmetPage = action_wheel:newAction("HelmetArmorToggle")
	:item("minecraft:iron_helmet")
	:toggleItem("minecraft:diamond_helmet")
	:onToggle(pings.setArmorHelmet)

t.chestplatePage = action_wheel:newAction("ChestplateArmorToggle")
	:item("minecraft:iron_chestplate")
	:toggleItem("minecraft:diamond_chestplate")
	:onToggle(pings.setArmorChestplate)

t.leggingsPage = action_wheel:newAction("LeggingsArmorToggle")
	:item("minecraft:iron_leggings")
	:toggleItem("minecraft:diamond_leggings")
	:onToggle(pings.setArmorLeggings)

t.bootsPage = action_wheel:newAction("BootsArmorToggle")
	:item("minecraft:iron_boots")
	:toggleItem("minecraft:diamond_boots")
	:onToggle(pings.setArmorBoots)

t.shellPage = action_wheel:newAction("ShellArmorToggle")
	:item("minecraft:scute")
	:toggleItem("minecraft:turtle_helmet")
	:onToggle(pings.setArmorShell)

-- Update action page info
function events.TICK()
	
	t.allPage
		:title(color.primary.."Toggle All Armor\n\n"..color.secondary.."Toggles visibility of all armor parts.")
		:hoverColor(color.hover)
		:toggleColor(color.active)
		:toggled(helmet and chestplate and leggings and boots and shell)
	
	t.helmetPage
		:title(color.primary.."Toggle Helmet\n\n"..color.secondary.."Toggles visibility of helmet parts.")
		:hoverColor(color.hover)
		:toggleColor(color.active)
		:toggled(helmet)
	
	t.chestplatePage
		:title(color.primary.."Toggle Chestplate\n\n"..color.secondary.."Toggles visibility of chestplate parts.")
		:hoverColor(color.hover)
		:toggleColor(color.active)
		:toggled(chestplate)
	
	t.leggingsPage
		:title(color.primary.."Toggle Leggings\n\n"..color.secondary.."Toggles visibility of leggings parts.")
		:hoverColor(color.hover)
		:toggleColor(color.active)
		:toggled(leggings)
	
	t.bootsPage
		:title(color.primary.."Toggle Boots\n\n"..color.secondary.."Toggles visibility of boots.")
		:hoverColor(color.hover)
		:toggleColor(color.active)
		:toggled(boots)
	
	t.shellPage
		:title(color.primary.."Toggle Shell Armor\n\n"..color.secondary.."Toggles visibility of armor on shell.")
		:hoverColor(color.hover)
		:toggleColor(color.active)
		:toggled(shell)
	
end

-- Return action wheel pages
return t