include "dat/scripts/general_helper.lua"

local title="Stranded and out of fuel"
local text=[[The ${shipName}'s fuel indicator suddenly starts flashing: you do not have enough fuel for another jump and there are no accessible worlds with refuelling services in the ${system} system!

It is possible for your crew to build a makeshift ramscoop that will gather enough fuel for one jump, but it will cost ${cost} credits in supplies. Order it done?"]]

function create()
	fuel, consumption = player.fuel()

	if (fuel>=consumption) then
		evt.finish()
	end

	for k,world in ipairs(system.cur():planets()) do
		if (world:canLand()) then
			evt.finish()
		end
	end

	hook.timer(5000, "offer_fuel")	
end

function offer_fuel()
	local cost=consumption*100

	local stringData={}
	stringData.shipName=player.ship()
	stringData.cost=cost
	stringData.system=system.cur():name()


	if tk.yesno( gh.format(title,stringData), gh.format(text,stringData) ) then
		player.refuel(consumption)
		player.pay(-cost)
	end

	evt.finish()
end