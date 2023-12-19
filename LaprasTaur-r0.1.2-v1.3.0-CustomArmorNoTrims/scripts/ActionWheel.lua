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
	:setAction( -1,
		action_wheel:newAction()
			:title("§9§lGlowing Eyes Settings")
			:hoverColor(vectors.hexToRGB("5EB7DD"))
			:item("minecraft:ender_eye")
			:onLeftClick(function() action_wheel:setPage(eyesPage) end))
	
	:setAction( -1,
		action_wheel:newAction()
			:title("§9§lFall Sound Settings")
			:hoverColor(vectors.hexToRGB("5EB7DD"))
			:item("minecraft:pufferfish")
			:onLeftClick(function() action_wheel:setPage(fallPage) end))
	
	:setAction( -1,
		action_wheel:newAction()
			:title("§9§lWhirlpool Settings")
			:hoverColor(vectors.hexToRGB("5EB7DD"))
			:item("minecraft:magma_block")
			:onLeftClick(function() action_wheel:setPage(whirPage) end))
	
	:setAction( -1,
		action_wheel:newAction()
			:title("§9§lAvatar Settings")
			:hoverColor(vectors.hexToRGB("5EB7DD"))
			:item("minecraft:armor_stand")
			:onLeftClick(function() action_wheel:setPage(avatPage) end))
	
	:setAction( -1,
		action_wheel:newAction()
			:title("§9§lCamera Settings")
			:hoverColor(vectors.hexToRGB("5EB7DD"))
			:item("minecraft:redstone")
			:onLeftClick(function() action_wheel:setPage(camPage) end))
	
	:setAction( -1, require("scripts.Pokeball").togglePage)

-- Eye glow actions
do
	local eyes = require("scripts.GlowingEyes")
	eyesPage
		:setAction( -1, eyes.togglePage)
		:setAction( -1, eyes.originsPage)
		:setAction( -1, eyes.effectPage)
		:setAction( -1, eyes.waterPage)
		:setAction( -1, backPage)
end

-- WhirlPool actions
do
	local whir = require("scripts.WhirlpoolEffect")
	whirPage
		:setAction( -1, whir.bubblePage)
		:setAction( -1, whir.effectPage)
		:setAction( -1, backPage)
end

-- Flop sound actions
do
	local fall = require("scripts.FallSound")
	fallPage
		:setAction( -1, fall.soundPage)
		:setAction( -1, fall.dryPage)
		:setAction( -1, backPage)
	
	function events.TICK()
		action_wheel:getPage("FallSoundPage"):getAction(2):setTitle(fall.dryTitle)
	end
end

-- Avatar actions
do
	local avatar = require("scripts.Player")
	avatPage
		:setAction( -1, avatar.vanillaSkinPage)
		:setAction( -1, avatar.modelPage)
		:setAction( -1, require("scripts.Animations"))
		:setAction( -1, require("scripts.ArmSwingControl"))
		:setAction( -1, backPage)
end

-- Camera actions
do
	local camera = require("scripts.CameraControl")
	camPage
		:setAction( -1, camera.posPage)
		:setAction( -1, camera.rotPage)
		:setAction( -1, camera.eyePage)
		:setAction( -1, backPage)
end