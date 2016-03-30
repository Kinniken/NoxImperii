

cargomission_class = {}

local cargomission_prototype = {
	validStartPlanet=function(self,c_planet)
		return true
	end,
	validEndPlanet=function(self,c_planet)
		return true
	end,
	addFactionReward=function(self,factionName,rewardFactor,rewardLimit)
		local factionReward={}

		local thefaction=faction.get(factionName)
		if thefaction then
			factionReward.faction=thefaction:name()
		else
			error("Unknown faction "..factionName.." in cargo mission!")
		end

		factionReward.faction=thefaction:name()

		if rewardFactor then
			factionReward.rewardFactor=rewardFactor
		else
			factionReward.rewardFactor=self.factionRewardFactor
		end

		if rewardLimit then
			factionReward.rewardLimit=rewardLimit
		else
			factionReward.rewardLimit=self.factionRewardLimit
		end

		table.insert(self.factionRewards,factionReward)
	end
}

cargomission_prototype.__index = cargomission_prototype

function cargomission_class.createNew()
	local o={}
	setmetatable(o, cargomission_prototype)
	o.weight=10
	o.minRushLevel=0
	o.maxRushLevel=5
	o.minCargoSize=10
	o.maxCargoSize=200
	o.minDistance=1
	o.maxDistance=3
	o.priceFactor=1
	o.lateRewardFactor=0.5
	o.factionRewardFactor=0.00002--1 point for every 50k of reward
	o.factionRewardLimit=50--can't get above this from mission rewards
	o.factionRewards={}
	o.cargoSizeLabels={"Small","Medium","Sizeable","Large","Bulk"}
    o.cargoPriorityLabels={"Courier","Priority","Pressing","Urgent","Emergency"}
	o.commodities={C.FOOD, C.INDUSTRIAL, C.CONSUMER_GOODS, C.LUXURY_GOODS, C.ORE}

	o.misn_title = "${cargoSizeAdj} shipment to ${targetWorld} (${quantity} tonnes)"
	o.misn_title_urgent = "${urgencyAdj} transport to ${targetWorld} (${quantity} tonnes)"

	o.misn_desc = "${targetWorld} in the ${targetSystem} system needs a delivery of ${quantity} tonnes of ${commodity}."
	o.misn_desc_urgent = "${targetWorld} in the ${targetSystem} system needs a delivery of ${quantity} tonnes of ${commodity} before the ${deadline} (time left: ${timeRemaining})."

    o.misn_reward = "${payment} credits"
    o.land_title="Delivery success!"
    o.land_msg={"The crates of ${commodity} are carried out of your ship by a sullen group of workers. The job takes inordinately long to complete, and the leader pays you without speaking a word.","The drums of ${commodity} are rushed out of your vessel by a team shortly after you land. Before you can even collect your thoughts, one of them presses a credit chip in your hand and departs.","The containers of ${commodity} are unloaded by an exhausted-looking bunch of dockworkers. Still, they make fairly good time, delivering your pay upon completion of the job."}

    o.land_title_late="Late delivery!"
    o.land_msg_late={"The crates of ${commodity} are carried out of your ship by a sullen group of workers. They are not happy that they have to work overtime because you were late. You are paid only ${paymentPartial} of the ${payment} you were promised.","The drums of ${commodity} are rushed out of your vessel by a team shortly after you land. Your late arrival is stretching quite a few schedules! Your pay is only ${paymentPartial} instead of ${payment} because of that.","The containers of ${commodity} are unloaded by an exhausted-looking bunch of dockworkers. You missed the deadline, so your reward is only ${paymentPartial} instead of the ${payment} you were hoping for."}
    o.acceptTitle="Mission Accepted"
    o.timeUp1="You've missed the deadline for the delivery to ${targetWorld}! But you can still make a late delivery if you hurry."
    o.timeUp2="The delivery to ${targetWorld} has been cancelled! You were too late."
    o.osd_title="Cargo mission"
    o.osd_msg1="Fly to ${targetWorld} in the ${targetSystem} system."
    o.osd_msg2=""
    o.osd_msg1_urgent="Fly to ${targetWorld} in the ${targetSystem} system before ${deadline}."
    o.osd_msg2_urgent="You have ${timeRemaining} remaining."
    o.misn_reward="${payment} cr"

    o.full1 = "No room in ship"
    o.full2 = "You don't have enough cargo space to accept this mission. It requires ${quantity} tonnes of free space (you need ${lackingSpace} more)."

    o.slow1 = "Too slow"
    o.slow2 = [[This shipment must arrive within ${timeRemaining}, but it will take at least ${minTime} for your ship to reach ${targetWorld}, missing the deadline.

Accept the mission anyway?]]

	return o
end