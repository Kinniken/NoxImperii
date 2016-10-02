--[[

   Template for missions in which the player must kill a ship

--]]

include "dat/scripts/general_helper.lua"
include "jumpdist.lua"
include "dat/missions/supportfiles/common.lua"

-- Whether mission starts in bar (if false, it starts in computer)
mission_bar=true
--Whether it starts when landing
mission_land=false
-- Whether mission ends in bar (if not, it ends in space in start system)
mission_return_to_bar=true
-- Whether mission ends when landing (if not, it ends in space in start system)
mission_return_to_planet=false

-- Whether the player has to be the main killer
allied_kills_count = false

-- Mission details
misn_title  = ""
misn_reward = "${credits} cr"
misn_desc   = ""

-- Text if mission from bar
bar_desc = ""
bar_accept_title = nil
bar_accept_text  = nil
bar_accept_title_extra = nil
bar_accept_text_extra = nil

-- Text if mission ends on starting bar
bar_success_title = "Spaceport Bar"
bar_success_text = [[]]

-- Text if mission ends in space in starting system.
space_success_title = ""
space_success_text = ""

-- Messages
msg      = {}
msg[1]   = "MISSION SUCCESS! Go back to ${endPlanet}."
msg[2]   = "Pursue ${targetShipName} to ${targetSystem}!"
msg[3]   = "MISSION FAILURE! Somebody else eliminated ${targetShipName}."
msg["__save"] = true

osd_msg = {}
osd_msg[1] = "Fly to the ${targetSystem} system"
osd_msg[2] = "Kill ${targetShipName}"
osd_msg[3] = "Return to ${endPlanet}"
osd_msg["__save"] = true


hunters = {}
hunter_hits = {}


function template_getStringData()
  local stringData={}
  stringData.playerName=player:name()
  stringData.shipName=player:ship()
  stringData.startPlanet=start_planet and start_planet:name() or ""
  stringData.startSystem=start_planet and start_planet:system():name() or ""
  stringData.credits=gh.numstring(credits)
  stringData.targetSystem=target_system and target_system:name() or ""
  stringData.targetPlanet=target_planet and target_planet:name() or ""
  stringData.endSystem=end_planet and end_planet:system():name() or ""
  stringData.endPlanet=end_planet and end_planet:name() or ""
  stringData.targetShipName=target_ship_name
  stringData.targetShipType=target_ship
  stringData.empireRank=emp_getRank()
  stringData.ardarRank=ardar_getRank()
  
  return stringData
end

function template_create ()
   if not start_planet then
    start_planet=planet.cur()--default
  end

   if not end_planet then
     end_planet=start_planet--default
   end

   -- Handle edge cases where no suitable neighbours exist.
   if not target_system then
      misn.finish(false)
      player.msg("no valid system")
   end

      

  local stringData=template_getStringData()
   
  if (computer_title) then
    misn.setTitle(gh.format(computer_title,stringData))
  else
    misn.setTitle(gh.format(misn_title,stringData))
  end

  misn.setReward(gh.format(misn_reward,stringData))

  if (mission_land) then

    if not tk.yesno( gh.format( start_title,stringData),gh.format( start_text,stringData)) then
        misn.finish()
     end

    template_accept ()


  elseif (mission_bar) then
    misn.setDesc(gh.format(bar_desc,stringData))
  else
    target_system_marker=misn.markerAdd( target_system, "computer" )
    misn.setDesc(gh.format(misn_desc,stringData))
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
        if not bar_accept_title_extra then
          bar_accept_title_extra=bar_accept_title
        end
        tk.msg(gh.format( bar_accept_title_extra,stringData),gh.format( bar_accept_text_extra,stringData))
     end
   end

   if (mission_bar or mission_land) then
    target_system_marker=misn.markerAdd( target_system, "high" )
  end

   misn.setDesc(gh.format(misn_desc,stringData))
   misn.setTitle(gh.format(misn_title,stringData))

   misn.accept()

   if (accept_title) then
    tk.msg(gh.format( accept_title,stringData),gh.format( accept_text,stringData))
   end

   -- Format and set osd message
   local osd_msg_formatted={}
   osd_msg_formatted[1] = gh.format(osd_msg[1],stringData)
   osd_msg_formatted[2] = gh.format(osd_msg[2],stringData)
   osd_msg_formatted[3] = gh.format(osd_msg[3],stringData)
   misn.osdCreate(gh.format(misn_title,stringData), osd_msg_formatted)

   -- Set hooks
   hook_sys_enter=hook.enter("sys_enter")
   last_sys = system.cur()
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
   if cur_sys == target_system then

      if not target_ship_pos then
        -- Choose position
        local pos = player.pilot():pos()

        local x,y = pos:get()
        local d = rnd.rnd( 1500, 2500 )
        local a = math.atan2( y, x ) + math.pi
        local offset = vec2.new()
        offset:setP( d, a )
        pos = pos + offset
      else

        local x,y = target_ship_pos:get()
        local d = rnd.rnd( 50, 100 )
        local a = math.atan2( y, x ) + math.pi
        local offset = vec2.new()
        offset:setP( d, a )
        pos = target_ship_pos + offset
      end

      -- Create the badass enemy
      p     = pilot.addRaw( target_ship, target_ship_ai, pos, target_ship_faction )

      local target_ship_pilot   = p[1]
      target_ship_pilot:rename(target_ship_name)
      target_ship_pilot:setHostile()
      target_ship_pilot:setVisplayer(true)
      target_ship_pilot:setHilight(true)
      target_ship_pilot:rmOutfit("all") -- Start naked
      pilot_outfitAddSet( target_ship_pilot, target_ship_outfits )
      hook.pilot( target_ship_pilot, "death", "ship_dead" )
      hook.pilot( target_ship_pilot, "jump", "ship_jump" )
      hook.pilot( target_ship_pilot, "attacked", "pilot_attacked" )
      hook.pilot( target_ship_pilot, "disable", "pilot_disable" )
      misn.osdActive(2)

      if get_escorts~=nil then
        local escorts=get_escorts()

        for k,v in ipairs( escorts ) do
          pos = target_ship_pilot:pos()
          local x,y = pos:get()
          local d = rnd.rnd( 150, 250 )
          local a = math.atan2( y, x ) + math.pi
          local offset = vec2.new()
          offset:setP( d, a )
          pos = pos + offset

          -- Create the badass enemy
          local escort_pilot     = pilot.addRaw( v.ship, v.ship_ai, pos, v.ship_faction )

          local escort_ship   = escort_pilot[1]
          escort_ship:rename(v.ship_name)
          escort_ship:setHostile()
          escort_ship:setVisplayer(true)
          escort_ship:rmOutfit("all") -- Start naked
          pilot_outfitAddSet( escort_ship, v.ship_outfits )

        end
      end

      if get_allies~=nil then
        local allies=get_allies()

        for k,v in ipairs( allies ) do
          pos = player.pilot():pos()
          local x,y = pos:get()
          local d = rnd.rnd( 50, 80 )
          local a = math.atan2( y, x ) + math.pi
          local offset = vec2.new()
          offset:setP( d, a )
          pos = pos + offset

          local escort_pilot     = pilot.addRaw( v.ship, v.ship_ai, pos, v.ship_faction )

          local escort_ship   = escort_pilot[1]
          escort_ship:rename(v.ship_name)
          escort_ship:setVisplayer(true)
          escort_ship:rmOutfit("all") -- Start naked
          pilot_outfitAddSet( escort_ship, v.ship_outfits )

        end
      end
   else
      misn.osdActive(1)
   end
   
end

function pilot_attacked( p, attacker, dmg )
   if attacker ~= nil then
      local found = false

      for i, j in ipairs( hunters ) do
         if j == attacker then
            hunter_hits[i] = hunter_hits[i] + dmg
            found = true
         end
      end

      if not found then
         local i = #hunters + 1
         hunters[i] = attacker
         hunter_hits[i] = dmg
      end
   end
end

-- Ship is dead
function ship_dead( pilot, attacker )
   if attacker == player.pilot() or allied_kills_count then
      -- it was the player who killed the ship
      ship_dead_success()
   else

    local top_hunter = nil
    local top_hits = 0
    local player_hits = 0
    local total_hits = 0
    for i, j in ipairs( hunters ) do
       total_hits = total_hits + hunter_hits[i]
       if j ~= nil then
          if j == player.pilot() then
             player_hits = player_hits + hunter_hits[i]
          elseif j:exists() and hunter_hits[i] > top_hits then
             top_hunter = j
             top_hits = hunter_hits[i]
          end
       end
    end

    if top_hunter == nil or player_hits >= top_hits/2 then
       ship_dead_success()
    else
      local stringData=template_getStringData()

       -- it was someone else
      player.msg( gh.format( msg[3], stringData ) )
      misn.finish(false)
    end
   end
end

function ship_dead_success()
   local stringData=template_getStringData()

  if (success_title) then
    tk.msg(gh.format( success_title,stringData),gh.format( success_text,stringData))
  else
    player.msg( gh.format(msg[1],stringData) )
  end

  misn.osdActive(3)
  hook.rm(hook_sys_enter)
  misn.markerMove(target_system_marker,end_planet:system())
  if (mission_return_to_bar) then        
    hook.land("land_reward","bar")
  elseif (mission_return_to_planet) then        
    hook.land("land_reward")
  else
    hook.enter("sys_enter_reward")
  end

  if (cargo_name) then
    carg_id = misn.cargoAdd( cargo_name, cargo_quantity )
  end
end

-- Ship jumped away
function ship_jump (pilot, jump_point)  

   target_system = jump_point:dest()

   local stringData=template_getStringData()
   player.msg( gh.format(msg[2], stringData) )

   misn.markerMove(target_system_marker,target_system)
   misn.setDesc(gh.format(misn_desc,stringData))
   misn.setTitle(gh.format(misn_title,stringData))

   local osd_msg_formatted={}
   osd_msg_formatted[1] = gh.format(osd_msg[1],stringData)
   osd_msg_formatted[2] = gh.format(osd_msg[2],stringData)
   osd_msg_formatted[3] = gh.format(osd_msg[3],stringData)
   misn.osdDestroy()
   misn.osdCreate(gh.format(misn_title,stringData), osd_msg_formatted)
end

function sys_enter_reward()
  hook.timer(3000, "sys_enter_finish")
end

function sys_enter_finish()
  if (end_planet:system()==system.cur()) then
    local stringData=template_getStringData()
      tk.msg(gh.format(space_success_title,template_getStringData()),gh.format(space_success_text,template_getStringData()) )
      give_rewards()
      if (carg_id) then
        misn.cargoJet(carg_id)
      end
  end
end

function land_reward()
   if (end_planet==planet.cur()) then
      local stringData=template_getStringData()
      tk.msg(gh.format(bar_success_title,stringData),gh.format(bar_success_text,stringData))
      give_rewards()
      if (carg_id) then
        misn.cargoJet(carg_id)
      end
   end
end


function pilot_disable ()
   if rnd.rnd() < 0.7 then
      for i, j in ipairs( pilot.get() ) do
         j:taskClear()
      end
   end
end
