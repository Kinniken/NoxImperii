include("dat/factions/spawn/common.lua")

fleet_table[#fleet_table+1] = new_fleet("Barbarian Raider",10,{presence={nil,nil,100,nil}})
fleet_table[#fleet_table+1] = new_fleet("Barbarian Vendetta",10,{presence={nil,nil,50,nil}})

fleet_table[#fleet_table+1] = new_fleet("Barbarian Looter",10,{presence={nil,20,100,nil}})
fleet_table[#fleet_table+1] = new_fleet("Barbarian Raptor",5,{presence={nil,20,100,nil}})
fleet_table[#fleet_table+1] = new_fleet(function() return spawn_variableFleet({"Barbarian Raider",2,4}) end,10,{presence={nil,20,100,nil}})


fleet_table[#fleet_table+1] = new_fleet(function() return spawn_variableFleet({"Barbarian Looter",1,1},{"Barbarian Raider",1,2}) end,10,{presence={20,50,200,nil}})
fleet_table[#fleet_table+1] = new_fleet(function() return spawn_variableFleet({"Barbarian Raptor",1,1},{"Barbarian Raider",1,2}) end,5,{presence={20,50,200,nil}})

fleet_table[#fleet_table+1] = new_fleet(function() return spawn_variableFleet({"Barbarian Slaver",1,1},{"Barbarian Looter",0,2},{"Barbarian Raider",2,4}) end,10,{presence={100,200,500,nil}})
fleet_table[#fleet_table+1] = new_fleet(function() return spawn_variableFleet({"Barbarian Slaver",1,2},{"Barbarian Looter",2,4},{"Barbarian Raider",4,8}) end,10,{presence={200,300,800,nil}})