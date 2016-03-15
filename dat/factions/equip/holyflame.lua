-- Generic equipping routines, helper functions and outfit definitions.
include("dat/factions/equip/generic.lua")

--[[
-- @brief Does empire pilot equipping
--
--    @param p Pilot to equip
--]]
function equip( p )
   -- Get ship info
   local shiptype, shipsize = equip_getShipBroad( p:ship():class() )

   -- Split by type
   if shiptype == "military" then
      equip_empireMilitary( p, shipsize )
   else
      equip_generic( p )
   end
end


-- Long Night change: now tied to slot size. Weapons must be of the level of the function
-- (or below), never above!
-- CANNONS
function equip_forwardEmpLow ()
   return { "Laser Cannon MK2", "Laser Cannon MK3" }
end
function equip_forwardEmpMed ()
   return { "Laser Cannon MK3", "Ripper Cannon", "Heavy Ripper Cannon" }
end
function equip_forwardEmpHigh ()
   return { "Railgun", "Heavy Ripper Cannon" }
end
-- TURRETS
function equip_turretEmpLow ()
   return { "Laser PD MK2" }
end
function equip_turretEmpMed ()
   return { "Laser Turret MK2", "Laser Turret MK3" }
end
function equip_turretEmpHig ()
   return { "Heavy Laser", "Turbolaser" }
end
-- RANGED
function equip_secondaryEmpLow ()
   return { "TeraCom Fury Launcher" }
end
function equip_secondaryEmpMed ()
   return { "Unicorp Headhunter Launcher" }
end
function equip_secondaryEmpHig ()
   return { "Unicorp Headhunter Launcher" }
end



--[[
-- @brief Equips a empire military type ship.
--]]
function equip_empireMilitary( p, shipsize )
   local medium, low
   local use_medium, use_low
   local use_secondary, use_forward, use_turrets
   local nweapon, nmedium, nlow = p:ship():slots()
   local scramble

   -- Defaults
   medium      = { "Unicorp Scrambler" }
   weapons     = {}
   scramble    = false

   --numbers of weapons of each type to use, regardless of size
   use_forward=0
   use_secondary=0
   use_turrets=0

   -- Equip by size and type
   if shipsize == "small" then
      local class = p:ship():class()

      -- Scout
      if class == "Scout" then
         use_forward    = rnd.rnd(1,#nweapon)
         medium         = { "Generic Afterburner", "Milspec Scrambler" }
         use_medium     = 2
         low            = { "Solar Panel" }

      -- Fighter
      elseif class == "Fighter" then
         use_forward    = nweapon-1
         use_secondary  = 1
         medium         = equip_mediumLow()
         low            = equip_lowLow()

      -- Bomber
      elseif class == "Bomber" then
         use_forward    = rnd.rnd(1,2)
         use_secondary  = nweapon - use_primary
         medium         = equip_mediumLow()
         low            = equip_lowLow()
      end

   elseif shipsize == "medium" then
      local class = p:ship():class()
      
      -- Corvette
      if class == "Corvette" then
         use_secondary  = rnd.rnd(1,2)
         use_forward    = nweapon - use_secondary
         medium         = equip_mediumMed()
         low            = equip_lowMed()
      end

      -- Destroyer
      if class == "Destroyer" then
         use_secondary  = 0
         use_turrets    = nweapon
         use_forward    = nweapon - use_secondary - use_turrets
         medium         = equip_mediumMed()
         low            = equip_lowMed()
      end

   else -- "heavy"
      use_secondary  = 2
      use_turrets    = nweapon - use_secondary

      medium         = equip_mediumHig()
      low            = equip_lowHig()
   end

   fillWeaponsBySlotSize(p,use_forward,use_secondary,use_turrets,{equip_forwardEmpLow,equip_forwardEmpMed,equip_forwardEmpHig},
      {equip_secondaryEmpLow,equip_secondaryEmpMed,equip_secondaryEmpHig},{equip_turretEmpLow,equip_turretEmpMed,equip_turretEmpHig})

   equip_ship( p, scramble, weapons, medium, low, 
               use_medium, use_low )
end
