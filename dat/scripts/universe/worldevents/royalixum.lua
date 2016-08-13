event=worldevent_class.createNew()
event.eventMessage="NEWS ALERT: Holy Flame bombing raids on ${world}; important casualties reported, food and medicine urgently needed."
event.weight=10
event.duration=time.create(0,0,15, 0, 0, 0 )
event.weightValidity=function(planet)
	return (planet.c:faction()==faction.get(G.ROYAL_IXUM) and planet.lua.settlements.royalixumites and planet.c:system():presence(G.HOLY_FLAME)>20 and planet.lua.planet==nil)
end
event.applyOnWorldCustom=function(self,planet,textData)
	textData.casualties=gh.prettyLargeNumber(planet.lua.settlements.royalixumites.population*0.05)
	planet.lua.settlements.royalixumites.population=planet.lua.settlements.royalixumites.population*0.95
	
	local effectId=planet.lua.settlements.royalixumites:addActiveEffect("The recent bombing is increasing demands for medicine and food.",
		(time.get() + self.duration):tonumber(), "royalixum_bombingraid" )
	planet.lua.settlements.royalixumites:addGoodDemand(C.MEDICINE,200,3,effectId)
	planet.lua.settlements.royalixumites:addGoodDemand(C.FOOD,200,3,effectId)
end
event.worldHistoryMessage="Major bombing raids by the Holy Flame caused ${casualties} civilian casualties."

event:addBarNews(G.ROYAL_IXUM,"${world} resists bombing raid","Grave news are coming in from ${world}, where the fanatic rebels have once again committed atrocities against their fellow Ixumites, using indiscriminate orbital bombardment against civilian populations despite our gallant navy fighting them heroically. The King himself mourns for his people, and urges them to keep up the fight!")
event:addBarNews(G.HOLY_FLAME,"${world} tastes divine fire","Brothers and sisters, the Flame herself has granted us another victory over the corrupt tyrants! On ${world}, bastion of the faithless, our holy navy has given them a taste of the divine wrath. If it is Her will, soon the would-be king himself will fall.")
event:addBarNews(G.EMPIRE,"Flame atrocities against ${world}","Our loyal ally the Kingdom of Ixum was targeted again on ${world} by the Roidhunate proxies, the so-called Holy Flame fanatics. With Imperial help, the legitimate King will one day hold those criminals to account!")
event:addBarNews(G.ROIDHUNATE,"Victory against the degenerate tyrants on ${world}","The fleets of our comrades the Order of the Holy Flame dealt a stinging blow to the degenerate Ixum monarchy on ${world}. Be warned, Emperor! One day the same will be done to Terra if it keeps opposing our legitimate expansion.")
table.insert(world_events.events,event)




event=worldevent_class.createNew()
event.eventMessage="NEWS ALERT: Riots against the King on ${world}; economy at standstill."
event.weight=20
event.duration=time.create(0,1,0, 0, 0, 0 )
event.weightValidity=function(planet)
	return (planet.c:faction()==faction.get(G.ROYAL_IXUM) and planet.lua.settlements.royalixumites and planet.lua.settlements.royalixumites:hasTag("slums") and planet.lua.planet==nil)
end
event.applyOnWorldCustom=function(self,planet,textData)
	local effectId=planet.lua.settlements.royalixumites:addActiveEffect("Ongoing riots are reducing consumer goods supply.",
		(time.get() + self.duration):tonumber(), "royalixum_riots" )
	planet.lua.settlements.royalixumites:reduceGoodSupply(C.CONSUMER_GOODS,500,3,effectId)
	planet.lua.settlements.royalixumites:reduceGoodSupply(C.PRIMITIVE_CONSUMER,500,3,effectId)
end
event.worldHistoryMessage="Widespread riots erupted against the Monarchy."

event:addBarNews(G.ROYAL_IXUM,"Flame supporters on ${world} behind agitation","Flame agitators' attempts at creating dissent against our Most Glorious King on ${world} are being rightfully stamped out by local security forces assisted by loyal subjects of His Majesty. Long may His Reign last!")
event:addBarNews(G.HOLY_FLAME,"${world} revolts against tyranny!","Our Brothers and Sisters on ${world} are rising against the Tyrant and his lackeys, eager to join our righteous Order. May the Holy Flame guide their path toward us!")
table.insert(world_events.events,event)



event=worldevent_class.createNew()
event.eventMessage="NEWS ALERT: Imperial military help reaches ${world}, armament to be distributed."
event.weight=20
event.duration=time.create(0,1,0, 0, 0, 0 )
event.weightValidity=function(planet)
	return (planet.c:faction()==faction.get(G.ROYAL_IXUM) and planet.lua.settlements.royalixumites and planet.lua.settlements.royalixumites:hasTag("weaponcentre") and planet.lua.planet==nil)
end
event.applyOnWorldCustom=function(self,planet,textData)
	local effectId=planet.lua.settlements.royalixumites:addActiveEffect("Important Imperial military help is flooding the market with weapons.",
		(time.get() + self.duration):tonumber(), "royalixum_imperialhelp" )
	planet.lua.settlements.royalixumites:addGoodSupply(C.MODERN_ARMAMENT,300,0.5,effectId)
	planet.lua.settlements.royalixumites:addGoodSupply(C.ARMAMENT,1000,0.5,effectId)
end
event.worldHistoryMessage="Massive Imperial military help reaches the world."

event:addBarNews(G.ROYAL_IXUM,"Imperial help reaches ${world}!","A large supply of modern armament has reached ${world} from our Imperial allies and is being distributed throughout the Kingdom. With the help of our loyal allies, we shall push back against the bloodthirsty priests!")
event:addBarNews(G.HOLY_FLAME,"Big Tyrant helps Small Tyrant","Faithful allies on ${world} informs us of the arrival of new weapons from the Empire to help the tyrannical forces of the faithless. We tell the Terran Emperor: with the Flame on our side, we do not fear your weapons! The Small Tyrant will fall, and one day so shall you!")
event:addBarNews(G.EMPIRE,"Imperial help for our Ixumite allies","The Empire demonstrated again its steadfast support for its ally the Kingdom of Ixum with the shipment of military help to ${world}. May the Royal forces use it wisely against the barbarous Flame supporters!")
event:addBarNews(G.ROIDHUNATE,"In blow for peace, the Empire supports the Ixumite tyrant","For all its talk of promoting peace in the Galaxy, the Empire showed its true colours again with its shipment of military help to the Ixumite tyrant on ${world}. Rest assured that the Roidhunate's allies, the Holy Flame Order, will make short work of those weapons thanks to its superior Ardar-designed ships.")
table.insert(world_events.events,event)