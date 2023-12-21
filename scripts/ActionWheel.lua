-- Connects various actions accross many scripts into pages
local mainPage = action_wheel:newPage("MainPage")
local eyesPage = action_wheel:newPage("GlowingEyesPage")
local whirPage = action_wheel:newPage("WhirlpoolPage")
local fallPage = action_wheel:newPage("FallSoundPage")
local avatPage = action_wheel:newPage("AvatarPage")
local camPage  = action_wheel:newPage("CameraPage")
local backPage = action_wheel:newAction()
	:title("§c§lGo Back?")
	:hoverColor(vectors.hexToRGB("FF7F7F"))
	:item("minecraft:barrier")
	:onLeftClick(function() action_wheel:setPage(mainPage) end)

action_wheel:setPage(mainPage)

-- Main actions
mainPage
	:action( 1,
		action_wheel:newAction()
			:title("§9§lGlowing Eyes Settings")
			:hoverColor(vectors.hexToRGB("5EB7DD"))
			:item("minecraft:ender_eye")
			:onLeftClick(function() action_wheel:setPage(eyesPage) end))
	
	:action( 2,
		action_wheel:newAction()
			:title("§9§lFall Sound Settings")
			:hoverColor(vectors.hexToRGB("5EB7DD"))
			:item("minecraft:pufferfish")
			:onLeftClick(function() action_wheel:setPage(fallPage) end))
	
	:action( 3,
		action_wheel:newAction()
			:title("§9§lWhirlpool Settings")
			:hoverColor(vectors.hexToRGB("5EB7DD"))
			:item("minecraft:magma_block")
			:onLeftClick(function() action_wheel:setPage(whirPage) end))
	
	:action( 4,
		action_wheel:newAction()
			:title("§9§lAvatar Settings")
			:hoverColor(vectors.hexToRGB("5EB7DD"))
			:item("minecraft:armor_stand")
			:onLeftClick(function() action_wheel:setPage(avatPage) end))
	
	:action( 5,
		action_wheel:newAction()
			:title("§9§lCamera Settings")
			:hoverColor(vectors.hexToRGB("5EB7DD"))
			:item("minecraft:redstone")
			:onLeftClick(function() action_wheel:setPage(camPage) end))
	
	:action( 6, require("scripts.Pokeball").togglePage)

-- Eye glow actions
do
	local eyes = require("scripts.GlowingEyes")
	eyesPage
		:action( 1, eyes.togglePage)
		:action( 2, eyes.originsPage)
		:action( 3, eyes.effectPage)
		:action( 4, eyes.waterPage)
		:action( 5, backPage)
end

-- WhirlPool actions
do
	local whir = require("scripts.WhirlpoolEffect")
	whirPage
		:action( 1, whir.bubblePage)
		:action( 2, whir.effectPage)
		:action( 3, backPage)
end

-- Flop sound actions
do
	local fall = require("scripts.FallSound")
	fallPage
		:action( 1, fall.soundPage)
		:action( 2, fall.dryPage)
		:action( 3, backPage)
end

-- Avatar actions
do
	local avatar = require("scripts.Player")
	avatPage
		:action( 1, avatar.vanillaSkinPage)
		:action( 2, avatar.modelPage)
		:action( 3, require("scripts.Arms"))
		:action( 4, backPage)
end

-- Camera actions
do
	local camera = require("scripts.CameraControl")
	camPage
		:action( 1, camera.posPage)
		:action( 2, camera.rotPage)
		:action( 3, camera.eyePage)
		:action( 4, backPage)
end