
include("pilot/generic.lua")
include("dat/factions/equip/helper.lua")
include("dat/factions/equip/outfits.lua")

local function equipMilShip(s,outfits, nbForwards, nbTurrets,nbSecondaries, nbUtilities, nbStructures)
   equip_fillTurretsBySlotSize(s,outfits,nbTurrets,equip_defaultTurretsMil())
   equip_fillWeaponsBySlotSize(s,outfits,nbForwards,nbSecondaries,equip_defaultForwardMil(),equip_defaultSecondary())
   equip_fillUtilitiesBySlotSize(s,outfits,nbUtilities,equip_defaultUtilities())
   equip_fillStructuresBySlotSize(s,outfits,nbStructures,equip_defaultStructures())
end

local function equipCivilianShip(s,outfits, nbForwards, nbTurrets,nbSecondaries, nbUtilities, nbStructures)
   equip_fillTurretsBySlotSize(s,outfits,nbTurrets,equip_defaultTurrets())
   equip_fillWeaponsBySlotSize(s,outfits,nbForwards,nbSecondaries,equip_defaultForward(),equip_defaultSecondary())
   equip_fillUtilitiesBySlotSize(s,outfits,nbUtilities,equip_defaultUtilities())
   equip_fillStructuresBySlotSize(s,outfits,nbStructures,equip_defaultStructures())
end

function trader_createRhino()

   local stype, s, outfits

   stype     = "Rhino"
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

   equipMilShip(s,outfits, nbForwards, nbTurrets, nbSecondaries,nbUtilities, nbStructures)

   return stype,outfits,"civilian",G.INDEPENDENT_TRADERS
end


function trader_createArgosy()

   local stype, s, outfits

   stype     = "Argosy"
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
   equipMilShip(s,outfits, nbForwards, nbTurrets, nbSecondaries,nbUtilities, nbStructures)

   return stype,outfits,"civilian",G.INDEPENDENT_TRADERS
end
