include "jumpdist.lua"
include "pilot/traders.lua"

function trader_createSmallArdarBorderTrader ()

   target_ship_name = trader_name()

   if rnd.rnd() < 0.5 then
      target_ship, target_ship_outfits =  trader_createKoala()
   else
      target_ship, target_ship_outfits =  trader_createMule()
   end

   -- Make sure to save the outfits.
   target_ship_outfits["__save"] = true

   return target_ship_name, target_ship, target_ship_outfits,"trader","Ardar Trader"
end