include("general_helper.lua")
include("universe/generate_nameGenerator.lua")

bar_desc={}

local imperial = {}
bar_desc.imperial=imperial
imperial[#imperial+1]={
  weight=10,
  getDesc=function(planet)
		
    local desc="The busy spaceport bar \"${name}\" features a vague Irish theme, last fashionable three or four centuries ago. At least they serve decent beer."
    
    local adj={"Lucky","Cheerful","Drunk","Brave"}
    local noun={"Irish","Celt","Shamrock","Clover"}

    local name="The "..adj[math.random(#adj)].." "..noun[math.random(#noun)]
    
    local stringData={}
    stringData.name=name

    return gh.format(desc,stringData)
  end,
  weightValidity=function(planet)
		return true
	end
}
imperial[#imperial+1]={
  weight=10,
  getDesc=function(planet)
		
    local desc="Frequented mainly by commercial pilots, the \"${name}\" is dingy but serves decent beer. A great place to meet people."
    
    local adj={"Quick","Brave","Dashing","Hungry","Thirsty"}
    local noun={"Pilot","Merchant","Trader","Captain"}

    local name=adj[math.random(#adj)].." "..noun[math.random(#noun)]
    
    local stringData={}
    stringData.name=name

    return gh.format(desc,stringData)
  end,
  weightValidity=function(planet)
		return true
	end
}
imperial[#imperial+1]={
  weight=20,
  getDesc=function(planet)		
    local desc="${planet}'s important Imperial naval base guarantees a steady stream of Imperial sailors and officers to the \"${name}\". Its walls feature holodecks of famous Imperial victories - few of them recent."
    
    local adj={"Weaping","Broken","Defeated","Terrified","Vanquished"}
    local noun={"Barbarian","Ardar","Pirate","Rebel"}

    local name=adj[math.random(#adj)].." "..noun[math.random(#noun)]
    
    local stringData={}
    stringData.name=name
    stringData.planet=planet.name

    return gh.format(desc,stringData)
  end,
  weightValidity=function(planet)
		return planet.lua.settlements.humans and planet.lua.settlements.humans.military>1
	end
}
imperial[#imperial+1]={
  weight=20,
  getDesc=function(planet)		
    local desc="The upmarket \"${name}\" caters to planet's prosperous merchants. Its extravagant decoration is not very tasteful, but its selection of liqueur is very extensive."
    
    local adj={"Beautiful","Ravishing","Dazzling","Sumptuous","Delightful"}
    local noun={"Courtesan","Singer","Dancer","Diva"}

    local name=adj[math.random(#adj)].." "..noun[math.random(#noun)]
    
    local stringData={}
    stringData.name=name
    stringData.planet=planet.name

    return gh.format(desc,stringData)
  end,
  weightValidity=function(planet)
		return planet.lua.settlements.humans and planet.lua.settlements.humans.services>1
	end
}
imperial[#imperial+1]={
  weight=20,
  getDesc=function(planet)		
    local desc="Little more than a workers' bar, the \"${name}\" serves nothing fancy. The local crowd is currently friendly, but riots over sport games are a regular occurrence."
    
    local adj={"Red","Green","Blue","Yellow"}
    local noun={"Team","Flag","Jersey","Pride","Emblem"}

    local name=adj[math.random(#adj)].." "..noun[math.random(#noun)]
    
    local stringData={}
    stringData.name=name
    stringData.planet=planet.name

    return gh.format(desc,stringData)
  end,
  weightValidity=function(planet)
		return planet.lua.settlements.humans and planet.lua.settlements.humans.stability<1
	end
}
imperial[#imperial+1]={
  weight=20,
  getDesc=function(planet)		
    local desc="The elegant \"${name}\" is patronised mainly by Imperial nobility; it has a large selection of the finest Bordeaux wines. More well-to-do pilots sometime visit, to the annoyance of the snobbish waiters."
    
    local adj={"River-side","High","Sunset","Beausejour","Sansoucis","Illustre"}
    local noun={"Estate","Palace","Garden","Pavilion"}

    local name=adj[math.random(#adj)].." "..noun[math.random(#noun)]
    
    local stringData={}
    stringData.name=name
    stringData.planet=planet.name

    return gh.format(desc,stringData)
  end,
  weightValidity=function(planet)
		return planet.lua.settlements.humans and planet.lua.settlements.humans.stability>=1
	end
}


local independent = {}
bar_desc.independent=independent
independent[#independent+1]={
  weight=10,
  getDesc=function(planet)		
    local desc="Typical of frontier cantines, the \"${name}\" is a cheap and animated bar, frequented by humans and aliens from a dozen species."
    
    local adj={"Hard","Good","Tough","Bad"}
    local noun={"Luck","Fate","Times","Dreams"}

    local name=adj[math.random(#adj)].." "..noun[math.random(#noun)]
    
    local stringData={}
    stringData.name=name
    stringData.planet=planet.name

    return gh.format(desc,stringData)
  end
}
independent[#independent+1]={
  weight=10,
  getDesc=function(planet)		
    local desc="${planet} is not a rich world, and \"${name}\" is not a fancy bar. But it serves cheap beer and the local crowd is friendly."
    
    local adj={"Straight","Strong","Hard","Quick","Cheap"}
    local noun={"Beer","Shot","Pint"}

    local name=adj[math.random(#adj)].." "..noun[math.random(#noun)]
    
    local stringData={}
    stringData.name=name
    stringData.planet=planet.name

    return gh.format(desc,stringData)
  end
}
independent[#independent+1]={
  weight=10,
  getDesc=function(planet)		
    local desc="Trade is down in the area, but ${planet} still sees a decent amount of merchant traffic. Most of it seems to pass through the \"${name}\"; everywhere you see traders are gulping down strong local liqueur."
    
    local noun={"Golden Goose","Quick Buck","Big Dreams","Lady Fortune","Fair Trade"}

    local name=noun[math.random(#noun)]
    
    local stringData={}
    stringData.name=name
    stringData.planet=planet.name

    return gh.format(desc,stringData)
  end
}
independent[#independent+1]={
  weight=10,
  getDesc=function(planet)		
    local desc="The \"${name}\" seems to be the headquarter of the local militia; most of the tables are held by drunken tough guys in patchy-looking ${planet} “navy” uniforms. They might hold their own against local pirates, but you wouldn't bet on them against barbarians."
    
    local noun={"Tough Guy","Hard Head","Broken Bones","Death Wish","Stone Fists"}

    local name=noun[math.random(#noun)]
    
    local stringData={}
    stringData.name=name
    stringData.planet=planet.name

    return gh.format(desc,stringData)
  end
}
independent[#independent+1]={
  weight=10,
  getDesc=function(planet)		
    local desc="Most of the ${name}'s customers are non-human, and the bar stocks little recognisable alcohols. It looks like a brawl could erupt any second."
    
    local noun={"Broken Glass","Moonshine","Last Stop","End of the World"}

    local name=noun[math.random(#noun)]
    
    local stringData={}
    stringData.name=name
    stringData.planet=planet.name

    return gh.format(desc,stringData)
  end
}

local ardar = {}
bar_desc.ardar=ardar
ardar[#ardar+1]={
  weight=10,
  getDesc=function(planet)		
    local desc="The \"${name}\" is decorated in the faux-rustic style fashionable throughout the Roidhunate; to human eyes, it looks like a particularly dark and tacky barn."
        
    local adj={"Dark","Ancient","Unbroken","Mighty"}
    local noun={"Castle","Tower","Dungeon","Fort","Stronghold"}

    local name=adj[math.random(#adj)].." "..noun[math.random(#noun)]
    
    local stringData={}
    stringData.name=name
    stringData.planet=planet.name

    return gh.format(desc,stringData)
  end
}
ardar[#ardar+1]={
  weight=20,
  getDesc=function(planet)    
    local desc="The \"${name}\" is strikingly equivalent to what you would find around a human military base, though the off-duty Ardar sailors seem to hold their liquor better than Terran servicemen would."
    
    local name="Naval Mess "..math.random(100,500)
    
    local stringData={}
    stringData.name=name
    stringData.planet=planet.name

    return gh.format(desc,stringData)
  end,
  weightValidity=function(planet)
		return planet.lua.settlements.ardars and planet.lua.settlements.ardars.military>1
	end
}
ardar[#ardar+1]={
  weight=10,
  getDesc=function(planet)    
    local desc="The star attraction of the \"${name}\" is clearly its collection of antique Ardar weapons hanging on the wall; should any of them fall on the patrons below, loss of limbs would be certain."
    
    local adj={"Curved","Straight","Dented","Polished","Bloody"}
    local noun={"Blade","Sword","Axe","Knife","Dagger"}

    local name=adj[math.random(#adj)].." "..noun[math.random(#noun)]
    
    local stringData={}
    stringData.name=name
    stringData.planet=planet.name

    return gh.format(desc,stringData)
  end
}
ardar[#ardar+1]={
  weight=10,
  getDesc=function(planet)    
    local desc="The stern and functional \"${name}\" serves standardised doses of alcohol on sparkling metal counters. It's cheap, though."
    
    local name="Spaceport Bar "..math.random(100,500)
    
    local stringData={}
    stringData.name=name
    stringData.planet=planet.name

    return gh.format(desc,stringData)
  end
}
ardar[#ardar+1]={
  weight=10,
  getDesc=function(planet)    
    local desc="The high-end \"${name}\" is done in a tasteful style reminiscent more of Terran Renaissance than of anything produced in the Roidhunate. The ongoing conflict has clearly not stopped Terran cultural influence from spreading."
    
    local adj={"Grand","Great","Noble","Honourable"}

    local name=adj[math.random(#adj)].." "..nameGenerator.generateNameArdarshir()
    
    local stringData={}
    stringData.name=name
    stringData.planet=planet.name

    return gh.format(desc,stringData)
  end
}
ardar[#ardar+1]={
  weight=10,
  getDesc=function(planet)    
    local desc="With its walls of cut stone and roof of heavy timber, the \"${name}\" seems straight out of Ardar epics. An Ardar bard visits twice a week to recite some classics."
    
    local noun={"Tale","Epic","Valour","Myth","Drama"}

    local name=noun[math.random(#noun)].." of "..nameGenerator.generateNameArdarshir()
    
    local stringData={}
    stringData.name=name
    stringData.planet=planet.name

    return gh.format(desc,stringData)
  end
}

local betelgeuse = {}
bar_desc.betelgeuse=betelgeuse
betelgeuse[#betelgeuse+1]={
  weight=20,
  getDesc=function(planet)    
    local desc="The \"${name}\" is a rococo display of extravagant luxury; the cocktail card is ten pages long and includes ingredients sourced from half the known space."
    
     local adj={"Sparkling","Fizzy","Fine","Dry","Tangy","Royal"}
    local noun={"Martini","Manhattan","Cosmopolitan","Boulevardier","Singapore Sling"}

    local name=adj[math.random(#adj)].." "..noun[math.random(#noun)]
    
    local stringData={}
    stringData.name=name
    stringData.planet=planet.name

    return gh.format(desc,stringData)
  end,
  weightValidity=function(planet)
		return planet.lua.settlements.betelgeuse and planet.lua.settlements.betelgeuse.services>1
	end
}
betelgeuse[#betelgeuse+1]={
  weight=20,
  getDesc=function(planet)    
    local desc="The wealthy merchants of ${planet} patronise the ${name}, and it shows in its luxurious decorations and extensive wine card."
    
    local adj={"Rare","Priceless","Imperial","Divine"}
    local noun={"Bottle","Jeroboam","Glass","Amphora"}

    local name=adj[math.random(#adj)].." "..noun[math.random(#noun)]
    
    local stringData={}
    stringData.name=name
    stringData.planet=planet.name

    return gh.format(desc,stringData)
  end,
  weightValidity=function(planet)
		return planet.lua.settlements.betelgeuse and planet.lua.settlements.betelgeuse.services>1
	end
}
betelgeuse[#betelgeuse+1]={
  weight=10,
  getDesc=function(planet)    
    local desc="The \"${name}\" is a little seedy by Betelgian standards. Clearly this is a place visited by lowly crew members more than master traders - or only by those looking for a little thrill outside of the gilded halls of the major trading house."
    
    local names={"Black Sheep","Rotten Egg","Stray Goat","Strange Tides","Wild Shores"}

    local name=names[math.random(#names)]
    
    local stringData={}
    stringData.name=name
    stringData.planet=planet.name

    return gh.format(desc,stringData)
  end
}

local royalixum = {}
bar_desc.royalixum=royalixum
royalixum[#royalixum+1]={
  weight=10,
  getDesc=function(planet)    
    local desc="The \"${name}\" has all the trappings of the sophisticated luxury favoured by the Ixumite nobility; and yet signs of decay are everywhere. Even the great marble counter is cracked and has been hastily repeated with mere plaster."
    
    local adj={"Gold","Silver","Jeweled","Priceless"}
    local noun={"Carafe","Plate","Goblet","Trophy"}

    local name=adj[math.random(#adj)].." "..noun[math.random(#noun)]
    
    local stringData={}
    stringData.name=name
    stringData.planet=planet.name

    return gh.format(desc,stringData)
  end
}
royalixum[#royalixum+1]={
  weight=10,
  getDesc=function(planet)    
    local desc="The dark and dingy \"${name}\" is filled with war veterans gulping down shots and trading war stories. Despite their bravado, a feel of despair hangs in the air."
    
    local adj={"Lonely","Tired","Restless","Carefree"}
    local noun={"Veteran","Infantry","Grunt"}

    local name=adj[math.random(#adj)].." "..noun[math.random(#noun)]
    
    local stringData={}
    stringData.name=name
    stringData.planet=planet.name

    return gh.format(desc,stringData)
  end
}
royalixum[#royalixum+1]={
  weight=10,
  getDesc=function(planet)    
    local desc="The ${name}'s decoration is a fancy take on the Imperial style... of a century ago. Clearly since then the local nobility has had higher priorities."
    
    local adj={"Imperial","Terran","French","Italian","Chinese","Japanese","Persian"}
    local noun={"Pavilion","Garden","Estate","Palace"}

    local name=adj[math.random(#adj)].." "..noun[math.random(#noun)]
    
    local stringData={}
    stringData.name=name
    stringData.planet=planet.name

    return gh.format(desc,stringData)
  end
}
royalixum[#royalixum+1]={
  weight=10,
  getDesc=function(planet)    
    local desc="The \"${name}\" is little more than a hastily-erected shelter. Presumably the preceding bar was destroyed recently, in bombings or riots."
    
    local adj={"Resilient","Unsinkable","Tough"}
    local noun={"Survivor","Shelter","Bar"}

    local name=adj[math.random(#adj)].." "..noun[math.random(#noun)]
    
    local stringData={}
    stringData.name=name
    stringData.planet=planet.name

    return gh.format(desc,stringData)
  end
}

local holyflame = {}
bar_desc.holyflame=holyflame
holyflame[#holyflame+1]={
  weight=10,
  getDesc=function(planet)    
    local desc="The risque frescoes have been painted over, the alcohol emptied, verses from the Book of the Holy Flame now decorate the walls and the bar has been renamed the \"${name}\". The herbal brews are excellent, though."
    
    local adj={"Holy","Sacred","Divine"}
    local noun={"Word","Book","Scroll","Verse"}

    local name=adj[math.random(#adj)].." "..noun[math.random(#noun)]
    
    local stringData={}
    stringData.name=name
    stringData.planet=planet.name

    return gh.format(desc,stringData)
  end
}
holyflame[#holyflame+1]={
  weight=10,
  getDesc=function(planet)    
    local desc="Alcohol is forbidden in the Holy Realm of Ixum, and the \"${name}\" instead serves the usual herbal brews. Holiness has a price."
    
    local adj={"Healthy","Holy","Blessed"}
    local noun={"Elixir","Bowl","Tea"}

    local name=adj[math.random(#adj)].." "..noun[math.random(#noun)]
    
    local stringData={}
    stringData.name=name
    stringData.planet=planet.name

    return gh.format(desc,stringData)
  end
}
holyflame[#holyflame+1]={
  weight=10,
  getDesc=function(planet)    
    local desc="The clean and bright \"${name}\" has an austere but peaceful atmosphere, almost monastic. Patrons sip their brews in near-silence."
    
    local adj={"Holy","Welcome","Grateful","Deep"}
    local noun={"Calm","Respite","Meditation","Prayer"}

    local name=adj[math.random(#adj)].." "..noun[math.random(#noun)]
    
    local stringData={}
    stringData.name=name
    stringData.planet=planet.name

    return gh.format(desc,stringData)
  end
}
holyflame[#holyflame+1]={
  weight=10,
  getDesc=function(planet)    
    local desc="The \"${name}\" seems mostly patronised by members of the local Holy Guard. Tough-looking, aggressive Ixumites, they make there other customers think twice before saying anything related to the war or the Holy Guardians."
    
    local adj={"Holy","Divine","Sacred","Blessed"}
    local noun={"Forces","Soldiers","Warriors","Crusaders"}

    local name=adj[math.random(#adj)].." "..noun[math.random(#noun)]
    
    local stringData={}
    stringData.name=name
    stringData.planet=planet.name

    return gh.format(desc,stringData)
  end
}

local barbarians = {}
bar_desc.barbarians=barbarians
barbarians[#barbarians+1]={
  weight=10,
  getDesc=function(planet)    
    local desc="Like many \"historically themed\" bars in the Empire, the \"${name}\" features wooden beams, stone walls and weapons on the wall. You can't remember though ever entering an Imperial bar with that much mud on the floor and quite that strong a stench."
    
    local adj={"Bloody","Terrific","Gory","Grizzly"}
    local noun={"Battle","Raid","Carnage","Massacre"}

    local name=adj[math.random(#adj)].." "..noun[math.random(#noun)]
    
    local stringData={}
    stringData.name=name
    stringData.planet=planet.name

    return gh.format(desc,stringData)
  end
}
barbarians[#barbarians+1]={
  weight=10,
  getDesc=function(planet)    
    local desc="The \"${name}\" is a large and dark hall, built by a culture where medieval-style banquets are still organised non-ironically."
    
    local adj={"Roast","Grilled","Sliced","Chopped"}
    local noun={"Pig","Ox","Sheep","Bull"}

    local name=adj[math.random(#adj)].." "..noun[math.random(#noun)]
    
    local stringData={}
    stringData.name=name
    stringData.planet=planet.name

    return gh.format(desc,stringData)
  end
}
barbarians[#barbarians+1]={
  weight=10,
  getDesc=function(planet)    
    local desc="The small and smoke-filled \"${name}\" is filled with burly-looking humanoids drinking heavily and occasionally fighting. The armed guards at the entrance intervene when things get out of hand - but not too early so as not to spoil the fun."
    
    local adj={"Jolly","Happy","Smiling"}
    local noun={"Barbarian","Warrior","Raider"}

    local name=adj[math.random(#adj)].." "..noun[math.random(#noun)]
    
    local stringData={}
    stringData.name=name
    stringData.planet=planet.name

    return gh.format(desc,stringData)
  end
}



