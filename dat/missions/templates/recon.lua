--[[

   Template for space recon missions

   --]]

   include "numstring.lua"
   include "universe/generate_helper.lua"
   include "jumpdist.lua"

-- Whether mission starts in bar (if false, it starts in computer)
mission_bar=true
-- Whether mission ends in bar (if not, it ends in space in start system)
mission_return_to_bar=true


-- Mission details
misn_title  = ""
misn_reward = "${credits} credits"
misn_desc   = ""

-- Text if mission from bar
bar_desc = ""
bar_accept_title = "Spaceport Bar"
bar_accept_text  = [[]]
bar_accept_text_extra = nil

-- Text if mission ends on starting bar
bar_success_title = "Spaceport Bar"
bar_success_text = [[]]

-- Text if mission ends in space in starting system.
space_success_text = ""

-- Messages
msg      = {}
msg[1]   = "System %s investigated."
msg[2]   = "All systems investigated. Return to ${startPlanet}."
osd_msg = {}
osd_msg[1] = "Investigate the targeted systems."
osd_msg[2] = "Return to ${startPlanet}."
osd_msg["__save"] = true



function template_getStringData()
  local stringData={}
  stringData.playerName=player:name()
  stringData.startPlanet=start_planet and start_planet:name() or ""
  stringData.startSystem=start_planet and start_planet:system():name() or ""
  stringData.credits=credits
  stringData.mainTargetPlanet=main_target_planet and main_target_planet:name() or ""
  stringData.mainTargetSystem=main_target_system and main_target_system:name() or ""

  for k,v in ipairs(target_systems) do
    stringData['targetSystem'..k]=v:name()
  end

  return stringData
end

function template_create ()
 start_planet=planet.cur()

 local stringData=template_getStringData()

  if (computer_title) then
    misn.setTitle(gh.format(computer_title,stringData))
  else
    misn.setTitle(gh.format(misn_title,stringData))
  end

  misn.setReward(gh.format(misn_reward,stringData))
  if (not mission_bar) then--computer
    misn.setDesc(gh.format(misn_desc,stringData))
    target_systems_markers={}
    for k,v in pairs(target_systems) do
      target_systems_markers[k]=misn.markerAdd( v, "computer" )
    end
  else
    misn.setDesc(gh.format(bar_desc,stringData))
  end

end

--[[
Mission entry point.
--]]
function template_accept ()
   -- Mission details:

   local stringData=template_getStringData()

   if (mission_bar) then
     if not tk.yesno( gh.format( bar_accept_title,stringData),gh.format( bar_accept_text,stringData)) then
      misn.finish()
    end

    if (bar_accept_text_extra) then
      tk.msg(gh.format( bar_accept_title,stringData),gh.format( bar_accept_text_extra,stringData))
    end

    target_systems_markers={}
    for k,v in pairs(target_systems) do
      target_systems_markers[k]=misn.markerAdd( v, "low" )
    end
  end

  misn.setDesc(gh.format(misn_desc,stringData))
  misn.setTitle(gh.format(misn_title,stringData))

  misn.accept()

  target_systems_visited={}

   -- Format and set osd message
   osd_msg[1] = gh.format(osd_msg[1],stringData)
   osd_msg[2] = gh.format(osd_msg[2],stringData)
   misn.osdCreate(gh.format(misn_title,stringData), osd_msg)

   -- Set hooks
   hook_sys_enter=hook.enter("sys_enter")
 end

-- Player won, gives rewards.
function template_give_rewards()
   -- Give monies
   player.pay(credits)

   -- Finish mission
   misn.finish(true)
 end


-- Entering a system
function sys_enter()
 cur_sys = system.cur()
   -- Check to see if reaching target system
   local systems_left=false
   
   for k,v in pairs(target_systems) do
    if (v==cur_sys and not target_systems_visited[k]) then
     target_systems_visited[k]=true
     misn.markerRm(target_systems_markers[k])
     player.msg( string.format(msg[1],v:name()) )
   end
   if not target_systems_visited[k] then
     systems_left=true
   end
 end

 if not systems_left then
  player.msg( gh.format(msg[2],template_getStringData()) )
  misn.osdActive(2)
  hook.rm(hook_sys_enter)
  misn.markerAdd( start_planet:system(), "low" )
  if (mission_return_to_bar) then        
    hook.land("land_reward","bar")
  else
    hook.enter("sys_enter_reward")
  end
end
end

function sys_enter_reward()
  if (start_planet:system()==system.cur()) then
    local stringData=template_getStringData()
    player.msg(gh.format(space_success_text,template_getStringData()) )
    give_rewards()
  end
end

function land_reward()
 if (start_planet==planet.cur()) then
  local stringData=template_getStringData()
  tk.msg(gh.format(bar_success_title,stringData),gh.format(bar_success_text,stringData))
  give_rewards()
end
end
