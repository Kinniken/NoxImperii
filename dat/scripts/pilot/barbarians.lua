
include("pilot/generic.lua")
include("dat/factions/equip/helper.lua")
include("dat/factions/equip/outfits.lua")


--[[
-- @brief Creates a mighty pirate of epic proportions.
--
--    @param barbarian_create If nil or true actually creates a pirate with a
--           random name and all, otherwise it'll give ship type and outfits.
--    @return If barbarian_create is false it'll return a string containing the
--           name of the ship of the pirate and a table containing the outfits,
--           otherwise it'll return the pirate itself and the outfit table.
--]]
function barbarian_create( barbarian_create )
   -- Create by default
   if barbarian_create == nil then
      barbarian_create = true
   end

   -- Choose pirate type
   local z = rnd.rnd()
   local p, o
   if z < 0.25 then
      p,o = barbarian_createPlanet( barbarian_create )
   elseif z < 0.5 then
      p,o = barbarian_createContinent( barbarian_create )
   else
      p,o = barbarian_createComet( barbarian_create )
   end

   -- Set name
   if barbarian_create then
      p:rename( barbarian_name() )
   end
   return p,o
end


-- Creates an empty ship for the pirate
function barbarian_createEmpty( ship )
   -- Create the pilot
   local pilots   = pilot.add( ship )
   local p        = pilots[1]

   -- Remove outfits
   p:rmOutfit( "all" )

   return p
end

-- Creates a pirate flying a "Pirate Kestrel"
function barbarian_createPlanet( barbarian_create )
   -- Create by default
   if barbarian_create == nil then
      barbarian_create = true
   end

   -- Create the pirate ship
   local p, s, olist
   if barbarian_create then
      p     = barbarian_createEmpty( "Barbarian Slaver" )
      s     = p:ship()
      olist = nil
   else
      p     = "Barbarian Slaver"
      s     = ship.get(p)
      olist = { }
   end

   -- Equipment vars
   local primary, secondary, medium, low
   local use_primary, use_secondary, use_medium, use_low
   local nhigh, nmedium, nlow = s:slots()

   -- Kestrel gets some good stuff
   primary        = { "Heavy Ion Turret", "Razor Turret MK2", "Laser Turret MK2", "Turreted Vulcan Gun" }
   secondary      = { "Unicorp Headhunter Launcher" }
   use_primary    = nhigh-2
   use_secondary  = 2
   addWeapons( primary, use_primary )
   addWeapons( secondary, use_secondary )
   medium         = equip_mediumHig()
   low            = equip_lowHig()

   -- FInally add outfits
   equip_ship( p, true, weapons, medium, low,nil,
               use_medium, use_low, olist )

   return p,olist
end



-- Creates a pirate flying a "Pirate Ancestor"
function barbarian_createContinent( barbarian_create )
   -- Create by default
   if barbarian_create == nil then
      barbarian_create = true
   end

   -- Create the pirate ship
   local p, s, olist
   if barbarian_create then
      p     = barbarian_createEmpty( "Barbarian Looter" )
      s     = p:ship()
      olist = nil
   else
      p     = "Barbarian Looter"
      s     = ship.get(p)
      olist = { }
   end

   -- Equipment vars
   local primary, secondary, medium, low
   local use_primary, use_secondary, use_medium, use_low
   local nhigh, nmedium, nlow = s:slots()

   -- Ancestor specializes in ranged combat.
   primary        = { "Laser Cannon MK1", "Laser Cannon MK2", "Plasma Blaster MK1", "Plasma Blaster MK2", "Razor MK1", "Razor MK2" }
   secondary      = { "Unicorp Fury Launcher" }
   use_primary    = nhigh-2
   use_secondary  = 2
   addWeapons( primary, use_primary )
   addWeapons( secondary, use_secondary )
   medium         = equip_mediumMed()
   low            = equip_lowMed()

   -- Finally add outfits
   equip_ship( p, true, weapons, medium, low,nil,
               use_medium, use_low, olist )

   return p,olist
end


-- Ceates a pirate flying a "Pirate Vendetta"
function barbarian_createComet( barbarian_create )

   -- Create by default
   if barbarian_create == nil then
      barbarian_create = true
   end

   -- Create the pirate ship
   local p, s, olist
   if barbarian_create then
      p     = barbarian_createEmpty( "Barbarian Raider" )
      s     = p:ship()
      olist = nil
   else
      p     = "Barbarian Raider"
      s     = ship.get(p)
      olist = { } 
   end

   -- Equipment vars
   local primary, secondary, medium, low
   local use_primary, use_secondary, use_medium, use_low
   local nhigh, nmedium, nlow = s:slots()

   -- Vendettas are all about close-range firepower.
   primary        = { "Plasma Blaster MK1", "Plasma Blaster MK2", "Laser Cannon MK1", "Razor MK2" }
   secondary      = { "Unicorp Fury Launcher", "Unicorp Banshee Launcher" }
   use_primary    = nhigh-1
   use_secondary  = 1
   addWeapons( primary, use_primary )
   addWeapons( secondary, use_secondary )
   medium         = equip_mediumLow()
   low            = equip_lowLow()

   -- Finally add outfits
   equip_ship( p, true, weapons, medium, low,nil,
               use_medium, use_low, olist )

   return p,olist
end


--[[
-- @brief Generates pilot names
--]]
function barbarian_name ()
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
