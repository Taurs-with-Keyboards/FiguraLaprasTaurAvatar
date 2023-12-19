-- Model setup
local model     = models.LaprasTaur
local modelRoot = model.Player

-- Check for mods
local firstPersonMod = client.hasResource("firstperson:icon.png")

if require("Config").matchCamera == true then
  -- Variable setup
  local pose      = require("scripts.Posing")
  local collision = false
  
  -- Warnings
  if require("Config").cameraWarn and host:isHost() then
    log("Warning:\n Camera control is currently on.\n The camera will do everything it can to prevent x-ray.\n If your head is inside a block, the camera will not follow the head. (You can disable these warnings in the config. -Total)")
    
    local icon = model.Hud.CamIcon
    local timer = 0
    function events.TICK()
      local firstPerson = renderer:isFirstPerson()
      icon:setVisible(collision and firstPerson)
      if collision and firstPerson then
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
   if context == "FIRST_PERSON" or context == "RENDER" then
      -- Pos checking
      local playerPos = player:getPos(delta)
      trueHeadPos     = modelRoot.UpperBody.Head:partToWorldMatrix():apply()
      
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
      local shouldOffset = not collision and model:getScale():length() >= 0.5
      renderer:offsetCameraPivot(shouldOffset and offset or 0)
        :offsetCameraRot(shouldOffset and (renderer:isCameraBackwards() and camRot / 2 or camRot) or 0)
   end
  end
elseif firstPersonMod and require("Config").cameraWarn and host:isHost() then
  log("Notice: You have First Person Mod installed. This Avatar has a camera control feature that will enhance your experience. Check the config and give it a shot! -Total")
end