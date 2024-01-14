-- Required scripts
local model     = require("scripts.ModelParts")
local kattArmor = require("lib.KattArmor")()

-- Setting the leggings to layer 1
kattArmor.Armor.Leggings:setLayer(1)

-- Armor parts
kattArmor.Armor.Helmet
	:addParts(model.head.headArmorHelmet.Helmet)
	:addTrimParts(model.head.headArmorHelmet.Trim)
kattArmor.Armor.Chestplate
	:addParts(
		model.body.bodyArmorChestplate.Chestplate,
		model.leftArm.leftArmArmorChestplate.Chestplate,
		model.rightArm.rightArmArmorChestplate.Chestplate,
		model.leftArmFP.leftArmArmorChestplateFP.Chestplate,
		model.rightArmFP.rightArmArmorChestplateFP.Chestplate,
		model.shell.ShellArmorChestplate.Chestplate,
		model.shell.Spikes.SpikesArmorChestplate.SpikesChestplate
	)
	:addTrimParts(
		model.body.bodyArmorChestplate.Trim,
		model.leftArm.leftArmArmorChestplate.Trim,
		model.rightArm.rightArmArmorChestplate.Trim,
		model.leftArmFP.leftArmArmorChestplateFP.Trim,
		model.rightArmFP.rightArmArmorChestplateFP.Trim,
		model.shell.ShellArmorChestplate.Trim,
		model.shell.Spikes.SpikesArmorChestplate.SpikesTrim
	)
kattArmor.Armor.Leggings
	:addParts(
		model.body.bodyArmorLeggings.Leggings,
		model.front.FrontArmorLeggings.Leggings,
		model.main.MainArmorLeggings.Leggings
	)
	:addTrimParts(
		model.body.bodyArmorLeggings.Trim,
		model.front.FrontArmorLeggings.Trim,
		model.main.MainArmorLeggings.Trim
	)
kattArmor.Armor.Boots
	:addParts(
		model.frontLeftFlipper.FrontLeftFlipperArmorBoot.Boot,
		model.frontLeftFlipper.FrontLeftFlipperTip.FrontLeftFlipperTipArmorBoot.Boot,
		model.frontRightFlipper.FrontRightFlipperArmorBoot.Boot,
		model.frontRightFlipper.FrontRightFlipperTip.FrontRightFlipperTipArmorBoot.Boot,
		model.backLeftFlipper.BackLeftFlipperArmorBoot.Boot,
		model.backLeftFlipper.BackLeftFlipperTip.BackLeftFlipperTipArmorBoot.Boot,
		model.backRightFlipper.BackRightFlipperArmorBoot.Boot,
		model.backRightFlipper.BackRightFlipperTip.BackRightFlipperTipArmorBoot.Boot
	)
	:addTrimParts(
		model.frontLeftFlipper.FrontLeftFlipperArmorBoot.Trim,
		model.frontLeftFlipper.FrontLeftFlipperTip.FrontLeftFlipperTipArmorBoot.Trim,
		model.frontRightFlipper.FrontRightFlipperArmorBoot.Trim,
		model.frontRightFlipper.FrontRightFlipperTip.FrontRightFlipperTipArmorBoot.Trim,
		model.backLeftFlipper.BackLeftFlipperArmorBoot.Trim,
		model.backLeftFlipper.BackLeftFlipperTip.BackLeftFlipperTipArmorBoot.Trim,
		model.backRightFlipper.BackRightFlipperArmorBoot.Trim,
		model.backRightFlipper.BackRightFlipperTip.BackRightFlipperTipArmorBoot.Trim
	)

-- Leather armor
kattArmor.Materials.leather
	:setTexture(textures["textures.armor.leatherArmor"])
	:addParts(kattArmor.Armor.Helmet,
		model.head.headArmorHelmet.Leather
	)
	:addParts(kattArmor.Armor.Chestplate,
		model.body.bodyArmorChestplate.Leather,
		model.leftArm.leftArmArmorChestplate.Leather,
		model.rightArm.rightArmArmorChestplate.Leather,
		model.leftArmFP.leftArmArmorChestplateFP.Leather,
		model.rightArmFP.rightArmArmorChestplateFP.Leather,
		model.shell.ShellArmorChestplate.Leather,
		model.shell.Spikes.SpikesArmorChestplate.SpikesLeather
	)
	:addParts(kattArmor.Armor.Leggings,
		model.body.bodyArmorLeggings.Leather,
		model.front.FrontArmorLeggings.Leather,
		model.main.MainArmorLeggings.Leather
	)
	:addParts(kattArmor.Armor.Boots,
		model.frontLeftFlipper.FrontLeftFlipperArmorBoot.Leather,
		model.frontLeftFlipper.FrontLeftFlipperTip.FrontLeftFlipperTipArmorBoot.Leather,
		model.frontRightFlipper.FrontRightFlipperArmorBoot.Leather,
		model.frontRightFlipper.FrontRightFlipperTip.FrontRightFlipperTipArmorBoot.Leather,
		model.backLeftFlipper.BackLeftFlipperArmorBoot.Leather,
		model.backLeftFlipper.BackLeftFlipperTip.BackLeftFlipperTipArmorBoot.Leather,
		model.backRightFlipper.BackRightFlipperArmorBoot.Leather,
		model.backRightFlipper.BackRightFlipperTip.BackRightFlipperTipArmorBoot.Leather
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

function events.TICK()
	
	for _, part in ipairs(model.helmetToggle) do
		part:visible(helmet)
	end
	
	for _, part in ipairs(model.chestplateToggle) do
		part:visible(chestplate)
	end
	
	for _, part in ipairs(model.leggingsToggle) do
		part:visible(leggings)
	end
	
	for _, part in ipairs(model.bootsToggle) do
		part:visible(boots)
	end
	
	for _, part in ipairs(model.chestplateShellToggle) do
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
	:title("§9§lToggle All Armor\n\n§bToggles visibility of all armor parts.")
	:hoverColor(vectors.hexToRGB("5EB7DD"))
	:toggleColor(vectors.hexToRGB("4078B0"))
	:item("minecraft:armor_stand")
	:toggleItem("minecraft:netherite_chestplate")
	:onToggle(pings.setArmorAll)

t.helmetPage = action_wheel:newAction("HelmetArmorToggle")
	:title("§9§lToggle Helmet\n\n§bToggles visibility of helmet parts.")
	:hoverColor(vectors.hexToRGB("5EB7DD"))
	:toggleColor(vectors.hexToRGB("4078B0"))
	:item("minecraft:iron_helmet")
	:toggleItem("minecraft:diamond_helmet")
	:onToggle(pings.setArmorHelmet)

t.chestplatePage = action_wheel:newAction("ChestplateArmorToggle")
	:title("§9§lToggle Chestplate\n\n§bToggles visibility of chestplate parts.")
	:hoverColor(vectors.hexToRGB("5EB7DD"))
	:toggleColor(vectors.hexToRGB("4078B0"))
	:item("minecraft:iron_chestplate")
	:toggleItem("minecraft:diamond_chestplate")
	:onToggle(pings.setArmorChestplate)

t.leggingsPage = action_wheel:newAction("LeggingsArmorToggle")
	:title("§9§lToggle Leggings\n\n§bToggles visibility of leggings parts.")
	:hoverColor(vectors.hexToRGB("5EB7DD"))
	:toggleColor(vectors.hexToRGB("4078B0"))
	:item("minecraft:iron_leggings")
	:toggleItem("minecraft:diamond_leggings")
	:onToggle(pings.setArmorLeggings)

t.bootsPage = action_wheel:newAction("BootsArmorToggle")
	:title("§9§lToggle Boots\n\n§bToggles visibility of boots.")
	:hoverColor(vectors.hexToRGB("5EB7DD"))
	:toggleColor(vectors.hexToRGB("4078B0"))
	:item("minecraft:iron_boots")
	:toggleItem("minecraft:diamond_boots")
	:onToggle(pings.setArmorBoots)

t.shellPage = action_wheel:newAction("ShellArmorToggle")
	:title("§9§lToggle Shell Armor\n\n§bToggles visibility of armor on shell.")
	:hoverColor(vectors.hexToRGB("5EB7DD"))
	:toggleColor(vectors.hexToRGB("4078B0"))
	:item("minecraft:scute")
	:toggleItem("minecraft:turtle_helmet")
	:onToggle(pings.setArmorShell)

-- Update action page info
function events.TICK()
	
	t.allPage       :toggled(helmet and chestplate and leggings and boots and shell)
	t.helmetPage    :toggled(helmet)
	t.chestplatePage:toggled(chestplate)
	t.leggingsPage  :toggled(leggings)
	t.bootsPage     :toggled(boots)
	t.shellPage     :toggled(shell)
	
end

-- Return action wheel pages
return t