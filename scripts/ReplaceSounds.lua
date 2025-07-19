-- Required scripts
local parts   = require("lib.PartsAPI")
local ground  = require("lib.GroundCheck")
local pose    = require("scripts.Posing")
local effects = require("scripts.SyncedVariables")

-- Find all ground parts
local groundParts = parts:createTable(function(part) return part:getName():find("Ground") end)

-- Stop script if ground parts could not be found
if #groundParts == 0 then return end

-- Config setup
config:name("LaprasTaur")
local makeSound = config:load("SoundsToggle")
if makesound == nil then makesound = true end

-- Animations setup
local anims = animations.LaprasTaur

-- Setup groundParts table
for k, i in ipairs(groundParts) do
	
	groundParts[k] = { part = i, wasGround = true, _pos = vec(0, 0, 0) }
	
end

-- Play footstep sound
local function playFootstep(p, b, volume, heavy)
	
	-- Snow check
	local snow = false
	if world.getBlockState(p + vec(0, 1, 0)):getID() == "minecraft:snow" then
		b = world.getBlockState(p + vec(0, 1, 0))
		snow = true
	end
	
	-- Play sound
	sounds:playSound(
		snow and b:getSounds()["step"] or "entity.puffer_fish.flop",
		p,
		(math.min(volume * 3 * (heavy and 2 or 1), 0.75)) * (snow and 0.66 or 1),
		heavy and 0.35 or 0.5
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
	local onGround = ground()
	local inWater  = player:isInWater()
	
	-- Play footsteps based on placement
	if makeSound and onGround and not (inWater or player:getVehicle() or effects.cF) then
		
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
				
				playFootstep(
					groundPos,
					groundBlock,
					(flipper._pos - groundPos):length(),
					flipper.part:getName():find("Torso")
				)
				
			end
			
			-- Store last ground
			flipper.wasGround = grounded
			flipper._pos = groundPos
			
		end
		
	else
		
		-- If conditions arent met, legs are considered previously on ground
		for _, flipper in ipairs(groundParts) do
			
			flipper.wasGround = true
			flipper._pos = flipper.part:partToWorldMatrix():apply()
			
		end
		
	end
	
end

-- Sound toggle
function pings.setSoundToggle(boolean)
	
	makeSound = boolean
	config:save("SoundsToggle", makeSound)
	if player:isLoaded() and makeSound then
		sounds:playSound("item.bucket.fill", player:getPos())
	end
	
end

-- Sync variable
function pings.syncSound(a)
	
	makeSound = a
	
end

-- Host only instructions
if not host:isHost() then return end

-- Sync on tick
function events.TICK()
	
	if world.getTime() % 200 == 0 then
		pings.syncSound(makeSound)
	end
	
end

-- Required scripts
local s, wheel, itemCheck, c = pcall(require, "scripts.ActionWheel")
if not s then return end -- Kills script early if ActionWheel.lua isnt found
pcall(require, "scripts.Shiny") -- Tries to find script, not required

-- Check for if page already exists
local pageExists = action_wheel:getPage("Lapras")

-- Pages
local parentPage = action_wheel:getPage("Main")
local laprasPage = pageExists or action_wheel:newPage("Lapras")

-- Actions table setup
local a = {}

-- Actions
if not pageExists then
	a.pageAct = parentPage:newAction()
		:item(itemCheck("cobblemon:water_stone", "turtle_egg"))
		:onLeftClick(function() wheel:descend(laprasPage) end)
end

a.soundAct = laprasPage:newAction()
	:item(itemCheck("sponge"))
	:toggleItem(itemCheck("water_bucket"))
	:onToggle(pings.setSoundToggle)

-- Update actions
function events.RENDER(delta, context)
	
	if action_wheel:isEnabled() then
		if a.pageAct then
			a.pageAct
				:title(toJson(
					{text = "Lapras Settings", bold = true, color = c.primary}
				))
		end
		
		a.soundAct
			:title(toJson(
				{
					"",
					{text = "Toggle Movement Sounds\n\n", bold = true, color = c.primary},
					{text = "Toggles the sounds played by the movement/flopping of your flippers.", color = c.secondary}
				}
			))
			:toggled(makeSound)
		
		for _, act in pairs(a) do
			act:hoverColor(c.hover):toggleColor(c.active)
		end
		
	end
	
end