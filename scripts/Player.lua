-- Required scripts
local pokemonParts  = require("lib.GroupIndex")(models.models.LaprasTaur)
local pokeballParts = require("lib.GroupIndex")(models.models.Pokeball)
local itemCheck     = require("lib.ItemCheck")
local color         = require("scripts.ColorProperties")

-- Glowing outline
renderer:outlineColor(vectors.hexToRGB("69CDEC"))

-- Config setup
config:name("LaprasTaur")
local vanillaSkin = config:load("AvatarVanillaSkin")
local slim        = config:load("AvatarSlim") or false
if vanillaSkin == nil then vanillaSkin = true end

-- Set skull and portrait groups to visible (incase disabled in blockbench)
pokemonParts.Skull   :visible(true)
pokemonParts.Portrait:visible(true)

-- All vanilla skin parts
local skin = {
	
	pokemonParts.Head.Head,
	pokemonParts.Head.Layer,
	
	pokemonParts.Body.Body,
	pokemonParts.Body.Layer,
	
	pokemonParts.leftArmDefault,
	pokemonParts.leftArmSlim,
	pokemonParts.leftArmDefaultFP,
	pokemonParts.leftArmSlimFP,
	
	pokemonParts.rightArmDefault,
	pokemonParts.rightArmSlim,
	pokemonParts.rightArmDefaultFP,
	pokemonParts.rightArmSlimFP,
	
	pokemonParts.Portrait.Head,
	pokemonParts.Portrait.Layer,
	
	pokemonParts.Skull.Head,
	pokemonParts.Skull.Layer
	
}

-- All layer parts
local layer = {
	
	HAT = {
		pokemonParts.Head.Layer
	},
	JACKET = {
		pokemonParts.Body.Layer,
		pokemonParts.Neck.Layer
	},
	LEFT_SLEEVE = {
		pokemonParts.leftArmDefault.Layer,
		pokemonParts.leftArmSlim.Layer,
		pokemonParts.leftArmDefaultFP.Layer,
		pokemonParts.leftArmSlimFP.Layer
	},
	RIGHT_SLEEVE = {
		pokemonParts.rightArmDefault.Layer,
		pokemonParts.rightArmSlim.Layer,
		pokemonParts.rightArmDefaultFP.Layer,
		pokemonParts.rightArmSlimFP.Layer
	},
	LEFT_PANTS_LEG = {
		pokemonParts.FrontLeftFlipper.Layer,
		pokemonParts.FrontLeftFlipperTip.Layer,
		pokemonParts.BackLeftFlipper.Layer,
		pokemonParts.BackLeftFlipperTip.Layer
	},
	RIGHT_PANTS_LEG = {
		pokemonParts.FrontRightFlipper.Layer,
		pokemonParts.FrontRightFlipperTip.Layer,
		pokemonParts.BackRightFlipper.Layer,
		pokemonParts.BackRightFlipperTip.Layer
	},
	CAPE = {
		pokemonParts.Cape
	},
	LOWER_BODY = {
		pokemonParts.Main.Layer,
		pokemonParts.Shell.Layer,
		pokemonParts.SpikeMF.Layer,
		pokemonParts.SpikeMM.Layer,
		pokemonParts.SpikeMB.Layer,
		pokemonParts.SpikeLS.Layer,
		pokemonParts.SpikeLF.Layer,
		pokemonParts.SpikeLB.Layer,
		pokemonParts.SpikeRS.Layer,
		pokemonParts.SpikeRF.Layer,
		pokemonParts.SpikeRB.Layer
	},
}

-- Determine vanilla player type on init
local vanillaAvatarType
function events.ENTITY_INIT()
	
	vanillaAvatarType = player:getModelType()
	
end

-- Misc tick required events
function events.TICK()
	
	-- Model shape
	local slimShape = (vanillaSkin and vanillaAvatarType == "SLIM") or (slim and not vanillaSkin)
	
	pokemonParts.leftArmDefault:visible(not slimShape)
	pokemonParts.rightArmDefault:visible(not slimShape)
	pokemonParts.leftArmDefaultFP:visible(not slimShape)
	pokemonParts.rightArmDefaultFP:visible(not slimShape)
	
	pokemonParts.leftArmSlim:visible(slimShape)
	pokemonParts.rightArmSlim:visible(slimShape)
	pokemonParts.leftArmSlimFP:visible(slimShape)
	pokemonParts.rightArmSlimFP:visible(slimShape)
	
	-- Skin textures
	local skinType = vanillaSkin and "SKIN" or "PRIMARY"
	for _, part in ipairs(skin) do
		part:primaryTexture(skinType)
	end
	
	-- Cape textures
	pokemonParts.Cape:primaryTexture(vanillaSkin and "CAPE" or "PRIMARY")
	
	-- Layer toggling
	for layerType, parts in pairs(layer) do
		local enabled = enabled
		if layerType == "LOWER_BODY" then
			enabled = player:isSkinLayerVisible("RIGHT_PANTS_LEG") or player:isSkinLayerVisible("LEFT_PANTS_LEG")
		else
			enabled = player:isSkinLayerVisible(layerType)
		end
		for _, part in ipairs(parts) do
			part:visible(enabled)
		end
	end
	
end

function events.RENDER(delta, context)
	
	-- Scales models to fit GUIs better
	if context == "FIGURA_GUI" or context == "MINECRAFT_GUI" or context == "PAPERDOLL" then
		pokemonParts.Player:scale(0.75)
		pokeballParts.Ball:scale(0.75)
	end
	
end

function events.POST_RENDER(delta, context)
	
	-- After scaling models to fit GUIs, immediately scale back
	pokemonParts.Player:scale(1)
	pokeballParts.Ball:scale(1)
	
end

-- Vanilla skin toggle
local function setVanillaSkin(boolean)
	
	vanillaSkin = boolean
	config:save("AvatarVanillaSkin", vanillaSkin)
	
end

-- Model type toggle
local function setModelType(boolean)
	
	slim = boolean
	config:save("AvatarSlim", slim)
	
end

-- Sync variables
local function syncPlayer(a, b)
	
	vanillaSkin = a
	slim = b
	
end

-- Pings setup
pings.setAvatarVanillaSkin = setVanillaSkin
pings.setAvatarModelType   = setModelType
pings.syncPlayer           = syncPlayer

-- Sync on tick
if host:isHost() then
	function events.TICK()
		
		if world.getTime() % 200 == 0 then
			pings.syncPlayer(vanillaSkin, slim)
		end
		
	end
end

-- Activate actions
setVanillaSkin(vanillaSkin)
setModelType(slim)

-- Setup table
local t = {}

-- Action wheel pages
t.vanillaSkinPage = action_wheel:newAction()
	:item(itemCheck("player_head{'SkullOwner':'"..avatar:getEntityName().."'}"))
	:onToggle(pings.setAvatarVanillaSkin)
	:toggled(vanillaSkin)

t.modelPage = action_wheel:newAction()
	:item(itemCheck("player_head"))
	:toggleItem(itemCheck("player_head{'SkullOwner':'MHF_Alex'}"))
	:onToggle(pings.setAvatarModelType)
	:toggled(slim)

-- Update action page info
function events.TICK()
	
	t.vanillaSkinPage
		:title(color.primary.."Toggle Vanilla Texture\n\n"..color.secondary.."Toggles the usage of your vanilla skin for the upper body.")
		:hoverColor(color.hover)
		:toggleColor(color.active)
	
	t.modelPage
		:title(color.primary.."Toggle Model Shape\n\n"..color.secondary.."Adjust the model shape to use Default or Slim Proportions.\nWill be overridden by the vanilla skin toggle.")
		:hoverColor(color.hover)
		:toggleColor(color.active)
	
end

-- Return action wheel pages
return t