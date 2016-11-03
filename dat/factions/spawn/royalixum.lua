include("dat/factions/spawn/common.lua")

fleet_table[#fleet_table+1] = new_fleet("Royal Ixum Meteor",10,{presence={nil,nil,50,nil}})
fleet_table[#fleet_table+1] = new_fleet("Royal Ixum Comet",10,{presence={nil,nil,nil,nil}})
fleet_table[#fleet_table+1] = new_fleet("Royal Ixum Continent",10,{presence={nil,50,200,nil}})


fleet_table[#fleet_table+1] = new_fleet({"Royal Ixum Meteor","Royal Ixum Meteor","Royal Ixum Meteor"},10,{presence={nil,50,500,nil},formation="wedge"})
fleet_table[#fleet_table+1] = new_fleet({"Royal Ixum Comet","Royal Ixum Meteor","Royal Ixum Meteor"},10,{presence={nil,50,500,nil},formation="wedge"})
fleet_table[#fleet_table+1] = new_fleet({"Royal Ixum Continent","Royal Ixum Meteor","Royal Ixum Meteor"},10,{presence={nil,100,1000,nil},formation="wedge"})


fleet_table[#fleet_table+1] = new_fleet(function() return spawn_variableFleet({"Royal Ixum Planet",1,1},{"Royal Ixum Continent",0,1},{"Royal Ixum Meteor",2,4}) end,10,{presence={50,200,nil,nil}})

fleet_table[#fleet_table+1] = new_fleet(function() return spawn_variableFleet({"Royal Ixum Nova",1,1},{"Royal Ixum Continent",0,2},{"Royal Ixum Meteor",2,6}) end,10,{presence={100,400,nil,nil}})

fleet_table[#fleet_table+1] = new_fleet(function() return spawn_variableFleet({"Royal Ixum Nova",1,3},{"Royal Ixum Planet",0,4},{"Royal Ixum Continent",4,8},{"Royal Ixum Meteor",4,16}) end,10,{presence={500,1000,nil,nil}})