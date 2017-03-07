include("dat/factions/spawn/common.lua")

-- courrier
declare_fleet("Betelgian Traders Pelegrina",10)
-- light trade
declare_fleet("Betelgian Traders Carvela",10)
-- bulk trade
declare_fleet("Betelgian Traders Veniera",10,{presence={nil,50,200,nil},enemies={nil,nil,10,20}})
-- explorer
declare_fleet("Betelgian Traders Impresa",5,{enemies={nil,10,nil,nil}})


declare_fleet(function() return spawn_variableFleet({"Betelgian Traders Carvela",2,4}) end,10,{presence={nil,50,nil,nil}})

declare_fleet(function() return spawn_variableFleet({"Betelgian Traders Veniera",2,4}) end,10,{presence={nil,100,400,nil},enemies={nil,nil,10,20}})


declare_fleet(function() return spawn_variableFleet({"Betelgian Traders Impresa",1,2},{"Betelgian Traders Carvela",1,2},{"Betelgian Traders Pelegrina",1,2}) end,10,{presence={nil,100,400,nil},enemies={nil,nil,10,20}})
declare_fleet(function() return spawn_variableFleet({"Betelgian Traders Veniera",4,8}) end,5000,{presence={nil,200,800,nil},enemies={nil,nil,10,20}})


