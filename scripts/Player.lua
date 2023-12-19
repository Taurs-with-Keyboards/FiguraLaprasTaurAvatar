-- Model setup
local model = models.LaprasTaur
local modelRoot = model.Player

-- Variable setup
local config = require("Config")

-- Sets the skin for the model parts
local vanillaSkinParts = {
  modelRoot.UpperBody.Head.Head,
  modelRoot.UpperBody.Head.HatLayer,

  modelRoot.UpperBody.Body.Body,
  modelRoot.UpperBody.Body.BodyLayer,

  modelRoot.UpperBody.RightArm.Steve,
  modelRoot.UpperBody.RightArm.Alex,

  modelRoot.UpperBody.LeftArm.Steve,
  modelRoot.UpperBody.LeftArm.Alex,
  
  model.Portrait.Head,
  model.Portrait.HatLayer,
  
  model.Skull.Head,
  model.Skull.HatLayer,
}
for _, part in pairs(vanillaSkinParts) do
  part:setPrimaryTexture(config.usesPlayerSkin and "SKIN" or nil)
end

-- Sets the modelType of the avatar.
local alex = config.isAlex or false
modelRoot.UpperBody.LeftArm.Steve:setVisible(not alex and nil)
modelRoot.UpperBody.RightArm.Steve:setVisible(not alex and nil)

modelRoot.UpperBody.LeftArm.Alex:setVisible(alex and nil)
modelRoot.UpperBody.RightArm.Alex:setVisible(alex and nil)

-- Show/hide skin layers depending on Skin Customization settings
local layerParts = {
  HAT = {
    modelRoot.UpperBody.Head.HatLayer,
  },
  JACKET = {
    modelRoot.UpperBody.Body.BodyLayer,
    modelRoot.LowerBody.Front.FrontLayer,
    modelRoot.LowerBody.Main.MainLayer,
    modelRoot.LowerBody.Main.Shell.UpperLayer,
    modelRoot.LowerBody.Main.Shell.LowerLayer,
  },
  RIGHT_SLEEVE = {
    modelRoot.UpperBody.RightArm.Steve.RightArmLayer,
    modelRoot.UpperBody.RightArm.Alex.RightArmLayer,
  },
  LEFT_SLEEVE = {
    modelRoot.UpperBody.LeftArm.Steve.LeftArmLayer,
    modelRoot.UpperBody.LeftArm.Alex.LeftArmLayer,
  },
}
function events.TICK()
  for playerPart, parts in pairs(layerParts) do
    local enabled = true
    enabled = player:isSkinLayerVisible(playerPart)
    enabled = enabled and nil
    for _, part in ipairs(parts) do
      part:setVisible(enabled)
    end
  end
end

-- Disables lower body if player is in spectator mode
function events.TICK()
  modelRoot.LowerBody:setParentType(player:getGamemode() == "SPECTATOR" and "BODY" or "NONE")
end