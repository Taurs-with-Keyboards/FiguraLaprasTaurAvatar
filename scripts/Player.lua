-- Required scripts
local parts = require("lib.GroupIndex")(models)

-- Glowing outline
renderer:outlineColor(vectors.hexToRGB("69CDEC"))

-- Config setup
config:name("LaprasTaur")
local vanillaSkin = config:load("AvatarVanillaSkin")
local slim        = config:load("AvatarSlim") or false
if vanillaSkin == nil then vanillaSkin = true end

-- Set skull and portrait groups to visible (incase disabled in blockbench)
parts.Skull   :visible(true)
parts.Portrait:visible(true)

-- All vanilla skin parts
local skin = {
	
	parts.Head.Head,
	parts.Head.Layer,
	
	parts.Body.Body,
	parts.Body.Layer,
	
	parts.leftArmDefault,
	parts.leftArmSlim,
	parts.leftArmDefaultFP,
	parts.leftArmSlimFP,
	
	parts.rightArmDefault,
	parts.rightArmSlim,
	parts.rightArmDefaultFP,
	parts.rightArmSlimFP,
	
	parts.Portrait.Head,
	parts.Portrait.Layer,
	
	parts.Skull.Head,
	parts.Skull.Layer
	
}

-- All layer parts
local layer = {
	
	HAT = {
		parts.Head.Layer
	},
	JACKET = {
		parts.Body.Layer,
		parts.Front.Layer
	},
	LEFT_SLEEVE = {
		parts.leftArmDefault.Layer,
		parts.leftArmSlim.Layer,
		parts.leftArmDefaultFP.Layer,
		parts.leftArmSlimFP.Layer
	},
	RIGHT_SLEEVE = {
		parts.rightArmDefault.Layer,
		parts.rightArmSlim.Layer,
		parts.rightArmDefaultFP.Layer,
		parts.rightArmSlimFP.Layer
	},
	LEFT_PANTS_LEG = {
		parts.FrontLeftFlipper.Layer,
		parts.FrontLeftFlipperTip.Layer,
		parts.BackLeftFlipper.Layer,
		parts.BackLeftFlipperTip.Layer
	},
	RIGHT_PANTS_LEG = {
		parts.FrontRightFlipper.Layer,
		parts.FrontRightFlipperTip.Layer,
		parts.BackRightFlipper.Layer,
		parts.BackRightFlipperTip.Layer
	},
	CAPE = {
		parts.Cape
	},
	LOWER_BODY = {
		parts.Main.Layer,
		parts.Shell.Layer,
		parts.SpikesLayer
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
	
	parts.leftArmDefault:visible(not slimShape)
	parts.rightArmDefault:visible(not slimShape)
	parts.leftArmDefaultFP:visible(not slimShape)
	parts.rightArmDefaultFP:visible(not slimShape)
	
	parts.leftArmSlim:visible(slimShape)
	parts.rightArmSlim:visible(slimShape)
	parts.leftArmSlimFP:visible(slimShape)
	parts.rightArmSlimFP:visible(slimShape)
	
	-- Skin textures
	local skinType = vanillaSkin and "SKIN" or "PRIMARY"
	for _, part in ipairs(skin) do
		part:primaryTexture(skinType)
	end
	
	-- Cape/Elytra textures
	parts.Cape:primaryTexture(vanillaSkin and "CAPE" or "PRIMARY")
	parts.Elytra:primaryTexture(vanillaSkin and player:hasCape() and (player:isSkinLayerVisible("CAPE") and "CAPE" or "ELYTRA") or "PRIMARY")
		:secondaryRenderType(player:getItem(5):hasGlint() and "GLINT" or "NONE")
	
	-- Disables lower body if player is in spectator mode
	parts.LowerBody:parentType(player:getGamemode() == "SPECTATOR" and "BODY" or "NONE")
	
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
t.vanillaSkinPage = action_wheel:newAction("VanillaSkin")
	:title("§9§lToggle Vanilla Texture\n\n§bToggles the usage of your vanilla skin for the upper body.")
	:hoverColor(vectors.hexToRGB("5EB7DD"))
	:toggleColor(vectors.hexToRGB("4078B0"))
	:item('minecraft:player_head{"SkullOwner":"'..avatar:getEntityName()..'"}')
	:onToggle(pings.setAvatarVanillaSkin)
	:toggled(vanillaSkin)

t.modelPage = action_wheel:newAction("ModelShape")
	:title("§9§lToggle Model Shape\n\n§bAdjust the model shape to use Default or Slim Proportions.\nWill be overridden by the vanilla skin toggle.")
	:hoverColor(vectors.hexToRGB("5EB7DD"))
	:toggleColor(vectors.hexToRGB("4078B0"))
	:item('minecraft:player_head')
	:toggleItem('minecraft:player_head{"SkullOwner":"MHF_Alex"}')
	:onToggle(pings.setAvatarModelType)
	:toggled(slim)

-- Return action wheel pages
return t