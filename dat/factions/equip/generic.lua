-- Outfit definitions
include("dat/factions/equip/outfits.lua")

-- Helper functions
include("dat/factions/equip/helper.lua")

--[[
-- @brief Does generic pilot equipping
--
--    @param p Pilot to equip
--]]
function equip_generic( p )
   -- Start with an empty ship
   p:rmOutfit("all")
   p:rmOutfit("cores")

   -- Get ship info
   local shiptype, shipsize = equip_getShipBroad( p:ship():class() )
   
   -- Equip core outfits. This process is separate from the other outfits, because cores were introduced
   -- later, and the outfitting routine should be fairly granular and tweakable.
   --equip_cores(p)

   -- Split by type
   if shiptype == "civilian" then
      equip_genericCivilian( p, shipsize )
   elseif shiptype == "merchant"  then
      equip_genericMerchant( p, shipsize )
   elseif shiptype == "military" then
      equip_genericMilitary( p, shipsize )
   elseif shiptype == "robotic" then
      equip_genericRobotic( p, shipsize )
   end
end

-- Returns a default set of weapons for use with fillWeaponsBySlotSize
function genericCivilianWeaponSets()
   return {equip_forwardLow,equip_forwardMed,equip_forwardHig},{equip_rangedLow,equip_rangedMed,equip_rangedHig},{equip_turretLow,equip_turretMed,equip_turretHig}
end

--[[
-- @brief Equips a generic civilian type ship.
--]]
function equip_genericCivilian( p, shipsize )
   local medium, low
   local use_forward,  use_secondary, use_medium, use_low
   local nweapons, nmedium, nlow = p:ship():slots()

   --numbers of weapons of each type to use, regardless of size
   use_forward=0
   use_secondary=0
   use_turrets=0

   -- Defaults
   medium      = { "Unicorp Scrambler" }
   low = {}

   weapons = {}

   use_secondary = 0
   use_medium  = 0
   use_low     = 0

   -- Per ship type
   if shipsize == "small" then
      use_forward=rnd.rnd(1,nweapons)

      medium   = { "Unicorp Scrambler" }
      if rnd.rnd() > 0.8 then
         use_medium = 1
      end
   else
      use_turrets=rnd.rnd(nweapons)

      medium   = { "Unicorp Scrambler" }
      if rnd.rnd() > 0.5 then
         use_medium = 1
      end
      low      = { "Plasteel Plating" }
      if rnd.rnd() > 0.5 then
         use_low = 1
      end
   end

   local forwards,secondaries,turrets=genericCivilianWeaponSets()
   fillWeaponsBySlotSize(p,use_forward,use_secondary,use_turrets,forwards,secondaries,turrets)

   equip_ship( p, true, weapons, medium, low,
               use_medium, use_low )
end




--[[
-- @brief Equips a generic merchant type ship.
--]]
function equip_genericMerchant( p, shipsize )
   local medium, low
   local use_forward, use_secondary, use_turrets, use_medium, use_low
   local nweapons, nmedium, nlow = p:ship():slots()

   -- Defaults
   medium      = { "Unicorp Scrambler" }
   low = {}

   weapons     = {}

   --numbers of weapons of each type to use, regardless of size
   use_forward=0
   use_secondary=0
   use_turrets=0

   -- Equip by size
   if shipsize == "small" then
      r = rnd.rnd()
      if r > 0.9 then -- 10% chance of all-turrets.
         use_turrets = nweapons
      elseif r > 0.2 then -- 70% chance of mixed loadout.
         use_turrets = nweapons -1
         use_forward = nweapons - use_turrets
      else -- Poor guy gets no turrets.
         use_forward = nweapons
      end

      medium   = { "Unicorp Scrambler" }
      if rnd.rnd() > 0.8 then
         use_medium = 1
      end
   elseif shipsize == "medium" then
      use_secondary = 1

      use_turrets = nweapons - use_secondary

      medium   = { "Unicorp Scrambler" }
      if rnd.rnd() > 0.6 then
         use_medium = 1
      end
      low    = { "Plasteel Plating" }
      if rnd.rnd() > 0.6 then
         use_low = 1
      end
   else

      use_secondary = 2

      use_turrets = nweapons - use_secondary

      medium = { "Unicorp Scrambler" }
      if rnd.rnd() > 0.4 then
         use_medium = 1
      end
      low    = { "Plasteel Plating" }
      if rnd.rnd() > 0.6 then
         use_low = 1
      end
   end

   local forwards,secondaries,turrets=genericCivilianWeaponSets()
   fillWeaponsBySlotSize(p,use_forward,use_secondary,use_turrets,forwards,secondaries,turrets)

   equip_ship( p, true, weapons, medium, low,
               use_medium, use_low )
end


--[[
-- @brief Equips a generic military type ship.
--]]
function equip_genericMilitary( p, shipsize )
   local medium, low
   local use_forward, use_secondary, use_turrets, use_medium, use_low
   local nweapons, nmedium, nlow = p:ship():slots()

   -- Defaults
   medium      = { "Unicorp Scrambler" }
   low = {}
   weapons     = {}

   --numbers of weapons of each type to use, regardless of size
   use_forward=0
   use_secondary=0
   use_turrets=0

   -- Equip by size and type
   if shipsize == "small" then
      local class = p:ship():class()

      -- Scout
      if class == "Scout" then
         use_forward    = rnd.rnd(1,nweapons)

         medium         = { "Generic Afterburner", "Milspec Scrambler" }
         use_medium     = 2
         low            = { "Solar Panel" }

      -- Fighter
      elseif class == "Fighter" then
         
         use_secondary  = 1
         use_forward    = nweapons-use_secondary

         medium         = equip_mediumLow()
         low            = equip_lowLow()


      -- Bomber
      elseif class == "Bomber" then

         use_secondary  = rnd.rnd(1,2)
         use_forward    = nweapons-use_secondary

         addWeapons( equip_forwardLow(), use_primary )
         addWeapons( equip_rangedLow(), use_secondary )
         medium         = equip_mediumLow()
         low            = equip_lowLow()

      end

   elseif shipsize == "medium" then
      
      use_secondary  = 1
      use_turrets    = nweapons-use_secondary

      medium         = equip_mediumMed()
      low            = equip_lowMed()


   else
      
      use_secondary  = 2
      use_turrets    = nweapons-use_secondary

      medium         = equip_mediumHig()
      low            = equip_lowHig()

   end

   local forwards,secondaries,turrets=genericCivilianWeaponSets()
   fillWeaponsBySlotSize(p,use_forward,use_secondary,use_turrets,forwards,secondaries,turrets)

   equip_ship( p, false, weapons, medium, low,
               use_medium, use_low )
end


--[[
-- @brief Equips a generic robotic type ship.
--]]
function equip_genericRobotic( p, shipsize )
   equip_fillSlots( p, { "Neutron Disruptor" }, { }, { } )
end

function fillWeaponsBySlotSize(p,use_forward,use_secondary,use_turrets,forwards,secondaries,turrets)
local slots=p:ship():getSlots()
   for k,v in pairs(slots) do
      if v.type=="weapon" then
         local size=1
         if v.size=="Medium" then
            size=2
         elseif v.size=="Large" then
            size=3
         end

         if (use_turrets>0) then
            addWeapons(turrets[size](),1)
            use_turrets=use_turrets-1
         elseif (use_secondary>0) then
            addWeapons(secondaries[size](),1)
            use_secondary=use_secondary-1
         elseif (use_forward>0) then
            addWeapons(forwards[size](),1)
            use_forward=use_forward-1
         end
      end
   end
end
