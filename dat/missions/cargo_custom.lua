include "dat/scripts/general_helper.lua"
include "dat/scripts/jumpdist.lua"
include "dat/scripts/nextjump.lua"
include "dat/scripts/numstring.lua"
include "dat/scripts/universe/objects/class_cargomissions.lua"
include "dat/scripts/universe/objects/class_planets.lua"
include "dat/scripts/universe/objects/class_settlements.lua"
include "dat/missions/cargo_custom_types.lua"

--modified version of cargo_common to use cargomission templates


-- Create the mission
function create()
    -- Note: this mission does not make any system claims.

    local curPlanet=planet_class.load(planet.cur())

    local bestIndustry=0
    local bestTechnology=0

    for k,settlement in pairs(curPlanet.lua.settlements) do
      if (settlement.industry>bestIndustry) then
        bestIndustry=settlement.industry
      end
      if (settlement.technology>bestTechnology) then
        bestTechnology=settlement.technology
      end
    end

    --check the value of the world for missions
    local score=bestIndustry*bestTechnology

    if (score<0.50) then
      score=0.5
    end

    --if lower than 1, might drop mission
    if (math.random()>score) then
      --print("exiting mission because score not enough: "..score)
      misn.finish(false)
    end

    cargoType=findMatchingType()
    if cargoType == nil then
       misn.finish(false)
    end

    cargoTypeId=cargoType.id--to reload it afterwards

    -- Calculate the route, distance, jumps and cargo to take
    destplanet, destsys, numjumps, traveldist, cargo = cargo_calculateRoute()
    if destplanet == nil then
       --print("No destination found")
       misn.finish(false)       
    end
    --print("Dest found: "..destplanet:name())

    --lower priorities more often
    urgency = math.min(rnd.rnd(cargoType.minRushLevel, cargoType.maxRushLevel),rnd.rnd(cargoType.minRushLevel, cargoType.maxRushLevel))
    
    if urgency>0 then
      -- Calculate time limit. Depends on tier and distance.
      -- The second time limit is for the reduced reward.
      stuperpx   = 0.2 - 0.025 * urgency
      stuperjump = 24*3600 + 300 - 300 * urgency
      stupertakeoff = 5*3600 + 300 - 75 * urgency
      allowance  = traveldist * stuperpx + numjumps * stuperjump + stupertakeoff + 240 * numjumps

      -- Allow extra time for refuelling stops.
      local jumpsperstop = 3 + math.min(urgency, 3)
      if numjumps > jumpsperstop then
          allowance = allowance + math.floor((numjumps-1) / jumpsperstop) * stuperjump
      end

      timelimit  = time.get() + time.create(0,0,0,0, 0, allowance)
      timelimit2 = time.get() + time.create(0,0,0,0, 0, allowance * 1.2)
    end

    --lower sizes more often
    amount     = math.min(rnd.rnd(cargoType.minCargoSize, cargoType.maxCargoSize),rnd.rnd(cargoType.minCargoSize, cargoType.maxCargoSize),rnd.rnd(cargoType.minCargoSize, cargoType.maxCargoSize)) 

    if (amount<=10) then
      cargoSizeTier=1
    elseif (amount<=20) then
      cargoSizeTier=2
    elseif (amount<=50) then
      cargoSizeTier=3
    elseif (amount<=100) then
      cargoSizeTier=4
    else
      cargoSizeTier=5
    end


    jumpreward = 1000
    distreward = 0.12
    reward     = math.floor(1.5^urgency * 1.2^cargoSizeTier * (numjumps * jumpreward + traveldist * distreward) * (1. + 0.05*rnd.twosigma())* cargoType.priceFactor)

    textData_targetWorld=destplanet:name()
    textData_targetSystem=destsys:name()
    textData_quantity=amount
    textData_commodity=cargo
    textData_payment=numstring(reward)
    textData_paymentPartial=numstring(reward*cargoType.lateRewardFactor)
    if (urgency>0) then
      textData_deadline=timelimit:str(0)
      textData_timeRemaining=(timelimit - time.get()):str(0)
      textData_urgencyAdj=cargoType.cargoPriorityLabels[urgency]
    end
    textData_cargoSizeAdj=cargoType.cargoSizeLabels[cargoSizeTier]
    
    print(cargoSizeTier)
    print(textData_cargoSizeAdj)
    print(#cargoType.cargoSizeLabels)


    local factionDescText

    if #(cargoType.factionRewards)==1 then
      factionDescText="This mission will increase your standing with the "..cargoType.factionRewards[1].faction.." and their allies, and reduce it with their enemies."
    elseif #(cargoType.factionRewards)>1 then
      factionDescText="This mission will increase your standing with the following factions and their allies, and reduce it with their enemies: "

      for k,v in ipairs(cargoType.factionRewards) do
        factionDescText=factionDescText..v.faction

        if k<#(cargoType.factionRewards) then
          factionDescText=factionDescText..", "
        end
      end
    end

    local misnDesc

    if (urgency==0) then
     misnDesc=cargoType.misn_desc,textData
    else
     misnDesc=cargoType.misn_desc_urgent,textData
    end

    if factionDescText then
      misnDesc=misnDesc.."\n\n"..factionDescText
    end

    local textData=createTextData()

    if (urgency==0) then
      misn.setTitle( gh.format(cargoType.misn_title,textData))      
    else
      misn.setTitle( gh.format(cargoType.misn_title_urgent,textData))
    end
    misn.setDesc(gh.format(misnDesc,textData))
    misn.markerAdd(destsys, "computer")

    misn.setReward(gh.format(cargoType.misn_reward,textData))
end

--a not very elegant solution to Naev saving only primitive vars in the mission data
function createTextData()
  local textData={}

  for k,v in pairs(_G) do
    if string.sub(k,1,string.len("textData_"))=="textData_" then
      textData[string.sub(k,string.len("textData_")+1)]=v
    end
  end

  return textData
end

-- Mission is accepted
function accept()

    local textData=createTextData()

    if player.pilot():cargoFree() < amount then

        local textData2={}
        textData2.lackingSpace=amount - player.pilot():cargoFree()
        textData2.quantity=textData.quantity

        tk.msg(gh.format(cargoType.full1,textData2), gh.format(cargoType.full2,textData2))
        misn.finish()
    end
    if (urgency>0) then
      player.pilot():cargoAdd( cargo, amount ) 
      local playerbest = cargoGetTransit( timelimit, numjumps, traveldist )
      player.pilot():cargoRm( cargo, amount ) 
      if timelimit < playerbest then
          local textData2={}
          textData2.deadline=textData.deadline
          textData2.targetWorld=textData.targetWorld
          textData2.minTime=(playerbest - time.get()):str()
          if not tk.yesno( gh.format(cargoType.slow1,textData2), gh.format(cargoType.slow2,textData2) ) then
              misn.finish()
          end
      end
    end
    misn.accept()
    intime = true
    misn.cargoAdd(cargo, amount) 
    local osd_msg={}
    if urgency==0 then
      osd_msg[1] = gh.format(cargoType.osd_msg1,textData)
      osd_msg[2] = gh.format(cargoType.osd_msg2,textData)
    else
      osd_msg[1] = gh.format(cargoType.osd_msg1_urgent,textData)
      osd_msg[2] = gh.format(cargoType.osd_msg2_urgent,textData)
    end
    local osd_title=gh.format(cargoType.osd_title,textData)
    misn.osdCreate(osd_title, osd_msg)
    hook.land("land")
    if urgency>0 then
      hook.date(time.create(0,0,0,0, 1, 0), "tick") -- every minute
    end
end

-- Land hook
function land()

  local textData=createTextData()

    if planet.cur() == destplanet then

        local effectiveReward

        if intime then
            -- Semi-random message.
            tk.msg(gh.format(cargoType.land_title,textData), gh.format(gh.randomObject(cargoType.land_msg),textData))
            effectiveReward=reward
        else
            -- Semi-random message for being late.
            tk.msg(gh.format(cargoType.land_title_late,textData), gh.format(gh.randomObject(cargoType.land_msg_late),textData))
            effectiveReward=reward*cargoType.lateRewardFactor
        end

        player.pay(effectiveReward)

        for k,v in ipairs(cargoType.factionRewards) do

          local f=faction.get(v.faction)

          if f then
            local repReward=effectiveReward*v.rewardFactor

            if (f:playerStanding()+repReward<=v.rewardLimit) then
              f:modPlayer(repReward)
            elseif f:playerStanding()<v.rewardLimit and f:playerStanding()+repReward>v.rewardLimit then
              --just enough to get to the limit
              f:modPlayer(v.rewardLimit-f:playerStanding())
            end            
          end

        end
        
        misn.finish(true)
    end
end

-- Date hook
function tick()

  cargoType=cargo_custom.typesById[cargoTypeId]

  local textData=createTextData()

  textData.timeRemaining=(timelimit - time.get()):str()
  if timelimit >= time.get() then
      -- Case still in time
      local osd_msg={}
      local osd_title=gh.format(cargoType.osd_title,textData)
      osd_msg[1] = gh.format(cargoType.osd_msg1_urgent,textData)
      osd_msg[2] = gh.format(cargoType.osd_msg2_urgent,textData)
      misn.osdCreate(osd_title, osd_msg)
  elseif timelimit2 <= time.get() then
      -- Case missed second deadline
      player.msg(gh.format(cargoType.timeUp2,textData))
      abort()
  elseif intime then
      -- Case missed first deadline
      local osd_msg={}
      local osd_title=gh.format(cargoType.osd_title,textData)
      player.msg(gh.format(cargoType.timeUp1,textData))
      osd_msg[1] = gh.format(cargoType.osd_msg1_urgent,textData)
      osd_msg[2] = gh.format(cargoType.osd_msg2_urgent,textData)
      misn.osdCreate(osd_title, osd_msg)
      intime = false
  end
end

function abort()
    misn.finish(false)
end


--return a valid custom type for this world, if any
function findMatchingType()

  local validTypes={}

  for k,v in ipairs(cargo_custom.types) do
    if (v:validStartPlanet(planet.cur())) then
      table.insert(validTypes,v)
    end
  end

  if (#validTypes==0) then
    return nil
  else

    local totalWeight=0

    for k,v in ipairs(validTypes) do
      totalWeight=totalWeight+v.weight
    end

    --if not enough event type, don't always return one
    if (math.random()*100>totalWeight) then
      --print("exiting mission because weight not enough: "..totalWeight)
      return nil
    end

    return gh.pickWeightedObject(validTypes)
  end
end


-- Build a set of target planets
function cargo_selectPlanets(routepos)
    local planets = {}
    getsysatdistance(system.cur(), cargoType.minDistance, cargoType.maxDistance,
        function(s)
            for i, v in ipairs(s:planets()) do
                if v:services()["inhabited"] and v ~= planet.cur() and v:class() ~= 0 and
                        not (s==system.cur() and ( vec2.dist( v:pos(), routepos ) < 2500 ) ) and
                  v:canLand() and cargoValidDest( v ) and cargoType:validEndPlanet( v ) then
                    planets[#planets + 1] = {v, s}
                end
           end
           return true
        end)

    return planets    
end

-- We have a destination, now we need to calculate how far away it is by simulating the journey there.
-- Assume shortest route with no interruptions.
-- This is used to calculate the reward.
function cargo_calculateDistance(routesys, routepos, destsys, destplanet)
    local traveldist = 0

   jumps = routesys:jumpPath( destsys )
   if jumps then
      for k, v in ipairs(jumps) do
        -- We're not in the destination system yet.
         -- So, get the next system on the route, and the distance between
         -- our entry point and the jump point to the next system.
        -- Then, set the exit jump point as the next entry point.
         local j, r = jump.get( v:system(), v:dest() )
        traveldist = traveldist + vec2.dist(routepos, j:pos())
        routepos = r:pos()
    end
   end

    -- We ARE in the destination system now, so route from the entry point to the destination planet.
    traveldist = traveldist + vec2.dist(routepos, destplanet:pos())

    return traveldist
end

function cargo_calculateRoute ()
    origin_p, origin_s = planet.cur()
    local routesys = origin_s
    local routepos = origin_p:pos()
    
    local planets = cargo_selectPlanets(missdist, routepos)
    if #planets == 0 then
       return
    end

    local index      = rnd.rnd(1, #planets)
    local destplanet = planets[index][1]
    local destsys    = planets[index][2]
    
    -- We have a destination, now we need to calculate how far away it is by simulating the journey there.
    -- Assume shortest route with no interruptions.
    -- This is used to calculate the reward.

    local numjumps   = origin_s:jumpDist(destsys)
    local traveldist = cargo_calculateDistance(routesys, routepos, destsys, destplanet)
    

    local cargo = cargoType.commodities[rnd.rnd(1, #(cargoType.commodities))]

    -- Return lots of stuff
    return destplanet, destsys, numjumps, traveldist, cargo
end



-- Calculates the minimum possible time taken for the player to reach a destination.
function cargoGetTransit( timelimit, numjumps, traveldist )
    local pstats   = player.pilot():stats()
    local stuperpx = 1 / pstats.speed_max * 30
    local arrivalt = time.get() + time.create(0,0,0,0, 0, traveldist * stuperpx +
            numjumps * pstats.jump_delay + 10180 + 240 * numjumps)
    return arrivalt
end
function cargoValidDest( targetplanet )
   -- The blacklist are factions which cannot be delivered to by factions other than themselves, i.e. the Thurion and Proteron.
   local blacklist = {
                     faction.get(G.BARBARIANS),
                     faction.get(G.PIRATES),
                     }
   for i,f in ipairs( blacklist ) do
      if planet.cur():faction() == blacklist[i] and targetplanet:faction() ~= blacklist[i] then
         return false
      end
   end
   return true
end
