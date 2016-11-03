include("dat/factions/spawn/common.lua")

-- courrier
fleet_table[#fleet_table+1] = new_fleet("Betelgian Traders Pelegrina",10)
-- light trade
fleet_table[#fleet_table+1] = new_fleet("Betelgian Traders Carvela",10)
-- bulk trade
fleet_table[#fleet_table+1] = new_fleet("Betelgian Traders Veniera",10,{presence={nil,50,200,nil},enemies={nil,nil,10,20}})
-- explorer
fleet_table[#fleet_table+1] = new_fleet("Betelgian Traders Impresa",5,{enemies={nil,10,nil,nil}})


fleet_table[#fleet_table+1] = new_fleet(function() return spawn_variableFleet({"Betelgian Traders Carvela",2,4}) end,10,{presence={nil,50,nil,nil}})

fleet_table[#fleet_table+1] = new_fleet(function() return spawn_variableFleet({"Betelgian Traders Veniera",2,4}) end,10,{presence={nil,100,400,nil},enemies={nil,nil,10,20}})


fleet_table[#fleet_table+1] = new_fleet(function() return spawn_variableFleet({"Betelgian Traders Impresa",1,2},{"Betelgian Traders Carvela",1,2},{"Betelgian Traders Pelegrina",1,2}) end,10,{presence={nil,100,400,nil},enemies={nil,nil,10,20}})
fleet_table[#fleet_table+1] = new_fleet(function() return spawn_variableFleet({"Betelgian Traders Veniera",4,8}) end,5000,{presence={nil,200,800,nil},enemies={nil,nil,10,20}})


