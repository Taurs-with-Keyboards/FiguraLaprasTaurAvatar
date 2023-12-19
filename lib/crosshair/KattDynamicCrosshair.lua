--================================================--
--   _  ___ _    ____      _    ___   __  ____    --
--  | |/ (_) |_ / ___|__ _| |_ / _ \ / /_|___ \   --
--  | ' /| | __| |   / _` | __| (_) | '_ \ __) |  --
--  | . \| | |_| |__| (_| | |_ \__, | (_) / __/   --
--  |_|\_\_|\__|\____\__,_|\__|  /_/ \___/_____|  --
--                                                --
--================================================--

--v2.3

if not host:isHost() or require("Config").matchCamera ~= true then models.lib.crosshair.Crosshair:setVisible(false) return end

renderer:setRenderCrosshair(false)

local curDir = (...):gsub("(.)$", "%1.")
local model
do
  local tmpModel = models
  for value in string.gmatch(curDir, "(.-)%.") do
    tmpModel = tmpModel[value]
  end
  model = tmpModel.Crosshair:setParentType("GUI")
end
local pos = vectors.vec3()

local function validBlock(block)
  return block and not block:isAir()
end
function events.ENTITY_INIT() pos:set(player:getPos()) end

---@class KattDynamicCrosshairAPI
---@field model ModelPart
---@field render fun(pos:Vector3, target:EntityAPI|BlockState, screenCoords:Vector2)
local api = { model = model }

function events.RENDER(delta, context)
  if context == "FIRST_PERSON" then
    local entity, entityPos = player:getTargetedEntity(host:getReachDistance())
    local block, blockPos = player:getTargetedBlock(true, host:getReachDistance())
    local deltaDeltaPos = player:getPos(delta) - player:getPos()
    local targetPos = entity and entityPos:add(deltaDeltaPos)
        or validBlock(block) and blockPos:add(deltaDeltaPos)
        or player:getPos(delta)
        :add(0, player:getEyeHeight())
        :add(player:getLookDir() * host:getReachDistance())
    pos:set(math.lerp(pos, targetPos, 0.35))
    
    local screenSpace = vectors.worldToScreenSpace(pos)
    local coords = screenSpace.xy:add(1, 1):mul(client:getScaledWindowSize()):div(-2, -2)
    
    if api.render then api.render(pos, entity or block, coords) end
    
    model:setPos(coords.xy_)
        :setVisible(screenSpace.z >= 1)
        :setScale(3 / screenSpace.w)
  else
    model:setVisible(false)
  end
end

return api
