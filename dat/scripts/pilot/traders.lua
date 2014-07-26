include("pilot/generic.lua")
include("dat/factions/equip/helper.lua")
include("dat/factions/equip/outfits.lua")

function trader_createSmallBorderTrader(  )
   -- Create by default
   if trader_create == nil then
      trader_create = true
   end

   -- Choose pirate type
   local z = rnd.rnd()
   local p, o
   if z < 0.5 then
      p,o = trader_createMuleMerseia( trader_create )
   else
      p,o = trader_createKoalaMerseia( trader_create )
   end

   -- Set name
   if trader_create then
      p:rename( trader_name() )
   end
   return p,o
end


-- Creates an empty ship for the pirate
function trader_createEmpty( ship )
   -- Create the pilot
   local pilots   = pilot.add( ship )
   local p        = pilots[1]

   -- Remove outfits
   p:rmOutfit( "all" )

   return p
end
function trader_createKoala(  )

   local p, s, olist

      p     = "Koala"
      s     = ship.get(p)
      olist = { }
   

   -- Equipment vars
   local primary, secondary, medium, low
   local use_primary, use_secondary, use_medium, use_low
   local nhigh, nmedium, nlow = s:slots()

   primary        = { "Laser Cannon MK1", "Ion Cannon" }
   secondary      = { "Unicorp Fury Launcher" }
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

function trader_createMule(  )

   local p, s, olist

      p     = "Mule"
      s     = ship.get(p)
      olist = { }
   

   -- Equipment vars
   local primary, secondary, medium, low
   local use_primary, use_secondary, use_medium, use_low
   local nhigh, nmedium, nlow = s:slots()

   primary        = { "Razor Turret MK1", "Turreted Gauss Gun" }
   secondary      = { "Unicorp Fury Launcher" }
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
      "Traveler",
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
