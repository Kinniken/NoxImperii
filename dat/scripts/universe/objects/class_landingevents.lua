landingevent_class = {}

local landingevent_prototype = {
  addYesOption=function(self,title,text,weight,values)
    self.addOption(self.yesOptions,title,text,weight,values)
  end,
  addNoOption=function(self,title,text,weight,values)
    self.addOption(self.noOptions,text,title,weight,values)
  end,
  addOption=function(options,title,text,weight,values)
    local option={}
    option.text=text
    option.title=title
    option.weight=weight
    option.values=values

    table.insert(options,option)
  end,
  weightValiditySelf=function(self,planet)
    if (self.validPlanets and not self.validPlanets[planet.lua.planetType]) then
      return false
    end

    if (self.validNatives and (not planet.lua.natives or not self.validNatives[planet.lua.natives.type])) then
     return false
    end

    return true
  end,
  run=function(self,planet)

    local textData=self.landingEventsTextData(planet)
    local option=nil

    if tk.yesno( gh.format(self.startTitle,textData), gh.format(self.startText,textData) ) then
      option=gh.pickWeightedObject(self.yesOptions)
    else
      option=gh.pickWeightedObject(self.noOptions)
    end

    if planet.lua.natives then
      textData.nativesname=planet.lua.natives.name
    end

    if option then      
      local crewLevelFactor=0

      if option.values.woundCrew then
        local crewlevel,crewname,crewgender,crewtype,crewactive,crewstatus=self.tryWoundingCrewMember()

        if crewlevel then
          textData.woundedCrewName=crewname
          textData.hisher=self.getGenderPossessive(crewgender)
          textData.heshe=self.getGenderPronoun(crewgender)          
        else
          textData.woundedCrewName="a crew member"
          if math.random()<0.5 then
            textData.hisher="his"
            textData.heshe="he"
          else
            textData.hisher="her"
            textData.heshe="she"
          end
        end
        textData.HeShe=textData.heshe:gsub("^%l", string.upper)
        textData.HisHer=textData.hisher:gsub("^%l", string.upper)
      end

      if option.values.crewType then
        local crewlevel,crewname,crewgender,crewtype,crewactive,crewstatus=player.crewByPosition(option.values.crewType)

        crewLevelFactor=crewlevel

        if crewlevel==0 then
          textData.crewJob=gh.format(option.values.crewAbsentText,textData)
        else
          textData.crewName=crewname
          textData.crewAdj=self.getCrewLevelAdj(crewlevel)
          textData.crewAdv=self.getCrewLevelAdv(crewlevel)
          textData.crewJob=gh.format(option.values.crewPresentText,textData)
        end     
      end

      if option.values.damages then
        local damages=gh.floorTo(adjustForShipPrice(option.values.damages+math.random()*option.values.damagesBonus),-2)
        textData.damages=damages
        player.pay(-damages)
      end

      if option.values.loot then
        local loot=gh.floorTo(self.adjustForCrewLevel(option.values.loot+math.random()*option.values.lootBonus,crewLevelFactor),-2)
        textData.loot=loot
        player.pay(loot)
      end

      if option.values.goodQuantity then
        local quantity=gh.floorTo(self.adjustForCrewLevel(option.values.goodQuantity+math.random()*option.values.goodQuantityBonus,crewLevelFactor),0)
        textData.quantity=quantity
        player.addCargo(option.values.goodType,quantity)
      end

      tk.msg( gh.format(option.title,textData), gh.format(option.text,textData))
    end
  end,

  landingEventsTextData=function(landedPlanet)
    local textData={}

    textData.playername=player.name()
    textData.shipname=player.ship()
    textData.planetname=planet.cur():name()
    textData.sunname=system.cur():name()

    if (landedPlanet.lua.natives) then
      textData.nativesname=landedPlanet.lua.natives.name
    elseif (landedPlanet.lua.settlements.natives) then
      textData.nativesname=landedPlanet.lua.settlements.natives.name
    end

    return textData
  end,

  --return value multiplied by ratio of ship price to starting ship price
  --goes from 1 to 30 for the most expensive ships (+/- 20M)
  adjustForShipPrice=function(value)

    local shipPrice,b=player.pilot():ship():price()

    return value*(0.75+(shipPrice/150000)/4)
  end,

  adjustForCrewLevel=function(value,level)

    if level==0 then--no crew member
      return value
    elseif level==1 then
      return value*2
    elseif level==2 then
      return value*4
    elseif level==3 then
      return value*6
    else
      return value*10
    end
  end,

  getCrewLevelAdj=function(level)
    if level<2 then--normally 1 only, 0 makes no sense
      return "passable"
    elseif level==2 then
      return "adequate"
    elseif level==3 then
      return "good"
    else
      return "fantastic"
    end
  end,

  getCrewLevelAdv=function(level)
    if level<2 then--normally 1 only, 0 makes no sense
      return "passably"
    elseif level==2 then
      return "adequately"
    elseif level==3 then
      return "efficiently"
    else
      return "fantastically"
    end
  end,

  getRandomCrewType=function()
    local crewTypes=player.crews()

    if (#crewTypes==0) then
      return nil
    end

    return gh.randomObject(crewTypes)
  end,

  getGenderPossessive=function(gender)
    if gender==1 then
      return "his"
    elseif gender==2 then
      return "her"
    else
      return "its"
    end
  end,

  getGenderPronoun=function(gender)
    if gender==1 then
      return "he"
    elseif gender==2 then
      return "she"
    else
      return "it"
    end
  end,

  tryWoundingCrewMember=function()
    local randomCrewType=getRandomCrewType()

    if (randomCrewType~=nil) then
      local level,name,gender,type,active,status=player.crew(randomCrewType)

      if status==1 then--healthy

        player.setCrewStatus(randomCrewType,2)

        return level,name,gender,type,active,status
      end         
    end

    return nil
  end
}

landingevent_prototype.__index = landingevent_prototype

function landingevent_class.createNew()
  local o={}
  setmetatable(o, landingevent_prototype)
  o.weight=10
  o.validPlanets=nil
  o.textData={}
  o.startText=nil
  o.startTitle=nil
  o.yesOptions={}
  o.noOptions={}
  return o
end