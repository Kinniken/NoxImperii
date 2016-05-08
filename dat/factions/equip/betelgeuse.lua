-- Generic equipping routines, helper functions and outfit definitions.
include("dat/factions/equip/generic.lua")

--[[
-- @brief Does empire pilot equipping
--
--    @param p Pilot to equip
--]]
function equip( p )
   -- Start with an empty ship
   p:rmOutfit("all")
   p:rmOutfit("cores")

   -- Get ship info
   local shiptype, shipsize = equip_getShipBroad( p:ship():class() )

   -- Split by type
   if shiptype == "civilian" then
      equip_civilian( p, shipsize )
   elseif shiptype == "merchant"  then
      equip_merchant( p, shipsize )
   elseif shiptype == "military" then
      equip_military( p, shipsize )
   end
end

function equip_military( p, shipsize )
   local nbSlotTurrets, nbSlotWeapons, nSlotUtilities, nbSlotStructures = equip_getSlotNumbers(p:ship())
   local nbTurrets,nbForwards,nbSecondaries,nbStructures,nbUtilities

   nbTurrets=0
   nbForwards=0
   nbSecondaries=0
   nbStructures=0
   nbUtilities=0

   -- Number of each type of outfits
   if shipsize == "small" then
      local class = p:ship():class()

      nbTurrets=rnd.rnd(nbSlotTurrets/2,nbSlotTurrets)

      -- Scout
      if class == "Scout" then
         nbForwards    = rnd.rnd(1,nbSlotWeapons)

      -- Fighter
      elseif class == "Fighter" then
         nbForwards    = rnd.rnd(nbSlotWeapons/2,nbSlotWeapons)

      -- Bomber
      elseif class == "Bomber" then
         nbSecondaries  = rnd.rnd(1,2)
         nbForwards    = nbSlotWeapons-use_secondary

      else
         nbForwards    = rnd.rnd(nbSlotWeapons/2,nbSlotWeapons)

      end

   elseif shipsize == "medium" then
      
      nbTurrets=rnd.rnd(nbSlotTurrets/2,nbSlotTurrets)

      nbSecondaries  = rnd.rnd(0,nbSlotWeapons/3)
      nbForwards     = rnd.rnd(1,nbSlotWeapons-nbSecondaries)
   else      
      nbTurrets=rnd.rnd(nbSlotTurrets/2,nbSlotTurrets)

      nbSecondaries  = rnd.rnd(1,nbSlotWeapons/3)
      nbForwards     = rnd.rnd(1,nbSlotWeapons-nbSecondaries)
   end

   nbStructures  = rnd.rnd(nbSlotStructures/3,nbSlotStructures)
   nbUtilities  = rnd.rnd(nSlotUtilities/3,nSlotUtilities)

   local outfits={}

   equip_fillTurretsBySlotSize(p:ship(),outfits,nbTurrets,equip_defaultTurretsBetelgeuse())
   equip_fillWeaponsBySlotSize(p:ship(),outfits,nbForwards,nbSecondaries,equip_defaultForwardBetelgeuse(),equip_defaultSecondaryBetelgeuse())
   equip_fillUtilitiesBySlotSize(p:ship(),outfits,nbUtilities,equip_defaultUtilitiesBetelgeuse())
   equip_fillStructuresBySlotSize(p:ship(),outfits,nbStructures,equip_defaultStructuresBetelgeuse())

   equip_ship( p, outfits )
end


function equip_civilian( p, shipsize )
   local nbSlotTurrets, nbSlotWeapons, nSlotUtilities, nbSlotStructures = equip_getSlotNumbers(p:ship())
   local nbTurrets,nbForwards,nbSecondaries,nbStructures,nbUtilities

   nbTurrets=0
   nbForwards=0
   nbSecondaries=0
   nbStructures=0
   nbUtilities=0

   -- Number of each type of outfits
   if shipsize == "small" then
      local class = p:ship():class()

      nbTurrets=rnd.rnd(nbSlotTurrets/2,nbSlotTurrets)
      nbForwards    = rnd.rnd(1,nbSlotWeapons)

   elseif shipsize == "medium" then
      
      nbTurrets=rnd.rnd(nbSlotTurrets/2,nbSlotTurrets)

      nbSecondaries  = rnd.rnd(0,nbSlotWeapons/3)
      nbForwards     = rnd.rnd(1,nbSlotWeapons-nbSecondaries)
   else      
      nbTurrets=rnd.rnd(nbSlotTurrets/2,nbSlotTurrets)

      nbSecondaries  = rnd.rnd(1,nbSlotWeapons/3)
      nbForwards     = rnd.rnd(1,nbSlotWeapons-nbSecondaries)
   end

   nbStructures  = rnd.rnd(nbSlotStructures/3,nbSlotStructures)
   nbUtilities  = rnd.rnd(nSlotUtilities/3,nSlotUtilities)

   local outfits={}

   equip_fillTurretsBySlotSize(p:ship(),outfits,nbTurrets,equip_defaultTurretsBetelgeuse())
   equip_fillWeaponsBySlotSize(p:ship(),outfits,nbForwards,nbSecondaries,equip_defaultForwardBetelgeuse(),equip_defaultSecondaryBetelgeuse())
   equip_fillUtilitiesBySlotSize(p:ship(),outfits,nbUtilities,equip_defaultUtilitiesBetelgeuse())
   equip_fillStructuresBySlotSize(p:ship(),outfits,nbStructures,equip_defaultStructuresBetelgeuseMerchant())

   equip_ship( p, outfits )
end


function equip_merchant( p, shipsize )
   local nbSlotTurrets, nbSlotWeapons, nSlotUtilities, nbSlotStructures = equip_getSlotNumbers(p:ship())
   local nbTurrets,nbForwards,nbSecondaries,nbStructures,nbUtilities

   nbTurrets=0
   nbForwards=0
   nbSecondaries=0
   nbStructures=0
   nbUtilities=0

   -- Number of each type of outfits
   if shipsize == "small" then
      local class = p:ship():class()

      nbTurrets=rnd.rnd(nbSlotTurrets/2,nbSlotTurrets)
      nbForwards    = rnd.rnd(1,nbSlotWeapons)

   elseif shipsize == "medium" then
      
      nbTurrets=rnd.rnd(nbSlotTurrets/2,nbSlotTurrets)

      nbSecondaries  = rnd.rnd(0,nbSlotWeapons/3)
      nbForwards     = rnd.rnd(1,nbSlotWeapons-nbSecondaries)
   else      
      nbTurrets=rnd.rnd(nbSlotTurrets/2,nbSlotTurrets)

      nbSecondaries  = rnd.rnd(1,nbSlotWeapons/3)
      nbForwards     = rnd.rnd(1,nbSlotWeapons-nbSecondaries)
   end

   nbStructures  = rnd.rnd(nbSlotStructures/3,nbSlotStructures)
   nbUtilities  = rnd.rnd(nSlotUtilities/3,nSlotUtilities)

   local outfits={}

   equip_fillTurretsBySlotSize(p:ship(),outfits,nbTurrets,equip_defaultTurretsBetelgeuse())
   equip_fillWeaponsBySlotSize(p:ship(),outfits,nbForwards,nbSecondaries,equip_defaultForwardBetelgeuse(),equip_defaultSecondaryBetelgeuse())
   equip_fillUtilitiesBySlotSize(p:ship(),outfits,nbUtilities,equip_defaultUtilitiesBetelgeuse())
   equip_fillStructuresBySlotSize(p:ship(),outfits,nbStructures,equip_defaultStructuresBetelgeuseMerchant())

   equip_ship( p, outfits )
end

