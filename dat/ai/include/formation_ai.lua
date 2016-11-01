include "fleet_form.lua"
include "general_helper.lua"

function create_fleet(lead_ship)
	ships = {}
	ships[1] = lead_ship

	local faction_ships = pilot.get( { lead_ship:faction() } )

	local shipNames = ""

	for _,v in ipairs(faction_ships) do
		if v:boss() == lead_ship and v ~= lead_ship then
			ships[#ships+1]=v
			shipNames=shipNames.."'"..v:name().."' "
		end
	end

	if #ships == 1 then
		mem.fleet = false
		warn("Couldn't locate other ships.")
		return
	end	

	if not formation_type then
		formation_type = column
	end

	if not formation_tightness then
		formation_tightness = 50--max distance ships are allowed to drift
	end

	if not formation_sticky then
		formation_sticky = 2--amount of cheat velocity matching; the higher, the more the formations stay accurate
	end

	warn("Creating fleet with "..#ships.." ships for "..lead_ship:name()..", formation: "..formation_type..", ships: "..shipNames)

	local fleet=Forma:new(ships, formation_type, 3000)

	mem.fleet = fleet
end