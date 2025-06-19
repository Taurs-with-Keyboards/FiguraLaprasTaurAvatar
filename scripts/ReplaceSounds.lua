-- Required scripts
local parts   = require("lib.PartsAPI")
local ground  = require("lib.GroundCheck")
local pose    = require("scripts.Posing")
local effects = require("scripts.SyncedVariables")

-- Find all ground parts
local groundParts = parts:createTable(function(part) return part:getName():find("Ground") end)

-- Stop script if ground parts could not be found
if #groundParts == 0 then return end

-- Animations setup
local anims = animations.LaprasTaur

-- Variable
local waterTimer = 0

-- Setup groundParts table
for k, i in ipairs(groundParts) do
	
	groundParts[k] = { part = i, wasGround = true }
	
end

-- Play footstep sound
local function playFootstep(p, b, sound)
	
	-- Snow check
	local snow = false
	if world.getBlockState(p + vec(0, 1, 0)):getID() == "minecraft:snow" then
		b = world.getBlockState(p + vec(0, 1, 0))
		snow = true
	end
	
	-- Play sound
	sounds:playSound(
		snow and b:getSounds()["step"] or sound,
		p,
		snow and 0.5 or 0.75,
		0.5
	)
	
end

-- Box check
local function inBox(pos, box_min, box_max)
	return pos.x >= box_min.x and pos.x <= box_max.x and
		   pos.y >= box_min.y and pos.y <= box_max.y and
		   pos.z >= box_min.z and pos.z <= box_max.z
end

function events.ON_PLAY_SOUND(id, pos, vol, pitch, loop, cat, path)
	
	-- Don't trigger if the sound was played by Figura (prevent potential infinite loop)
	if not path then return end
	
	-- Don't do anything if the user isn't loaded
	if not player:isLoaded() then return end
	
	-- Make sure the sound is (most likely) played by the user
	if (player:getPos() - pos):length() > 0.05 then return end
	
	-- If sound contains ".step", stop the sound
	if id:find(".step") then
		return true
	end
	
end

function events.TICK()
	
	-- Variables
	local vel      = player:getVelocity()
	local onGround = ground()
	local inWater  = player:isInWater()
	
	-- Count down water timer
	waterTimer = math.max(waterTimer - 1, 0)
	
	-- If in water, change sound type by adjusting timer
	if inWater then
		waterTimer = 200
	end
	
	local soundType = (waterTimer ~= 0 or anims.laugh and anims.laugh:isPlaying()) and "entity.puffer_fish.flop" or "entity.turtle.shamble"
	
	-- Play footsteps based on placement
	if onGround and not (inWater or player:getVehicle() or effects.cF) then
		
		for _, flipper in ipairs(groundParts) do
			
			-- Block variables
			local groundPos   = flipper.part:partToWorldMatrix():apply()
			local blockPos    = groundPos:copy():floor()
			local groundBlock = world.getBlockState(groundPos)
			local groundBoxes = groundBlock:getCollisionShape()
			
			-- Check for ground
			local grounded = false
			if groundBoxes then
				for i = 1, #groundBoxes do
					local box = groundBoxes[i]
					if inBox(groundPos, blockPos + box[1], blockPos + box[2]) then
						
						grounded = true
						break
						
					end
				end
			end
			
			-- Play footstep
			if grounded and not flipper.wasGround then
				
				playFootstep(groundPos, groundBlock, soundType)
				
			end
			
			-- Store last ground
			flipper.wasGround = grounded
			
		end
		
	else
		
		-- If conditions arent met, legs are considered previously on ground
		for _, flipper in ipairs(groundParts) do
			
			flipper.wasGround = true
			
		end
		
	end
	
end