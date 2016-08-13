include("pilot/generic.lua")
include("dat/factions/equip/helper.lua")
include("dat/factions/equip/outfits.lua")
include('universe/generate_nameGenerator.lua')

local function equipArdarShip(s,outfits, nbForwards, nbTurrets,nbSecondaries, nbUtilities, nbStructures)
   equip_fillTurretsBySlotSize(s,outfits,nbTurrets,equip_defaultTurretsArdar())
   equip_fillWeaponsBySlotSize(s,outfits,nbForwards,nbSecondaries,equip_defaultForwardArdar(),equip_defaultSecondaryArdar())
   equip_fillUtilitiesBySlotSize(s,outfits,nbUtilities,equip_defaultUtilitiesArdar())
   equip_fillStructuresBySlotSize(s,outfits,nbStructures,equip_defaultStructuresArdar())
end

function ardarshir_createMeteor()

   local stype, s, outfits

   stype 	 = "Ardar Roeth"
   s     = ship.get(stype)
   outfits = { }   
   outfits["__save"] = true

   local nbSlotTurrets, nbSlotWeapons, nSlotUtilities, nbSlotStructures = equip_getSlotNumbers(s)

   local nbTurrets,nbForwards,nbSecondaries,nbStructures,nbUtilities

   -- heavy on weapons
   nbTurrets=nbSlotTurrets
   nbForwards=nbSlotWeapons-nbTurrets
   nbSecondaries=0
   nbStructures=nbSlotStructures
   nbUtilities=nSlotUtilities

   equipArdarShip(s,outfits, nbForwards, nbTurrets, nbSecondaries,nbUtilities, nbStructures)

   return stype,outfits,"roidhunate",G.ROIDHUNATE
end


function ardarshir_createComet()

   local stype, s, outfits

   stype     = "Ardar Vach Rueth"
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

   equipArdarShip(s,outfits, nbForwards, nbTurrets, nbSecondaries,nbUtilities, nbStructures)

   return stype,outfits,"roidhunate",G.ROIDHUNATE
end

function ardarshir_createContinent()

   local stype, s, outfits

   stype     = "Ardar Brythioch"
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

   equipArdarShip(s,outfits, nbForwards, nbTurrets, nbSecondaries,nbUtilities, nbStructures)

   return stype,outfits,"roidhunate",G.ROIDHUNATE
end