cargo_custom={}
cargo_custom.types={}
cargo_custom.typesRef={}



--Imperial short-range, safe
cargoCustom=cargomission_class.createNew()
cargoCustom.id="imperial_safe"
cargoCustom.weight=100
cargoCustom.validStartPlanet=function(self,c_planet)
		return c_planet:faction()==faction.get(G.EMPIRE) and c_planet:system():presence(G.PIRATES)<10 and c_planet:system():presence(G.BARBARIANS)<10
	end
cargoCustom.validEndPlanet=function(self,c_planet)
		return c_planet:faction()==faction.get(G.EMPIRE) and c_planet:system():presence(G.PIRATES)<10 and c_planet:system():presence(G.BARBARIANS)<10
	end
cargoCustom:addFactionReward(G.IMPERIAL_TRADERS)
table.insert(cargo_custom.types,cargoCustom)


--Imperial short-range, risky
cargoCustom=cargomission_class.createNew()
cargoCustom.id="imperial_risky"
cargoCustom.weight=100
cargoCustom.priceFactor=2
cargoCustom.maxRushLevel=1--with pirates to fight more is impossible
cargoCustom.misn_title = "Frontier shipment to ${targetWorld} (${quantity} tonnes)"
cargoCustom.misn_title_urgent = "${urgencyAdj} frontier transport to ${targetWorld} (${quantity} tonnes)"
cargoCustom.validStartPlanet=function(self,c_planet)
		return c_planet:faction()==faction.get(G.EMPIRE) and (c_planet:system():presence(G.PIRATES)>=10 or c_planet:system():presence(G.BARBARIANS)>=10)
	end
cargoCustom.validEndPlanet=function(self,c_planet)
		return c_planet:faction()==faction.get(G.EMPIRE) and (c_planet:system():presence(G.PIRATES)>=10 or c_planet:system():presence(G.BARBARIANS)>=10)
	end
cargoCustom:addFactionReward(G.IMPERIAL_TRADERS)
table.insert(cargo_custom.types,cargoCustom)


--Imperial military, risky
cargoCustom=cargomission_class.createNew()
cargoCustom.id="imperial_military"
cargoCustom.weight=50
cargoCustom.priceFactor=1.2
cargoCustom.maxRushLevel=1--with pirates to fight more is impossible
cargoCustom.commodities={C.ARMAMENT,C.MODERN_ARMAMENT}
cargoCustom.misn_title = "Navy shipment to ${targetWorld} (${quantity} tonnes)"
cargoCustom.misn_title_urgent = "${urgencyAdj} navy transport to ${targetWorld} (${quantity} tonnes)"
cargoCustom.misn_desc = "The Imperial Navy needs ${quantity} tonnes of ${commodity} shipped to a base on ${targetWorld} in the ${targetSystem} system. The pay isn't great, but the Navy will be grateful."
cargoCustom.misn_desc_urgent = "The Imperial Navy needs ${quantity} tonnes of ${commodity} shipped to a base on ${targetWorld} in the ${targetSystem} system. It must reach before the ${deadline} (time left: ${timeRemaining}). The pay isn't great, but the Navy will be grateful."
cargoCustom.validStartPlanet=function(self,c_planet)
		return c_planet:faction()==faction.get(G.EMPIRE)
	end
cargoCustom.validEndPlanet=function(self,c_planet)
		return c_planet:faction()==faction.get(G.EMPIRE) and (c_planet:system():presence(G.PIRATES)>=10 or c_planet:system():presence(G.BARBARIANS)>=10)
	end
cargoCustom:addFactionReward(G.EMPIRE)
table.insert(cargo_custom.types,cargoCustom)


--Imperial or fringes to fringes
cargoCustom=cargomission_class.createNew()
cargoCustom.id="imperial_fringe"
cargoCustom.weight=50
cargoCustom.priceFactor=3
cargoCustom.maxDistance=5
cargoCustom.maxRushLevel=1--with pirates to fight more is impossible
cargoCustom.misn_title = "Fringe shipment to ${targetWorld} (${quantity} tonnes)"
cargoCustom.misn_title_urgent = "${urgencyAdj} fringe transport to ${targetWorld} (${quantity} tonnes)"
cargoCustom.validStartPlanet=function(self,c_planet)
		return c_planet:faction()==faction.get(G.EMPIRE) or c_planet:faction()==faction.get(G.INDEPENDENT_WORLDS)
	end
cargoCustom.validEndPlanet=function(self,c_planet)
		return c_planet:faction()==faction.get(G.INDEPENDENT_WORLDS)
	end
cargoCustom:addFactionReward(G.INDEPENDENT_TRADERS)
table.insert(cargo_custom.types,cargoCustom)



--Roidhunate
cargoCustom=cargomission_class.createNew()
cargoCustom.id="roidhunate_base"
cargoCustom.weight=50
cargoCustom.priceFactor=0.8
cargoCustom.minDistance=1
cargoCustom.maxDistance=6
cargoCustom.validStartPlanet=function(self,c_planet)
		return c_planet:faction()==faction.get(G.ROIDHUNATE)
	end
cargoCustom.validEndPlanet=function(self,c_planet)
		return c_planet:faction()==faction.get(G.ROIDHUNATE)
	end
cargoCustom:addFactionReward(G.ROIDHUNATE)
cargoCustom.misn_title = "Ardar shipment to ${targetWorld} (${quantity} tonnes)"
cargoCustom.misn_title_urgent = "${urgencyAdj} Ardar transport to ${targetWorld} (${quantity} tonnes)"
cargoCustom.misn_desc = "An Ardar company needs ${quantity} tonnes of ${commodity} shipped to a client on ${targetWorld} in the ${targetSystem} system."
cargoCustom.misn_desc_urgent = "An Ardar company needs ${quantity} tonnes of ${commodity} shipped to a client on ${targetWorld} in the ${targetSystem} system. It must reach before the ${deadline} (time left: ${timeRemaining})."
cargoCustom.land_msg={"The Ardars at the spaceport are clearly not used to dealing with independent couriers, an a human one at that. They process the delivery competently, but you can feel lingering unease."}
cargoCustom.land_msg_late={"The Ardars at the spaceport are clearly not used to dealing with independent couriers, an a human one at that. When they realise that you are late, unease turns to hostility; they pay you ${paymentPartial} of the ${payment} credits promised, scornfully commenting on human unreliability."}
table.insert(cargo_custom.types,cargoCustom)


--Imperial military, risky
cargoCustom=cargomission_class.createNew()
cargoCustom.id="roidhunate_military"
cargoCustom.weight=20
cargoCustom.priceFactor=1
cargoCustom.maxRushLevel=1
cargoCustom.commodities={C.ARMAMENT,C.MODERN_ARMAMENT}
cargoCustom.validStartPlanet=function(self,c_planet)
		return c_planet:faction()==faction.get(G.ROIDHUNATE)
	end
cargoCustom.validEndPlanet=function(self,c_planet)
		return c_planet:faction()==faction.get(G.ROIDHUNATE) and (c_planet:system():presence(G.PIRATES)>=10 or c_planet:system():presence(G.BARBARIANS)>=10)
	end
cargoCustom:addFactionReward(G.ROIDHUNATE)
cargoCustom.misn_title = "Ardar Navy shipment to ${targetWorld} (${quantity} tonnes)"
cargoCustom.misn_title_urgent = "${urgencyAdj} Ardar Navy transport to ${targetWorld} (${quantity} tonnes)"
cargoCustom.misn_desc = "The Ardar Navy needs ${quantity} tonnes of ${commodity} shipped to a base on ${targetWorld} in the ${targetSystem} system, and due to a lack of transport ships will even pay independent traders to do it."
cargoCustom.misn_desc_urgent = "The Ardar Navy needs ${quantity} tonnes of ${commodity} shipped to a base on ${targetWorld} in the ${targetSystem} system, and due to a lack of transport ships will even pay independent traders to do it. It must reach before the ${deadline} (time left: ${timeRemaining})."
cargoCustom.land_msg={"The Ardar Officer you deliver the cargo to is clearly angry at dealing with an independent contractor, and a human one at that. He proceeds the delivery and your payment well enough though, muttering under his breath about possible spies and saboteurs."}
cargoCustom.land_msg_late={"The Ardar Officer you deliver the cargo to is clearly angry at dealing with an independent contractor, and a human one at that. When he realises you are late he turns hostile. But rules are rules, and Ardars generally respect them, so he pays you ${paymentPartial} of the ${payment} credits agreed, deducting the late fee without hesitation."}
table.insert(cargo_custom.types,cargoCustom)


--Betelgeuse ingoing
cargoCustom=cargomission_class.createNew()
cargoCustom.id="betelgeuse_ingoing"
cargoCustom.weight=10
cargoCustom.priceFactor=3
cargoCustom.minDistance=5
cargoCustom.maxDistance=15
cargoCustom.maxRushLevel=1--with pirates to fight more is impossible
cargoCustom:addFactionReward(G.BETELGIAN_TRADERS)
cargoCustom.misn_title = "Betelgian shipment to ${targetWorld} (${quantity} tonnes)"
cargoCustom.misn_title_urgent = "${urgencyAdj} Betelgian transport to ${targetWorld} (${quantity} tonnes)"
cargoCustom.misn_desc = "A Betelgian trading house needs ${quantity} tonnes of ${commodity} shipped to its base of ${targetWorld} in the ${targetSystem} system."
cargoCustom.misn_desc_urgent = "A Betelgian trading house needs ${quantity} tonnes of ${commodity} shipped to its base of ${targetWorld} in the ${targetSystem} system. It must reach before the ${deadline} (time left: ${timeRemaining})."
cargoCustom.land_msg={"As you land in the trading house's private spaceport, its efficient crew members waste no time discharging your cargo. You are paid immediately by a competent-looking minor clerk."}
cargoCustom.land_msg_late={"As you land in the trading house's private spaceport, its efficient crew members waste no time discharging your cargo. The clerk in charge pays you ${paymentPartial} of the ${payment} credits agreed due to your tardy arrival."}
cargoCustom.valid=function(self)
	return var.peek("betelgeuse_missions_1")
end
cargoCustom.validStartPlanet=function(self,c_planet)
		return c_planet:faction()==faction.get(G.EMPIRE) or c_planet:faction()==faction.get(G.INDEPENDENT_WORLDS) or c_planet:faction()==faction.get(G.ROIDHUNATE) or c_planet:faction()==faction.get(G.ROYAL_IXUM) or c_planet:faction()==faction.get(G.HOLY_FLAME)
	end
cargoCustom.validEndPlanet=function(self,c_planet)
		return c_planet:faction()==faction.get(G.BETELGEUSE)
	end
table.insert(cargo_custom.types,cargoCustom)

--Betelgeuse outgoing
cargoCustom=cargomission_class.createNew()
cargoCustom.id="betelgeuse_outgoing"
cargoCustom.weight=20
cargoCustom.priceFactor=2
cargoCustom.minDistance=5
cargoCustom.maxDistance=15
cargoCustom.maxRushLevel=1--with pirates to fight more is impossible
cargoCustom:addFactionReward(G.BETELGIAN_TRADERS)
cargoCustom.misn_title = "Betelgian shipment to ${targetWorld} (${quantity} tonnes)"
cargoCustom.misn_title_urgent = "${urgencyAdj} Betelgian transport to ${targetWorld} (${quantity} tonnes)"
cargoCustom.misn_desc = "A Betelgian trading house needs ${quantity} tonnes of ${commodity} shipped to its branch on ${targetWorld} in the ${targetSystem} system."
cargoCustom.misn_desc_urgent = "A Betelgian trading house needs ${quantity} tonnes of ${commodity} shipped to its branch on ${targetWorld} in the ${targetSystem} system. It must reach before the ${deadline} (time left: ${timeRemaining})."
cargoCustom.land_msg={"The section of ${targetWorld}'s dedicated to the trading house is well-run, and efficient crew members waste no time discharging your cargo. You are paid immediately by a competent-looking minor clerk."}
cargoCustom.land_msg_late={"The section of ${targetWorld}'s dedicated to the trading house is well-run, and efficient crew members waste no time discharging your cargo. The clerk in charge pays you ${paymentPartial} of the ${payment} credits agreed due to your tardy arrival."}
cargoCustom.valid=function(self)
	return var.peek("betelgeuse_missions_1")
end
cargoCustom.validStartPlanet=function(self,c_planet)
	return c_planet:faction()==faction.get(G.BETELGEUSE)
	end
cargoCustom.validEndPlanet=function(self,c_planet)
	return c_planet:faction()==faction.get(G.EMPIRE) or c_planet:faction()==faction.get(G.INDEPENDENT_WORLDS) or c_planet:faction()==faction.get(G.ROIDHUNATE) or c_planet:faction()==faction.get(G.ROYAL_IXUM) or c_planet:faction()==faction.get(G.HOLY_FLAME)
	end
table.insert(cargo_custom.types,cargoCustom)


--Empire to Kingdom of Ixum
cargoCustom=cargomission_class.createNew()
cargoCustom.id="empire_royal_ixum"
cargoCustom.weight=10
cargoCustom.priceFactor=3
cargoCustom.minDistance=3
cargoCustom.maxDistance=10
cargoCustom.maxRushLevel=1--with pirates to fight more is impossible
cargoCustom.commodities={C.ARMAMENT,C.MODERN_ARMAMENT}
cargoCustom:addFactionReward(G.EMPIRE)
cargoCustom:addFactionReward(G.ROYAL_IXUM)
cargoCustom.misn_title = "Military aid to ${targetWorld} (${quantity} tonnes)"
cargoCustom.misn_title_urgent = "${urgencyAdj} military aid to ${targetWorld} (${quantity} tonnes)"
cargoCustom.misn_desc = "The Imperial Navy needs ${quantity} tonnes of ${commodity} sent to its Royal Ixum allies on ${targetWorld} in the ${targetSystem} system."
cargoCustom.misn_desc_urgent = "The Imperial Navy needs ${quantity} tonnes of ${commodity} sent to its Royal Ixum allies on ${targetWorld} in the ${targetSystem} system. It must reach by ${deadline} (time left: ${timeRemaining})."
cargoCustom.land_msg={"The Royal Ixum military spaceport is a mess; it looks it has suffered damages, only hastily repaired. A gruff-looking sergeant processes your papers while exhausted-looking grunts unload your cargo."}
cargoCustom.land_msg_late={"The Royal Ixum military spaceport is a mess; it looks it has suffered damages, only hastily repaired. While exhausted-looking grunts unload your cargo, a furious sergeant berates you for the late shipment. You end up getting ${paymentPartial} of the ${payment} credits promised, and an earful as a bonus."}
cargoCustom.validStartPlanet=function(self,c_planet)
	return c_planet:faction()==faction.get(G.EMPIRE)
	end
cargoCustom.validEndPlanet=function(self,c_planet)
	return c_planet:faction()==faction.get(G.ROYAL_IXUM)
	end
table.insert(cargo_custom.types,cargoCustom)

--Roidhunate to Holy Flame
cargoCustom=cargomission_class.createNew()
cargoCustom.id="roidhunate_holy_flame"
cargoCustom.weight=10
cargoCustom.priceFactor=3
cargoCustom.minDistance=3
cargoCustom.maxDistance=10
cargoCustom.maxRushLevel=1--with pirates to fight more is impossible
cargoCustom.commodities={C.ARMAMENT,C.MODERN_ARMAMENT}
cargoCustom:addFactionReward(G.ROIDHUNATE)
cargoCustom:addFactionReward(G.HOLY_FLAME)
cargoCustom.misn_title = "Military aid to ${targetWorld} (${quantity} tonnes)"
cargoCustom.misn_title_urgent = "${urgencyAdj} military aid to ${targetWorld} (${quantity} tonnes)"
cargoCustom.misn_desc = "The Ardar Navy needs ${quantity} tonnes of ${commodity} sent to its Holy Flame allies on ${targetWorld} in the ${targetSystem} system."
cargoCustom.misn_desc_urgent = "The Ardar Navy needs ${quantity} tonnes of ${commodity} sent to its Holy Flame allies on ${targetWorld} in the ${targetSystem} system. It must reach by ${deadline} (time left: ${timeRemaining})."
cargoCustom.land_msg={"The Holy Flame spaceport is chaos incarnated; nobody seems to know how to process deliveries. You finally locate a stern-looking minor officer that organises the unloading and your payment, though he is clearly unhappy at dealing with an infidel."}
cargoCustom.land_msg_late={"The Holy Flame spaceport is chaos incarnated; nobody seems to know how to process deliveries. You finally locate a stern-looking minor officer that organises the unloading and your payment, though he is clearly unhappy at dealing with an infidel. When he realises that you are late, he becomes incandescent you are lucky to get even ${paymentPartial} of the ${payment} credits promised."}
cargoCustom.validStartPlanet=function(self,c_planet)
	return c_planet:faction()==faction.get(G.ROIDHUNATE)
	end
cargoCustom.validEndPlanet=function(self,c_planet)
	return c_planet:faction()==faction.get(G.HOLY_FLAME)
	end
table.insert(cargo_custom.types,cargoCustom)

--[[Events or tag-specific ones]]

cargoCustom=cargomission_class.createNew()
cargoCustom.id="winedelivery"
cargoCustom.osd_title="Wine delivery"
cargoCustom.misn_title = "Wine shipment to ${targetWorld} (${quantity} tonnes)"
cargoCustom.misn_title_urgent = "${urgencyAdj} wine transport to ${targetWorld} (${quantity} tonnes)"
cargoCustom.misn_desc = "A rich noble on ${targetWorld} in the ${targetSystem} system has placed an order for ${quantity} tonnes of fine wine from the festival."
cargoCustom.misn_desc_urgent = "A rich noble on ${targetWorld} in the ${targetSystem} system has placed an order for ${quantity} tonnes of fine wine from the festival. It must reach before his party on the ${deadline} (time left: ${timeRemaining})."
cargoCustom.land_msg={"The barrels of fine wines are quickly but reverently carried out by workers, to be sent straight to the noble's estate."}
cargoCustom.land_msg_late={"The barrels of fine wines are quickly but reverently carried out by workers, to be sent straight to the noble's estate. His butler is furious at the delay and pays only ${paymentPartial} of the ${payment} credits agreed."}
cargoCustom.commodities={C.BORDEAUX}
cargoCustom.priceFactor=1.5
cargoCustom.minCargoSize=5
cargoCustom.maxCargoSize=10
cargoCustom.minDistance=1
cargoCustom.maxDistance=5
cargoCustom:addFactionReward(G.IMPERIAL_TRADERS)
cargoCustom.validStartPlanet=function(self,c_planet)
		local planet=planet_class.load(c_planet)
		return planet.lua.settlements and planet.lua.settlements.humans and planet.lua.settlements.humans:hasActiveEffect("winefair")
	end
cargoCustom.validEndPlanet=function(self,c_planet)
		local planet=planet_class.load(c_planet)
		return planet.lua.settlements and planet.lua.settlements.humans and planet.lua.settlements.humans.services > 0.7
	end
table.insert(cargo_custom.types,cargoCustom)


cargoCustom=cargomission_class.createNew()
cargoCustom.id="winefairfood"
cargoCustom.osd_title="Food for the wine fair"
cargoCustom.misn_title = "Food for wine fair on ${targetWorld} (${quantity} tonnes)"
cargoCustom.misn_title_urgent = "${urgencyAdj} food for wine fair in ${targetWorld} (${quantity} tonnes)"
cargoCustom.misn_desc = "The wine fair on ${targetWorld} in the ${targetSystem} system requires ${quantity} tonnes of gourmet food."
cargoCustom.misn_desc_urgent = "The wine fair on ${targetWorld} in the ${targetSystem} system requires ${quantity} tonnes of gourmet food. It must reach before ${deadline} (time left: ${timeRemaining})."
cargoCustom.land_msg={"The crates of gourmet food are hurriedly delivered to the festival's kitchens."}
cargoCustom.land_msg_late={"The crates of gourmet food are hurriedly delivered to the festival's kitchens. The organizer is furious at the delay and pays only ${paymentPartial} of the ${payment} credits agreed."}
cargoCustom.commodities={C.GOURMET_FOOD}
cargoCustom.priceFactor=1.5
cargoCustom.minCargoSize=5
cargoCustom.maxCargoSize=10
cargoCustom.minDistance=1
cargoCustom.maxDistance=5
cargoCustom.minRushLevel=2
cargoCustom.maxRushLevel=4
cargoCustom:addFactionReward(G.IMPERIAL_TRADERS)
cargoCustom.validStartPlanet=function(self,c_planet)
		local planet=planet_class.load(c_planet)
		return planet.lua.settlements and planet.lua.settlements.humans and planet.lua.settlements.humans.agriculture>0.8
	end
cargoCustom.validEndPlanet=function(self,c_planet)
		local planet=planet_class.load(c_planet)
		return planet.lua.settlements and planet.lua.settlements.humans  and planet.lua.settlements.humans:hasActiveEffect("winefair")
	end
table.insert(cargo_custom.types,cargoCustom)



cargoCustom=cargomission_class.createNew()
cargoCustom.id="beerdelivery"
cargoCustom.osd_title="Beer delivery"
cargoCustom.misn_title = "Beer shipment to ${targetWorld} (${quantity} tonnes)"
cargoCustom.misn_title_urgent = "${urgencyAdj} beer transport to ${targetWorld} (${quantity} tonnes)"
cargoCustom.land_msg={"The crates of beer are unloaded straight by the client, ${targetWorld}'s largest gourmet food store."}
cargoCustom.land_msg_late={"The crates of beer are unloaded straight by the client, ${targetWorld}'s largest gourmet food store. He is furious at the delay and pays only ${paymentPartial} of the ${payment} credits agreed."}
cargoCustom.misn_desc = "A gourmet store on ${targetWorld} in the ${targetSystem} system has placed an order for ${quantity} tonnes of the famous local beer."
cargoCustom.misn_desc_urgent = "A gourmet store on ${targetWorld} in the ${targetSystem} system has placed an order for ${quantity} tonnes of the famous local beer. It must reach before the ${deadline} (time left: ${timeRemaining})."
cargoCustom.commodities={C.GOURMET_FOOD}
cargoCustom.priceFactor=1.5
cargoCustom.minCargoSize=5
cargoCustom.maxCargoSize=10
cargoCustom.minDistance=1
cargoCustom.maxDistance=5
cargoCustom:addFactionReward(G.IMPERIAL_TRADERS)
cargoCustom.validStartPlanet=function(self,c_planet)
		local planet=planet_class.load(c_planet)
		return planet.lua.settlements and planet.lua.settlements.humans and planet.lua.settlements.humans:hasTag("craftbeers")
	end
cargoCustom.validEndPlanet=function(self,c_planet)
		local planet=planet_class.load(c_planet)
		return planet.lua.settlements and planet.lua.settlements.humans and planet.lua.settlements.humans.services > 0.7
	end
table.insert(cargo_custom.types,cargoCustom)



cargoCustom=cargomission_class.createNew()
cargoCustom.id="melapilgrims"
cargoCustom.osd_title="Pilgrims for Mela"
cargoCustom.cargoPriorityLabels={"","Priority","Pressing","Urgent",""}
cargoCustom.misn_title_urgent = "${urgencyAdj} Pilgrims for ${targetWorld} (Space: ${quantity} tonnes)"
cargoCustom.misn_desc_urgent = "A group of Hindu pilgrims are headed for the Mela on ${targetWorld} in the ${targetSystem} system. They'll need ${quantity} tonnes of space refitted as temporary accommodation. They must reach before the ${deadline} (time left: ${timeRemaining})."

cargoCustom.land_msg={"The pilgrims exit the ship chanting mantras, grateful for the journey to ${targetWorld}'s famous Mela."}
cargoCustom.land_msg={"The pilgrims exit the ship chanting mantras, grateful for the journey to ${targetWorld}'s famous Mela - even if they are reaching later than they would have liked."}
cargoCustom.commodities={"Pilgrims"}
cargoCustom.priceFactor=1.5
cargoCustom.minRushLevel=2
cargoCustom.maxRushLevel=4
cargoCustom.minCargoSize=20
cargoCustom.maxCargoSize=100
cargoCustom.minDistance=1
cargoCustom.maxDistance=5
cargoCustom:addFactionReward(G.IMPERIAL_TRADERS)
cargoCustom.validStartPlanet=function(self,c_planet)
		local planet=planet_class.load(c_planet)
		return planet.lua.settlements and planet.lua.settlements.humans
	end
cargoCustom.validEndPlanet=function(self,c_planet)
		local planet=planet_class.load(c_planet)
		return planet.lua.settlements and planet.lua.settlements.humans and planet.lua.settlements.humans:hasActiveEffect("mela")
	end
table.insert(cargo_custom.types,cargoCustom)



cargoCustom=cargomission_class.createNew()
cargoCustom.id="carnivaltourists"
cargoCustom.osd_title="Tourists for the Carnival"
cargoCustom.cargoPriorityLabels={"","Priority","Pressing","Urgent",""}
cargoCustom.misn_title_urgent = "${urgencyAdj} Tourists for ${targetWorld} (Space: ${quantity} tonnes)"
cargoCustom.misn_desc_urgent = "A group of tourists are headed for the carnival on ${targetWorld} in the ${targetSystem} system. They'll need ${quantity} tonnes of space refitted as temporary accommodation. They must reach before the ${deadline} (time left: ${timeRemaining})."

cargoCustom.land_msg={"The tourists excitedly exit the ship, taking in the carnival atmosphere of Port ${targetWorld}."}
cargoCustom.land_msg={"The tourists exit the ship, grumbling about the delay."}
cargoCustom.commodities={"Tourists"}
cargoCustom.priceFactor=1.5
cargoCustom.minRushLevel=2
cargoCustom.maxRushLevel=4
cargoCustom.minCargoSize=20
cargoCustom.maxCargoSize=100
cargoCustom.minDistance=1
cargoCustom.maxDistance=5
cargoCustom:addFactionReward(G.IMPERIAL_TRADERS)
cargoCustom.validStartPlanet=function(self,c_planet)
		local planet=planet_class.load(c_planet)
		return planet.lua.settlements and planet.lua.settlements.humans
	end
cargoCustom.validEndPlanet=function(self,c_planet)
		local planet=planet_class.load(c_planet)
		return planet.lua.settlements and planet.lua.settlements.humans and planet.lua.settlements.humans:hasActiveEffect("empire_carnival")
	end
table.insert(cargo_custom.types,cargoCustom)



cargoCustom=cargomission_class.createNew()
cargoCustom.id="empire_barbarian_help"
cargoCustom.osd_title="Urgent Medical Help"
cargoCustom.misn_title_urgent = "${urgencyAdj} medical help for ${targetWorld} (Space: ${quantity} tonnes)"
cargoCustom.misn_desc_urgent = "${quantity} tonnes of urgent medical help is needed on ${targetWorld} in the ${targetSystem} system following the recent barbarian raids. It must reach before the ${deadline} (time left: ${timeRemaining})."

cargoCustom.land_msg={"${targetWorld}'s spaceport is a ruin, with makeshift facilities barely operational. Clearly the damages suffered were much bigger than announced on the news. A harried crew takes your crate and they are rushed onward to makeshift hospitals."}
cargoCustom.land_msg_late={"${targetWorld}'s spaceport is a ruin, with makeshift facilities barely operational. Clearly the damages suffered were much bigger than announced on the news. A harried crew takes your crate and they are rushed onward to makeshift hospitals; your late arrival means they've run out."}
cargoCustom.commodities={C.MEDICINE}
cargoCustom.priceFactor=1.5
cargoCustom.minRushLevel=2
cargoCustom.maxRushLevel=4
cargoCustom.minCargoSize=20
cargoCustom.maxCargoSize=100
cargoCustom.minDistance=1
cargoCustom.maxDistance=8
cargoCustom:addFactionReward(G.EMPIRE)
cargoCustom.validStartPlanet=function(self,c_planet)
		local planet=planet_class.load(c_planet)
		return planet.lua.settlements and planet.lua.settlements.humans
	end
cargoCustom.validEndPlanet=function(self,c_planet)
		local planet=planet_class.load(c_planet)
		return planet.lua.settlements and planet.lua.settlements.humans and (planet.lua.settlements.humans:hasActiveEffect("empire_barbarian_raid"))
	end
table.insert(cargo_custom.types,cargoCustom)


cargoCustom=cargomission_class.createNew()
cargoCustom.id="fringe_barbarian_help"
cargoCustom.osd_title="Urgent Medical Help"
cargoCustom.misn_title_urgent = "${urgencyAdj} medical help for ${targetWorld} (Space: ${quantity} tonnes)"
cargoCustom.misn_desc_urgent = "${quantity} tonnes of urgent medical help is needed on ${targetWorld} in the ${targetSystem} system following the recent barbarian raids. It must reach before the ${deadline} (time left: ${timeRemaining})."

cargoCustom.land_msg={"${targetWorld}'s spaceport is a ruin, with makeshift facilities barely operational. Clearly the damages suffered were much bigger than announced on the news. A harried crew takes your crate and they are rushed onward to makeshift hospitals."}
cargoCustom.land_msg_late={"${targetWorld}'s spaceport is a ruin, with makeshift facilities barely operational. Clearly the damages suffered were much bigger than announced on the news. A harried crew takes your crate and they are rushed onward to makeshift hospitals; your late arrival means they've run out."}
cargoCustom.commodities={C.MEDICINE}
cargoCustom.priceFactor=1.5
cargoCustom.minRushLevel=2
cargoCustom.maxRushLevel=4
cargoCustom.minCargoSize=20
cargoCustom.maxCargoSize=100
cargoCustom.minDistance=1
cargoCustom.maxDistance=8
cargoCustom:addFactionReward(G.INDEPENDENT_WORLDS)
cargoCustom.validStartPlanet=function(self,c_planet)
		local planet=planet_class.load(c_planet)
		return planet.lua.settlements and planet.lua.settlements.humans
	end
cargoCustom.validEndPlanet=function(self,c_planet)
		local planet=planet_class.load(c_planet)
		return planet.lua.settlements and planet.lua.settlements.humans and (planet.lua.settlements.humans:hasActiveEffect("fringe_barbarian_raid"))
	end
table.insert(cargo_custom.types,cargoCustom)



cargoCustom=cargomission_class.createNew()
cargoCustom.id="empire_plague_medical_help"
cargoCustom.osd_title="Urgent Medical Help"
cargoCustom.misn_title_urgent = "${urgencyAdj} medical help for ${targetWorld} (Space: ${quantity} tonnes)"
cargoCustom.misn_desc_urgent = "${quantity} tonnes of urgent medical help is needed on ${targetWorld} in the ${targetSystem} system due to the ongoing plague. It must reach before the ${deadline} (time left: ${timeRemaining})."

cargoCustom.land_msg={"${targetWorld}'s spaceport is near-silent, under tight control of police officers enforcing the quarantine. Your cargo is unloaded by masked men who make it disappear in a closed-down wing of the facilities. An officer pays you and makes it clear you're to leave as soon as your business is done."}
cargoCustom.land_msg_late={"${targetWorld}'s spaceport is near-silent, under tight control of police officers enforcing the quarantine. Your cargo is unloaded by masked men who make it disappear in a closed-down wing of the facilities. An officer pays you ${paymentPartial} of the ${payment} credits due to your late arrival and makes it clear you're to leave as soon as your business is done."}
cargoCustom.commodities={C.MEDICINE}
cargoCustom.priceFactor=1.5
cargoCustom.minRushLevel=2
cargoCustom.maxRushLevel=4
cargoCustom.minCargoSize=20
cargoCustom.maxCargoSize=100
cargoCustom.minDistance=1
cargoCustom.maxDistance=8
cargoCustom:addFactionReward(G.EMPIRE)
cargoCustom.validStartPlanet=function(self,c_planet)
		local planet=planet_class.load(c_planet)
		return planet.lua.settlements and planet.lua.settlements.humans
	end
cargoCustom.validEndPlanet=function(self,c_planet)
		local planet=planet_class.load(c_planet)
		return planet.lua.settlements and planet.lua.settlements.humans and planet.lua.settlements.humans:hasActiveEffect("empire_plague")
	end
table.insert(cargo_custom.types,cargoCustom)


--Fringe
cargoCustom=cargomission_class.createNew()
cargoCustom.id="fringe_alien_fungus"
cargoCustom.osd_title="Famine Relief"
cargoCustom.misn_title_urgent = "${urgencyAdj} famine relief for ${targetWorld} (Space: ${quantity} tonnes)"
cargoCustom.misn_desc_urgent = "${quantity} tonnes of food are urgently needed ${targetWorld} in the ${targetSystem} system following crop failures caused by an alien fungus. It must reach before the ${deadline} (time left: ${timeRemaining})."

cargoCustom.land_msg={"${targetWorld}'s spaceport is a hub of activity, with food help from the Empire and traders pouring in. Your cargo is handled promptly and professionally, though you cannot help but notice the sunken cheeks of the spaceport workers."}
cargoCustom.land_msg_late={"${targetWorld}'s spaceport is a hub of activity, with food help from the Empire and traders pouring in. Your cargo is handled promptly and professionally, though you cannot help but notice the sunken cheeks of the spaceport workers - your delay might have played a part."}
cargoCustom.commodities={C.FOOD}
cargoCustom.priceFactor=2
cargoCustom.minRushLevel=2
cargoCustom.maxRushLevel=4
cargoCustom.minCargoSize=20
cargoCustom.maxCargoSize=100
cargoCustom.minDistance=1
cargoCustom.maxDistance=8
cargoCustom:addFactionReward(G.INDEPENDENT_WORLDS)
cargoCustom.validStartPlanet=function(self,c_planet)
		return c_planet:faction()==faction.get(G.EMPIRE)
	end
cargoCustom.validEndPlanet=function(self,c_planet)
		local planet=planet_class.load(c_planet)
		return planet.lua.settlements and planet.lua.settlements.humans and planet.lua.settlements.humans:hasActiveEffect("fringe_alienfungus")
	end
table.insert(cargo_custom.types,cargoCustom)


--Roidhunate

cargoCustom=cargomission_class.createNew()
cargoCustom.id="ardar_settlers"
cargoCustom.osd_title="Ardar Settlers"
cargoCustom.misn_title = "Ardar settlers for ${targetWorld} (Space: ${quantity} tonnes)"
cargoCustom.misn_desc = "Ardar settlers are heading for ${targetWorld} in the ${targetSystem} system, following the recently-announced Ardar settlement program there. They'll need ${quantity} tonnes of space refitted as temporary accommodation."
cargoCustom.misn_title_urgent = "${urgencyAdj} Ardar settlers for ${targetWorld} (Space: ${quantity} tonnes)"
cargoCustom.misn_desc_urgent = "Ardar settlers are heading for ${targetWorld} in the ${targetSystem} system, following the recently-announced Ardar settlement program there. They'll need ${quantity} tonnes of space refitted as temporary accommodation. They must reach before the ${deadline} (time left: ${timeRemaining})."

cargoCustom.land_msg={"The settlers exit your ship, enthusiastically looking at their new home, breathing ${targetWorld}'s heady frontier air. Their reactions are almost human, and it reminds you of similar scenes involving Terran settlers - the kind you rarely see any more outside of historical holovids."}
cargoCustom.land_msg_late={"The settlers exit your ship, enthusiastically looking at their new home, breathing ${targetWorld}'s heady frontier air. Their reactions are almost human, and it reminds you of similar scenes involving Terran settlers - the kind you rarely see any more outside of historical holovids.\n\nThey are so taken with the sights they do not even grumble at your late arrival."}
cargoCustom.commodities={"Ardar Settlers"}
cargoCustom.priceFactor=1.5
cargoCustom.minRushLevel=0
cargoCustom.maxRushLevel=1
cargoCustom.minCargoSize=20
cargoCustom.maxCargoSize=100
cargoCustom.minDistance=1
cargoCustom.maxDistance=8
cargoCustom:addFactionReward(G.ROIDHUNATE)
cargoCustom.validStartPlanet=function(self,c_planet)
		local planet=planet_class.load(c_planet)
		return planet.lua.settlements and planet.lua.settlements.ardars
	end
cargoCustom.validEndPlanet=function(self,c_planet)
		local planet=planet_class.load(c_planet)
		return planet.lua.settlements and planet.lua.settlements.ardars and planet.lua.settlements.ardars:hasActiveEffect("ardar_settlers")
	end
table.insert(cargo_custom.types,cargoCustom)




cargoCustom=cargomission_class.createNew()
cargoCustom.id="ardar_hunting_weapons"
cargoCustom.osd_title="Hunting Weapons"
cargoCustom.misn_title_urgent = "${urgencyAdj} hunting weapons for hunt on ${targetWorld} (Space: ${quantity} tonnes)"
cargoCustom.misn_desc_urgent = "A party of Ardar nobles have requested the delivery of ${quantity} tonnes of hunting weapons for their hunt on ${targetWorld} in the ${targetSystem} system. It must reach before the ${deadline} (time left: ${timeRemaining})."

cargoCustom.land_msg={"The nobles' servants are waiting when your ship lands and hurriedly collect the delivered weapons. Tomorrow will be a great hunting day!"}
cargoCustom.land_msg={"The nobles' servants are waiting when your ship lands and hurriedly collect the delivered weapons, protesting at your late arrival. Tomorrow will be a great hunting day!"}
cargoCustom.commodities={C.NATIVE_WEAPONS}
cargoCustom.priceFactor=1.5
cargoCustom.minRushLevel=1
cargoCustom.maxRushLevel=4
cargoCustom.minCargoSize=5
cargoCustom.maxCargoSize=50
cargoCustom.minDistance=1
cargoCustom.maxDistance=8
cargoCustom:addFactionReward(G.ROIDHUNATE)
cargoCustom.validStartPlanet=function(self,c_planet)
		local planet=planet_class.load(c_planet)
		return planet.lua.settlements and planet.lua.settlements.ardars
	end
cargoCustom.validEndPlanet=function(self,c_planet)
		local planet=planet_class.load(c_planet)
		return planet.lua.settlements and planet.lua.settlements.ardars and planet.lua.settlements.ardars:hasActiveEffect("ardar_greathunt")
	end
table.insert(cargo_custom.types,cargoCustom)



cargoCustom=cargomission_class.createNew()
cargoCustom.id="ardar_gourmetfood"
cargoCustom.osd_title="Ardar Gourmet Food"
cargoCustom.misn_title = "Festival food delivery to ${targetWorld} (${quantity} tonnes)"
cargoCustom.misn_title_urgent = "${urgencyAdj} festival food transport to ${targetWorld} (${quantity} tonnes)"
cargoCustom.misn_desc = "An Ardar noble on ${targetWorld} in the ${targetSystem} system has placed an order for ${quantity} tonnes of gourmet Ardar food from the festival."
cargoCustom.misn_desc_urgent = "An Ardar noble on ${targetWorld} in the ${targetSystem} system has placed an order for ${quantity} tonnes of gourmet Ardar food from the festival. It must reach before the ${deadline} (time left: ${timeRemaining})."
cargoCustom.land_msg={"The Ardar noble's servants quickly and efficiently unload the crates and ship them to his estate."}
cargoCustom.land_msg_late={"The Ardar noble's servants quickly and efficiently unload the crates and ship them to his estate. His household head is furious at the delay and pays only ${paymentPartial} of the ${payment} credits agreed."}
cargoCustom.commodities={C.GOURMET_FOOD}
cargoCustom.priceFactor=1.5
cargoCustom.minCargoSize=5
cargoCustom.maxCargoSize=10
cargoCustom.minDistance=1
cargoCustom.maxDistance=5
cargoCustom:addFactionReward(G.ARDAR_TRADERS)
cargoCustom.validStartPlanet=function(self,c_planet)
		local planet=planet_class.load(c_planet)
		return planet.lua.settlements and planet.lua.settlements.ardar and planet.lua.settlements.ardar:hasActiveEffect("ardar_foodfestival")
	end
cargoCustom.validEndPlanet=function(self,c_planet)
		local planet=planet_class.load(c_planet)
		return planet.lua.settlements and planet.lua.settlements.ardar and planet.lua.settlements.ardar.services > 0.7
	end
table.insert(cargo_custom.types,cargoCustom)



--Betelgeuse

cargoCustom=cargomission_class.createNew()
cargoCustom.id="betelgeuse_trade_flet_preparation"
cargoCustom.osd_title="Goods for trade fleet"
cargoCustom.misn_title_urgent = "${urgencyAdj} goods for trade fleet on ${targetWorld} (Space: ${quantity} tonnes)"
cargoCustom.misn_desc_urgent = "${quantity} tonnes of ${commodity} is needed by the trade fleet assembling on ${targetWorld} in the ${targetSystem} system. It must reach before the ${deadline} (time left: ${timeRemaining})."

cargoCustom.land_msg={"${targetWorld}'s spaceport is bustling with preparations, with dozens of technicians surrounding each of the massive Betelgian trade ships. You've barely landed that your cargo is hurriedly unloaded and forwarded to a waiting ship. Excitement is palpable in the air; here is the real glory of Betelgeuse, in the sleek lines of the ships tasked with exploring the unknown, not in the refined palaces of the princes or the store rooms filled with precious goods."}
cargoCustom.land_msg_late={"${targetWorld}'s spaceport is bustling with preparations, with dozens of technicians surrounding each of the massive Betelgian trade ships. You've barely landed that your cargo is hurriedly unloaded and forwarded to a waiting ship. Excitement is palpable in the air; here is the real glory of Betelgeuse, in the sleek lines of the ships tasked with exploring the unknown, not in the refined palaces of the princes or the store rooms filled with precious goods.\n\nYou being late costs you a fine, and you're paid only ${paymentPartial} of the ${payment} credits."}
cargoCustom.commodities={C.BASIC_TOOLS,C.BASIC_WEAPONS,C.PRIMITIVE_CONSUMER,C.PRIMITIVE_INDUSTRIAL}
cargoCustom.priceFactor=2
cargoCustom.minRushLevel=2
cargoCustom.maxRushLevel=5
cargoCustom.minCargoSize=20
cargoCustom.maxCargoSize=100
cargoCustom.minDistance=1
cargoCustom.maxDistance=8
cargoCustom:addFactionReward(G.BETELGEUSE)
cargoCustom.validStartPlanet=function(self,c_planet)
		local planet=planet_class.load(c_planet)
		return c_planet:faction()==faction.get(G.EMPIRE) or c_planet:faction()==faction.get(G.ROIDHUNATE) or c_planet:faction()==faction.get(G.BETELGEUSE)
	end
cargoCustom.validEndPlanet=function(self,c_planet)
		local planet=planet_class.load(c_planet)
		return planet.lua.settlements and planet.lua.settlements.betelgeuse and planet.lua.settlements.betelgeuse:hasActiveEffect("betelgeuse_fleetleaving")
	end
table.insert(cargo_custom.types,cargoCustom)




cargo_custom.typesById={}
for k,v in pairs(cargo_custom.types) do
	cargo_custom.typesById[v.id]=v
end


-- Royal Ixum

cargoCustom=cargomission_class.createNew()
cargoCustom.id="royalixum_bombingraid"
cargoCustom.osd_title="Urgent Humanitarian Help"
cargoCustom.misn_title_urgent = "${urgencyAdj} humanitarian help for ${targetWorld} (Space: ${quantity} tonnes)"
cargoCustom.misn_desc_urgent = "${quantity} tonnes of urgent humanitarian help is needed on ${targetWorld} in the ${targetSystem} system following the recent bombings by the Holy Flame. It must reach before the ${deadline} (time left: ${timeRemaining})."

cargoCustom.land_msg={"${targetWorld}'s spaceport looks even more damaged than before the recent raids. Royal officers have managed to reopen a small section to handle humanitarian relief, and that's about it. Your cargo is unloaded by hand, the usual equipment being out of order."}
cargoCustom.land_msg_late={"${targetWorld}'s spaceport looks even more damaged than before the recent raids. Royal officers have managed to reopen a small section to handle humanitarian relief, and that's about it. Your cargo is unloaded by hand, the usual equipment being out of order. Your late arrival reduces your fee."}
cargoCustom.commodities={C.MEDICINE,C.FOOD}
cargoCustom.priceFactor=2
cargoCustom.minRushLevel=2
cargoCustom.maxRushLevel=4
cargoCustom.minCargoSize=20
cargoCustom.maxCargoSize=100
cargoCustom.minDistance=1
cargoCustom.maxDistance=8
cargoCustom:addFactionReward(G.ROYAL_IXUM)
cargoCustom.validStartPlanet=function(self,c_planet)
		return c_planet:faction()==faction.get(G.EMPIRE) or c_planet:faction()==faction.get(G.ROYAL_IXUM)
	end
cargoCustom.validEndPlanet=function(self,c_planet)
		local planet=planet_class.load(c_planet)
		return planet.lua.settlements and planet.lua.settlements.royalixumites and (planet.lua.settlements.royalixumites:hasActiveEffect("royalixum_bombingraid"))
	end
table.insert(cargo_custom.types,cargoCustom)



cargoCustom=cargomission_class.createNew()
cargoCustom.id="royalixum_militaryhelp"
cargoCustom.osd_title="Dispatch Terran Military Help"
cargoCustom.misn_title_urgent = "${urgencyAdj} military help for ${targetWorld} (Space: ${quantity} tonnes)"
cargoCustom.misn_desc_urgent = "${quantity} tonnes of Terran military help must be shipped to ${targetWorld} in the ${targetSystem} system. It must reach before the ${deadline} (time left: ${timeRemaining})."

cargoCustom.land_msg={"The Royal Ixum military spaceport is a mess; it looks it has suffered damages, only hastily repaired. A gruff-looking sergeant processes your papers while exhausted-looking grunts unload your cargo."}
cargoCustom.land_msg_late={"The Royal Ixum military spaceport is a mess; it looks it has suffered damages, only hastily repaired. While exhausted-looking grunts unload your cargo, a furious sergeant berates you for the late shipment. You end up getting ${paymentPartial} of the ${payment} credits promised, and an earful as a bonus."}
cargoCustom.commodities={C.MODERN_ARMAMENT,C.ARMAMENT}
cargoCustom.priceFactor=2
cargoCustom.minRushLevel=2
cargoCustom.maxRushLevel=4
cargoCustom.minCargoSize=20
cargoCustom.maxCargoSize=100
cargoCustom.minDistance=1
cargoCustom.maxDistance=8
cargoCustom:addFactionReward(G.ROYAL_IXUM)
cargoCustom.validStartPlanet=function(self,c_planet)
		local planet=planet_class.load(c_planet)

		return c_planet:faction()==faction.get(G.ROYAL_IXUM) and planet.lua.settlements and planet.lua.settlements.royalixumites and (planet.lua.settlements.royalixumites:hasActiveEffect("royalixum_imperialhelp"))
	end
cargoCustom.validEndPlanet=function(self,c_planet)
		return c_planet:faction()==faction.get(G.ROYAL_IXUM)
	end
table.insert(cargo_custom.types,cargoCustom)



--Holy Flame

cargoCustom=cargomission_class.createNew()
cargoCustom.id="holyflame_bombingraid"
cargoCustom.osd_title="Urgent Reconstruction Help"
cargoCustom.misn_title_urgent = "${urgencyAdj} reconstruction help for ${targetWorld} (Space: ${quantity} tonnes)"
cargoCustom.misn_desc_urgent = "${quantity} tonnes of urgent reconstruction help is needed on ${targetWorld} in the ${targetSystem} system following the recent bombings by the Kingdom of Ixum. It must reach before the ${deadline} (time left: ${timeRemaining})."
cargoCustom.land_msg={"The Holy Flame spaceport is chaos incarnated; nobody seems to know how to process deliveries. You finally locate a stern-looking minor officer that organises the unloading and your payment, though he is clearly unhappy at dealing with an infidel."}
cargoCustom.land_msg_late={"The Holy Flame spaceport is chaos incarnated; nobody seems to know how to process deliveries. You finally locate a stern-looking minor officer that organises the unloading and your payment, though he is clearly unhappy at dealing with an infidel. When he realises that you are late, he becomes incandescent you are lucky to get even ${paymentPartial} of the ${payment} credits promised."}
cargoCustom.commodities={C.INDUSTRIAL,C.PRIMITIVE_INDUSTRIAL}
cargoCustom.priceFactor=2
cargoCustom.minRushLevel=2
cargoCustom.maxRushLevel=4
cargoCustom.minCargoSize=20
cargoCustom.maxCargoSize=100
cargoCustom.minDistance=1
cargoCustom.maxDistance=8
cargoCustom:addFactionReward(G.HOLY_FLAME)
cargoCustom.validStartPlanet=function(self,c_planet)
		return c_planet:faction()==faction.get(G.ROIDHUNATE) or c_planet:faction()==faction.get(G.HOLY_FLAME)
	end
cargoCustom.validEndPlanet=function(self,c_planet)
		local planet=planet_class.load(c_planet)
		return planet.lua.settlements and planet.lua.settlements.holyflame and (planet.lua.settlements.holyflame:hasActiveEffect("holyflame_bombingraid"))
	end
table.insert(cargo_custom.types,cargoCustom)



cargoCustom=cargomission_class.createNew()
cargoCustom.id="holyflame_refugees"
cargoCustom.osd_title="Ixumite Refugees"
cargoCustom.misn_title = "Ixumite Refugees for ${targetWorld} (Space: ${quantity} tonnes)"
cargoCustom.misn_desc = "Refugees fleeing persecution need safe travel to ${targetWorld} in the ${targetSystem} system. They'll need ${quantity} tonnes of space refitted as temporary accommodation."

cargoCustom.land_msg={"The exhausted refugees exit your ship, penny-less but safe, ready to start a new life on ${targetWorld} - provided the Holy Flame does not manage to overrun it as well."}
cargoCustom.commodities={"Ixumite Refugees"}
cargoCustom.priceFactor=2
cargoCustom.minRushLevel=0
cargoCustom.maxRushLevel=0
cargoCustom.minCargoSize=20
cargoCustom.maxCargoSize=100
cargoCustom.minDistance=1
cargoCustom.maxDistance=8
cargoCustom:addFactionReward(G.ROYAL_IXUM)
cargoCustom.validStartPlanet=function(self,c_planet)
		local planet=planet_class.load(c_planet)
		return planet.lua.settlements and planet.lua.settlements.holyflame and planet.lua.settlements.holyflame:hasActiveEffect("holyflame_minoritydeparture")
	end
cargoCustom.validEndPlanet=function(self,c_planet)
		return c_planet:faction()==faction.get(G.ROYAL_IXUM)
	end
table.insert(cargo_custom.types,cargoCustom)