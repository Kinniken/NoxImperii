--[[
package.path = package.path .. ';./scripts/?.lua;../?.lua'

function include(file)
	local path=file:match("(.*).lua")
	require(path)
end

vars={["harkan_empire_choice"]=false,["harkan_roidhunate_choice"]=false,["intro_2_planet"]="World1",["intro_3_planet"]="World2"}

var={}
var.peek=function(v) return vars[v] end

nbOutfits={["Reserve Ensign"]=1,["Ardarshir Auxiliary, Class III"]=1}
player={}
player.numOutfit=function(outfit)
player.misnAllDone=function() return {"Intro 3","Empire 5 sfsg","Ardar 5 sfsg"} end
player.misnAllActive=function() return {} end

if not nbOutfits[outfit] then return 0
else return nbOutfits[outfit] end end
]]

include('dat/scripts/general_helper.lua')
include('universe/live/live_desc.lua')
include('universe/live/live_info.lua')

function updateMissionsDesc()
  
  local missionsDone = player.misnAllDone()
  local missionsIP = player.misnAllActive()
  
  local doneIndex={}
  local ipIndex={}
  local sections={"Empire","Ardar","Intro","Harkan","Harkan Empire","Harkan Roidhunate"}
  
  for _,sectionName in ipairs(sections) do
    doneIndex[sectionName]=0
    ipIndex[sectionName]=0
  end
  
  for _,missionName in ipairs(missionsDone) do
    for _,sectionName in ipairs(sections) do
      local id=missionName:match(sectionName.." (%d+)")
      
      if id ~= nil then
        id=tonumber(id)
        if id>doneIndex[sectionName] then
          doneIndex[sectionName]=id
        end
      end
    end
  end
  for _,missionName in ipairs(missionsIP) do
    for _,sectionName in ipairs(sections) do
      local id=missionName:match(sectionName.." (%d+)")
      
      if id ~= nil then
        id=tonumber(id)
        if id>ipIndex[sectionName] then
          ipIndex[sectionName]=id
        end
      end
    end
  end
  
	local desc="Main Storyline:\n\n"
  
  if (var.peek("harkan_empire_choice")) then    
    if doneIndex["Harkan Empire"]==8 then
      desc=desc.."You have finished the Harkan chapter of the main storyline by siding with the Empire. No other storyline missions are currently available in Nox Imperii; check for further updates!"
    else
      desc=desc.."You are currently doing the Harkan chapter of the main storyline, on the side of the Empire."
      if ipIndex["Harkan Empire"]==0 then
        --6, 7 or 8
        desc=desc.." The next mission is availabe on Harkan."
      else
        desc=desc.." A mission is in progress."
      end
    end
  elseif (var.peek("harkan_roidhunate_choice")) then
    if doneIndex["Harkan Roidhunate"]==7 then
      desc=desc.."You have finished the Harkan chapter of the main storyline by siding with the Roidhunate. No other storyline missions are currently available in Nox Imperii; check for further updates!"
    else
      desc=desc.."You are currently doing the Harkan chapter of the main storyline, on the side of the Roidhunate."
      if ipIndex["Harkan Roidhunate"]==0 then
        --6 & 7
        desc=desc.." The next mission will start automatically while in any Ardar system."
      else
        desc=desc.." A mission is in progress."
      end
    end
  elseif (doneIndex["Harkan"]>0 or ipIndex["Harkan"]>0) then
    desc=desc.."You are currently doing the Harkan chapter of the main storyline."
    if ipIndex["Harkan"]==0 then
      if doneIndex["Harkan"]==1 or doneIndex["Harkan"]==3 then
        desc=desc.." The next mission is availabe on Harkan."
      elseif doneIndex["Harkan"]==2 or doneIndex["Harkan"]==4 then
        desc=desc.." The next mission will start automatically while in any Imperial system."
      end
    else
      desc=desc.." A mission is in progress."
    end
  elseif doneIndex["Intro"]==3 then
    desc=desc.."You have finished the introduction. The next chapter will start automatically while in any Imperial system."
  else
    desc=desc.."You are currently doing the introduction of the main storyline."
    if ipIndex["Intro"]==0 then
      if doneIndex["Intro"]==0 then
        desc=desc.." The next mission will start automatically while in any Imperial system."
      elseif doneIndex["Intro"]==1 then
        desc=desc.." The next mission is availabe on "..var.peek("intro_2_planet").."."
      elseif doneIndex["Intro"]==2 then
        desc=desc.." The next mission is availabe on "..var.peek("intro_3_planet").."."
      end
    else
      desc=desc.." A mission is in progress."
    end
  end
  
  --recurring
  desc=desc.."\n\nEmpire rank: "..emp_getRank()..""
  
  if doneIndex["Empire"]<ipIndex["Empire"] then
    desc=desc.."\n\nYou are currently doing a mission that will raise your rank."
  elseif doneIndex["Empire"]==0 or doneIndex["Empire"]==2 or doneIndex["Empire"]==3 or doneIndex["Empire"]==4 then
    desc=desc.."\n\nThe next mission is available from an officer in bars on Imperial planets bordering barbarian space. Try multiple planets if you cannot find it at first!"
  elseif doneIndex["Empire"]==1 then
    desc=desc.."\n\nThe next mission is available from an officer in bars on Imperial planets bordering Ardar space. Try multiple planets if you cannot find it at first!"
  else
    desc=desc.."\n\nYou have done all the Imperial missions and have reached the highest rank."
  end
  
  desc=desc.."\n\nRoidhunate rank: "..ardar_getRank()..""
  
  if doneIndex["Ardar"]<ipIndex["Ardar"] then
    desc=desc.."\n\nYou are currently doing a mission that will raise your rank."
  elseif doneIndex["Ardar"]==0 then
    desc=desc.."\n\nThe next mission is available from an officer in bars on Ardar planets bordering Imperial space. Try multiple planets if you cannot find it at first!"
  elseif doneIndex["Ardar"]==1 or doneIndex["Ardar"]==3 then
    desc=desc.."\n\nThe next mission is available on Ardar planets bordering barbarian space. Try multiple planets if you cannot find it at first!"
  elseif doneIndex["Ardar"]==2 or doneIndex["Ardar"]==4 then
    desc=desc.."\n\nThe next mission is available on Ardar planets bordering Imperial space. Try multiple planets if you cannot find it at first!"
  else
    desc=desc.."\n\nYou have done all the Roidhunate missions and have reached the highest rank."
  end
  
  desc=desc.."\n\nBetelgeuse rank: "..betelgeuse_getRank()..""
  desc=desc.."\n\nThere are currently no missions for Betelgeuse. Ranks can be purchased instead."
  
  desc=desc.."\n\nKingdom of Ixum rank: "..royalixum_getRank()..""
  desc=desc.."\n\nThere are currently no missions for the Kingdom of Ixum. Ranks can be purchased instead."
  
  desc=desc.."\n\nHoly Flame rank: "..holyflame_getRank()..""
  desc=desc.."\n\nThere are currently no missions for the Holy Flame. Ranks can be purchased instead."
  
  var.push("missions_status",desc)
  
end

function emp_getRank()
   if player.numOutfit( "Reserve Admiral" )>0 then
      return "Admiral"
    elseif player.numOutfit( "Reserve Colonel" )>0 then
      return "Colonel"
   elseif player.numOutfit( "Reserve Major" )>0 then
      return "Major"
   elseif player.numOutfit( "Reserve Lieutenant" )>0 then
      return "Lieutenant"
   elseif player.numOutfit( "Reserve Ensign" )>0 then
      return "Ensign"
  else
    return "None"
  end
end


function ardar_getRank()
if player.numOutfit( "Ardarshir Ally" )>0 then
      return "Ally"
    elseif player.numOutfit( "Ardarshir Auxiliary, Honourable" )>0 then
      return "Honourable Auxiliary"
   elseif player.numOutfit( "Ardarshir Auxiliary, Class III" )>0 then
      return "Auxiliary Class III"
   elseif player.numOutfit( "Ardarshir Auxiliary, Class II" )>0 then
      return "Auxiliary Class II"
   elseif player.numOutfit( "Ardarshir Auxiliary, Class I" )>0 then
      return "Auxiliary Class I"
  else
    return "None"
  end
end

function betelgeuse_getRank()
if player.numOutfit( "Betelgian Merchant Prince" )>0 then
      return "Merchant Prince"
    elseif player.numOutfit( "Betelgian Explorer" )>0 then
      return "Explorer"
   elseif player.numOutfit( "Betelgian Merchant" )>0 then
      return "Merchant"
   elseif player.numOutfit( "Betelgian Trader" )>0 then
      return "Trader"
   elseif player.numOutfit( "Betelgian Courier" )>0 then
      return "Courier"
  else
    return "None"
  end
end

function betelgeuse_getRank()
if player.numOutfit( "Betelgian Merchant Prince" )>0 then
      return "Merchant Prince"
    elseif player.numOutfit( "Betelgian Explorer" )>0 then
      return "Explorer"
   elseif player.numOutfit( "Betelgian Merchant" )>0 then
      return "Merchant"
   elseif player.numOutfit( "Betelgian Trader" )>0 then
      return "Trader"
   elseif player.numOutfit( "Betelgian Courier" )>0 then
      return "Courier"
  else
    return "None"
  end
end

function royalixum_getRank()
if player.numOutfit( "Ixumite Earl" )>0 then
      return "Earl"
    elseif player.numOutfit( "Ixumite Baron" )>0 then
      return "Baron"
   elseif player.numOutfit( "Ixumite Knight" )>0 then
      return "Knight"
   elseif player.numOutfit( "Ixumite Honorary Lancer" )>0 then
      return "Lancer"
   elseif player.numOutfit( "Ixumite Honorary Hunter" )>0 then
      return "Hunter"
  else
    return "None"
  end
end

function holyflame_getRank()
if player.numOutfit( "Holy Flame Champion" )>0 then
      return "Champion"
    elseif player.numOutfit( "Holy Flame Warrior" )>0 then
      return "Warrior"
   elseif player.numOutfit( "Holy Flame Brother" )>0 then
      return "Brother"
   elseif player.numOutfit( "Holy Flame Initiate" )>0 then
      return "Initiate"
   elseif player.numOutfit( "Holy Flame Servant" )>0 then
      return "Servant"
  else
    return "None"
  end
end

--print(updateMissionsDesc())