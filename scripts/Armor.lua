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
	:addTrimParts(upperRoot.Head.Armor.HelmetTrim)
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
	:addTrimParts(
		upperRoot.Body.Armor.ChestplateTrim,
		model.RightArm.Armor.ChestplateTrim,
		model.LeftArm.Armor.ChestplateTrim,
		upperRoot.RightArm.Armor.ChestplateTrim,
		upperRoot.LeftArm.Armor.ChestplateTrim,
		lowerRoot.Main.Shell.Armor.ChestplateTrim,
		lowerRoot.Main.Shell.Spikes.Armor.ChestplateTrim
	)
kattArmor.Armor.Leggings
	:addParts(
		upperRoot.Body.Armor.Belt,
		lowerRoot.Front.Armor.Leggings,
		lowerRoot.Main.Armor.Leggings
	)
	:addTrimParts(
		upperRoot.Body.Armor.BeltTrim,
		lowerRoot.Front.Armor.LeggingsTrim,
		lowerRoot.Main.Armor.LeggingsTrim
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
	:addTrimParts(
		lowerRoot.Main.FlipperFrontRight.Armor.BootTrim,
		lowerRoot.Main.FlipperFrontRight.Tip.Armor.BootTrim,
		lowerRoot.Main.FlipperFrontLeft.Armor.BootTrim,
		lowerRoot.Main.FlipperFrontLeft.Tip.Armor.BootTrim,
		lowerRoot.Main.FlipperBackRight.Armor.BootTrim,
		lowerRoot.Main.FlipperBackRight.Tip.Armor.BootTrim,
		lowerRoot.Main.FlipperBackLeft.Armor.BootTrim,
		lowerRoot.Main.FlipperBackLeft.Tip.Armor.BootTrim
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