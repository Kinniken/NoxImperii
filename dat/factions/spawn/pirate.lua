include("dat/factions/spawn/common.lua")

fleet_table[#fleet_table+1] = new_fleet("Pirate Shark",10,{presence={nil,nil,50,nil}})
fleet_table[#fleet_table+1] = new_fleet("Pirate Admonisher",5,{presence={nil,nil,50,nil}})

fleet_table[#fleet_table+1] = new_fleet("Pirate Delta",5)
fleet_table[#fleet_table+1] = new_fleet("Pirate Vendetta",5)
fleet_table[#fleet_table+1] = new_fleet("Pirate Rhino",5)
fleet_table[#fleet_table+1] = new_fleet("Pirate Kestrel",5)

fleet_table[#fleet_table+1] = new_fleet(function() return spawn_variableFleet({"Pirate Shark",2,5}) end,10,{presence={10,20,nil,nil}})
fleet_table[#fleet_table+1] = new_fleet(function() return spawn_variableFleet({"Pirate Admonisher",1,2},{"Pirate Shark",0,2}) end,10,{presence={10,20,nil,nil}})
fleet_table[#fleet_table+1] = new_fleet(function() return spawn_variableFleet({"Pirate Delta",1,1},{"Pirate Shark",1,3}) end,10,{presence={20,40,nil,nil}})
fleet_table[#fleet_table+1] = new_fleet(function() return spawn_variableFleet({"Pirate Rhino",2,4}) end,10,{presence={20,40,nil,nil}})

fleet_table[#fleet_table+1] = new_fleet(function() return spawn_variableFleet({"Pirate Kestrel",1,1},{"Pirate Admonisher",0,2},{"Pirate Shark",1,3}) end,10,{presence={50,100,nil,nil}})

fleet_table[#fleet_table+1] = new_fleet(function() return spawn_variableFleet({"Pirate Kestrel",2,3},{"Pirate Admonisher",2,4},{"Pirate Shark",2,4}) end,5,{presence={100,200,nil,nil}})
