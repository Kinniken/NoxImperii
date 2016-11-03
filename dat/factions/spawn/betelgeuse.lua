include("dat/factions/spawn/common.lua")

declare_fleet("Betelgian Meteor",10,{presence={nil,nil,50,nil}})
declare_fleet("Betelgian Comet",10,{presence={nil,nil,nil,nil}})
declare_fleet("Betelgian Continent",10,{presence={nil,50,200,nil}})


declare_fleet({"Betelgian Meteor","Betelgian Meteor"},10,{presence={nil,50,500,nil},formation="wedge"})
declare_fleet({"Betelgian Comet","Betelgian Comet","Betelgian Comet","Betelgian Meteor","Betelgian Meteor"},10,{presence={nil,50,500,nil},formation="wedge"})
declare_fleet({"Betelgian Continent","Betelgian Comet","Betelgian Comet","Betelgian Meteor","Betelgian Meteor"},10,{presence={nil,100,1000,nil},formation="wedge"})


declare_fleet(function() return spawn_variableFleet({"Betelgian Planet",1,1},{"Betelgian Continent",0,1},{"Betelgian Comet",1,2},{"Betelgian Meteor",2,4}) end,10,{presence={50,200,nil,nil}})

declare_fleet(function() return spawn_variableFleet({"Betelgian Nova",1,1},{"Betelgian Continent",0,2},{"Betelgian Comet",1,2},{"Betelgian Meteor",2,6}) end,10,{presence={100,400,nil,nil}})

declare_fleet(function() return spawn_variableFleet({"Betelgian Nova",1,3},{"Betelgian Planet",0,4},{"Betelgian Continent",2,4},{"Betelgian Comet",3,6},{"Betelgian Meteor",4,16}) end,10,{presence={500,1000,nil,nil}})