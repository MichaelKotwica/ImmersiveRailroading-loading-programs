-- Documentation
	-- Materials Needed:
		-- 1 Item loader Augment
        -- 1 Detector Augment
		-- 1 Transposer
		-- 1 Adapter
		-- 1 Redstone Card
	
	-- How does it work:
		-- It keeps transferring items until freight car is full or until the input chest is empty.
		-- When it finishes loading, it emits a redstone signal indicating that it is finished loading.
		-- When full, redstone goes on, off, then on continuously until the freight car completely passes over the detector augment.

	-- list of sides:
		-- sides.left
		-- sides.right
		-- sides.north
		-- sides.south
		-- sides.up (above)
		-- sides.down (below)

	-- Note:
		-- Feel free to adjust the sides, redstone strength, and transfer rate as you need. 

-- Start of loader.lua
local component = require('component')
local sides = require('sides')
local event = require('event')
local term = require('term')
-- End getting APIs

local DetectorAugments = component.list('ir_augment_detector')
local transposer = component.transposer
local rs = component.redstone
-- End getting components 

local input = sides.down -- input of transposer. 
						 --	Place input chest (double-chest or better) on side of transposer input.

local output = sides.up -- output of the transposer, must be set to side of item loader augment.

local rsOutput = sides.right -- Redstone output side
local rsStrength = 15 -- Strength of redstone signal

local transferRate = 64 -- How fast transposer loads items (64 = 1 stack of 64 items)

print("Item loader is now running.")

event.listen("ir_train_overhead", function(name, address, augment_type, uuid)
	if name ~= "ir_train_overhead" or augment_type ~= "DETECTOR" then
		return
	end
local Detector = component.proxy(address)

rs.setOutput(rsOutput, 0)
term.clear()

	while true do -- Keep transferring items until freight car is full
		if (string.find(Detector.info().id, "freight") and Detector.info().speed == 0) then
			local cagoPercent = Detector.info().cargo_percent
			transferAmmount = transposer.transferItem(input, output, transferRate)

			if transferAmmount == 0 then
				rs.setOutput(rsOutput, rsStrength)
				print("All cargo loaded!")
				break
			else
				print("Cargo is "..cargoPercent.."% loaded.")
				rs.setOutput(rsOutput, 0)
			end
		end
	end
end)