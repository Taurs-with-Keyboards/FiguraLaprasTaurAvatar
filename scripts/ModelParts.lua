-- Setup table
local t = {}

-- Models setup
t.model    = models.LaprasTaur
t.pokeball = models.Pokeball

-- Model parts
t.root  = t.model.Player
t.upper = t.root.UpperBody
t.lower = t.root.LowerBody

-- Head parts
t.head = t.upper.Head
t.eyes = t.head.Eyes
t.ears = t.head.Ears

-- Body parts
t.body   = t.upper.Body
t.elytra = t.body.Elytra
t.cape   = t.body.Cape

-- Arm parts
t.leftArm    = t.upper.LeftArm
t.rightArm   = t.upper.RightArm
t.leftArmFP  = t.model.LeftArmFP
t.rightArmFP = t.model.RightArmFP

-- Lower parts
t.front = t.lower.Front
t.main  = t.lower.Main

-- Shell parts
t.shell = t.main.Shell
t.chest = t.shell.Chest

-- Flipper parts
t.frontLeftFlipper  = t.main.FrontLeftFlipper
t.frontRightFlipper = t.main.FrontRightFlipper
t.backLeftFlipper   = t.main.BackLeftFlipper
t.backRightFlipper  = t.main.BackRightFlipper

-- Misc parts
t.skull    = t.model.Skull
t.portrait = t.model.Portrait

t.skull   :visible(true)
t.portrait:visible(true)

-- All vanilla skin parts
t.skin = {
	
	t.head.Head,
	t.head.Layer,
	
	t.body.Body,
	t.body.Layer,
	
	t.leftArm.leftArmDefault,
	t.leftArm.leftArmSlim,
	t.leftArmFP.leftArmDefaultFP,
	t.leftArmFP.leftArmSlimFP,
	
	t.rightArm.rightArmDefault,
	t.rightArm.rightArmSlim,
	t.rightArmFP.rightArmDefaultFP,
	t.rightArmFP.rightArmSlimFP,
	
	t.portrait.Head,
	t.portrait.Layer,
	
	t.skull.Head,
	t.skull.Layer
	
}

-- All layer parts
t.layer = {
	
	HAT = {
		t.head.Layer
	},
	JACKET = {
		t.body.Layer,
		t.front.Layer
	},
	LEFT_SLEEVE = {
		t.leftArm.leftArmDefault.Layer,
		t.leftArm.leftArmSlim.Layer,
		t.leftArmFP.leftArmDefaultFP.Layer,
		t.leftArmFP.leftArmSlimFP.Layer
	},
	RIGHT_SLEEVE = {
		t.rightArm.rightArmDefault.Layer,
		t.rightArm.rightArmSlim.Layer,
		t.rightArmFP.rightArmDefaultFP.Layer,
		t.rightArmFP.rightArmSlimFP.Layer
	},
	LEFT_PANTS_LEG = {
		t.frontLeftFlipper.Layer,
		t.frontLeftFlipper.FrontLeftFlipperTip.Layer,
		t.backLeftFlipper.Layer,
		t.backLeftFlipper.BackLeftFlipperTip.Layer
	},
	RIGHT_PANTS_LEG = {
		t.frontRightFlipper.Layer,
		t.frontRightFlipper.FrontRightFlipperTip.Layer,
		t.backRightFlipper.Layer,
		t.backRightFlipper.BackRightFlipperTip.Layer
	},
	CAPE = {
		t.cape
	},
	LOWER_BODY = {
		t.main.Layer,
		t.shell.Layer,
		t.shell.Spikes.SpikesLayer
	},
}

-- All helmet parts
t.helmetToggle = {
	
	t.head.headArmorHelmet,
	t.head.HelmetItemPivot
	
}

-- All chestplate parts
t.chestplateToggle = {
	
	t.body.bodyArmorChestplate,
	t.leftArm.leftArmArmorChestplate,
	t.rightArm.rightArmArmorChestplate,
	t.leftArmFP.leftArmArmorChestplateFP,
	t.rightArmFP.rightArmArmorChestplateFP
	
}

-- All shell armor parts
t.chestplateShellToggle = {
	
	t.shell.ShellArmorChestplate,
	t.shell.Spikes.SpikesArmorChestplate
	
}

-- All leggings parts
t.leggingsToggle = {
	
	t.body.bodyArmorLeggings,
	t.front.FrontArmorLeggings,
	t.main.MainArmorLeggings
	
}

-- All boots parts
t.bootsToggle = {
	
	t.frontLeftFlipper.FrontLeftFlipperArmorBoot,
	t.frontLeftFlipper.FrontLeftFlipperTip.FrontLeftFlipperTipArmorBoot,
	
	t.frontRightFlipper.FrontRightFlipperArmorBoot,
	t.frontRightFlipper.FrontRightFlipperTip.FrontRightFlipperTipArmorBoot,
	
	t.backLeftFlipper.BackLeftFlipperArmorBoot,
	t.backLeftFlipper.BackLeftFlipperTip.BackLeftFlipperTipArmorBoot,
	
	t.backRightFlipper.BackRightFlipperArmorBoot,
	t.backRightFlipper.BackRightFlipperTip.BackRightFlipperTipArmorBoot
	
}

--[[
	
	Because flat parts in the model are 2 faces directly on top
	of eachother, and have 0 inflate, the two faces will z-fight.
	This prevents z-fighting, as well as z-fighting at a distance,
	as well as translucent stacking.
	
	Please add plane/flat parts with 2 faces to the table below.
	0.01 works, but this works much better :)
	
--]]

-- All plane parts
t.planeParts = {
	
	
	
}

-- Apply
for _, part in ipairs(t.planeParts) do
	part:primaryRenderType("TRANSLUCENT_CULL")
end

-- Return model parts table
return t