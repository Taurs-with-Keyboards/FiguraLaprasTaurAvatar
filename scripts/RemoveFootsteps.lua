-- Remove Footsteps
function events.on_play_sound(id, pos, _, _, _, path)
	
	return player:isLoaded() and (pos - player:getPos()):lengthSquared() < 1 and id:find("step") and path == "PLAYERS"
	
end