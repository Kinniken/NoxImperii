include("dat/factions/spawn/common_new.lua")

fleet_table[#fleet_table+1] = new_fleet({"Barbarian Raider"},10,100,nil)
fleet_table[#fleet_table+1] = new_fleet({"Barbarian Vendetta"},5,100,nil)

fleet_table[#fleet_table+1] = new_fleet({"Barbarian Looter"},5,nil,50)
fleet_table[#fleet_table+1] = new_fleet({"Barbarian Raptor"},5,nil,50)
fleet_table[#fleet_table+1] = new_fleet({"Barbarian Raider","Barbarian Raider"},5,nil,50)

fleet_table[#fleet_table+1] = new_fleet({"Barbarian Looter","Barbarian Raider"},10,nil,100)
fleet_table[#fleet_table+1] = new_fleet({"Barbarian Raptor","Barbarian Raider"},5,nil,100)

fleet_table[#fleet_table+1] = new_fleet({"Barbarian Slaver","Barbarian Raider","Barbarian Raider"},10,nil,200)
fleet_table[#fleet_table+1] = new_fleet({"Barbarian Slaver","Barbarian Looter","Barbarian Raider"},5,nil,200)