
include("pilot/generic.lua")
include("dat/factions/equip/helper.lua")
include("dat/factions/equip/outfits.lua")

local function equipBarbarianShip(s,outfits, nbForwards, nbTurrets,nbSecondaries, nbUtilities, nbStructures)

   equip_fillTurretsBySlotSize(s,outfits,nbTurrets,equip_defaultTurretsBarbarians())
   equip_fillWeaponsBySlotSize(s,outfits,nbForwards,nbSecondaries,equip_defaultForwardBarbarians(),equip_defaultSecondaryBarbarians())
   equip_fillUtilitiesBySlotSize(s,outfits,nbUtilities,equip_defaultUtilities())
   equip_fillStructuresBySlotSize(s,outfits,nbStructures,equip_defaultUtilitiesPirates())

end

function barbarians_createComet()

   local stype, s, outfits

   stype     = "Barbarian Raider"
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

   equipBarbarianShip(s,outfits, nbForwards, nbTurrets, nbSecondaries,nbUtilities, nbStructures)

   return stype,outfits,"barbarians",G.BARBARIANS
end

function barbarians_createContinent()

   local stype, s, outfits

   stype     = "Barbarian Looter"
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

   equipBarbarianShip(s,outfits, nbForwards, nbTurrets, nbSecondaries,nbUtilities, nbStructures)

   return stype,outfits,"barbarians",G.BARBARIANS
end


function barbarians_createPlanet()

   local stype, s, outfits

   stype     = "Barbarian Slaver"
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

   equipBarbarianShip(s,outfits, nbForwards, nbTurrets, nbSecondaries,nbUtilities, nbStructures)

   return stype,outfits,"barbarians",G.BARBARIANS
end



