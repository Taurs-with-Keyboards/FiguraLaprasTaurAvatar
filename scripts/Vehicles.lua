-- Required scripts
local parts   = require("lib.PartsAPI")
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
carrier.vehicle.newSeat("Seat1", parts.group.Seat1, {
	priority = 3,
	tags = {["gscarrier:flat"] = true},
	condition = function() if parts.group.Chest:getVisible() then return false end end
})

-- Seat 2
carrier.vehicle.newSeat("Seat2", parts.group.Seat2, {
	priority = 2,
	tags = {["gscarrier:flat"] = true},
	condition = function() if parts.group.Chest:getVisible() then return false end end
})

-- Seat Chest
carrier.vehicle.newSeat("SeatChest", parts.group.ChestSeat, {
	priority = 1,
	tags = {["gscarrier:chair"] = true},
	condition = function() if not parts.group.Chest:getVisible() then return false end end
})

-- Chest Block
local chest = parts.group.Chest:newBlock("Chest")
	:block("chest")
	:pos(-8, 0, -8)

function events.TICK()
	
	-- Variables
	local vehicle = player:getVehicle() or false
	local type    = vehicle and vehicle:getType() or ""
	
	-- Vehicle renders/part toggle
	renderer:setRenderVehicle(not type:find("boat"))
	parts.group.Chest:visible(type:find("chest"))
	
	-- Redirect all passengers to pivots if vehicle is a boat
	carrier.vehicle.setRedirect(type:find("boat"))
	
end