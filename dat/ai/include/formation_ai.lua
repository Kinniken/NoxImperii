include "dat/ai/include/fleet_form.lua"
include "general_helper.lua"

function create_fleet()
	ships = {}
	ships[1] = ai.pilot()

	local faction_ships = pilot.get( { ai.pilot():faction() } )

	local shipNames = ""

	for _,v in ipairs(faction_ships) do
		if v:leader()== ai.pilot() and v ~= ai.pilot() then
			ships[#ships+1]=v
			shipNames=shipNames.."'"..v:name().."' "
		end
	end

	if #ships == 1 then
		mem.fleet = false
		warn("Couldn't locate other ships.")
		return
	end

	local fleet_formation

	if mem.fleet_formation then
		fleet_formation = mem.fleet_formation
	elseif formation_default_type then
		fleet_formation = formation_default_type
	else
		fleet_formation = "column"
	end
	
	if not formation_tightness then
		formation_tightness = 50--max distance ships are allowed to drift
	end

	if not formation_sticky then
		formation_sticky = 2--amount of cheat velocity matching; the higher, the more the formations stay accurate
	end

	--warn("Creating fleet with "..#ships.." ships for "..ai.pilot():name()..", formation: "..fleet_formation..", ships: "..shipNames)

	local fleet=Forma:new(ships, fleet_formation, 3000)

	mem.fleet = fleet
end