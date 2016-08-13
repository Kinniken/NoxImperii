
-- Gets a barbarian planet
function get_barbarian_planet( sys )
   local planets = {}
    getsysatdistance(sys, 2,7,
        function(s)
            for i, v in ipairs(s:planets()) do
                if v:faction() == faction.get(G.BARBARIANS) then
                    planets[#planets + 1] = {v, s}
                end
           end
           return true
        end)

    if (#planets==0) then
      return nil,nil
    end

    local id=math.random(#planets)

    return planets[id][1],planets[id][2]
end

--[[
Functions to create pirates based on difficulty more easily.
--]]
function barbarian_lord_generate ()
   local titles={"Lord","Warlord","Chief"}

   -- Get the pirate name
   barbarian_name = titles[math.random(#titles)].." "..nameGenerator.generateNameOther()

   -- Get the pirate details
   rating = player.getRating()
   if rating < 50 then
      barbarian_ship, barbarian_outfits = barbarian_easy()
   elseif rating < 150 then
      barbarian_ship, barbarian_outfits = barbarian_medium()
   else
      barbarian_ship, barbarian_outfits = barbarian_hard()
   end

   -- Make sure to save the outfits.
   barbarian_outfits["__save"] = true

   return barbarian_name, barbarian_ship, barbarian_outfits,"baddie",G.BARBARIANS
end
function barbarian_easy ()
   return barbarian_createComet()
end
function barbarian_medium ()
   return barbarian_createContinent()
end
function barbarian_hard ()
    return barbarian_createContinent()
end


-- Gets a system with barbarian influence
function get_adjacent_barbarian_system( sys, sysTaken )
   local systems=getsysatdistance(sys, 1, 1,
        function(s)
            if not s:presences()[G.BARBARIANS] then
               return false
            end
            local taken=false
            if sysTaken then               
               for _,k in pairs(sysTaken) do
                  if k==s then
                     taken=true
                  end
               end
            end
           return not taken
        end)

   -- Make sure system has pirates
   if #systems == nil then
      return sys
   else
      return systems[ rnd.rnd(1,#systems) ]
   end
end
