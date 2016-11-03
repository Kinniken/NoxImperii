include("dat/factions/spawn/common.lua")

fleet_table[#fleet_table+1] = new_fleet("Ardar Meteor",10,{presence={nil,nil,50,nil}})
fleet_table[#fleet_table+1] = new_fleet("Ardar Comet",10,{presence={nil,nil,nil,nil}})
fleet_table[#fleet_table+1] = new_fleet("Ardar Continent",10,{presence={nil,50,200,nil}})


fleet_table[#fleet_table+1] = new_fleet({"Ardar Meteor","Ardar Meteor"},10,{presence={nil,50,500,nil},formation="wedge"})
fleet_table[#fleet_table+1] = new_fleet({"Ardar Comet","Ardar Comet","Ardar Comet","Ardar Meteor","Ardar Meteor"},10,{presence={nil,50,500,nil}})
fleet_table[#fleet_table+1] = new_fleet({"Ardar Continent","Ardar Comet","Ardar Comet","Ardar Meteor","Ardar Meteor"},10,{presence={nil,100,1000,nil}})


fleet_table[#fleet_table+1] = new_fleet(function() return spawn_variableFleet({"Ardar Planet",1,1},{"Ardar Continent",0,1},{"Ardar Comet",1,2},{"Ardar Meteor",2,4}) end,10,{presence={50,200,nil,nil}})

fleet_table[#fleet_table+1] = new_fleet(function() return spawn_variableFleet({"Ardar Nova",1,1},{"Ardar Continent",0,2},{"Ardar Comet",1,2},{"Ardar Meteor",2,6}) end,10,{presence={100,400,nil,nil}})

fleet_table[#fleet_table+1] = new_fleet(function() return spawn_variableFleet({"Ardar Nova",1,3},{"Ardar Planet",0,4},{"Ardar Continent",2,4},{"Ardar Comet",3,6},{"Ardar Meteor",4,16}) end,10,{presence={500,1000,nil,nil}})
