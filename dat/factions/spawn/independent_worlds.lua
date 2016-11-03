include("dat/factions/spawn/common.lua")

fleet_table[#fleet_table+1] = new_fleet("Independent Worlds Wasp",10,{presence={nil,nil,50,nil}})
fleet_table[#fleet_table+1] = new_fleet("Independent Worlds Shark",10,{presence={nil,nil,50,nil}})
fleet_table[#fleet_table+1] = new_fleet("Independent Worlds Admonisher",10,{presence={nil,nil,100,nil}})

fleet_table[#fleet_table+1] = new_fleet("Independent Worlds Voyager Frigate",10,{presence={nil,50,200,nil}})
fleet_table[#fleet_table+1] = new_fleet("Independent Worlds Delta",10,{presence={nil,50,200,nil}})
fleet_table[#fleet_table+1] = new_fleet("Independent Worlds Vendetta",10,{presence={nil,50,200,nil}})

fleet_table[#fleet_table+1] = new_fleet(function() return spawn_variableFleet({"Independent Worlds Wasp",2,4}) end,10,{presence={nil,50,nil,nil}})
fleet_table[#fleet_table+1] = new_fleet(function() return spawn_variableFleet({"Independent Worlds Shark",2,4}) end,10,{presence={nil,50,nil,nil}})
fleet_table[#fleet_table+1] = new_fleet(function() return spawn_variableFleet({"Independent Worlds Admonisher",2,4}) end,10,{presence={nil,50,nil,nil}})


fleet_table[#fleet_table+1] = new_fleet(function() return spawn_variableFleet({"Independent Worlds Raptor",1,1},{"Independent Worlds Vendetta",0,1},{"Independent Worlds Shark",1,2},{"Independent Worlds Admonisher",1,2}) end,10,{presence={50,100,400,nil}})
fleet_table[#fleet_table+1] = new_fleet(function() return spawn_variableFleet({"Independent Worlds Delta",1,1},{"Independent Worlds Shark",1,2},{"Independent Worlds Admonisher",1,2}) end,10,{presence={50,100,400,nil}})


fleet_table[#fleet_table+1] = new_fleet(function() return spawn_variableFleet({"Independent Worlds Raptor",2,3},{"Independent Worlds Vendetta",2,4},{"Independent Worlds Shark",2,4},{"Independent Worlds Admonisher",2,4}) end,10,{presence={100,200,nil,nil}})