include("pilot/generic.lua")
include("dat/factions/equip/helper.lua")
include("dat/factions/equip/outfits.lua")
include('universe/generate_nameGenerator.lua')

-- Creates an empty ship for the pirate
function trader_createEmpty( ship )
   -- Create the pilot
   local pilots   = pilot.add( ship )
   local p        = pilots[1]

   -- Remove outfits
   p:rmOutfit( "all" )

   return p
end
function trader_createMeryoch(  )

   local p, s, outfits

   p     = "Meryoch"
   s     = ship.get(p)
   outfits = { }
   outfits["__save"] = true

   local nbSlotTurrets, nbSlotWeapons, nSlotUtilities, nbSlotStructures = equip_getSlotNumbers(s)

   local nbTurrets,nbForwards,nbSecondaries,nbStructures,nbUtilities

   -- light on weapons
   nbTurrets=nbSlotTurrets/2
   nbForwards=nbSlotWeapons/2
   nbSecondaries=0
   nbStructures=nbSlotStructures
   nbUtilities=nSlotUtilities

   equip_fillTurretsBySlotSize(s,outfits,nbTurrets,equip_defaultTurrets())
   equip_fillWeaponsBySlotSize(s,outfits,nbForwards,nbSecondaries,equip_defaultForward(),equip_defaultSecondary())
   equip_fillUtilitiesBySlotSize(s,outfits,nbUtilities,equip_defaultUtilities())
   equip_fillStructuresBySlotSize(s,outfits,nbStructures,equip_defaultStructuresMerchant())

   return p,outfits
end

function trader_createGeldoch(  )

   local p, s, outfits

   p     = "Geldoch"
   s     = ship.get(p)
   outfits = { }
   outfits["__save"] = true

   local nbSlotTurrets, nbSlotWeapons, nSlotUtilities, nbSlotStructures = equip_getSlotNumbers(s)

   local nbTurrets,nbForwards,nbSecondaries,nbStructures,nbUtilities

   -- heavy on weapons
   nbTurrets=nbSlotTurrets
   nbForwards=nbSlotWeapons-nbTurrets
   nbSecondaries=1
   nbStructures=nbSlotStructures
   nbUtilities=nSlotUtilities

   equip_fillTurretsBySlotSize(s,outfits,nbTurrets,equip_defaultTurrets())
   equip_fillWeaponsBySlotSize(s,outfits,nbForwards,nbSecondaries,equip_defaultForward(),equip_defaultSecondary())
   equip_fillUtilitiesBySlotSize(s,outfits,nbUtilities,equip_defaultUtilities())
   equip_fillStructuresBySlotSize(s,outfits,nbStructures,equip_defaultStructuresMerchant())

   return p,outfits
end

function ardarshir_trader_name()


   local randomArdarName=nameGenerator.generateNameArdarshir()

   local descriptors = {
      "Busy",
      "Daring",
      "Industrious",
      "Ambitious",
      "Mighty",
      "Prosperous",
      "Disciplined",
      "Efficient"
   }

   return "The "..descriptors[ rnd.rnd(1,#descriptors) ].." "..randomArdarName
end

--[[
-- @brief Generates pilot names
--]]
function trader_name ()
   local articles = {
      "The",
   }
   local descriptors = {
      "Joyful",
      "Daring",
      "Rich",
      "Ambitious",
      "Adventurous"
   }
   local colours = {
      "Red",
      "Green",
      "Blue",
      "Cyan",
      "Black",
      "Brown",
      "Mauve",
      "Crimson",
      "Yellow",
      "Purple"
   }
   local actors = {
      "Merchant",
      "Trader",
      "Bohemian",
      "Traveller",
      "Caravel",
      "Cutter",
      "Vessel",
      "Gypsy"
   }

   local article = articles[ rnd.rnd(1,#articles) ]
   local descriptor = descriptors[ rnd.rnd(1,#descriptors) ]
   local colour = colours[ rnd.rnd(1,#colours) ]
   local actor = actors[ rnd.rnd(1,#actors) ]

   local r = rnd.rnd()
   if r < 0.166 then
      return article .. " " .. actor
   elseif r < 0.333 then
      return colour .. " " .. actor
   elseif r < 0.50 then
      return descriptor .. " " .. actor
   elseif r < 0.666 then
      return article .. " " .. descriptor .. " " .. actor
   elseif r < 0.833 then
      return article .. " " .. colour .. " " .. actor
   else
      return article .. " " .. descriptor .. " " .. colour .. " " .. actor
   end
end
