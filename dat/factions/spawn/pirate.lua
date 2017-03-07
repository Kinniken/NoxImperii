include("dat/factions/spawn/common.lua")

declare_fleet("Pirate Shark",10,{presence={nil,nil,50,nil}})
declare_fleet("Pirate Admonisher",5,{presence={nil,nil,50,nil}})

declare_fleet("Pirate Delta",5)
declare_fleet("Pirate Vendetta",5)
declare_fleet("Pirate Rhino",5)
declare_fleet("Pirate Kestrel",5)

declare_fleet(function() return spawn_variableFleet({"Pirate Shark",2,5}) end,10,{presence={20,50,nil,nil}})
declare_fleet(function() return spawn_variableFleet({"Pirate Admonisher",1,2},{"Pirate Shark",0,2}) end,10,{presence={20,50,nil,nil}})
declare_fleet(function() return spawn_variableFleet({"Pirate Delta",1,1},{"Pirate Shark",1,3}) end,10,{presence={40,80,nil,nil}})
declare_fleet(function() return spawn_variableFleet({"Pirate Rhino",2,4}) end,10,{presence={40,80,nil,nil}})

declare_fleet(function() return spawn_variableFleet({"Pirate Kestrel",1,1},{"Pirate Admonisher",0,2},{"Pirate Shark",1,3}) end,10,{presence={80,200,nil,nil}})

declare_fleet(function() return spawn_variableFleet({"Pirate Kestrel",2,3},{"Pirate Admonisher",2,4},{"Pirate Shark",2,4}) end,5,{presence={150,300,nil,nil}})
