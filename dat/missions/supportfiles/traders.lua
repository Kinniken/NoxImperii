include "jumpdist.lua"
include "pilot/traders.lua"

function trader_createSmallArdarBorderTrader ()

   target_ship_name = ardarshir_trader_name()

   target_ship, target_ship_outfits =  trader_createMeryoch()

   -- Make sure to save the outfits.
   target_ship_outfits["__save"] = true

   return target_ship_name, target_ship, target_ship_outfits,"trader",G.ARDAR_TRADERS
end

function trader_createToughArdarBorderTrader ()

   target_ship_name = ardarshir_trader_name()

   target_ship, target_ship_outfits =  trader_createGeldoch()

   -- Make sure to save the outfits.
   target_ship_outfits["__save"] = true

   return target_ship_name, target_ship, target_ship_outfits,"trader",G.ARDAR_TRADERS
end