-- Documentation
    -- Materials Needed:
        -- 1 Item Unloader Augment
        -- 1 Detector Augment
        -- 1 Transposer
        -- 1 Adapter
        -- 1 Redstone Card
   
    -- How does it work:
        -- It keeps transferring items until freight car is empty or until the output chest is full.
        -- When it finishes unloading, it emits a redstone signal indicating that it is finished unloading.
        -- When empty, redstone goes on, off, then on continuously until the freight car completely passes over the detector augment.
 
    -- list of sides:
        -- sides.left
        -- sides.right
        -- sides.north
        -- sides.south
        -- sides.up (above)
        -- sides.down (below)
 
    -- Note:
        -- Feel free to adjust the sides, redstone strength, and transfer rate as you need.
 
-- Start of unloader.lua
local component = require('component')
local sides = require('sides')
local event = require('event')
local term = require('term')
-- End getting APIs
 
local DetectorAugments = component.list('ir_augment_detector')
local transposer = component.transposer
local rs = component.redstone
-- End getting components
 
local input = sides.up -- input of transposer, must be set to side of item unloader augment.
 
local output = sides.south -- Place output chest (double-chest or better) on side of transposer output.
 
local rsOutput = sides.down -- Redstone output side
local rsStrength = 15 -- Strength of redstone signal
 
local transferRate = 64 -- How fast transposer loads items (64 = 1 stack of 64 items)
 
print("Item unloader is now running.")
 
event.listen("ir_train_overhead", function(name, address, augment_type, uuid)
    if name ~= "ir_train_overhead" or augment_type ~= "DETECTOR" then
        return
    end
local Detector = component.proxy(address)
 
rs.setOutput(rsOutput, 0)
term.clear()
 
    while true do -- Keep transferring items until freight car is full
        if (string.find(Detector.info().id, "freight") and Detector.info().speed == 0) then
            local cargoPercent = (Detector.info().cargo_percent - 100) * (-1)
            transferAmmount = transposer.transferItem(input, output, transferRate)
 
            if transferAmmount == 0 then
                rs.setOutput(rsOutput, rsStrength)
                print("All cargo unloaded!")
                break
            else
                print("Cargo is "..cargoPercent.."% unloaded.")
                rs.setOutput(rsOutput, 0)
            end
        end
    end
end)
