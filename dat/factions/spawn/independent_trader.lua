include("dat/factions/spawn/common.lua")

declare_fleet("Independent Traders Endeavour",10,{presence={nil,nil,50,nil}})
declare_fleet("Independent Traders Scarab",10,{presence={nil,nil,50,nil}})
declare_fleet("Independent Traders Fish Bone",10,{presence={nil,nil,100,nil}})
declare_fleet("Independent Traders Voyager Cargo",5,{presence={nil,nil,100,nil}})
declare_fleet("Independent Traders Hauler",5,{presence={nil,nil,100,nil}})
declare_fleet("Independent Traders Whale",5,{presence={nil,nil,100,nil},enemies={nil,nil,10,20}})
declare_fleet("Independent Traders Rhino",20,{presence={nil,nil,100,nil},enemies={nil,10,nil,nil}})

declare_fleet(function() return spawn_variableFleet({"Independent Traders Scarab",1,2},{"Independent Traders Endeavour",1,3}) end,10,{presence={nil,20,nil,nil}})

declare_fleet(function() return spawn_variableFleet({"Independent Traders Fish Bone",2,5}) end,10,{presence={nil,50,nil,nil}})
declare_fleet(function() return spawn_variableFleet({"Independent Traders Hauler",2,5}) end,10,{presence={nil,50,nil,nil}})
declare_fleet(function() return spawn_variableFleet({"Independent Traders Voyager Cargo",2,5}) end,10,{presence={nil,50,nil,nil}})

declare_fleet(function() return spawn_variableFleet({"Independent Traders Whale",2,4}) end,10,{presence={nil,100,nil,nil},enemies={nil,nil,10,20}})

declare_fleet(function() return spawn_variableFleet({"Independent Traders Rhino",2,4}) end,10,{presence={nil,100,nil,nil},enemies={nil,10,nil,nil}})