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
      cargo_civilian(p)
      p:setCredits( rnd.int(p:ship():price()/20 , p:ship():price()/10) )
   elseif shiptype == "merchant"  then
      equip_genericMerchant( p, shipsize )
      cargo_merchant(p)
      p:setCredits( rnd.int(p:ship():price()/20 , p:ship():price()/10) )
   elseif shiptype == "military" then
      equip_genericMilitary( p, shipsize )
      cargo_military(p)
      p:setCredits( rnd.int(p:ship():price()/50 , p:ship():price()/25) )
   end
end

function cargo_civilian(p)
   cargo_fill(p,{C.FOOD,C.CONSUMER_GOODS},{C.GOURMET_FOOD,C.LUXURY_GOODS},2,0.2,1)
end

function cargo_merchant(p)
   cargo_fill(p,{C.FOOD,C.CONSUMER_GOODS,C.PRIMITIVE_CONSUMER,C.ORE,C.PRIMITIVE_INDUSTRIAL,C.INDUSTRIAL,C.ARMAMENT,C.PRIMITIVE_ARMAMENT},{C.MODERN_INDUSTRIAL,C.LUXURY_GOODS,C.GOURMET_FOOD,C.MODERN_ARMAMENT},3,0.5,1)
end

function cargo_military(p)
   cargo_fill(p,{C.ARMAMENT,C.MODERN_ARMAMENT},{C.ARMAMENT,C.MODERN_ARMAMENT},2,0.2,0.5)
end

function cargo_fill(p,types,rareTypes,maxTypeNumber,minFill,maxFill)
   local free=p.cargoFree(p)

   local nbTypes=math.random(1,maxTypeNumber)

   for i=1,maxTypeNumber do
      local nb=math.ceil(math.random(minFill*free/maxTypeNumber,maxFill*free/maxTypeNumber))

      if (math.random()>0.1) then
         p:cargoAdd(types[math.random(#types)],nb)
      else
         p:cargoAdd(rareTypes[math.random(#rareTypes)],nb)
      end
   end
end

--[[
-- @brief Equips a generic civilian type ship.
--]]
function equip_genericCivilian( p, shipsize )
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

   equip_fillTurretsBySlotSize(p:ship(),outfits,nbTurrets,equip_defaultTurrets())
   equip_fillWeaponsBySlotSize(p:ship(),outfits,nbForwards,nbSecondaries,equip_defaultForward(),equip_defaultSecondary())
   equip_fillUtilitiesBySlotSize(p:ship(),outfits,nbUtilities,equip_defaultUtilities())
   equip_fillStructuresBySlotSize(p:ship(),outfits,nbStructures,equip_defaultStructures())

   equip_ship( p, outfits )
end




--[[
-- @brief Equips a generic merchant type ship.
--]]
function equip_genericMerchant( p, shipsize )
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

   equip_fillTurretsBySlotSize(p:ship(),outfits,nbTurrets,equip_defaultTurrets())
   equip_fillWeaponsBySlotSize(p:ship(),outfits,nbForwards,nbSecondaries,equip_defaultForward(),equip_defaultSecondary())
   equip_fillUtilitiesBySlotSize(p:ship(),outfits,nbUtilities,equip_defaultUtilities())
   equip_fillStructuresBySlotSize(p:ship(),outfits,nbStructures,equip_defaultStructuresMerchant())

   equip_ship( p, outfits )
end


--[[
-- @brief Equips a generic military type ship.
--]]
function equip_genericMilitary( p, shipsize )

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

   equip_fillTurretsBySlotSize(p:ship(),outfits,nbTurrets,equip_defaultTurrets())
   equip_fillWeaponsBySlotSize(p:ship(),outfits,nbForwards,nbSecondaries,equip_defaultForwardMil(),equip_defaultSecondary())
   equip_fillUtilitiesBySlotSize(p:ship(),outfits,nbUtilities,equip_defaultUtilities())
   equip_fillStructuresBySlotSize(p:ship(),outfits,nbStructures,equip_defaultStructures())

   equip_ship( p, outfits )
end




