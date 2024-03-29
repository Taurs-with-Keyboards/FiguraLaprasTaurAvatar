-- Required scripts
local itemCheck = require("lib.ItemCheck")
local avatar    = require("scripts.Player")
local armor     = require("scripts.Armor")
local camera    = require("scripts.CameraControl")
local color     = require("scripts.ColorProperties")
local fall      = require("scripts.FallSound")
local whirlpool = require("scripts.WhirlpoolEffect")
local eyes      = require("scripts.GlowingEyes")
local anims     = require("scripts.Anims")
local arms      = require("scripts.Arms")
local pokeball  = require("scripts.Pokeball")

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

-- Page setups
local pages = {
	
	main      = action_wheel:newPage(),
	avatar    = action_wheel:newPage(),
	armor     = action_wheel:newPage(),
	camera    = action_wheel:newPage(),
	pokemon   = action_wheel:newPage(),
	fall      = action_wheel:newPage(),
	whirlpool = action_wheel:newPage(),
	eyes      = action_wheel:newPage(),
	anims     = action_wheel:newPage()
	
}

-- Page actions
local pageActions = {
	
	avatar = action_wheel:newAction()
		:item(itemCheck("armor_stand"))
		:onLeftClick(function() descend(pages.avatar) end),
	
	pokemon = action_wheel:newAction()
		:item(itemCheck("cobblemon:water_stone", "turtle_egg"))
		:onLeftClick(function() descend(pages.pokemon) end),
	
	anims = action_wheel:newAction()
		:item(itemCheck("jukebox"))
		:onLeftClick(function() descend(pages.anims) end),
	
	armor = action_wheel:newAction()
		:item(itemCheck("iron_chestplate"))
		:onLeftClick(function() descend(pages.armor) end),
	
	camera = action_wheel:newAction()
		:item(itemCheck("redstone"))
		:onLeftClick(function() descend(pages.camera) end),
	
	fall = action_wheel:newAction()
		:item(itemCheck("pufferfish"))
		:onLeftClick(function() descend(pages.fall) end),
	
	whirlpool = action_wheel:newAction()
		:item(itemCheck("magma_block"))
		:onLeftClick(function() descend(pages.whirlpool) end),
	
	eyes = action_wheel:newAction()
		:item(itemCheck("ender_eye"))
		:onLeftClick(function() descend(pages.eyes) end)
	
}

-- Update action page info
function events.TICK()
	
	pageActions.avatar
		:title(color.primary.."Avatar Settings")
		:hoverColor(color.hover)
	
	pageActions.pokemon
		:title(color.primary.."Pokemon Settings")
		:hoverColor(color.hover)
	
	pageActions.anims
		:title(color.primary.."Animations")
		:hoverColor(color.hover)
	
	pageActions.armor
		:title(color.primary.."Armor Settings")
		:hoverColor(color.hover)
	
	pageActions.camera
		:title(color.primary.."Camera Settings")
		:hoverColor(color.hover)
	
	pageActions.fall
		:title(color.primary.."Fall Sound Settings")
		:hoverColor(color.hover)
	
	pageActions.whirlpool
		:title(color.primary.."Whirlpool Settings")
		:hoverColor(color.hover)
	
	pageActions.eyes
		:title(color.primary.."Glowing Eyes Settings")
		:hoverColor(color.hover)
	
end

-- Action back to previous page
local backAction = action_wheel:newAction()
	:title("§c§lGo Back?")
	:hoverColor(vectors.hexToRGB("FF5555"))
	:item(itemCheck("barrier"))
	:onLeftClick(function() ascend() end)

-- Set starting page to main page
action_wheel:setPage(pages.main)

-- Main actions
pages.main
	:action( -1, pageActions.avatar)
	:action( -1, pageActions.pokemon)
	:action( -1, pageActions.eyes)
	:action( -1, pageActions.anims)
	:action( -1, pokeball.togglePage)

-- Avatar actions
pages.avatar
	:action( -1, avatar.vanillaSkinPage)
	:action( -1, avatar.modelPage)
	:action( -1, pageActions.armor)
	:action( -1, pageActions.camera)
	:action( -1, backAction)

-- Armor actions
pages.armor
	:action( -1, armor.helmetPage)
	:action( -1, armor.chestplatePage)
	:action( -1, armor.leggingsPage)
	:action( -1, armor.bootsPage)
	:action( -1, armor.shellPage)
	:action( -1, armor.allPage)
	:action( -1, backAction)

-- Camera actions
pages.camera
	:action( -1, camera.posPage)
	:action( -1, camera.eyePage)
	:action( -1, backAction)

-- Lapras actions
pages.pokemon
	:action( -1, color.shinyPage)
	:action( -1, pageActions.fall)
	:action( -1, pageActions.whirlpool)
	:action( -1, backAction)

-- Flop sound actions
pages.fall
	:action( -1, fall.soundPage)
	:action( -1, fall.dryPage)
	:action( -1, backAction)

-- Whirlpool actions
pages.whirlpool
	:action( -1, whirlpool.bubblePage)
	:action( -1, whirlpool.dolphinsGracePage)
	:action( -1, backAction)

-- Eye glow actions
pages.eyes
	:action( -1, eyes.togglePage)
	:action( -1, eyes.powerPage)
	:action( -1, eyes.nightVisionPage)
	:action( -1, eyes.waterPage)
	:action( -1, backAction)

-- Animation actions
pages.anims
	:action( -1, anims.stretchPage)
	:action( -1, anims.laughPage)
	:action( -1, anims.frontFlipPage)
	:action( -1, anims.backFlipPage)
	:action( -1, arms.movePage)
	:action( -1, backAction)