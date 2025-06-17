-- Required scripts
local pokemonParts = require("lib.GroupIndex")(models.LaprasTaur)
local carrier      = require("lib.GSCarrier")

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
carrier.vehicle.newSeat("Seat1", pokemonParts.RiderPos1, {
	priority = 3,
	tags = {["gscarrier:flat"] = true},
	condition = function() if pokemonParts.Chest:getVisible() then return false end end
})

-- Seat 2
carrier.vehicle.newSeat("Seat2", pokemonParts.RiderPos2, {
	priority = 2,
	tags = {["gscarrier:flat"] = true},
	condition = function() if pokemonParts.Chest:getVisible() then return false end end
})

-- Seat Chest
carrier.vehicle.newSeat("SeatChest", pokemonParts.RiderPosChest, {
	priority = 1,
	tags = {["gscarrier:chair"] = true},
	condition = function() if not pokemonParts.Chest:getVisible() then return false end end
})

-- Chest Block
local chest = pokemonParts.Chest:newBlock("Chest")
	:block("chest")
	:pos(-8, 0, -8)

function events.TICK()
	
	-- Variables
	local vehicle = player:getVehicle() or false
	local type    = vehicle and vehicle:getType() or false
	
	-- Vehicle renders/part toggle
	renderer:setRenderVehicle(type ~= "minecraft:boat" and type ~= "minecraft:chest_boat")
	pokemonParts.Chest:visible(type == "minecraft:chest_boat")
	
	-- Redirect all passengers to pivots if vehicle is a boat
	carrier.vehicle.setRedirect(type == "minecraft:boat")
	
end