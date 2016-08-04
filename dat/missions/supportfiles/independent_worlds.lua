function get_independent_planet( sys )
   local planets = {}
    getsysatdistance(sys, 2,7,
        function(s)
            for i, v in ipairs(s:planets()) do
                if v:faction() == faction.get(G.INDEPENDENT_WORLDS) then
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