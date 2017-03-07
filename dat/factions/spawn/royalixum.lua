include("dat/factions/spawn/common.lua")

declare_fleet("Royal Ixum Meteor",10,{presence={nil,nil,50,nil}})
declare_fleet("Royal Ixum Comet",10,{presence={nil,nil,nil,nil}})
declare_fleet("Royal Ixum Continent",10,{presence={nil,50,200,nil}})


declare_fleet({"Royal Ixum Meteor","Royal Ixum Meteor","Royal Ixum Meteor"},10,{presence={nil,50,500,nil},formation="wedge"})
declare_fleet({"Royal Ixum Comet","Royal Ixum Meteor","Royal Ixum Meteor"},10,{presence={nil,50,500,nil},formation="wedge"})
declare_fleet({"Royal Ixum Continent","Royal Ixum Meteor","Royal Ixum Meteor"},10,{presence={nil,100,1000,nil},formation="wedge"})


declare_fleet(function() return spawn_variableFleet({"Royal Ixum Planet",1,1},{"Royal Ixum Continent",0,1},{"Royal Ixum Meteor",2,4}) end,10,{presence={50,200,nil,nil}})
