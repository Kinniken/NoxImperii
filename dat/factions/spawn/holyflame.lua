include("dat/factions/spawn/common.lua")

declare_fleet("Holy Flame Meteor",10,{presence={nil,nil,50,nil}})
declare_fleet("Holy Flame Comet",10,{presence={nil,nil,nil,nil}})
declare_fleet("Holy Flame Continent",10,{presence={nil,50,200,nil}})


declare_fleet({"Holy Flame Meteor","Holy Flame Meteor"},10,{presence={nil,50,500,nil},formation="wedge"})
declare_fleet({"Holy Flame Comet","Holy Flame Comet","Holy Flame Comet","Holy Flame Meteor","Holy Flame Meteor"},10,{presence={nil,50,500,nil}})
declare_fleet({"Holy Flame Continent","Holy Flame Comet","Holy Flame Comet","Holy Flame Meteor","Holy Flame Meteor"},10,{presence={nil,100,1000,nil}})


declare_fleet(function() return spawn_variableFleet({"Holy Flame Planet",1,1},{"Holy Flame Continent",0,1},{"Holy Flame Comet",1,2},{"Holy Flame Meteor",2,4}) end,10,{presence={50,200,nil,nil}})
