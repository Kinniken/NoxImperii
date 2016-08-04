--[[
-- Common Empire Mission framework
--
-- This framework allows to keep consistency and abstracts around commonly used
--  empire mission functions.
--]]


--[[
-- @brief Gets a random official portrait name.
--
-- @return A random official portrait name.
--]]
function ardar_getOfficialRandomPortrait ()
   local portraits = {
      "ardar/military_m1",
      "ardar/military_m2",
      "ardar/military_m3"
   }

   return portraits[ rnd.rnd( 1, #portraits ) ]
end

