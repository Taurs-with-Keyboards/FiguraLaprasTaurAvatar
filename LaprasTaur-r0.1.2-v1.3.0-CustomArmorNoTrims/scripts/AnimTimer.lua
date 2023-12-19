-- Table setup
local t = {}

t.animTime = 0

-- Animation variables
local time  = 0
local _time = time
function events.TICK()
	-- Animation timer setup
	_time = time
	
	-- Animation velocity control
	local fbVel     = math.clamp(player:getVelocity():dot((player:getLookDir().x_z):normalize()),         -0.25, 0.25)
	local lrVel     = math.clamp(math.abs(player:getVelocity():cross(player:getLookDir().x_z:normalize()).y), 0, 0.25)
	local animSpeed = (fbVel >= -0.05 and math.max(fbVel, lrVel) or math.min(fbVel, lrVel)) * 0.005
	
	-- Animation timeline
	time = time + (animSpeed + (fbVel > -0.05 and 0.0005 or -0.0005))
end

function events.RENDER(delta, context)
	-- Animation timeline renderer
	t.animTime = math.lerp(_time, time, delta)
end

return t