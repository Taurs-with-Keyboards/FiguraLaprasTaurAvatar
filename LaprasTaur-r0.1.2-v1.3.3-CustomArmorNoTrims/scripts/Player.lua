-- Model setup
local model     = models.LaprasTaur
local upperRoot = model.Player.UpperBody
local lowerRoot = model.Player.LowerBody

-- Glowing outline
renderer:outlineColor(vectors.hexToRGB("69CDEC"))

-- Config setup
config:name("LaprasTaur")
local vanillaSkin = config:load("AvatarVanillaSkin")
if vanillaSkin == nil then vanillaSkin = true end
local slim = config:load("AvatarSlim") or false

-- Vanilla parts table
local skinParts = {
	upperRoot.Head.Head,
	upperRoot.Head.HatLayer,
	
	upperRoot.Body.Body,
	upperRoot.Body.BodyLayer,
	
	model.RightArm.Default,
	model.RightArm.Slim,
	upperRoot.RightArm.Default,
	upperRoot.RightArm.Slim,
	
	model.LeftArm.Default,
	model.LeftArm.Slim,
	upperRoot.LeftArm.Default,
	upperRoot.LeftArm.Slim,
	
	model.Portrait.Head,
	model.Portrait.HatLayer,
	
	model.Skull.Head,
	model.Skull.HatLayer,
}

-- Variable setup
local vanillaAvatarType = nil
function events.ENTITY_INIT()
	vanillaAvatarType = player:getModelType()
end

-- Misc tick required events
function events.TICK()
	-- Model shape
	local slimShape = (vanillaSkin and vanillaAvatarType == "SLIM") or (slim and not vanillaSkin)
	
	model.LeftArm.Default:visible(not slimShape)
	model.RightArm.Default:visible(not slimShape)
	upperRoot.LeftArm.Default:visible(not slimShape)
	upperRoot.RightArm.Default:visible(not slimShape)
	
	model.LeftArm.Slim:visible(slimShape)
	model.RightArm.Slim:visible(slimShape)
	upperRoot.LeftArm.Slim:visible(slimShape)
	upperRoot.RightArm.Slim:visible(slimShape)
	
	-- Skin textures
	for _, part in ipairs(skinParts) do
		part:primaryTexture(vanillaSkin and "SKIN" or "CUSTOM", textures["textures.skin"])
	end
	
	-- Cape/Elytra texture
	upperRoot.Body.Cape:primaryTexture(vanillaSkin and "CAPE" or nil)
	upperRoot.Body.Elytra:primaryTexture(vanillaSkin and player:hasCape() and (player:isSkinLayerVisible("CAPE") and "CAPE" or "ELYTRA") or nil)
		:secondaryRenderType(player:getItem(5):hasGlint() and "GLINT" or "NONE")
	
	-- Disables lower body if player is in spectator mode
	lowerRoot:parentType(player:getGamemode() == "SPECTATOR" and "BODY" or "NONE")
	
end

-- Show/hide skin layers depending on Skin Customization settings
local layerParts = {
	HAT = {
		upperRoot.Head.HatLayer,
	},
	JACKET = {
		upperRoot.Body.BodyLayer,
		lowerRoot.Front.FrontLayer,
		lowerRoot.Main.MainLayer,
		lowerRoot.Main.Shell.ExternalLayer,
		lowerRoot.Main.Shell.Spikes.SpikesLayer,
	},
	RIGHT_SLEEVE = {
		upperRoot.RightArm.Default.ArmLayer,
		upperRoot.RightArm.Slim.ArmLayer,
	},
	LEFT_SLEEVE = {
		upperRoot.LeftArm.Default.ArmLayer,
		upperRoot.LeftArm.Slim.ArmLayer,
	},
	RIGHT_PANTS_LEG = {
		lowerRoot.Main.FlipperFrontRight.FlipperLayer,
		lowerRoot.Main.FlipperFrontRight.Tip.FlipperLayer,
		lowerRoot.Main.FlipperBackRight.FlipperLayer,
		lowerRoot.Main.FlipperBackRight.Tip.FlipperLayer,
	},
	LEFT_PANTS_LEG = {
		lowerRoot.Main.FlipperFrontLeft.FlipperLayer,
		lowerRoot.Main.FlipperFrontLeft.Tip.FlipperLayer,
		lowerRoot.Main.FlipperBackLeft.FlipperLayer,
		lowerRoot.Main.FlipperBackLeft.Tip.FlipperLayer,
	},
	CAPE = {
		upperRoot.Body.Cape,
	},
}
function events.TICK()
	for playerPart, parts in pairs(layerParts) do
		local enabled = player:isSkinLayerVisible(playerPart)
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
			pings.syncPlayer(vanillaSkin, slim, skin)
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

-- Return table
return t