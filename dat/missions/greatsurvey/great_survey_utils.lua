
include "jumpdist.lua"
include "numstring.lua"
include "universe/generate_helper.lua"
include('universe/objects/class_planets.lua')
include "universe/live/live_universe.lua"

function computePayement(surveyedPlanet)

   local reward={};

   local lx,ly=surveyedPlanet.c:system():coords()
   reward.rewardDistance=(math.floor(math.max(0,(gh.calculateDistance({x=0,y=0},{x=lx,y=ly})-600)*5)))
   reward.rewardDistance=math.min(reward.rewardDistance,4000)

   reward.rewardNatives=0

   if (surveyedPlanet.lua.natives) then
      if surveyedPlanet.lua.natives:hasTag("rare") then
         reward.rewardNatives=2500
      else
         reward.rewardNatives=1000
      end
   end

   if (surveyedPlanet.lua.humanFertility>0.7) then
      reward.rewardFertility=math.floor(surveyedPlanet.lua.humanFertility*1000)
   else
      reward.rewardFertility=0
   end

   if (surveyedPlanet.lua.minerals>0.5) then
      reward.rewardMinerals=math.floor(surveyedPlanet.lua.minerals*1000)
   else
      reward.rewardMinerals=0
   end

   reward.rewardTotal=reward.rewardDistance+reward.rewardNatives+reward.rewardFertility+reward.rewardMinerals

   return reward

end

function isSystemValid(system)
   local presences=system.cur():presences()

   return not presences["Empire of Terra"] and not presences["Roidhunate of Ardarshir"] and not presences["Oligarchy of Betelgeuse"]
end

function handlePlanet(surveyedPlanet,successMessage)

   if isSystemValid(planet.cur():system()) then

      local surveyedPlanet=planet_class.load(planet.cur())

      if not surveyedPlanet:hasTag("surveyed") then
         surveyedPlanet:addTag("surveyed")
         surveyedPlanet:addHistory("The world was surveyed by "..player:name().." on board the "..player:ship().." as part of the Second Great Survey.")
         generatePlanetServices(surveyedPlanet)
         surveyedPlanet:save()

         local reward=computePayement(surveyedPlanet)

         tk.msg( finishedtitle, gh.format(successMessage,reward) )
         player.pay( reward.rewardTotal )

         return true
      end
   end

   return false
end