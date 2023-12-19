-- Model setup
local lapras    = models.LaprasTaur
local pokeball  = models.PokeBall
local modelroot = lapras.Player

-- Table setup
local t         = {}
t.vehicle       = nil   -- Vehicle exists
t.vehicleType   = false -- Vehicle type
t.isPassenger   = false -- Player is passenger
t.hasPassenger  = false -- Player has passenger (in vehicle)
t.isVehicle     = false -- Player is vehicle 

t.boat          = false -- Is boat
t.chest_boat    = false -- Is chest boat
t.minecart      = false -- Is minecart
t.horse         = false -- Is horse
t.donkey        = false -- Is donkey
t.mule          = false -- Is mule
t.zombieHorse   = false -- Is Zombie Horse
t.skeletonHorse = false -- Is Skeleton Horse
t.pig           = false -- Is pig
t.strider       = false -- Is strider
t.camel         = false -- Is camel

local vehicle
local prevType = false
function events.TICK()
  -- Get player name
  local name = player:getName()
  
  -- Get vehicle data
  t.vehicle = player:getVehicle()
  if t.vehicle then
    t.vehicleType  = t.vehicle:getType()
    t.isPassenger  = t.vehicle:getPassengers()[2] and t.vehicle:getPassengers()[2]:getName() == name or false
    t.hasPassenger = t.vehicle:getPassengers()[2] and t.vehicle:getPassengers()[2]:getName() ~= name or false
  else
    t.vehicleType  = false
    t.isPassenger  = false
    t.hasPassenger = false
  end
  
  t.isVehicle = player:getPassengers()[1] ~= nil
  
  -- Update vehicle type
  if prevType ~= t.vehicleType then
    t.boat          = t.vehicleType == "minecraft:boat"
    t.chest_boat    = t.vehicleType == "minecraft:chest_boat"
    t.minecart      = t.vehicleType == "minecraft:minecart"
    t.horse         = t.vehicleType == "minecraft:horse"
    t.donkey        = t.vehicleType == "minecraft:donkey"
    t.mule          = t.vehicleType == "minecraft:mule"
    t.zombieHorse   = t.vehicleType == "minecraft:zombie_horse"
    t.skeletonHorse = t.vehicleType == "minecraft:skeleton_horse"
    t.pig           = t.vehicleType == "minecraft:pig"
    t.strider       = t.vehicleType == "minecraft:strider"
    t.camel         = t.vehicleType == "minecraft:camel"
  end
  
  prevType = t.vehicleType
  
  -- Vehicle renders/part toggles
  renderer:setRenderVehicle(not(t.boat or t.chest_boat))
  modelroot.LowerBody.Main.Shell.Chest:setVisible(t.chest_boat)
end

-- Returns table
return t