--[[

   Template for missions in which the player must kill a ship

--]]

include "numstring.lua"
include "dat/scripts/general_helper.lua"
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
msg[1]   = "MISSION SUCCESS! Go back to ${endPlanet}."
msg[2]   = "Pursue %s!"
msg[3]   = "MISSION FAILURE! Somebody else eliminated ${targetShipName}."

osd_msg = {}
osd_msg[1] = "Fly to the ${targetSystem} system"
osd_msg[2] = "Kill ${targetShipName}"
osd_msg[3] = "Return to ${endPlanet}"
osd_msg["__save"] = true


function template_getStringData()
  local stringData={}
  stringData.playerName=player:name()
  stringData.startPlanet=start_planet and start_planet:name() or ""
  stringData.startSystem=start_planet and start_planet:system():name() or ""
  stringData.credits=credits
  stringData.targetSystem=target_system and target_system:name() or ""
  stringData.targetPlanet=target_planet and target_planet:name() or ""
  stringData.endSystem=end_planet and end_planet:system():name() or ""
  stringData.endPlanet=end_planet and end_planet:name() or ""
  stringData.targetShipName=target_ship_name
  stringData.targetShipType=target_ship

  return stringData
end

function template_create ()
   start_planet=planet.cur()
   end_planet=start_planet--default

   -- Handle edge cases where no suitable neighbours exist.
   if not target_system then
      misn.finish(false)
   end

  local stringData=template_getStringData()
   
  if (computer_title) then
    misn.setTitle(gh.format(computer_title,stringData))
  else
    misn.setTitle(gh.format(misn_title,stringData))
  end

  misn.setReward(gh.format(misn_reward,stringData))

   if (not mission_bar) then--computer
      target_system_marker=misn.markerAdd( target_system, "computer" )
      misn.setDesc(gh.format(misn_desc,stringData))
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

     target_system_marker=misn.markerAdd( target_system, "high" )
   end

   misn.setDesc(gh.format(misn_desc,stringData))
   misn.setTitle(gh.format(misn_title,stringData))

   misn.accept()

   -- Format and set osd message
   osd_msg[1] = gh.format(osd_msg[1],stringData)
   osd_msg[2] = gh.format(osd_msg[2],stringData)
   osd_msg[3] = gh.format(osd_msg[3],stringData)
   misn.osdCreate(gh.format(misn_title,stringData), osd_msg)

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

      -- Choose position
      local pos = player.pilot():pos()

      local x,y = pos:get()
      local d = rnd.rnd( 1500, 2500 )
      local a = math.atan2( y, x ) + math.pi
      local offset = vec2.new()
      offset:setP( d, a )
      pos = pos + offset

      -- Create the badass enemy
      p     = pilot.addRaw( target_ship, target_ship_ai, pos, target_ship_faction )

      ship   = p[1]
      ship:rename(target_ship_name)
      ship:setHostile()
      ship:setVisplayer(true)
      ship:setHilight(true)
      ship:rmOutfit("all") -- Start naked
      pilot_outfitAddSet( ship, target_ship_outfits )
      hook.pilot( ship, "death", "ship_dead" )
      hook.pilot( ship, "jump", "ship_jump" )
      misn.osdActive(2)
   else
      misn.osdActive(1)
   end
   
end

-- Ship is dead
function ship_dead( pilot, attacker )
    local stringData=template_getStringData()
   if attacker == player.pilot() or rnd.rnd() > 0.5 then
      -- it was the player who killed the ship

      player.msg( gh.format(msg[1],stringData) )
      misn.osdActive(3)
      hook.rm(hook_sys_enter)
      misn.markerMove(target_system_marker,start_planet:system())
      if (mission_return_to_bar) then        
        hook.land("land_reward","bar")
      else
        hook.enter("sys_enter_reward")
      end
   else
      -- it was someone else
      player.msg( gh.format( msg[3], stringData ) )
      misn.finish(false)
   end
end

-- Ship jumped away
function ship_jump ()
   player.msg( gh.format(msg[2], stringData) )

   -- Basically just swap the system
   target_system = get_suitable_system( target_system )
end

function sys_enter_reward()
  if (end_planet:system()==system.cur()) then
    local stringData=template_getStringData()
      player.msg(gh.format(space_success_text,template_getStringData()) )
      give_rewards()
  end
end

function land_reward()
   if (end_planet==planet.cur()) then
      local stringData=template_getStringData()
      tk.msg(gh.format(bar_success_title,stringData),gh.format(bar_success_text,stringData))
      give_rewards()
   end
end
