-- Required scripts
local eyes      = require("scripts.GlowingEyes")
local whirlpool = require("scripts.WhirlpoolEffect")
local fall      = require("scripts.FallSound")
local avatar    = require("scripts.Player")
local arms      = require("scripts.Arms")
local camera    = require("scripts.CameraControl")
local armor     = require("scripts.Armor")
local pokeball  = require("scripts.Pokeball")

-- Page setups
local mainPage      = action_wheel:newPage("MainPage")
local eyesPage      = action_wheel:newPage("GlowingEyesPage")
local whirlpoolPage = action_wheel:newPage("WhirlpoolPage")
local fallPage      = action_wheel:newPage("FallSoundPage")
local avatarPage    = action_wheel:newPage("AvatarPage")
local cameraPage    = action_wheel:newPage("CameraPage")
local armorPage     = action_wheel:newPage("ArmorPage")

-- Action back to main page
local backPage = action_wheel:newAction()
	:title("§c§lGo Back?")
	:hoverColor(vectors.hexToRGB("FF7F7F"))
	:item("minecraft:barrier")
	:onLeftClick(function() action_wheel:setPage(mainPage) end)

-- Set starting page to main page
action_wheel:setPage(mainPage)

-- Main actions
mainPage
	:action( -1,
		action_wheel:newAction()
			:title("§9§lGlowing Eyes Settings")
			:hoverColor(vectors.hexToRGB("5EB7DD"))
			:item("minecraft:ender_eye")
			:onLeftClick(function() action_wheel:setPage(eyesPage) end))
	
	:action( -1,
		action_wheel:newAction()
			:title("§9§lFall Sound Settings")
			:hoverColor(vectors.hexToRGB("5EB7DD"))
			:item("minecraft:pufferfish")
			:onLeftClick(function() action_wheel:setPage(fallPage) end))
	
	:action( -1,
		action_wheel:newAction()
			:title("§9§lWhirlpool Settings")
			:hoverColor(vectors.hexToRGB("5EB7DD"))
			:item("minecraft:magma_block")
			:onLeftClick(function() action_wheel:setPage(whirlpoolPage) end))
	
	:action( -1,
		action_wheel:newAction()
			:title("§9§lAvatar Settings")
			:hoverColor(vectors.hexToRGB("5EB7DD"))
			:item("minecraft:armor_stand")
			:onLeftClick(function() action_wheel:setPage(avatarPage) end))
	
	:action( -1,
		action_wheel:newAction()
			:title("§9§lCamera Settings")
			:hoverColor(vectors.hexToRGB("5EB7DD"))
			:item("minecraft:redstone")
			:onLeftClick(function() action_wheel:setPage(cameraPage) end))
	
	:action( -1,
		action_wheel:newAction()
			:title("§9§lArmor Settings")
			:hoverColor(vectors.hexToRGB("55FFFF"))
			:item("minecraft:iron_chestplate")
			:onLeftClick(function() action_wheel:setPage(armorPage) end))
	
	:action( -1, pokeball.togglePage)

-- Eye glow actions
eyesPage
	:action( -1, eyes.togglePage)
	:action( -1, eyes.powerPage)
	:action( -1, eyes.nightVisionPage)
	:action( -1, eyes.waterPage)
	:action( -1, backPage)

-- Whirlpool actions
whirlpoolPage
	:action( -1, whirlpool.bubblePage)
	:action( -1, whirlpool.dolphinsGracePage)
	:action( -1, backPage)

-- Flop sound actions
fallPage
	:action( -1, fall.soundPage)
	:action( -1, fall.dryPage)
	:action( -1, backPage)

-- Avatar actions
avatarPage
	:action( -1, avatar.vanillaSkinPage)
	:action( -1, avatar.modelPage)
	:action( -1, arms.movePage)
	:action( -1, backPage)

-- Camera actions
cameraPage
	:action( -1, camera.posPage)
	:action( -1, camera.eyePage)
	:action( -1, backPage)

-- Armor actions
-- armorPage
	-- :action( -1, armor.allPage)
	-- :action( -1, armor.bootsPage)
	-- :action( -1, armor.leggingsPage)
	-- :action( -1, armor.chestplatePage)
	-- :action( -1, armor.helmetPage)
	-- :action( -1, backPage)