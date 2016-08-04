include("pilot/generic.lua")
include("dat/factions/equip/helper.lua")
include("dat/factions/equip/outfits.lua")


--[[
-- @brief Creates a mighty pirate of epic proportions.
--
--    @param pirate_create If nil or true actually creates a pirate with a
--           random name and all, otherwise it'll give ship type and outfits.
--    @return If pirate_create is false it'll return a string containing the
--           name of the ship of the pirate and a table containing the outfits,
--           otherwise it'll return the pirate itself and the outfit table.
--]]
function pirate_create( )

   -- Choose pirate type
   local z = rnd.rnd()
   local p, o
   if z < 0.25 then
      p,o = pirate_createKestrel( )
   elseif z < 0.5 then
      p,o = pirate_createAdmonisher( )
   elseif z < 0.75 then
      p,o = pirate_createDelta( )
   else
      p,o = pirate_createVendetta( )
   end

   return p,o
end


-- Creates an empty ship for the pirate
function pirate_createEmpty( ship )
   -- Create the pilot
   local pilots   = pilot.add( ship )
   local p        = pilots[1]

   -- Remove outfits
   p:rmOutfit( "all" )

   return p
end

-- Creates a pirate flying a "Pirate Kestrel"
function pirate_createKestrel(  )


   -- Create the pirate ship
   local p, s, outfits

   p     = "Pirate Kestrel"
   s     = ship.get(p)
   outfits = { }
   outfits["__save"] = true
   

   local nbSlotTurrets, nbSlotWeapons, nSlotUtilities, nbSlotStructures = equip_getSlotNumbers(s)

   local nbTurrets,nbForwards,nbSecondaries,nbStructures,nbUtilities

   -- fully equipped
   nbTurrets=nbSlotTurrets
   nbForwards=nbSlotWeapons-2
   nbSecondaries=2
   nbStructures=nbSlotStructures
   nbUtilities=nSlotUtilities

   equip_fillTurretsBySlotSize(s,outfits,nbTurrets,equip_defaultTurretsPirates())
   equip_fillWeaponsBySlotSize(s,outfits,nbForwards,nbSecondaries,equip_defaultForwardPirates(),equip_defaultSecondaryPirates())
   equip_fillUtilitiesBySlotSize(s,outfits,nbUtilities,equip_defaultUtilitiesPirates())
   equip_fillStructuresBySlotSize(s,outfits,nbStructures,equip_defaultStructuresPirates())

   return p,outfits
end


-- Creates a pirate flying a "Pirate Admonisher"
function pirate_createAdmonisher( pirate_create )

   -- Create the pirate ship
   local p, s, outfits

   p     = "Pirate Admonisher"
   s     = ship.get(p)
   outfits = { }
   outfits["__save"] = true
   

   local nbSlotTurrets, nbSlotWeapons, nSlotUtilities, nbSlotStructures = equip_getSlotNumbers(s)

   local nbTurrets,nbForwards,nbSecondaries,nbStructures,nbUtilities

   -- fully equipped
   nbTurrets=nbSlotTurrets
   nbForwards=nbSlotWeapons-1
   nbSecondaries=1
   nbStructures=nbSlotStructures
   nbUtilities=nSlotUtilities

   equip_fillTurretsBySlotSize(s,outfits,nbTurrets,equip_defaultTurretsPirates())
   equip_fillWeaponsBySlotSize(s,outfits,nbForwards,nbSecondaries,equip_defaultForwardPirates(),equip_defaultSecondaryPirates())
   equip_fillUtilitiesBySlotSize(s,outfits,nbUtilities,equip_defaultUtilitiesPirates())
   equip_fillStructuresBySlotSize(s,outfits,nbStructures,equip_defaultStructuresPirates())

   return p,outfits
end


-- Creates a pirate flying a "Pirate Delta"
function pirate_createDelta( pirate_create )
   -- Create the pirate ship
   local p, s, outfits

      p     = "Pirate Delta"
      s     = ship.get(p)
      outfits = { }
      outfits["__save"] = true
   

   local nbSlotTurrets, nbSlotWeapons, nSlotUtilities, nbSlotStructures = equip_getSlotNumbers(s)

   local nbTurrets,nbForwards,nbSecondaries,nbStructures,nbUtilities

   -- fully equipped
   nbTurrets=nbSlotTurrets
   nbForwards=nbSlotWeapons/2
   nbSecondaries=nbSlotWeapons/2
   nbStructures=nbSlotStructures/2
   nbUtilities=nSlotUtilities/2

   equip_fillTurretsBySlotSize(s,outfits,nbTurrets,equip_defaultTurretsPirates())
   equip_fillWeaponsBySlotSize(s,outfits,nbForwards,nbSecondaries,equip_defaultForwardPirates(),equip_defaultSecondaryPirates())
   equip_fillUtilitiesBySlotSize(s,outfits,nbUtilities,equip_defaultUtilitiesPirates())
   equip_fillStructuresBySlotSize(s,outfits,nbStructures,equip_defaultStructuresPirates())

   return p,outfits
end


-- Ceates a pirate flying a "Pirate Vendetta"
function pirate_createVendetta( pirate_create )


   -- Create the pirate ship
   local p, s, outfits

      p     = "Pirate Vendetta"
      s     = ship.get(p)
      outfits = { } 
      outfits["__save"] = true

   local nbSlotTurrets, nbSlotWeapons, nSlotUtilities, nbSlotStructures = equip_getSlotNumbers(s)

   local nbTurrets,nbForwards,nbSecondaries,nbStructures,nbUtilities

   -- fully equipped
   nbTurrets=nbSlotTurrets
   nbForwards=nbSlotWeapons
   nbSecondaries=0
   nbStructures=nbSlotStructures/2
   nbUtilities=nSlotUtilities/2

   equip_fillTurretsBySlotSize(s,outfits,nbTurrets,equip_defaultTurretsPirates())
   equip_fillWeaponsBySlotSize(s,outfits,nbForwards,nbSecondaries,equip_defaultForwardPirates(),equip_defaultSecondaryPirates())
   equip_fillUtilitiesBySlotSize(s,outfits,nbUtilities,equip_defaultUtilitiesPirates())
   equip_fillStructuresBySlotSize(s,outfits,nbStructures,equip_defaultStructuresPirates())

   return p,outfits
end


--[[
-- @brief Generates pilot names
--]]
function pirate_name ()
   local articles = {
      "The",
   }
   local descriptors = {
      "Lustful",
      "Bloody",
      "Morbid",
      "Horrible",
      "Terrible",
      "Very Bad",
      "No Good",
      "Dark",
      "Evil",
      "Murderous",
      "Fearsome",
      "Defiant",
      "Unsightly",
      "Pirate's",
      "Night's",
      "Space",
      "Astro",
      "Delicious",
      "Fearless",
      "Eternal",
      "Mighty"
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
      "Beard",
      "Moustache",
      "Neckbeard",
      "Demon",
      "Vengeance",
      "Corsair",
      "Pride",
      "Insanity",
      "Peril",
      "Death",
      "Doom",
      "Raider",
      "Devil",
      "Serpent",
      "Bulk",
      "Killer",
      "Thunder",
      "Tyrant",
      "Lance",
      "Destroyer",
      "Horror",
      "Dread",
      "Blargh",
      "Terror"
   }
   local actorspecials = {
      "Angle Grinder",
      "Belt Sander",
      "Chainsaw",
      "Impact Wrench",
      "Band Saw",
      "Table Saw",
      "Drill Press",
      "Jigsaw",
      "Turret Lathe",
      "Claw Hammer",
      "Rubber Mallet",
      "Squeegee",
      "Pipe Wrench",
      "Bolt Cutter",
      "Staple Gun",
      "Crowbar",
      "Pickaxe",
      "Bench Grinder",
      "Scythe"
   }
   local article = articles[ rnd.rnd(1,#articles) ]
   local descriptor = descriptors[ rnd.rnd(1,#descriptors) ]
   local colour = colours[ rnd.rnd(1,#colours) ]
   local actor = actors[ rnd.rnd(1,#actors) ]
   local actorspecial = actorspecials[ rnd.rnd(1,#actorspecials) ]

   if rnd.rnd() < 0.25 then
      return article .. " " .. actorspecial
   else
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
end
