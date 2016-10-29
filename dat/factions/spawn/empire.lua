include("dat/factions/spawn/common_new.lua")

fleet_table[#fleet_table+1] = new_fleet({"Imperial Meteor"},10,nil,nil)
fleet_table[#fleet_table+1] = new_fleet({"Imperial Comet"},10,nil,nil)
fleet_table[#fleet_table+1] = new_fleet({"Imperial Continent"},5,nil,nil)
fleet_table[#fleet_table+1] = new_fleet({"Imperial Planet"},2,nil,nil)
fleet_table[#fleet_table+1] = new_fleet({"Imperial Nova"},1,nil,nil)


fleet_table[#fleet_table+1] = new_fleet({"Imperial Meteor","Imperial Meteor","Imperial Meteor"},10,nil,50)
fleet_table[#fleet_table+1] = new_fleet({"Imperial Comet","Imperial Meteor","Imperial Meteor"},10,nil,50)
fleet_table[#fleet_table+1] = new_fleet({"Imperial Continent"},10,nil,50)


fleet_table[#fleet_table+1] = new_fleet({"Imperial Planet","Imperial Continent"},10,nil,100)
fleet_table[#fleet_table+1] = new_fleet({"Imperial Planet","Imperial Continent","Imperial Continent"},10,nil,100)


fleet_table[#fleet_table+1] = new_fleet({"Imperial Nova","Imperial Continent","Imperial Continent"},10,nil,200)


fleet_table[#fleet_table+1] = new_fleet({"Imperial Nova","Imperial Planet","Imperial Planet","Imperial Continent","Imperial Continent"},10,nil,500)