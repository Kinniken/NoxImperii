include("dat/factions/spawn/common.lua")

declare_fleet("Imperial Meteor",10,{presence={nil,nil,50,nil}})
declare_fleet("Imperial Comet",10)
declare_fleet("Imperial Continent",10,{presence={nil,50,200,nil}})


declare_fleet({"Imperial Meteor","Imperial Meteor","Imperial Meteor"},10,{presence={nil,50,500,nil},formation="wedge"})
declare_fleet({"Imperial Comet","Imperial Meteor","Imperial Meteor"},10,{presence={nil,50,500,nil},formation="wedge"})
declare_fleet({"Imperial Continent","Imperial Meteor","Imperial Meteor"},10,{presence={nil,100,1000,nil},formation="wedge"})


declare_fleet(function() return spawn_variableFleet({"Imperial Planet",1,1},{"Imperial Continent",0,1},{"Imperial Meteor",2,4}) end,10,{presence={50,200,nil,nil}})

declare_fleet(function() return spawn_variableFleet({"Imperial Nova",1,1},{"Imperial Continent",0,2},{"Imperial Meteor",2,6}) end,10,{presence={100,400,nil,nil}})

declare_fleet(function() return spawn_variableFleet({"Imperial Nova",1,3},{"Imperial Planet",0,4},{"Imperial Continent",4,8},{"Imperial Meteor",4,16}) end,10000,{presence={500,1000,nil,nil}})