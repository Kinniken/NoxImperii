include("general_helper.lua")

--[[
-- @brief Handles the ship class by splitting it up into type/size.
--
-- Valid types are:
--  - civilian
--  - merchant
--  - military
--  - robotic
--
-- Valid sizes are:
--  - small
--  - medium
--  - large
--
--    @return Two parameters, first would be type, second would be size.
--]]
function equip_getShipBroad( class )

   -- Civilian
   if class == "Yacht" or class == "Luxury Yacht" then
      return "civilian", "small"
   elseif class == "Cruise Ship" then
      return "civilian", "medium"

   -- Merchant
   elseif class == "Courier" then
      return "merchant", "small"
   elseif class == "Freighter" or class == "Armoured Transport" then
      return "merchant", "medium"
   elseif class == "Bulk Carrier" then
      return "merchant", "large"

   -- Military
   elseif class == "Scout" or class == "Fighter" or class == "Bomber"  then
      return "military", "small"
   elseif class == "Corvette" or class == "Destroyer" then
      return "military", "medium"
   elseif class == "Cruiser" or class == "Carrier" then
      return "military", "large"

   -- Robotic
   elseif class == "Drone" then
      return "robotic", "small"
   elseif class == "Heavy Drone" then
      return "robotic", "small"
   elseif class == "Mothership" then
      return "robotic", "large"

   -- Unknown
   else
      print("Unknown ship of class '" .. class .. "'")
   end
end


function equip_ship( p, outfits )

   --print(p:ship():name())
   --gh.tprint(outfits)

   for k,v in ipairs(outfits) do
      p:addOutfit( v )
   end
end


function equip_getSlotNumbers(s)
   local slots=s:getSlots()
   local nbturrets,nbweapons,nbutilities,nbstructures
   nbturrets=0
   nbweapons=0
   nbutilities=0
   nbstructures=0 

   for k,v in pairs(slots) do

      if v.type=="weapon" and v.property=="Turret" then
         nbturrets=nbturrets+1
      elseif v.type=="weapon" then
         nbweapons=nbweapons+1
      elseif v.type=="utility" then
         nbutilities=nbutilities+1
      elseif v.type=="structure" then
         nbstructures=nbstructures+1
      end
   end

   return nbturrets,nbweapons,nbutilities,nbstructures
end


function equip_fillWeaponsBySlotSize(s,outfits,nbforwards,nbsecondaries,forwards,secondaries)
   local slots=s:getSlots()
   for k,v in pairs(slots) do

      if v.type=="weapon" and v.property==nil then
         local size=1
         if v.size=="Medium" then
            size=2
         elseif v.size=="Large" then
            size=3
         end

         if (nbsecondaries>0) then
            outfits[ #outfits+1 ] = gh.randomObject(secondaries[size])
            nbsecondaries=nbsecondaries-1
         elseif (nbforwards>0) then
            outfits[ #outfits+1 ] = gh.randomObject(forwards[size])
            nbforwards=nbforwards-1
         end
      end
   end
end

function equip_fillTurretsBySlotSize(s,outfits,nbturrets,turrets)
   local slots=s:getSlots()
   for k,v in pairs(slots) do

      if v.type=="weapon" and v.property=="Turret" then
         local size=1
         if v.size=="Medium" then
            size=2
         elseif v.size=="Large" then
            size=3
         end



         if (nbturrets>0) then
            outfits[ #outfits+1 ] = gh.randomObject(turrets[size])
            nbturrets=nbturrets-1
         end
      end
   end
end

function equip_fillUtilitiesBySlotSize(s,outfits,nbutilities,utilities)
   local slots=s:getSlots()
   for k,v in pairs(slots) do
      if v.type=="utility" then
         local size=1
         if v.size=="Medium" then
            size=2
         elseif v.size=="Large" then
            size=3
         end

         if (nbutilities>0) then
            outfits[ #outfits+1 ] = gh.randomObject(utilities[size])
            nbutilities=nbutilities-1
         end
      end
   end
end

function equip_fillStructuresBySlotSize(s,outfits,nbstructures,structures)
   local slots=s:getSlots()
   for k,v in pairs(slots) do
      if v.type=="structure" then
         local size=1
         if v.size=="Medium" then
            size=2
         elseif v.size=="Large" then
            size=3
         end

         if (nbstructures>0) then
            outfits[ #outfits+1 ] = gh.randomObject(structures[size])
            nbstructures=nbstructures-1
         end
      end
   end
end


function _shuffle( t, max )
   local n, k

   n = max
   while n > 1 do
      k = math.random(n)
      n = n - 1
      t[n], t[k] = t[k], t[n]
   end

   return t
end


function icmb( t1, t2 )
   t = {}
   for _,v in ipairs(t1) do
      t[ #t+1 ] = v
   end
   for _,v in ipairs(t2) do
      t[ #t+1 ] = v
   end
   return t
end
