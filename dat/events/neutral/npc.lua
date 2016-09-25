
--[[
-- Event for creating random characters in the spaceport bar.
-- The random NPCs will tell the player things about the Naev universe in general, about their faction, or about the game itself.
--]]

include('general_helper.lua')
include "dat/events/tutorial/tutorial-common.lua"

lang = naev.lang()
if lang == 'es' then --not translated atm
else --default english
   civ_port = {}
   civ_port.general =   {"neutral/male1",
                            "neutral/female1",
                            "neutral/miner1",
                            "neutral/miner2",
                            "neutral/thief1",
                            "neutral/thief2",
                            "neutral/thief3",
                           }   
   civ_port.traders =    {"neutral/male1",
                            "neutral/female1",
                            "neutral/thief1",
                            "neutral/thief3",
                           }
    civ_port.ardarCivilians = {
    	"dvaered/dv_civilian1",
    	"dvaered/dv_civilian2"
	}
	civ_port.imperialMilitary = {
		"empire/empire1",
		"empire/empire2",
		"empire/empire3",
		"empire/empire4"
	}	
	civ_port.ardarMilitary = {
		"ardar/military_m1",
		"ardar/military_m2",
		"ardar/military_m3"
	}
	civ_port.independentMilitary = {
		"pirate/pirate_militia1",
		"pirate/pirate_militia2"
	}
	civ_port.betelgianMilitary = {
		"empire/empire1",
		"empire/empire2",
		"empire/empire3",
		"empire/empire4"
	}
	civ_port.royalixumMilitary = {
		"empire/empire1",
		"empire/empire2",
		"empire/empire3",
		"empire/empire4"
	}
	civ_port.holyflameCivilians = {
    	"holyflame/holyflame_1",
    	"holyflame/holyflame_2",
    	"holyflame/holyflame_3",
    	"holyflame/holyflame_4"
	}
	civ_port.holyflameMilitary = {
		"holyflame/holyflame_military1",
    	"holyflame/holyflame_military2"
	}
    civ_port.barbarians =    {"pirate/pirate1",
						"pirate/pirate2",
						"pirate/pirate3",
						"pirate/pirate4",
    }
						   
						   
						   
	civ_desc = {}
   civ_desc.general = {"This person seems to be here to relax.",
               "There is a civilian sitting on one of the tables.",
               "There is a civilian sitting there, looking somewhere else.",
               "A worker sits at one of the tables, wearing a nametag saying \"Go away\".",
               "A civilian sits at the bar, seemingly serious about the cocktails on offer.",
               "A civilian wearing a shirt saying: \"Ask me about Jaegnhild\"",
               "There is a civilian sitting in the corner.",
               "A civilian feverishly concentrating on a fluorescing drink.",
               "A civilian drinking alone.",
               "This person seems friendly enough.",
               "A civilian sitting at the bar.",
               "This person is idly browsing a news terminal.",
               "A worker sits drinks, but not working.",
               "A worker slouched against the bar, nursing a drink.",
               "This worker seems bored with everything but their drink.",
               }
	civ_desc.imperialMilitary = {
		"An Imperial Private in a Navy uniform, drinking spirits.",
		"A bored-looking Imperial Sailor sitting at the bar."
	}	
	civ_desc.ardarMilitary = {
		"A smart-looking Ardar Private, gulping down telloch.",
		"A fierce Ardar Sailor."
	}
	civ_desc.independentMilitary = {
		"A gruff militia member sitting at the bar.",
		"A soldier from the local militia sipping a beer."
	}
	civ_desc.betelgianMilitary = {
		"A Betelgian soldier in a shiny uniform.",
		"A sailor from the Betelgian navy drinking a cocktail."
	}
	civ_desc.royalixumMilitary = {
		"A tired-looking sailor from the Royal Navy.",
		"A down-cast soldier from the Royal Army."
	}
	civ_desc.holyflameMilitary = {
		"A mean-looking warrior from the Holy Guard.",
		"A lanky private from the Holy Flame Navy."
	}
    civ_desc.barbarians =    {
		"A burly humanoid of uncertain origin.",
		"A gruff-looking barbarian drinking too much."
    }

   
   msg_lore={}
   msg_lore.empire={}
   msg_lore.empire.civilians={
	"Back when I was a kid, the Empire was so much better!",
"Those reports of increasing barbarian raids are pretty scary, don't you think?",
"I'm sure our brave Imperial Navy can hold firm against those damned Ardars. We're number one!",
"I'd like to visit the Imperial Palace one day. They say it has over a hundred thousand rooms!",
"I have a cousin in the Navy, I hope he's OK. Last I heard he was posted on the Ardar border. ",
"Don't repeat it, but my wife's uncle works in the sector's administration, and he tells me the governor is corrupt!",
"I wanted to be an officer, but it's really tough if you don't have contacts.",
"Sometime I wonder... Maybe we do deserve to lose to the Roidhunate? They are so much more disciplined than we humans...",
"My grandfather used to complain things were run properly in his days. Then he died due to a mix-up at the Imperial hospital. He'd have been happy to be proven right!",
   }
   msg_lore.empire.military={
	"I don't care what the admiralty says, every day we are losing ground against the barbarians, and that's a fact.",
"Those damned greentails are more disciplined than us, that's true, and they have better officers, that's true to, and their Roidhun knows what he is doing, sure as hell, but we're better than them, that's for sure. ",
"I've fought long on the border mate, those barbarian ships are scary-looking but really badly crewed.",
"Our lieutenant served as “instructor” for the Ixumites, he told us the royalists are close to collapse.",
"If only the admiralty was not made up of such cowards, we could really hit those crocodiles on the snout. We still have the bigger navy, not that they use it!",
   }
   msg_lore.empire.traders={
	"Every year trade is getting harder, know what I mean?",
"I used to trade with independent worlds, but it's gotten too dangerous. ",
"There's still money to be made in this Galaxy, don't listen to all the defeatists. I recently sold medicine at five time the going rate! World has an epidemic going on, but business' business, you know?",
"What are you going for, slow and safe profit in the inner systems or risky but profitable deals in the fringes?",
   }
   
   
   msg_lore.independent={}
   msg_lore.independent.civilians={
	"You Imperials are always sneering at us, but your Empire is rotten to the core and everybody knows it.",
"The Emperor is naked, they say. And not just during his orgies.",
"My family moved here from a safe Imperial world a century ago. Opportunity of a lifetime, grandpa said. Last we saw him he was being dragged into a barbarian slave ship.",
"The future of the human race is here, on the fringes. Not in your decadent Empire.",
"You look like you've traveled! Have you been to Terra? I want to see it one day! If I ever leave this dump.",
"Barbarian raids are getting worse and worse... don't tell anyone I said that, but we were doing better when the Empire was more present here!",
"If the Roidhunate wins, they'll respect our neutrality, I'm sure.",
   }
   msg_lore.independent.military={
	"We don't need no stinking Empire to protect us, that's for sure.",
"I've fought more barbarians you ever will, greenhorn. ",
"The Imperial Navy has good ships, but you Imperials are too fussy to fight properly.",
"Shields are for wuss, steel plates is what you really need.",
"You favour guns like real men or are you more of a missile weakling?",
   }
   msg_lore.independent.traders={
"Trade's on the frontier isn't easy, but that's where the money is. ",
"I took some pirate fire on my last run, but I made a tidy profit too!",
"My mum never wanted me to be a trader, “it's too dangerous”, she would say. Maybe it is, but I'm earning for my entire family.",
"The trick to trading here is to keep an eye on the news. There's always stuff happening, and reacting fast gets you big rewards.",
"Barbarians, pirates... I've met them all in space, I'm still trading. Cheers!",
"I have a brother working in the local militia. I sometime wish I had a safe job like that.",
   }
   
      msg_lore.ardar={}
   msg_lore.ardar.civilians={
	"Ha, a human. You've come to see how an Empire should be run?",
"Don't worry, I'm sure the Roidhun will be merciful when we finally rule Terra.",
"Did you know people of any species can become Roidhunate citizens? Some even manage minor positions in the bureaucracy!",
"I'm not afraid to say it, I admire your Empire. Well, the one you had a few centuries ago of course, not what's left of it today.",
"I'll never understand you humans. Individually you are such a gifted species, why are your societies so chaotic and unproductive?",
"I've heard there's a lot of corruption in the Empire, is it true?",
"I hope you won't take offence, but I find humans flabby and weak-looking.",
"Did you know Ardar was unified two centuries before we reached space? My teachers told me it took much longer on Terra. But then you are such an individualistic race!",
   }
   msg_lore.ardar.military={
	"I can't wait for the day we really fight those Imperial fleets. We're going to win, it's going to be great!",
"I've heard you humans are having troubles with barbarians, that's true? Have you tried nuking their home worlds? It's working pretty well for us.",
"I've studied your ships, they are really good. Good for us you don't know how to use them!",
"I'm studying to become an officer, we're even covering Terran military history! Our instructor told us of a Napoleon guy, you've heard of him?",
"I've only ever fought barbarians and pirates... I wish I could fight the Empire instead!",
"You'll have a glass of telloch with me? Next time we meet, could be in battle!",
"I'll say one thing for you terrans, that whisky thing you make is worth every drop!",
"The day we take over Terra, I want my share of loot in whisky! Joking, joking...",
   }
   msg_lore.ardar.traders={
"Is it true that in the Empire most traders don't work for the government?",
"I've heard that in the Empire you can become rich and respected by being a successful trader! Incredible!",
"I wanted to be in the Navy like everyone else, but I couldn't make it. Father never forgave me...",
"Traders are not very respected here, but at least it's a safe job.",
"I don't understand why the Roidhun allows human traders here.",
"When I was younger, I visited Terra as part of a trading delegation. My cousin is in the Ardar Navy, it will be his turn soon!",
   }
   
      msg_lore.betelgeuse={}
   msg_lore.betelgeuse.civilians={
	"I wish I could have joined a trading house... Get rich, see the Galaxy...",
"We Betelgians are great explorers, the best in the Galaxy! Well, I've never been off this rock, but still, explorers’ blood, you know?",
"Why can't the Roidhunate and you guys just focus on making money and not threaten war all the time?",
"I hope our Doge does the right thing and stays out of that conflict of yours. Trade and neutrality, that's our way.",
"You humans are great inventors, but you don't understand anything about trade.",
"Betelgeuse is an open society, if you're rich, your species doesn't matter!",
   }
   msg_lore.betelgeuse.military={
	"I wish I was born in the Empire or the Roidhunate, soldiers are respected there! Here it's all “do you know how much taxes you pay for your stupid ships?”.",
"I'm in the Betelgian Navy. Yes, really. And no, not ALL our ships are converted freighters!",
"People think the Betelgian Navy is useless and costs too much, but who do they call when barbarians threaten trade routes, you think?",
"I was part of a naval training exercise with the Imperial Navy once, such fine warships!",
"My mother was so disappointed when I joined the Navy.... broke her heart.",
   }
   msg_lore.betelgeuse.traders={
"I've been to Terra once, quite a profitable run. And to Ardarshir twice. See the world, make money, that's my motto!",
"I travelled with an exploration fleet once, greatest time of my life! Unknown worlds, weird natives, great trading opportunities... that's the way to live!",
"If you are ever lucky enough to be admitted in a Betelgian trading house, you'll get opportunities for riches you'd never have thought possible!",
"I'm glad I'm a Betelgian trader, best place to do business.",
   }
   
      msg_lore.royalixum={}
   msg_lore.royalixum.civilians={
	"Long live his Majesty!",
"This war had been going on for a century, and it feels like two...",
"Before the war, Ixum was a rich realm. Well, not for everybody, that's true.",
"The Guardians should have stayed out of politics!",
"I have cousins on Gonder. Haven't spoke with them in years.",
"Without Terran help, the monarchy would have fallen long ago.",
   }
   msg_lore.royalixum.military={
	"Cheers to you, Terran ally! One day we will defeat those fanatics.",
"My father spent his entire life fighting in this war, looks like I'll be doing the same.",
"High Command says we're winning, but that's rubbish.",
"Those ships the Empire sends us are really good.",
"If only the Ardars were not backing those fanatics, we'd have won long ago!",
"To Royal-Imperial Naval cooperation!",
   }
   
   msg_lore.holyflame={}
   msg_lore.holyflame.civilians={
	"The Flame will burn away infidels like you!",
"I sometime wonder... what does alcohol tastes like? Is it really better than those herbal brews?",
"The Guardians are guiding us towards victory. But why does it have to take so long?",
"I'm sure our sacrifices will be made worthwhile by the Flame.",
"You should have come before the war, stranger. Ixum was something then.",
"Down with the King, that heretical tyrant!",
"Alcohol can't be better than this wholesome herbal tea.",
"Convert before it is too late, for the Flame will soon be upon you!",
   }
   msg_lore.holyflame.military={
	"To the Guardians and our great ally, the Ardar Roidhun!",
"We will smash what remains of the Tyrant's fleets and drag him back in chains in front of the Guardians!",
"Without the help sent by your damned Empire, the royalists would have collapsed long ago.",
"All your Empire's ships couldn't face a navy guided by the Holy Flame.",
"You Imperials are all jaded, decadent materialists. You stand no chance against people guided by the Flame.",
   }
   
   msg_lore.barbarians={}
   msg_lore.barbarians.civilians={
	"I like a good ale between two raids. Pillaging is thirsty work.",
"It's unusual to see a human here - not covered in chains, I mean.",
"Are you here to joins raids also? Better plunder than be plundered!",
"You Imperials think we are all barbarians, but that's just not true. Between two raids, I collect battle-axes, for example.",
"One day, I hope to visit Terra itself. I've heard the Imperial Palace is an incredible sight - enough plunder to fill a fleet!",
"Your ships are good enough to destroy ten of ours. That's why we always bring eleven.",
"You wouldn't happen to have whisky with you, would you? I remember that lovely little tavern I pillaged on my last raid, such a great choice of liqueur!",
   }

   -- Gameplay tip messages.
   -- ALL NPCs have a chance to say one of these lines instead of a lore message.
   -- So, make sure the tips are always faction neutral.
   msg_tip =                  {"I heard you can set your weapons to only fire when your target is in range, or just let them fire when you pull the trigger. Sounds handy!",
                               "Did you know that if a planet doesn't like you, you can often bribe the spaceport operators and land anyway? Just hail the planet with " .. tutGetKey("hail") .. ", and click the bribe button! Careful though, it doesn't always work.",
                               "These new-fangled missile systems! You can't even fire them unless you get a target lock first! But the same thing goes for your opponents. You can actually make it harder for them to lock on to your ship by equipping scramblers or jammers. Scout class ships are also harder to target.",
                               "You know how you can't change your ship or your equipment on some planets? Well, it seems you need an outfitter to change equipment, and a shipyard to change ships! Bet you didn't know that.",
                               "Are you buying missiles? You can hold down \027bctrl\0270 to buy 5 of them at a time, and \027bshift\0270 to buy 10. And if you press them both at once, you can buy 50 at a time! It actually works for everything, but why would you want to buy 50 laser cannons?",
                               "If you're on a mission you just can't beat, you can open the information panel and abort the mission. There's no penalty for doing it, so don't hesitate to try the mission again later.",
                               "Don't forget that you can revisit the tutorial modules at any time from the main menu. I know I do.",
                               "Some weapons have a different effect on shields than they do on armour. Keep that in mind when equipping your ship.",
                               "Afterburners can speed you up a lot, but when they get hot they don't work as well anymore. Don't use them carelessly!",
                               "There are passive outfits and active outfits. The passive ones modify your ship continuously, but the active ones only work if you turn them on. You usually can't keep an active outfit on all the time, so you need to be careful only to use it when you need it.",
                               "Missile jammers slow down missiles close to your ship. If your enemies are using missiles, it can be very helpful to have one on board.",
                               "If you're having trouble with overheating weapons or outfits, you can press " .. tutGetKey("autobrake") .. " twice to put your ship into Active Cooldown. Careful though, your energy and shields won't recharge while you do it!",
                               "If you're having trouble shooting other ships face on, try outfitting with turrets or use an afterburner to avoid them entirely!",
                               "You know how time speeds up when Autonav is on, but then goes back to normal when enemies are around? Turns out you can't disable the return to normal speed entirely, but you can control what amount of danger triggers it. Really handy if you want to ignore enemies that aren't actually hitting you.",
                              }

   -- Mission hint messages. Each element should be a table containing the mission name and the corresponding hint.
   -- ALL NPCs have a chance to say one of these lines instead of a lore message.
   -- So, make sure the hints are always faction neutral.
   msg_mhint =                {
   -- {"Shadowrun", "Apparently there's a woman who regularly turns up on planets in and around the Klantar system. I wonder what she's looking for?"},
                               -- {"Collective Espionage 1", "The Empire is trying to really do something about the Collective, I hear. Who knows, maybe you can even help them out if you make it to Omega Station."},
                               -- {"Hitman", "There are often shady characters hanging out in the Alteris system. I'd stay away from there if I were you, someone might offer you a dirty kind of job!"},
                               -- {"Za'lek Shipping Delivery", "So there's some Za'lek scientist looking for a cargo monkey out on Niflheim in the Dohriabi system. I hear it's pretty good money."},
                               -- {"Sightseeing", "Rich folk will pay extra to go on an offworld sightseeing tour in a luxury yacht. Look like you can put a price on luxury!"},
                              }

   -- Event hint messages. Each element should be a table containing the event name and the corresponding hint.
   -- Make sure the hints are always faction neutral.
   msg_ehint =                {
   -- {"FLF/DV Derelicts", "The FLF and the Dvaered sometimes clash in Surano. If you go there, you might find something of interest... Or not."},
                              }

   -- Mission after-care messages. Each element should be a table containing the mission name and a line of text.
   -- This text will be said by NPCs once the player has completed the mission in question.
   -- Make sure the messages are always faction neutral.
   msg_mdone =                {
   -- {"Nebula Satellite", "Heard some crazy scientists got someone to put a satellite inside the nebula for them. I thought everyone with half a brain knew to stay out of there, but oh well."},
                               -- {"Shadow Vigil", "Did you hear? There was some big incident during a diplomatic meeting between the Empire and the Dvaered. Nobody knows what exactly happened, but both diplomats died. Now both sides are accusing the other of foul play. Could get ugly."},
                               -- {"Operation Cold Metal", "Hey, remember the Collective? They got wiped out! I feel so much better now that there aren't a bunch of robot ships out there to get me anymore."},
                               -- {"Baron", "Some thieves broke into a museum on Varia and stole a holopainting! Most of the thieves were caught, but the one who carried the holopainting offworld is still at large. No leads. Damn criminals..."},
                               -- {"Destroy the FLF base!", "The Dvaered scored a major victory against the FLF recently. They went into Sigur and blew the hidden base there to bits! I bet that was a serious setback for the FLF."},
                              }

   -- Event after-care messages. Each element should be a table containing the event name and a line of text.
   -- This text will be said by NPCs once the player has completed the event in question.
   -- Make sure the messages are always faction neutral.
   msg_edone =                {
   --{"Animal trouble", "What? You had rodents sabotage your ship? Man, you're lucky to be alive. If it had hit the wrong power line..."},
 --                             {"Naev Needs You!", "What do you mean, the world ended and then the creator of the universe came and fixed it? What kind of illegal substance are you on? Get away from me, you lunatic."},
                              }
   
   npcs = {}
   
   npcs.empire_civilians={
	worldFactions={[G.EMPIRE]=true},
	name="Imperial Civilian",
	speech={	{items=msg_lore.empire.civilians,weight=10},
				{items=msg_tip,weight=5}},
	portraits=civ_port.general,
	descriptions=civ_desc.general,
	weight=20
   }
   npcs.empire_military={
	worldFactions={[G.EMPIRE]=true},
	name="Imperial Private",
	speech={	{items=msg_lore.empire.military,weight=10}},
	portraits=civ_port.imperialMilitary,
	descriptions=civ_desc.imperialMilitary,
	weight=10
   }

   
   npcs.empire_traders={
   	worldFactions={[G.EMPIRE]=true,[G.INDEPENDENT_WORLDS]=true},
	name="Imperial Trader",
	speech={	{items=msg_lore.empire.traders,weight=10},
				{items=msg_tip,weight=5}},
	portraits=civ_port.traders,
	descriptions=civ_desc.general,
	weight=10
   }
   
   
   npcs.independent_civilians={
	worldFactions={[G.INDEPENDENT_WORLDS]=true},
	name="Independent Worlds Civilian",
	speech={	{items=msg_lore.independent.civilians,weight=10},
				{items=msg_tip,weight=5}},
	portraits=civ_port.general,
	descriptions=civ_desc.general,
	weight=20
   }
   npcs.independent_military={
	worldFactions={[G.INDEPENDENT_WORLDS]=true},
	name="Local Militia Member",
	speech={	{items=msg_lore.independent.military,weight=10}},
	portraits=civ_port.independentMilitary,
	descriptions=civ_desc.independentMilitary,
	weight=20
   }
   npcs.independent_traders={
	worldFactions={[G.INDEPENDENT_WORLDS]=true},
	name="Independent Trader",
	speech={	{items=msg_lore.independent.traders,weight=10},
				{items=msg_tip,weight=5}},
	portraits=civ_port.traders,
	descriptions=civ_desc.general,
	weight=10
   }
   
   
   npcs.ardar_civilians={
	worldFactions={[G.ROIDHUNATE]=true},
	name="Ardar Civilian",
	speech={	{items=msg_lore.ardar.civilians,weight=10},
				{items=msg_tip,weight=5}},
	portraits=civ_port.ardarCivilians,
	descriptions=civ_desc.general,
	weight=20
   }
   npcs.ardar_military={
	worldFactions={[G.ROIDHUNATE]=true},
	name="Ardar Private",
	speech={	{items=msg_lore.ardar.military,weight=10}},
	portraits=civ_port.ardarMilitary,
	descriptions=civ_desc.ardarMilitary,
	weight=20
   }
   npcs.ardar_traders={
	worldFactions={[G.ROIDHUNATE]=true},
	name="Ardar Trader",
	speech={	{items=msg_lore.ardar.traders,weight=10},
				{items=msg_tip,weight=5}},
	portraits=civ_port.ardarCivilians,
	descriptions=civ_desc.general,
	weight=10
   }
   
   
   npcs.betelgeuse_civilians={
	worldFactions={[G.BETELGEUSE]=true},
	name="Betelgian Civilian",
	speech={	{items=msg_lore.betelgeuse.civilians,weight=10},
				{items=msg_tip,weight=5}},
	portraits=civ_port.general,
	descriptions=civ_desc.general,
	weight=20
   }
   npcs.betelgeuse_military={
	worldFactions={[G.BETELGEUSE]=true},
	name="Betelgian Private",
	speech={	{items=msg_lore.betelgeuse.military,weight=10}},
	portraits=civ_port.betelgianMilitary,
	descriptions=civ_desc.betelgianMilitary,
	weight=10
   }
   npcs.betelgeuse_traders={
	worldFactions={[G.BETELGEUSE]=true},
	name="Betelgian Trader",
	speech={	{items=msg_lore.betelgeuse.traders,weight=10},
				{items=msg_tip,weight=5}},
	portraits=civ_port.traders,
	descriptions=civ_desc.general,
	weight=20
   }
   npcs.betelgeuse_traders_ext={
	worldFactions={[G.EMPIRE]=true,[G.ROIDHUNATE]=true,[G.ROYAL_IXUM]=true,[G.HOLY_FLAME]=true,[G.INDEPENDENT_WORLDS]=true},
	name="Betelgian Trader",
	speech={	{items=msg_lore.betelgeuse.traders,weight=10},
				{items=msg_tip,weight=5}},
	portraits=civ_port.traders,
	descriptions=civ_desc.general,
	weight=2
   }
   
   
   npcs.royalixum_civilians={
	worldFactions={[G.ROYAL_IXUM]=true},
	name="Ixumite Civilian",
	speech={	{items=msg_lore.royalixum.civilians,weight=10},
				{items=msg_tip,weight=5}},
	portraits=civ_port.general,
	descriptions=civ_desc.general,
	weight=20
   }
   npcs.royalixum_military={
	worldFactions={[G.ROYAL_IXUM]=true},
	name="Royal Ixumite Private",
	speech={	{items=msg_lore.royalixum.military,weight=10}},
	portraits=civ_port.royalixumMilitary,
	descriptions=civ_desc.royalixumMilitary,
	weight=20
   }
   
   
   npcs.holyflame_civilians={
	worldFactions={[G.HOLY_FLAME]=true},
	name="Ixumite Civilian",
	speech={	{items=msg_lore.holyflame.civilians,weight=10},
				{items=msg_tip,weight=5}},
	portraits=civ_port.holyflameCivilians,
	descriptions=civ_desc.general,
	weight=20
   }
   npcs.holyflame_military={
	worldFactions={[G.HOLY_FLAME]=true},
	name="Holy Flame Warrior",
	speech={	{items=msg_lore.holyflame.military,weight=10}},
	portraits=civ_port.holyflameMilitary,
	descriptions=civ_desc.holyflameMilitary,
	weight=20
   }
   
   
   npcs.barbarians={
	worldFactions={[G.BARBARIANS]=true},
	name="Barbarian",
	speech={	{items=msg_lore.barbarians.civilians,weight=10}},
	portraits=civ_port.barbarians,
	descriptions=civ_desc.barbarians,
	weight=20
   }
   
   
end


function create()
   -- Logic to decide what to spawn, if anything.
   -- TODO: Do not spawn any NPCs on restricted assets.

   npcs_data={}

   local num_npc = rnd.rnd(1, 5)
   for i = 0, num_npc do
      spawnNPC()
   end

   -- End event on takeoff.
   hook.takeoff( "leave" )
end

-- Spawns an NPC.
function spawnNPC()

   if planet.cur():faction()==nil then
   		evt.finish(false)
   end
   
   local suitableNPCs={}
   local fac=planet.cur():faction():name()
   
   for k,v in pairs(npcs) do
   		if (v.worldFactions[fac]==true) then
   			suitableNPCs[#suitableNPCs+1]=v
   		end
   end

   if #suitableNPCs == 0 then
   	print("No bar NPCs for faction "..fac..": ")
   	evt.finish(false)
   end

   local npc=gh.pickWeightedObject(suitableNPCs)

   local npcname = npc.name

   -- Select a portrait
   local portrait = gh.randomObject(npc.portraits)

   -- Select a description for the civilian.
   local desc = gh.randomObject(npc.descriptions)

   -- Select what this NPC should say.
   local speechList = gh.pickWeightedObject(npc.speech)

   local msg=gh.randomObject(speechList.items)


   local npcdata = {name = npcname, msg = msg, func = func}

   id = evt.npcAdd("talkNPC", npcname, portrait, desc, 50)
   npcs_data[id] = npcdata
end

function talkNPC(id)
   local npcdata = npcs_data[id]

   if npcdata.func then
      -- Execute NPC specific code
      npcdata.func()
   end

   tk.msg(npcdata.name, "\"" .. npcdata.msg .. "\"")
end

--[[
--    Event is over when player takes off.
--]]
function leave ()
   evt.finish()
end
