include("dat/factions/spawn/common.lua")

fleet_table[#fleet_table+1] = new_fleet("Holy Flame Meteor",10,{presence={nil,nil,50,nil}})
fleet_table[#fleet_table+1] = new_fleet("Holy Flame Comet",10,{presence={nil,nil,nil,nil}})
fleet_table[#fleet_table+1] = new_fleet("Holy Flame Continent",10,{presence={nil,50,200,nil}})


fleet_table[#fleet_table+1] = new_fleet({"Holy Flame Meteor","Holy Flame Meteor"},10,{presence={nil,50,500,nil},formation="wedge"})
fleet_table[#fleet_table+1] = new_fleet({"Holy Flame Comet","Holy Flame Comet","Holy Flame Comet","Holy Flame Meteor","Holy Flame Meteor"},10,{presence={nil,50,500,nil}})
fleet_table[#fleet_table+1] = new_fleet({"Holy Flame Continent","Holy Flame Comet","Holy Flame Comet","Holy Flame Meteor","Holy Flame Meteor"},10,{presence={nil,100,1000,nil}})


fleet_table[#fleet_table+1] = new_fleet(function() return spawn_variableFleet({"Holy Flame Planet",1,1},{"Holy Flame Continent",0,1},{"Holy Flame Comet",1,2},{"Holy Flame Meteor",2,4}) end,10,{presence={50,200,nil,nil}})

fleet_table[#fleet_table+1] = new_fleet(function() return spawn_variableFleet({"Holy Flame Nova",1,1},{"Holy Flame Continent",0,2},{"Holy Flame Comet",1,2},{"Holy Flame Meteor",2,6}) end,10,{presence={100,400,nil,nil}})

fleet_table[#fleet_table+1] = new_fleet(function() return spawn_variableFleet({"Holy Flame Nova",1,3},{"Holy Flame Planet",0,4},{"Holy Flame Continent",2,4},{"Holy Flame Comet",3,6},{"Holy Flame Meteor",4,16}) end,10,{presence={500,1000,nil,nil}})