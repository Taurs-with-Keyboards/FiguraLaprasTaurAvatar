-- Required scripts
local model   = require("scripts.ModelParts")
local carrier = require("lib.GSCarrier")

-- GSCarrier rider
carrier.rider.addRoots(models)
carrier.rider.addTag("gscarrier:taur")
carrier.rider.controller.setGlobalOffset(vec(0, -10, 0))
carrier.rider.controller.setModifyCamera(false)
carrier.rider.controller.setModifyEye(false)
carrier.rider.controller.setAimEnabled(false)

-- GSCarrier vehicle
carrier.vehicle.addTag("gscarrier:taur", "gscarrier:land", "gscarrier:water")

-- Seat 1
carrier.vehicle.newSeat("Seat1", model.shell.RiderPos1, {
	priority = 3,
	tags = {["gscarrier:flat"] = true},
	condition = function() if model.chest:getVisible() then return false end end
})

-- Seat 2
carrier.vehicle.newSeat("Seat2", model.shell.RiderPos2, {
	priority = 2,
	tags = {["gscarrier:flat"] = true},
	condition = function() if model.chest:getVisible() then return false end end
})

-- Seat Chest
carrier.vehicle.newSeat("SeatChest", model.chest.RiderPosChest, {
	priority = 1,
	tags = {["gscarrier:chair"] = true},
	condition = function() if not model.chest:getVisible() then return false end end
})

function events.TICK()
	
	-- Variables
	local vehicle = player:getVehicle() or false
	local type    = vehicle and vehicle:getType() or false
	
	-- Vehicle renders/part toggle
	renderer:setRenderVehicle(type ~= "minecraft:boat" and type ~= "minecraft:chest_boat")
	model.chest:visible(type == "minecraft:chest_boat")
	
	-- Redirect all passengers to pivots if vehicle is a boat
	carrier.vehicle.setRedirect(type == "minecraft:boat")
	
end