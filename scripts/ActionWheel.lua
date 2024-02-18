-- Required scripts
local avatar    = require("scripts.Player")
local armor     = require("scripts.Armor")
local camera    = require("scripts.CameraControl")
local fall      = require("scripts.FallSound")
local whirlpool = require("scripts.WhirlpoolEffect")
local eyes      = require("scripts.GlowingEyes")
local anims     = require("scripts.Anims")
local arms      = require("scripts.Arms")
local pokeball  = require("scripts.Pokeball")

-- Page setups
local mainPage      = action_wheel:newPage("MainPage")
local avatarPage    = action_wheel:newPage("AvatarPage")
local armorPage     = action_wheel:newPage("ArmorPage")
local cameraPage    = action_wheel:newPage("CameraPage")
local laprasPage    = action_wheel:newPage("LaprasPage")
local fallPage      = action_wheel:newPage("FallSoundPage")
local whirlpoolPage = action_wheel:newPage("WhirlpoolPage")
local eyesPage      = action_wheel:newPage("GlowingEyesPage")
local animsPage     = action_wheel:newPage("AnimationPage")

-- Logs pages for navigation
local navigation = {}

-- Go forward a page
local function descend(page)
	
	navigation[#navigation + 1] = action_wheel:getCurrentPage() 
	action_wheel:setPage(page)
	
end

-- Go back a page
local function ascend()
	
	action_wheel:setPage(table.remove(navigation, #navigation))
	
end

-- Action back to previous page
local backPage = action_wheel:newAction()
	:title("§c§lGo Back?")
	:hoverColor(vectors.hexToRGB("FF5555"))
	:item("minecraft:barrier")
	:onLeftClick(function() ascend() end)

-- Set starting page to main page
action_wheel:setPage(mainPage)

-- Main actions
mainPage
	:action( -1,
		action_wheel:newAction()
			:title("§9§lAvatar Settings")
			:hoverColor(vectors.hexToRGB("5EB7DD"))
			:item("minecraft:armor_stand")
			:onLeftClick(function() descend(avatarPage) end))
	
	:action( -1,
		action_wheel:newAction()
			:title("§9§lLapras Settings")
			:hoverColor(vectors.hexToRGB("5EB7DD"))
			:item("minecraft:turtle_helmet")
			:onLeftClick(function() descend(laprasPage) end))
	
	:action( -1,
		action_wheel:newAction()
			:title("§9§lAnimations")
			:hoverColor(vectors.hexToRGB("5EB7DD"))
			:item("minecraft:jukebox")
			:onLeftClick(function() descend(animsPage) end))
	
	:action( -1, pokeball.togglePage)

-- Avatar actions
avatarPage
	:action( -1, avatar.vanillaSkinPage)
	:action( -1, avatar.modelPage)
	:action( -1,
		action_wheel:newAction()
			:title("§9§lArmor Settings")
			:hoverColor(vectors.hexToRGB("5EB7DD"))
			:item("minecraft:iron_chestplate")
			:onLeftClick(function() descend(armorPage) end))
	:action( -1,
		action_wheel:newAction()
			:title("§9§lCamera Settings")
			:hoverColor(vectors.hexToRGB("5EB7DD"))
			:item("minecraft:redstone")
			:onLeftClick(function() descend(cameraPage) end))
	:action( -1, backPage)

-- Armor actions
armorPage
	:action( -1, armor.helmetPage)
	:action( -1, armor.chestplatePage)
	:action( -1, armor.leggingsPage)
	:action( -1, armor.bootsPage)
	:action( -1, armor.shellPage)
	:action( -1, armor.allPage)
	:action( -1, backPage)

-- Camera actions
cameraPage
	:action( -1, camera.posPage)
	:action( -1, camera.eyePage)
	:action( -1, backPage)

-- Lapras actions
laprasPage
	:action( -1,
		action_wheel:newAction()
			:title("§9§lFall Sound Settings")
			:hoverColor(vectors.hexToRGB("5EB7DD"))
			:item("minecraft:pufferfish")
			:onLeftClick(function() descend(fallPage) end))
	:action( -1,
		action_wheel:newAction()
			:title("§9§lWhirlpool Settings")
			:hoverColor(vectors.hexToRGB("5EB7DD"))
			:item("minecraft:magma_block")
			:onLeftClick(function() descend(whirlpoolPage) end))
	:action( -1,
		action_wheel:newAction()
			:title("§9§lGlowing Eyes Settings")
			:hoverColor(vectors.hexToRGB("5EB7DD"))
			:item("minecraft:ender_eye")
			:onLeftClick(function() descend(eyesPage) end))
	:action( -1, backPage)

-- Flop sound actions
fallPage
	:action( -1, fall.soundPage)
	:action( -1, fall.dryPage)
	:action( -1, backPage)

-- Whirlpool actions
whirlpoolPage
	:action( -1, whirlpool.bubblePage)
	:action( -1, whirlpool.dolphinsGracePage)
	:action( -1, backPage)

-- Eye glow actions
eyesPage
	:action( -1, eyes.togglePage)
	:action( -1, eyes.powerPage)
	:action( -1, eyes.nightVisionPage)
	:action( -1, eyes.waterPage)
	:action( -1, backPage)

-- Animation actions
animsPage
	:action( -1, arms.movePage)
	:action( -1, backPage)