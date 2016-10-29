include("dat/factions/spawn/common_new.lua")

fleet_table[#fleet_table+1] = new_fleet({"Pirate Shark"},10,50,nil)
fleet_table[#fleet_table+1] = new_fleet({"Pirate Admonisher"},5,50,nil)

fleet_table[#fleet_table+1] = new_fleet({"Pirate Delta"},5,nil,nil)
fleet_table[#fleet_table+1] = new_fleet({"Pirate Vendetta"},5,nil,nil)
fleet_table[#fleet_table+1] = new_fleet({"Pirate Rhino"},5,nil,nil)
fleet_table[#fleet_table+1] = new_fleet({"Pirate Kestrel"},5,nil,nil)

fleet_table[#fleet_table+1] = new_fleet({"Pirate Shark","Pirate Shark","Pirate Shark"},10,nil,50)
fleet_table[#fleet_table+1] = new_fleet({"Pirate Admonisher","Pirate Admonisher"},10,nil,50)
fleet_table[#fleet_table+1] = new_fleet({"Pirate Delta","Pirate Shark"},10,nil,50)

fleet_table[#fleet_table+1] = new_fleet({"Pirate Kestrel","Pirate Delta","Pirate Shark","Pirate Shark"},5,nil,100)
fleet_table[#fleet_table+1] = new_fleet({"Pirate Kestrel","Pirate Rhino","Pirate Rhino"},5,nil,100)

fleet_table[#fleet_table+1] = new_fleet({"Pirate Kestrel","Pirate Kestrel","Pirate Kestrel"},5,nil,200)
