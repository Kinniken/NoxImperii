event=worldevent_class.createNew()
event.weightValidity=function(planet)
	return (planet.c:faction()==faction.get(G.ROIDHUNATE) and planet.lua.settlements.natives and planet.lua.settlements.natives.stability<1 and planet.lua.planet==nil)
end
event.weight=10
event.applyOnWorldCustom=function(self,planet,textData)
	textData.natives=planet.lua.settlements.natives.name
	textData.casualties=gh.prettyLargeNumber(planet.lua.settlements.natives.population*0.05)
	planet.lua.settlements.natives.population=planet.lua.settlements.natives.population*0.95
	
	local effectId=planet:addActiveEffect("natives","Harsh repression of the native population is driving them to arms.",
		(time.get() + time.create( 0,2,0, 0, 0, 0 )):tonumber(),"roidhunate_native_repression" )
	planet.lua.settlements.natives:addGoodDemand(C.BASIC_WEAPONS,200,3,effectId)
end
event.eventMessage="NEWS ALERT: Native uprising on ${world} in response to Ardar repression, arm sales boom."

event.worldHistoryMessage="${casualties} ${natives} casualties reported in a ferocious Ardar repression campaign, leading to more unrest."

event:addBarNews(G.EMPIRE,"Ardar Atrocities Reported On Frontier World","Reports are coming in of a major wave of repression hitting natives on ${world}, with casualties estimated at ${casualties}. This unfortunate world was recently annexed by the nefarious Roidhunate, and the gallant ${natives} have been fighting hard against the hated invaders. While the Empire is sadly too far to aid them in their just struggle, we wish them all the best against their reptilian foes.",time.create(0,2,0, 0,0,0))

event:addBarNews(G.ROIDHUNATE,"Pacification of ${world} in progress","Recent troubles on ${world} are coming to an end thanks to the prompt and vigorous intervention of the Ardar army. The efforts of suspected Terran agitators is believed to be behind the recent events, as the loyalty of the ${natives} to the Roidhunate is beyond doubts.",time.create(0,2,0, 0,0,0))
table.insert(world_events.events,event)




event=worldevent_class.createNew()
event.weightValidity=function(planet)
	return (planet.c:faction()==faction.get(G.ROIDHUNATE) and planet.lua.settlements.ardars and planet.c:system():presence(G.BARBARIANS)>0 and planet.lua.planet==nil)
end
event.weight=5
event.duration=time.create( 0,2,0, 0, 0, 0 )
event.applyOnWorldCustom=function(self,planet,textData)
	textData.arrivals=gh.prettyLargeNumber(planet.lua.settlements.ardars.population*0.3)
	planet.lua.settlements.ardars.population=planet.lua.settlements.ardars.population*1.3
	
	local effectId=planet:addActiveEffect("ardars","Demand for industrial goods increase to accommodate new settlers.",
		(time.get() + self.duration):tonumber(),"ardar_settlers" )
	planet.lua.settlements.ardars:addGoodDemand(C.INDUSTRIAL,200,2,effectId)
	planet.lua.settlements.ardars:addGoodDemand(C.PRIMITIVE_INDUSTRIAL,200,2,effectId)
	
end
event.eventMessage="NEWS ALERT: The Roidhunate launches a massive settlement program on ${world}. Industrial supplies urgently needed!"

event.worldHistoryMessage="${arrivals} new Ardar settlers move in as part of new government program."

event:addBarNews(G.ROIDHUNATE,"The Roidhunate strengthens colonization efforts","The Roidhunate is launching a new colonization program aimed at strengthening our hold over ${world}. ${arrivals} settlers are being moved to the planet; demand for industrial goods increases to cope with the arrivals.")
table.insert(world_events.events,event)




event=worldevent_class.createNew()
event.weightValidity=function(planet)
	return (planet.c:faction()==faction.get(G.ROIDHUNATE) and planet.lua.settlements.ardars and planet.lua.settlements.ardars.industry>1 and planet.lua.settlements.ardars.technology>1 and planet.lua.planet==nil)
end
event.weight=20
event.applyOnWorldCustom=function(self,planet,textData)
	planet.lua.settlements.ardars.industry=planet.lua.settlements.ardars.industry*1.1
	
	local effectId=planet:addActiveEffect("ardars","Major ship-building program drives prices of armament.",
		(time.get() + time.create( 0,2,0, 0, 0, 0 )):tonumber(), "roidhunate_navyshipbuilding" )
	planet.lua.settlements.ardars:addGoodDemand(C.ARMAMENT,200,2,effectId)
	planet.lua.settlements.ardars:addGoodDemand(C.MODERN_ARMAMENT,100,2,effectId)
	
end
event.eventMessage="NEWS ALERT: New ship-building program by the Ardar Navy drives up armament prices on ${world}."

event.worldHistoryMessage="A Roidhunate ship-building campaign stimulated the local economy."

event:addBarNews(G.ROIDHUNATE,"New ship-building campaign to strengthen the Ardar Navy","The Roidhun in person has ordered a new program to boost the Ardar Navy; several new dreadnoughts will be built on ${world}. The announcement has sent prices of armament booming on the planet. Glory to the Ardar Navy!",time.create(0,2,0, 0,0,0))
event:addBarNews(G.EMPIRE,"Jingoist Roidhunate on ship-building frenzy","The militaristic and aggressive Ardars are thought to have ordered the construction of yet more ships on ${world}. Imperial experts affirm that this is only idle bluster and that the Imperial Navy would make short work of the new ships.",time.create(0,2,0, 0,0,0))
table.insert(world_events.events,event)


event=worldevent_class.createNew()
event.weightValidity=function(planet)
	return (planet.c:faction()==faction.get(G.ROIDHUNATE) and planet.lua.settlements.ardars and planet.lua.settlements.ardars:hasTag("hightechcenter") and planet.lua.planet==nil)
end
event.weight=50--high because so little world qualify
event.applyOnWorldCustom=function(self,planet,textData)
	planet.lua.settlements.ardars.industry=planet.lua.settlements.ardars.industry*1.1
	
	local effectId=planet:addActiveEffect("ardars","Pioneering industrial techniques is boosting the production of modern armament.",
		(time.get() + time.create( 0,2,0, 0, 0, 0 )):tonumber(), "roidhunate_innovativearmament" )
	planet.lua.settlements.ardars:addGoodSupply(C.MODERN_ARMAMENT,300,0.5,effectId)
	
end
event.eventMessage="NEWS ALERT: The Ardar research centre on ${world} has developed new technologies boosting armament production."

event.worldHistoryMessage="Technical innovations drove an armament production boom."

event:addBarNews(G.ROIDHUNATE,"Innovative technology drives armament production on ${world}","The Ardar Navy research centre on ${world} is making breakthrough in modern armament production, boosting production and reducing prices! Every passing day the dominance of the Roidhunate in military technology grows more assured.",time.create(0,2,0, 0,0,0))
table.insert(world_events.events,event)




event=worldevent_class.createNew()
event.weightValidity=function(planet)
	return (planet.c:faction()==faction.get(G.ROIDHUNATE) and planet.lua.settlements.ardars and planet.lua.settlements.ardars:hasTag("huntingreserve") and planet.lua.planet==nil)
end
event.weight=50--high because so little worlds qualify
event.duration=time.create( 0,1,0, 0, 0, 0 )
event.applyOnWorldCustom=function(self,planet,textData)
	
	local effectId=planet:addActiveEffect("ardars","The Great Hunt in progress is driving strong demand for native weapons and exotic food.",
		(time.get() + self.duration):tonumber(),"ardar_greathunt" )
	planet.lua.settlements.ardars:addGoodDemand(C.NATIVE_WEAPONS,300,5,effectId)
	
end
event.eventMessage="NEWS ALERT: Ardar nobles gather on ${world} for great hunt; exotic weapons in high demand."

event.worldHistoryMessage="A Great Hunt was held to much acclaim by participating nobles."

event:addBarNews(G.ROIDHUNATE,"Ardar nobles prove their valour in Great Hunt","A Great Hunt is currently being held on ${world} by a cousin of the Roidhun himself. Nobles from the entire sector are gathering, keen to prove their strength and courage. Mighty is the Roidhunate, to be led by such people!")
event:addBarNews(G.EMPIRE,"Barbarous display by bloodthirsty Ardars","Ardar petty chiefs have gathered on ${world} to compete in bloody display of animal slaughter. We debate at noon: can the Roidhunate be considered anything more than an overgrown barbarian kingdom?")
table.insert(world_events.events,event)




event=worldevent_class.createNew()
event.weightValidity=function(planet)
	return (planet.c:faction()==faction.get(G.ROIDHUNATE) and planet.lua.settlements.ardars and planet.lua.planet==nil)
end
event.weight=5
event.duration=time.create( 0,1,0, 0, 0, 0 )
event.applyOnWorldCustom=function(self,planet,textData)

	textData.poet=nameGenerator.generateNameArdarshir()
	textData.hero=nameGenerator.generateNameArdarshir()
	
	local effectId=planet:addActiveEffect("ardars","The recital of a great new epic tale is boosting demand for ancient weapons.",
		(time.get() + self.duration):tonumber(), "roidhunate_epicrecital" )
	planet.lua.settlements.ardars:addGoodDemand(C.NATIVE_WEAPONS,300,5,effectId)
	
end
event.eventMessage="NEWS ALERT: Recital of great Ardar epic tale bring masses to ${world}, inspires fad for ancient weapons."

event.worldHistoryMessage="Local poet ${poet} pens the Tale of ${hero}, is acclaimed throughout the Roidhunate."

event:addBarNews(G.ROIDHUNATE,"New Epic Tale inspires martial prowess",
	"Famous poet ${poet} of ${world} has started a recital of his new epic, \"The Tale of ${hero}\". The full recital will take thirty days, but the work is already hailed as the equal of ancient masterpieces. Local demand for bladed weapons soars as the Tale promotes a revival of fencing arts.")
event:addBarNews(G.EMPIRE,"Latest Ardar tale fails to impress",
	"Art critics throughout the Empire are not impressed with the latest fad in the Roidhunate, the so-called \"Tale of ${hero}\". Penned by the would-be poet ${poet} of ${world}, it is yet an other ghastly tale of endless duels against various demons by the titular Ardar hero. And not only does it last thirty days, but word has it that it had started a passion for fencing on ${world}!")
table.insert(world_events.events,event)




event=worldevent_class.createNew()
event.weightValidity=function(planet)
	return (planet.c:faction()==faction.get(G.ROIDHUNATE) and planet.lua.settlements.ardars and planet.lua.planet==nil)
end
event.weight=5
event.duration=time.create( 0,2,0, 0, 0, 0 )
event.applyOnWorldCustom=function(self,planet,textData)

	textData.expert=getHumanFemaleName()

	planet.lua.settlements.ardars.stability=planet.lua.settlements.ardars.stability*0.95
	
	local effectId=planet:addActiveEffect("ardars","An anti-corruption drive is lowering demand and prices for luxury goods.",
		(time.get() + self.duration):tonumber(),"roidhunate_anticorruption" )
	planet.lua.settlements.ardars:reduceGoodDemand(C.LUXURY_GOODS,300,0.5,effectId)
	
end
event.eventMessage="NEWS ALERT: Crime syndicate uncovered on ${world}; prices of luxury goods collapses as corruption is rooted out."

event.worldHistoryMessage="A major crime syndicate is busted, hitting the luxury good market hard."

event:addBarNews(G.ROIDHUNATE,"Anti-Ardar elements rooted out",
	"A couple of minor officials on ${world} have been arrested for links with anti-Ardar criminals. Connections to Imperial crime Mafia are suspected. Justice will be swift and severe for the enemies of the Roidhun and the Ardar race!")
event:addBarNews(G.EMPIRE,"Ardar world of ${world} nest of crime, corruption",
	"Far from the image of righteousness and probity the Roidhunate likes to project, reports show the Ardar world of ${world} to be controlled by crime syndicates in collusion with corrupt officials. Leading expert on the Roidhunate ${expert} weights in: \"this goes all the way up to the Roidhun himself\".")
table.insert(world_events.events,event)



event=worldevent_class.createNew()
event.weightValidity=function(planet)
	return (planet.c:faction()==faction.get(G.ROIDHUNATE) and planet.lua.settlements.ardars and planet.lua.settlements.ardars:hasTag("minority") and planet.lua.planet==nil)
end
event.weight=50--tag-specific
event.duration=time.create( 0,1,0, 0, 0, 0 )
event.applyOnWorldCustom=function(self,planet,textData)

	textData.minority=planet.lua.settlements.ardars.minorityName

	planet.lua.settlements.ardars.stability=planet.lua.settlements.ardars.stability*0.95
	
	local effectId=planet:addActiveEffect("ardars","Protests are paralysing the local economy, leading to rising consumer good prices.",
		(time.get() + self.duration):tonumber() )
	planet.lua.settlements.ardars:reduceGoodDemand(C.LUXURY_GOODS,300,0.5,effectId)
	
end
event.eventMessage="NEWS ALERT: Protests by ${minority} minority paralyse economy on ${world}; price of customer goods shoot up."

event.worldHistoryMessage="Massive protests by the ${minority} minority shut down the local economy."

event:addBarNews(G.ROIDHUNATE,"Troublemakers perturb peaceful community",
	"The ${minority} minority of ${world} has recently been troubled by foreign agitators trying to exploit imaginary racial prejudice. The Roidhunate authorities have again reaffirmed the full equality of all Ardars and reminded them that the so-called dominance of Roidhunate Ardars steams only from superior qualifications.")
event:addBarNews(G.EMPIRE,"Roidhunate racism cause riots on ${world}",
	"The contempt held by Ardars for other species is well-known; we have recently had a reminder that they also discriminate among themselves. On ${world}, the ${minority} minority has been rioting to protest at the enduring discrimination they face from the Roidhunate Ardar majority. The authorities predictably reacted with violent repression.")
table.insert(world_events.events,event)





event=worldevent_class.createNew()
event.weightValidity=function(planet)
	return (planet.c:faction()==faction.get(G.ROIDHUNATE) and planet.lua.settlements.ardars and planet.lua.settlements.ardars:hasTag("oldcolony") and planet.lua.planet==nil)
end
event.weight=30--tag-specific
event.duration=time.create( 0,2,0, 0, 0, 0 )
event.applyOnWorldCustom=function(self,planet,textData)
	
	local effectId=planet:addActiveEffect("ardars","The celebration of the first settlement drives strong demand for food and luxury goods.",
		(time.get() + self.duration):tonumber() )
	planet.lua.settlements.ardars:addGoodDemand(C.LUXURY_GOODS,300,5,effectId)
	planet.lua.settlements.ardars:addGoodDemand(C.FOOD,800,5,effectId)
	
end
event.eventMessage="NEWS ALERT: The Ardar colony of ${world} celebrates its ancient heritage."

event.worldHistoryMessage="Great celebrations were held to commemorate the founding of the first colony."

event:addBarNews(G.ROIDHUNATE,"${world} celebrates its foundation",
	"The old colony of ${world} is celebrating its founding, one of the earliest in the Roidhunate. The planet's leading officials are gathering for two weeks of tributes to the pioneering spirit of the early settlers.")
table.insert(world_events.events,event)



event=worldevent_class.createNew()
event.weightValidity=function(planet)
	return (planet.c:faction()==faction.get(G.ROIDHUNATE) and planet.lua.settlements.ardars and planet.lua.settlements.ardars:hasTag("navyplanet") and planet.lua.planet==nil)
end
event.weight=50--tag-specific
event.duration=time.create( 0,2,0, 0, 0, 0 )
event.applyOnWorldCustom=function(self,planet,textData)
	
	local effectId=planet:addActiveEffect("ardars","The military parade is driving up the cost of food and other consumer goods.",
		(time.get() + self.duration):tonumber(),"roidhunate_militaryparade" )
	planet.lua.settlements.ardars:addGoodDemand(C.CONSUMER_GOODS,500,5,effectId)
	planet.lua.settlements.ardars:addGoodDemand(C.FOOD,800,5,effectId)
	
end
event.eventMessage="NEWS ALERT: Great military parade held on ${world}."

event.worldHistoryMessage="A great military parade brought together the entire world."

event:addBarNews(G.ROIDHUNATE,"Military parade on ${world} cheered by the population",
	"${world} is famous for its military spirit and contribution to the glorious Ardar Navy, and is proving it yet again with a major military parade held over two entire weeks. The Roidhun himself saluted this exemplary demonstration of martial spirit and adhesion to Ardar values.")
table.insert(world_events.events,event)




event=worldevent_class.createNew()
event.weightValidity=function(planet)
	return (planet.c:faction()==faction.get(G.ROIDHUNATE) and planet.lua.settlements.ardars and planet.lua.settlements.ardars:hasTag("gourmetfood") and planet.lua.planet==nil)
end
event.weight=50--tag-specific
event.duration=time.create( 0,2,0, 0, 0, 0 )
event.applyOnWorldCustom=function(self,planet,textData)
	
	local effectId=planet:addActiveEffect("ardars","Ardar Traditional Food Festival features gourmet food and Telloch at promotional prices.",
		(time.get() + self.duration):tonumber(),"ardar_foodfestival" )
	planet.lua.settlements.ardars:addGoodSupply(C.GOURMET_FOOD,500,0.5,effectId)
	planet.lua.settlements.ardars:addGoodSupply(C.TELLOCH,300,0.5,effectId)
	
end
event.eventMessage="NEWS ALERT: Ardar Traditional Food Festival starts on ${world}, special prices on offer."

event.worldHistoryMessage="A Traditional Food Festival highlighted Ardar food specialities."

event:addBarNews(G.ROIDHUNATE,"Virtues of Ardar Traditional Food showcased on ${world}",
	"A major food festival is starting on ${world}, promoting the virtues of traditional Ardar food. Far from the degenerate \"delicacies\" favoured in the Empire, Ardar food is renowned in the Galaxy for its healthy benefits and vigour-inducing properties! Special prices on offer.")
event:addBarNews(G.EMPIRE,"Ardar \"delicacies\" on display on ${world}",
	"In a hilarious development, the Ardar world of ${world} is holding a would-be gourmet food festival. Adventurers on a dare can try such delicacies as whole animals roasted in their own blood, snake-like creatures served raw in thin slices and soups of \"vigour-inducing\" roots of various kind. We'll stick with oysters, steak tartar and swallows' nests - civilized food for a civilized race.")
table.insert(world_events.events,event)




--[[
TODO

Space: ${world}'s military production targets met a year in advance, excess available for export
Effect: targets of military good production were met in advance, leading to availability of cheaper weapons.
History: Military goods production targets were fulfilled in advance, to great acclaim
News: The Roidhunate's industrial might keeps growing as ${world} exceeds production quota leading to widespread availability of quality armament.


Space: Roidhun's cousin ${name} visits ${world}, great banquets organised by cheering population.
Effect: The visit of the Roidhun's cousin has driven up the price of gourmet food.
History: ${world} hosted Lord ${name}, the Roidhun's cousin, in a series of great banquets.
News: The mighty Lord ${name}, cousin of His Highness the Roidhun, is visiting ${world} to great acclaim by the loyal population!


Space: Re-enactment of the famous Battle of ${name} draws tens of thousand of Ardars to ${world}, drives up food prices.
Effect: The re-enactment of the Battle of ${name} is drawing crowds and driving up food prices.
History: The re-enactment of the Battle of ${name} drew tens of thousand of people to ${world}.
News: Cheering crowds have come to ${world} to attend the massive re-enactment of the famous Battle of ${name}, a pivotal battle in the unification of Ardarshir under the early Roidhunate. A sumptuous display of Ardar valour and patriotism!


Space: Celebrations in honour of war hero drives up luxury goods prices on ${world}, ${system} system
Effect: The celebrations in honour of the local hero are driving up the prices of luxury goods.
History: Young Ardar Lieutenant ${name} was decorated by the Ardar Navy for stunning bravery in combat.
News: The Ardar Lieutenant ${name}, a native of ${world}, is being celebrated on his home planet after his heroic actions against superior barbarian forces led to Ardar victory against overwhelming odds. Let all young Ardars follow his shining example!


Space: Bumper harvest on ${world}, ${system} system, produces record food surpluses.
Effect: The superb harvest is generating massive food surpluses.
History: An excellent harvest led to record food production.
News: Ardar agriculture continues to outperform as bumper harvests on ${world} generate large surpluses! His Excellency Lord ${name}, in charge of agricultural efforts in the sector, praised the patriotic Ardar farmers and called on all Ardars to follow their lead.


Space: Industrialisation drive on ${world} boosts demand for mineral ores
Effect: Industrialisation efforts are boosting the demand for ores, driving prices up.
History: An Industrialisation drive ordered by the Roidhunate boosted local production capacities.
News: Lord ${name}, in charge of industry on ${world}, had launched a massive industrialisation effort to increase the planet's contributions to Roidhunate industries. Demand for minerals is said to have spiked as loyal industry workers join in this great effort to strengthen our mighty Roidhunate.


Space: Mining accidents on ${world} reported; massive casualties feared, medical help urgently requested.
Effect: The mining disaster is driving up demand for medicine and restricting ore supplies.
History: A major mining accident let to the collapse of a borehole, causing great loss of life.
News: Heroic Ardar miners were killed in tragic mining accident on ${world} as a borehole collapses in suspicious circumstances. As the Roidhunate authorities urgently organise medical help, Internal Security investigates the disaster. Have no fear, culprits will be found!


Empire

Space: Mass strikes on ${world} following imposition of new taxes
Effect: The ongoing strikes are paralysing local production, leading to rising consumer goods prices.
History: A new governor's efforts to raise taxes led to mass strikes.
News: The governor of ${world} has strongly condemned the ongoing strikes, declaring them "a scandalous movement organised by foreign agents provocateurs against the collection of reasonable taxes urgently needed for the defence of the Empire and the renovation of the gubernatorial palace". Reports from ${world}'s main cities mention major shortages of consumer goods.


]]