include("dat/factions/spawn/common_new.lua")

fleet_table[#fleet_table+1] = new_fleet({"Betelgian Meteor"},10,nil,nil)
fleet_table[#fleet_table+1] = new_fleet({"Betelgian Comet"},10,nil,nil)
fleet_table[#fleet_table+1] = new_fleet({"Betelgian Continent"},5,nil,nil)
fleet_table[#fleet_table+1] = new_fleet({"Betelgian Planet"},2,nil,nil)
fleet_table[#fleet_table+1] = new_fleet({"Betelgian Nova"},1,nil,nil)


fleet_table[#fleet_table+1] = new_fleet({"Betelgian Meteor","Betelgian Meteor","Betelgian Meteor"},10,nil,50)
fleet_table[#fleet_table+1] = new_fleet({"Betelgian Comet","Betelgian Meteor","Betelgian Meteor"},10,nil,50)
fleet_table[#fleet_table+1] = new_fleet({"Betelgian Continent"},10,nil,50)


fleet_table[#fleet_table+1] = new_fleet({"Betelgian Planet","Betelgian Continent"},10,nil,100)
fleet_table[#fleet_table+1] = new_fleet({"Betelgian Planet","Betelgian Continent","Betelgian Continent"},10,nil,100)


fleet_table[#fleet_table+1] = new_fleet({"Betelgian Nova","Betelgian Continent","Betelgian Continent"},10,nil,200)


fleet_table[#fleet_table+1] = new_fleet({"Betelgian Nova","Betelgian Planet","Betelgian Planet","Betelgian Continent","Betelgian Continent"},10,nil,500)