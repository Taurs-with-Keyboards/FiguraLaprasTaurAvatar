-- Model setup
local lapras    = models.LaprasTaur
local pokeball  = models.PokeBall
local modelroot = lapras.Player

-- Table setup
local t        = {}
t.vehicle      = nil   -- Vehicle exists
t.vehicleType  = false -- Vehicle type
t.isPassenger  = false -- Player is passenger
t.hasPassenger = false -- Player has passenger

t.boat         = false -- Is boat
t.chest_boat   = false -- Is chest boat
t.minecart     = false -- Is minecart
t.horse        = false -- Is horse
t.pig          = false -- Is pig
t.strider      = false -- Is strider

local vehicle
local prevType = false
function events.TICK()
  -- Get player name
  local name = player:getName()
  
  -- Get vehicle data
  t.vehicle = player:getVehicle()
  if t.vehicle then
    t.vehicleType  = t.vehicle:getType()
    t.isPassenger  = t.vehicle:getControllingPassenger() and t.vehicle:getControllingPassenger():getName() ~= name or false
    t.hasPassenger = t.vehicle:getPassengers()[2] and t.vehicle:getControllingPassenger():getName() == name or false
  else
    t.vehicleType  = false
    t.isPassenger  = false
    t.hasPassenger = false
  end
  
  -- Update vehicle type
  if prevType ~= t.vehicleType then
    t.boat       = t.vehicleType == "minecraft:boat"
    t.chest_boat = t.vehicleType == "minecraft:chest_boat"
    t.minecart   = t.vehicleType == "minecraft:minecart"
    t.horse      = t.vehicleType == "minecraft:horse"
    t.pig        = t.vehicleType == "minecraft:pig"
    t.strider    = t.vehicleType == "minecraft:strider"
  end
  
  prevType = t.vehicleType
  
  -- Vehicle renders/part toggles
  renderer:setRenderVehicle(not(t.boat or t.chest_boat))
  modelroot.LowerBody.Main.Shell.Chest:setVisible(t.chest_boat)
end

-- Returns table
return t