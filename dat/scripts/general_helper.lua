include('dat/scripts/constants.lua')

--puts the game in debug more (mass system generations, more frequent events)
debugMode=false

gh = {}

function gh.countMembers(table)
  local cpt=0
  for k,v in pairs(table) do
    cpt=cpt+1
  end
  return cpt
end

function gh.floorTo(number,digits)
  local digits=digits or 0
  local factor=10^digits

  return math.floor(number*factor)/factor
end

function gh.randomInRange(range)
    return range[1]+(range[2]-range[1])*math.random()
end

function gh.randomize(number,factor)
    return number*(1-factor)+number*factor*2*math.random()
end

function gh.tprint (tbl, indent)
  if not indent then indent = 0 end
  for k, v in pairs(tbl) do
    formatting = string.rep("  ", indent) .. k .. ": "
    if type(v) == "table" then
      print(formatting)
      gh.tprint(v, indent+1)
    else
      print(formatting .. tostring(v))
    end
  end
end

function gh.tprintError (tbl, indent)
  local rep
  if not indent then indent = 0 end
  for k, v in pairs(tbl) do
    formatting = string.rep("  ", indent) .. k .. ": "
    if type(v) == "table" then
      rep=rep..formatting.."\n"
      rep=rep..gh.tprintError(v, indent+1)
    else
      rep=rep..formatting .. tostring(v).."\n"
    end
  end
  return rep
end

function gh.pickConditionalWeightedObject(table,obj)

  local totalWeight=0

  for k,v in pairs(table) do
    if (v.weightValidity) then--filter method, only if valid
      if (v.weightValidity(obj)) then
        totalWeight=totalWeight+v.weight
      end
    elseif (v.weightValiditySelf) then--filter method, only if valid
      if (v:weightValiditySelf(obj)) then
        totalWeight=totalWeight+v.weight
      end
    else
      totalWeight=totalWeight+v.weight
    end
  end

  if (totalWeight==0) then
    return nil
  end

  local targetWeight=math.random(totalWeight)

  local weightPassed=0

  for k,v in pairs(table) do

    if (v.weightValidity) then--filter method, only if valid
      if (v.weightValidity(obj)) then
        weightPassed=weightPassed+v.weight
      end
    elseif (v.weightValiditySelf) then--filter method, only if valid
      if (v:weightValiditySelf(obj)) then
        weightPassed=weightPassed+v.weight
      end
    else
      weightPassed=weightPassed+v.weight
    end

    if (targetWeight<=weightPassed) then
      return v
    end
  end

  return nil

end

function gh.filterConditionalObjects(table,obj)

  local valid={}

  for k,v in pairs(table) do

    if (v.weightValidity) then--filter method, only if valid
      if (v.weightValidity(obj)) then
        valid[#valid+1]=v
      end
    elseif (v.weightValiditySelf) then--filter method, only if valid
      if (v:weightValiditySelf(obj)) then
        valid[#valid+1]=v
      end
    else
      valid[#valid+1]=v
    end
  end

  return valid
end


function gh.pickWeightedObject(table)

  local totalWeight=0

  for k,v in pairs(table) do 
    if (type(v)~="table") then
      print("failed table:",k)
      print(v)
      return nil
    end
    if (v.weight==nil) then
      print("failed key:",k)
      I.tprint(table)
      return nil
    end

    totalWeight=totalWeight+v.weight
  end


  local targetWeight=math.random(totalWeight)

  local weightPassed=0

  for k,v in pairs(table) do 
    weightPassed=weightPassed+v.weight
    if (targetWeight<=weightPassed) then
      return v
    end
  end

  return nil
end

function gh.randomObject(table)
  local id=math.random(#table)

  return table[id]
end

function gh.calculateDistance(coord1,coord2)
  return math.sqrt((coord1.x-coord2.x)^2 + (coord1.y-coord2.y)^2)
end

function gh.calculateDistanceSquare(coord1,coord2)
  return (coord1.x-coord2.x)^2 + (coord1.y-coord2.y)^2
end

function gh.prettyLargeNumber(number)
  if (number<100000) then
    return gh.floorTo(number,-3)
  elseif (number<1000000) then
    return gh.floorTo(number,-4)
  elseif (number<100000000) then
    return gh.floorTo(number/1000000).." millions"
  elseif (number<1000000000) then
    return gh.floorTo(number/1000000,1).." millions"
  elseif (number<100000000000) then
    return gh.floorTo(number/1000000000).." billions"
  else
    return gh.floorTo(number/1000000000,1).." billions"
  end
end

function gh.populationScore(population)
  return (math.log10(population)/10)
end

function gh.concatLists(lists)
    local res={}
    for k,list in pairs(lists) do
      for i=1,#list do
          res[#res+1] = list[i]
      end
    end
    return res
end

function gh.isPlanetCivilized(luaData)
  return (gh.countMembers(luaData.settlements)>0)
end

function gh.format(s, tab)
  return (s:gsub('($%b{})', function(w) return tab[w:sub(3, -2)] or w end)):gsub("\t", "")
end

function gh.formatAll(sarray, tab)
  local res={}
  for k,s in ipairs(sarray) do
    res[k]=gh.format(s, tab)
  end
  return res
end

function gh.randomPosAround(pos,minDistance,maxDistance)
  local x,y = pos:get()
  local d = rnd.rnd( minDistance, maxDistance )
  local a = math.atan2( y, x ) + math.pi
  local offset = vec2.new()
  offset:setP( d, a )
  pos = pos + offset

  return pos
end

function gh.numstring(number)
    number = math.floor(number + 0.5)
    local numberstring = ""
    while number >= 1000 do
        numberstring = string.format( ",%03d%s", number % 1000, numberstring )
        number = math.floor(number / 1000)
    end
    numberstring = number % 1000 .. numberstring
    return numberstring
end
