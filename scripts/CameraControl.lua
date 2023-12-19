-- Model setup
local model     = models.LaprasTaur
local modelRoot = model.Player
local pokeball  = models.PokeBall

-- Variable setup
local config    = require("Config")
local camera    = config.matchCamera
local warn      = config.cameraWarn
local pose      = require("scripts.Posing")
local collision = false

-- Warnings
if warn and host:isHost() then
  local icon = model.Hud.CamIcon
  local timer = 0
  function events.TICK()
    local firstPerson = renderer:isFirstPerson()
    icon:setVisible(collision and firstPerson and camera)
    if collision and firstPerson and camera then
      timer = (timer % 40) + 1
      local x = timer <= 20
      
      local window = client:getScaledWindowSize().xy
      icon:setPos(-window.x / 2 - 20, -window.y / 2, 0)
      
      icon.Cross:setVisible(x)
    end
  end
end

-- Startup camera pos
local trueHeadPos = 0
function events.ENTITY_INIT()
  trueHeadPos = player:getPos()
end

function events.RENDER(delta, context)
  if context == "FIRST_PERSON" or context == "RENDER" or (not client.isHudEnabled() and context ~= "MINECRAFT_GUI") then
    -- Pos checking
    local playerPos = player:getPos(delta)
    trueHeadPos     = model:getScale():length() >= 0.5 and modelRoot.UpperBody.Head:partToWorldMatrix(delta):apply() or pokeball:partToWorldMatrix(delta):apply(0, 2.25, 0)
    
    -- Pehkui scaling
    local nbt = player:getNbt()
    local scale =
      (nbt["pehkui:scale_data_types"] and
      nbt["pehkui:scale_data_types"]["pehkui:base"] and
      nbt["pehkui:scale_data_types"]["pehkui:base"]["scale"]) and
      nbt["pehkui:scale_data_types"]["pehkui:base"]["scale"] or 1
    local modelWidth =
      (nbt["pehkui:scale_data_types"] and
      nbt["pehkui:scale_data_types"]["pehkui:model_width"] and
      nbt["pehkui:scale_data_types"]["pehkui:model_width"]["scale"]) and
      nbt["pehkui:scale_data_types"]["pehkui:model_width"]["scale"] or 1
    local modelHeight =
      (nbt["pehkui:scale_data_types"] and
      nbt["pehkui:scale_data_types"]["pehkui:model_height"] and
      nbt["pehkui:scale_data_types"]["pehkui:model_height"]["scale"]) and
      nbt["pehkui:scale_data_types"]["pehkui:model_height"]["scale"] or 1
    
    local offsetScale = vec(modelWidth, modelHeight, modelWidth) * scale
    
    -- Camera offset & rotation setup
    local offset = (trueHeadPos - playerPos) * (context == "FIRST_PERSON" and offsetScale or 1) + vec(0, -player:getEyeHeight(delta) + ((3/16) * offsetScale.y), 0)
    local camRot = -modelRoot.UpperBody:getOffsetRot(delta)
    
    -- Block gathering/collision checking (checks for full blocks)
    local blockPos = playerPos + offset + vec(0, player:getEyeHeight(delta) - ((3/16) * offsetScale.y), 0)
    local blocks = world.getBlocks(blockPos - 0.125, blockPos + 0.125)
    for _, block in ipairs(blocks) do
      if block:isFullCube() then
        collision = true
        break
      else
        collision = false
      end
    end
    
    -- Renders offset & rotation
    local shouldOffset = not collision and camera and not pose.spin
    renderer:offsetCameraPivot(shouldOffset and offset or 0)
      :offsetCameraRot(shouldOffset and model:getScale():length() >= 0.5 and (renderer:isCameraBackwards() and camRot / 2 or camRot) or 0)
  end
end

-- Camera toggler
local function setCamera(boolean)
  camera = boolean
end

-- Setup ping
pings.setCamera = setCamera

-- Return action wheel page
setCamera(camera)
return action_wheel:newAction()
  :title("Camera Toggle\n\nSets the camera position and rotation to where your model's head is!\nIf your head is inside a block, the camera will default to its original state.\nThis is done to prevent x-ray.")
  :hoverColor(vectors.hexToRGB("5EB7DD"))
  :toggleColor(vectors.hexToRGB("4078B0"))
  :item("minecraft:barrier")
  :toggleItem("minecraft:compass")
  :onToggle(pings.setCamera)
  :toggled(camera)