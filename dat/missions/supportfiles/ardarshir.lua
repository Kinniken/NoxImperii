

function get_ardarshir_system( sys,sysTaken )
   local planets = {}
    getsysatdistance(system.cur(), 3, 8,
        function(s)
            local taken=false
            if sysTaken then               
               for _,k in pairs(sysTaken) do
                  if k==s then
                     taken=true
                  end
               end
            end
            if (taken) then
              return true
            end
            for i, v in ipairs(s:planets()) do
                if v:faction() == faction.get(G.ROIDHUNATE) and
                        v:canLand() then
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