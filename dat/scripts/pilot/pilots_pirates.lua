
include("pilot/generic.lua")
include("dat/factions/equip/helper.lua")
include("dat/factions/equip/outfits.lua")

local function equipArdarShip(s,outfits, nbForwards, nbTurrets,nbSecondaries, nbUtilities, nbStructures)
   equip_fillTurretsBySlotSize(s,outfits,nbTurrets,equip_defaultTurretsArdar())
   equip_fillWeaponsBySlotSize(s,outfits,nbForwards,nbSecondaries,equip_defaultForwardArdar(),equip_defaultSecondaryArdar())
   equip_fillUtilitiesBySlotSize(s,outfits,nbUtilities,equip_defaultUtilitiesArdar())
   equip_fillStructuresBySlotSize(s,outfits,nbStructures,equip_defaultStructuresArdar())
end

function pirates_createMerkhrioch()

   local stype, s, outfits

   stype     = "Merkhrioch"
   s     = ship.get(stype)
   outfits = { }   
   outfits["__save"] = true

   local nbSlotTurrets, nbSlotWeapons, nSlotUtilities, nbSlotStructures = equip_getSlotNumbers(s)

   local nbTurrets,nbForwards,nbSecondaries,nbStructures,nbUtilities

   -- heavy on weapons
   nbTurrets=nbSlotTurrets
   nbForwards=nbSlotWeapons-nbTurrets
   nbSecondaries=2
   nbStructures=nbSlotStructures
   nbUtilities=nSlotUtilities

   --Ardar equipment for this one
   equipArdarShip(s,outfits, nbForwards, nbTurrets, nbSecondaries,nbUtilities, nbStructures)

   return stype,outfits,"barbarians",G.BARBARIANS
end

function pirates_createGeldoch()

   local stype, s, outfits

   stype     = "Geldoch"
   s     = ship.get(stype)
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

   --Ardar equipment for this one
   equipArdarShip(s,outfits, nbForwards, nbTurrets, nbSecondaries,nbUtilities, nbStructures)

   return stype,outfits,"barbarians",G.BARBARIANS
end


