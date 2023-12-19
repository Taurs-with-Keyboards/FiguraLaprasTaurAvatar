-- Model setup
local model     = models.LaprasTaur
local upperRoot = model.Player.UpperBody
local lowerRoot = model.Player.LowerBody

-- Katt armor setup
local kattArmor = require("lib.KattArmor")()

-- Setting the leggings to layer 1
kattArmor.Armor.Leggings:setLayer(1)

-- Armor parts
kattArmor.Armor.Helmet
	:addParts(upperRoot.Head.Armor.Helmet)
kattArmor.Armor.Chestplate
	:addParts(
		upperRoot.Body.Armor.Chestplate,
		model.RightArm.Armor.Chestplate,
		model.LeftArm.Armor.Chestplate,
		upperRoot.RightArm.Armor.Chestplate,
		upperRoot.LeftArm.Armor.Chestplate,
		lowerRoot.Main.Shell.Armor.Chestplate,
		lowerRoot.Main.Shell.Spikes.Armor.Chestplate
	)
kattArmor.Armor.Leggings
	:addParts(
		upperRoot.Body.Armor.Belt,
		lowerRoot.Front.Armor.Leggings,
		lowerRoot.Main.Armor.Leggings
	)
kattArmor.Armor.Boots
	:addParts(
		lowerRoot.Main.FlipperFrontRight.Armor.Boot,
		lowerRoot.Main.FlipperFrontRight.Tip.Armor.Boot,
		lowerRoot.Main.FlipperFrontLeft.Armor.Boot,
		lowerRoot.Main.FlipperFrontLeft.Tip.Armor.Boot,
		lowerRoot.Main.FlipperBackRight.Armor.Boot,
		lowerRoot.Main.FlipperBackRight.Tip.Armor.Boot,
		lowerRoot.Main.FlipperBackLeft.Armor.Boot,
		lowerRoot.Main.FlipperBackLeft.Tip.Armor.Boot
	)

-- Leather armor
kattArmor.Materials.leather
	:setTexture(textures["textures.armor.leatherArmor"])
	:addParts(kattArmor.Armor.Helmet,
		upperRoot.Head.Armor.HelmetLeather
	)
	:addParts(kattArmor.Armor.Chestplate,
		upperRoot.Body.Armor.ChestplateLeather,
		model.RightArm.Armor.ChestplateLeather,
		model.LeftArm.Armor.ChestplateLeather,
		upperRoot.RightArm.Armor.ChestplateLeather,
		upperRoot.LeftArm.Armor.ChestplateLeather,
		lowerRoot.Main.Shell.Armor.ChestplateLeather,
		lowerRoot.Main.Shell.Spikes.Armor.ChestplateLeather
	)
	:addParts(kattArmor.Armor.Leggings,
		upperRoot.Body.Armor.BeltLeather,
		lowerRoot.Front.Armor.LeggingsLeather,
		lowerRoot.Main.Armor.LeggingsLeather
	)
	:addParts(kattArmor.Armor.Boots,
		lowerRoot.Main.FlipperFrontRight.Armor.BootLeather,
		lowerRoot.Main.FlipperFrontRight.Tip.Armor.BootLeather,
		lowerRoot.Main.FlipperFrontLeft.Armor.BootLeather,
		lowerRoot.Main.FlipperFrontLeft.Tip.Armor.BootLeather,
		lowerRoot.Main.FlipperBackRight.Armor.BootLeather,
		lowerRoot.Main.FlipperBackRight.Tip.Armor.BootLeather,
		lowerRoot.Main.FlipperBackLeft.Armor.BootLeather,
		lowerRoot.Main.FlipperBackLeft.Tip.Armor.BootLeather
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