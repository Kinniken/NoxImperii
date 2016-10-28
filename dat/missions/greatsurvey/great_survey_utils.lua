
include "jumpdist.lua"
include "dat/scripts/general_helper.lua"
include('universe/objects/class_planets.lua')
include "universe/live/live_universe.lua"

rewardsClass={["Asteroid Moon"]=100,
["Silicate Moon"]=500,
["Hot Telluric"]=1000,
["Glasshouse"]=1500,
["Hot Earth-like"]=1500,
["Warm Earth-like"]=3000,
["Earth-like"]=5000,
["Cold Earth-like"]=3000,
["Cold Telluric"]=1500,
["Hot Jupiter"]=1000,
["Gas Giant"]=1000,
["Volcanic Moon"]=500,
["Rocky Moon"]=500,
["Ice Moon"]=1000,
["Methane Moon"]=500,
["Volcanic Oasis Moon"]=3000}

local planet_bonus=[[${worldName} is the first "${worldClass}" world you have surveyed.

As a result, the Great Survey grants you a bonus of ${bonus} credits!

You can check the list of world types and how many you have discovered in the "Great Survey" tab of the Info panel.]]

local specie_bonus=[[The ${specieName} are the first ${specieType} species you have discovered.

As a result, the Great Survey grants you a bonus of ${bonus} credits!

You can check the list of specie types and how many you have discovered in the "Great Survey" tab of the Info panel.]]

function computePayement(surveyedPlanet)

   local reward={};

   reward.worldName=surveyedPlanet.c:name()

   local lx,ly=surveyedPlanet.c:system():coords()

   reward.rewardWorldClass=rewardsClass[surveyedPlanet.c:class()]

   if (reward.rewardWorldClass==nil) then
      print("No reward for world class: "..surveyedPlanet.c:class())
      reward.rewardWorldClass=0
   end

   reward.worldClass=surveyedPlanet.c:class()

   reward.rewardNatives=0

   if (surveyedPlanet.lua.natives) then
      if surveyedPlanet.lua.natives:hasTag("rare") then
         reward.rewardNatives=25000
      else
         reward.rewardNatives=10000
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

   distance=(math.floor(math.max(0,(gh.calculateDistance({x=0,y=0},{x=lx,y=ly})-1000))))
   distance=math.min(distance,800)

   reward.rewardDistance=1+(distance/800)*3

   reward.rewardDistance=math.floor(reward.rewardDistance*10)/10

   reward.rewardTotal=reward.rewardDistance*(reward.rewardWorldClass+reward.rewardNatives+reward.rewardFertility+reward.rewardMinerals)

   reward.rewardDistance=gh.numstring(reward.rewardDistance)
   reward.rewardWorldClass=gh.numstring(reward.rewardWorldClass)
   reward.rewardNatives=gh.numstring(reward.rewardNatives)
   reward.rewardFertility=gh.numstring(reward.rewardFertility)
   reward.rewardMinerals=gh.numstring(reward.rewardMinerals)

   reward.rewardTotal=math.floor(reward.rewardTotal)
   reward.rewardTotalStr=gh.numstring(reward.rewardTotal)

   return reward

end

function isSystemValid(system)
   local presences=system.cur():presences()

   return not presences[G.EMPIRE] and not presences[G.ROIDHUNATE] and not presences[G.BETELGEUSE] and not presences[G.ROYAL_IXUM] and not presences[G.HOLY_FLAME]
end

function handlePlanet(surveyedPlanet,successMessage)

   if isSystemValid(planet.cur():system()) then

      local surveyedPlanet=planet_class.load(planet.cur())

      if not surveyedPlanet:hasTag("surveyed") then
         surveyedPlanet:addTag("surveyed")
         surveyedPlanet:addHistory("The world was surveyed by "..player:name().." on board the "..player:ship().." as part of the Second Great Survey.")
         generatePlanetServices(surveyedPlanet)
         surveyedPlanet:save()

         local shortInfo=planet.cur():shortInfo()

         if shortInfo and shortInfo ~= "(null)" then
            shortInfo=shortInfo..", surveyed"
         else
            shortInfo="Surveyed"
         end

         planet.cur():setShortInfo(shortInfo)

         local reward=computePayement(surveyedPlanet)

         tk.msg( finishedtitle, gh.format(successMessage,reward) )
         player.pay( reward.rewardTotal )

         local planetClassCount=var.peek("survey_planet_"..surveyedPlanet.c:class())

         if not planetClassCount then
            planetClassCount=0
         end

         if planetClassCount==0 and rewardsClass[surveyedPlanet.c:class()] ~= nil then
            local bonus=rewardsClass[surveyedPlanet.c:class()]*10
            reward.bonus=gh.numstring(bonus)          
            tk.msg( "Bonus!", gh.format(planet_bonus,reward) )
            player.pay( bonus )
         end

         planetClassCount=planetClassCount+1

         var.push("survey_planet_"..surveyedPlanet.c:class(),planetClassCount)

         if (surveyedPlanet.lua.natives) then

            if (surveyedPlanet.lua.natives.type) then
               error("Planet "..planet.cur():name().." has natives with no types!")
            else

               local nativeClassCount=var.peek("survey_natives_"..surveyedPlanet.lua.natives.type)

               if not nativeClassCount then
                  nativeClassCount=0
               end

               if nativeClassCount==0 then
                  local bonus

                  if surveyedPlanet.lua.natives:hasTag("rare") then
                     bonus=250000
                  else
                     bonus=100000
                  end

                  reward.bonus=gh.numstring(bonus)

                  reward.specieName=surveyedPlanet.lua.natives.name
                  reward.specieType=natives_generator.common_natives[surveyedPlanet.lua.natives.type].label
                  tk.msg( "Bonus!", gh.format(specie_bonus,reward) )
                  player.pay( bonus )
               end

               nativeClassCount=nativeClassCount+1

               var.push("survey_natives_"..surveyedPlanet.lua.natives.type,nativeClassCount)
            end
         end

         return true
      end
   end

   return false
end