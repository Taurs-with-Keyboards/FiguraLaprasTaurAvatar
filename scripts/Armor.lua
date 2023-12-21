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
	:addParts(upperRoot.Head.headArmor.Helmet)
	:addTrimParts(upperRoot.Head.headArmor.HelmetTrim)
kattArmor.Armor.Chestplate
	:addParts(
		upperRoot.Body.bodyArmor.Chestplate,
		model.RightArmFP.rightArmArmorFP.Chestplate,
		model.LeftArmFP.leftArmArmorFP.Chestplate,
		upperRoot.RightArm.rightArmArmor.Chestplate,
		upperRoot.LeftArm.leftArmArmor.Chestplate,
		lowerRoot.LowerBodyMain.Shell.ShellArmor.Chestplate,
		lowerRoot.LowerBodyMain.Shell.Spikes.SpikesArmor.SpikesChestplate
	)
	:addTrimParts(
		upperRoot.Body.bodyArmor.ChestplateTrim,
		model.RightArmFP.rightArmArmorFP.ChestplateTrim,
		model.LeftArmFP.leftArmArmorFP.ChestplateTrim,
		upperRoot.RightArm.rightArmArmor.ChestplateTrim,
		upperRoot.LeftArm.leftArmArmor.ChestplateTrim,
		lowerRoot.LowerBodyMain.Shell.ShellArmor.ChestplateTrim,
		lowerRoot.LowerBodyMain.Shell.Spikes.SpikesArmor.SpikesChestplateTrim
	)
kattArmor.Armor.Leggings
	:addParts(
		upperRoot.Body.bodyArmor.Belt,
		lowerRoot.LowerBodyFront.LowerBodyFrontArmor.Leggings,
		lowerRoot.LowerBodyMain.LowerBodyMainArmor.Leggings
	)
	:addTrimParts(
		upperRoot.Body.bodyArmor.BeltTrim,
		lowerRoot.LowerBodyFront.LowerBodyFrontArmor.LeggingsTrim,
		lowerRoot.LowerBodyMain.LowerBodyMainArmor.LeggingsTrim
	)
kattArmor.Armor.Boots
	:addParts(
		lowerRoot.LowerBodyMain.FrontRightFlipper.FrontRightFlipperArmor.Boot,
		lowerRoot.LowerBodyMain.FrontRightFlipper.FrontRightFlipperTip.FrontRightFlipperTipArmor.Boot,
		lowerRoot.LowerBodyMain.FrontLeftFlipper.FrontLeftFlipperArmor.Boot,
		lowerRoot.LowerBodyMain.FrontLeftFlipper.FrontLeftFlipperTip.FrontLeftFlipperTipArmor.Boot,
		lowerRoot.LowerBodyMain.BackRightFlipper.BackRightFlipperArmor.Boot,
		lowerRoot.LowerBodyMain.BackRightFlipper.BackRightFlipperTip.BackRightFlipperTipArmor.Boot,
		lowerRoot.LowerBodyMain.BackLeftFlipper.BackLeftFlipperArmor.Boot,
		lowerRoot.LowerBodyMain.BackLeftFlipper.BackLeftFlipperTip.BackLeftFlipperTipArmor.Boot
	)
	:addTrimParts(
		lowerRoot.LowerBodyMain.FrontRightFlipper.FrontRightFlipperArmor.BootTrim,
		lowerRoot.LowerBodyMain.FrontRightFlipper.FrontRightFlipperTip.FrontRightFlipperTipArmor.BootTrim,
		lowerRoot.LowerBodyMain.FrontLeftFlipper.FrontLeftFlipperArmor.BootTrim,
		lowerRoot.LowerBodyMain.FrontLeftFlipper.FrontLeftFlipperTip.FrontLeftFlipperTipArmor.BootTrim,
		lowerRoot.LowerBodyMain.BackRightFlipper.BackRightFlipperArmor.BootTrim,
		lowerRoot.LowerBodyMain.BackRightFlipper.BackRightFlipperTip.BackRightFlipperTipArmor.BootTrim,
		lowerRoot.LowerBodyMain.BackLeftFlipper.BackLeftFlipperArmor.BootTrim,
		lowerRoot.LowerBodyMain.BackLeftFlipper.BackLeftFlipperTip.BackLeftFlipperTipArmor.BootTrim
	)

-- Leather armor
kattArmor.Materials.leather
	:setTexture(textures["textures.armor.leatherArmor"])
	:addParts(kattArmor.Armor.Helmet,
		upperRoot.Head.headArmor.HelmetLeather
	)
	:addParts(kattArmor.Armor.Chestplate,
		upperRoot.Body.bodyArmor.ChestplateLeather,
		model.RightArmFP.rightArmArmorFP.ChestplateLeather,
		model.LeftArmFP.leftArmArmorFP.ChestplateLeather,
		upperRoot.RightArm.rightArmArmor.ChestplateLeather,
		upperRoot.LeftArm.leftArmArmor.ChestplateLeather,
		lowerRoot.LowerBodyMain.Shell.ShellArmor.ChestplateLeather,
		lowerRoot.LowerBodyMain.Shell.Spikes.SpikesArmor.SpikesChestplateLeather
	)
	:addParts(kattArmor.Armor.Leggings,
		upperRoot.Body.bodyArmor.BeltLeather,
		lowerRoot.LowerBodyFront.LowerBodyFrontArmor.LeggingsLeather,
		lowerRoot.LowerBodyMain.LowerBodyMainArmor.LeggingsLeather
	)
	:addParts(kattArmor.Armor.Boots,
		lowerRoot.LowerBodyMain.FrontRightFlipper.FrontRightFlipperArmor.BootLeather,
		lowerRoot.LowerBodyMain.FrontRightFlipper.FrontRightFlipperTip.FrontRightFlipperTipArmor.BootLeather,
		lowerRoot.LowerBodyMain.FrontLeftFlipper.FrontLeftFlipperArmor.BootLeather,
		lowerRoot.LowerBodyMain.FrontLeftFlipper.FrontLeftFlipperTip.FrontLeftFlipperTipArmor.BootLeather,
		lowerRoot.LowerBodyMain.BackRightFlipper.BackRightFlipperArmor.BootLeather,
		lowerRoot.LowerBodyMain.BackRightFlipper.BackRightFlipperTip.BackRightFlipperTipArmor.BootLeather,
		lowerRoot.LowerBodyMain.BackLeftFlipper.BackLeftFlipperArmor.BootLeather,
		lowerRoot.LowerBodyMain.BackLeftFlipper.BackLeftFlipperTip.BackLeftFlipperTipArmor.BootLeather
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