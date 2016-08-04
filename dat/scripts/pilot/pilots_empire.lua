include("pilot/generic.lua")
include("dat/factions/equip/helper.lua")
include("dat/factions/equip/outfits.lua")
include('universe/generate_nameGenerator.lua')

local function equipEmpireShip(s,outfits, nbForwards, nbTurrets, nbSecondaries,nbUtilities, nbStructures)

   equip_fillTurretsBySlotSize(s,outfits,nbTurrets,equip_defaultTurretsEmpire())
   equip_fillWeaponsBySlotSize(s,outfits,nbForwards,nbSecondaries,equip_defaultForwardEmpire(),equip_defaultSecondaryEmpire())
   equip_fillUtilitiesBySlotSize(s,outfits,nbUtilities,equip_defaultUtilitiesEmpire())
   equip_fillStructuresBySlotSize(s,outfits,nbStructures,equip_defaultStructuresEmpire())

end

function empire_createMeteor()
   
   local stype, s, outfits

   stype     = "Imperial Tunguska"
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

   equipEmpireShip(s,outfits, nbForwards, nbTurrets, nbSecondaries,nbUtilities, nbStructures)

   return stype,outfits,"empire",G.EMPIRE
end

function empire_createComet()
   
   local stype, s, outfits

   stype 	 = "Imperial Halley"
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

   equipEmpireShip(s,outfits, nbForwards, nbTurrets, nbSecondaries,nbUtilities, nbStructures)

   return stype,outfits,"empire",G.EMPIRE
end

function empire_createContinent()
   
   local stype, s, outfits

   stype     = "Imperial Asieneuve"
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

   equipEmpireShip(s,outfits, nbForwards, nbTurrets, nbSecondaries,nbUtilities, nbStructures)

   return stype,outfits,"empire",G.EMPIRE
end


function empire_createPlanet()
   
   local stype, s, outfits

   stype     = "Imperial Jupiter"
   s     = ship.get(stype)
   outfits = { }   
   outfits["__save"] = true

   local nbSlotTurrets, nbSlotWeapons, nSlotUtilities, nbSlotStructures = equip_getSlotNumbers(s)

   local nbTurrets,nbForwards,nbSecondaries,nbStructures,nbUtilities

   -- heavy on weapons
   nbTurrets=nbSlotTurrets
   nbForwards=nbSlotWeapons-nbTurrets
   nbSecondaries=4
   nbStructures=nbSlotStructures
   nbUtilities=nSlotUtilities

   equipEmpireShip(s,outfits, nbForwards, nbTurrets, nbSecondaries,nbUtilities, nbStructures)

   return stype,outfits,"empire",G.EMPIRE
end