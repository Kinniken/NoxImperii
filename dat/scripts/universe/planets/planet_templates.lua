
stellar_templates = {}

sun_templates = {} 

include('universe/planets/planet_descs.lua')
include('universe/natives/generate_natives.lua')
include('universe/locations.lua')

local all={}
local allOrdered={}
local allMoonOrdered={}

sun_templates.allPlanetsTemplate = all
sun_templates.allPlanetsTemplateOrdered = allOrdered
sun_templates.allMoonsTemplateOrdered = allMoonOrdered

--[[
	Note: the world's physical charactistic attributes and scores (mass,dayLength, fertility...) are typically expressed compared to Earth. Exceptions:
		- Temperature in K (Earth: 287)

	The minRadius and maxRadius are multipliers for the system's radius (i.e. by default the bigger a star system, the further the planets are from the sun)
]]


--moons for terrestoid planets
moonTemplateAsteroid={spacePicts={"asteroid-D00.png","asteroid-D01.png","asteroid-D02.png","asteroid-D03.png","asteroid-D04.png","asteroid-D05.png","asteroid-D06.png"},exteriorPicts={"ln/asteroid.png"},minRadius=300,maxRadius=400,descGenerator=descModule.moonAsteroidDesc,typeName="moonAsteroid",classification="Asteroid Moon",mass={0.005,0.01},planetRadius={0.05,0.1},nativeFertility={0.0,0},humanFertility={0,0},minerals={0.2,0.5}}
allMoonOrdered[#allMoonOrdered+1]=moonTemplateAsteroid
moonTemplateRealMoon={spacePicts={"moon-C00.png","moon-C01.png","moon-D00.png","moon-D01.png"},exteriorPicts={"ln/barren_moon.png"},minRadius=400,maxRadius=500,descGenerator=descModule.moonWorldDesc,typeName="moonWorld",classification="Silicate Moon",mass={0.1,0.2},planetRadius={0.1,0.2},nativeFertility={0.0,0},humanFertility={0,0},minerals={0.5,1}}
allMoonOrdered[#allMoonOrdered+1]=moonTemplateRealMoon

--terrestoid planets
all.planetTemplateMercury={spacePicts={"A00.png","A01.png"},exteriorPicts={"ln/desert3.png"},minRadius=0.05,maxRadius=0.1,descGenerator=descModule.mercuryDesc,typeName="mercury",classification="Hot Telluric",mass={0.03,0.1},planetRadius={0.2,0.5},ua={0.25,0.5},temperature={380,500},dayLength={40,1000},yearLength={0.1,0.5},nativeFertility={0,0},humanFertility={0,0},minerals={0,0.15}}
allOrdered[#allOrdered+1]=all.planetTemplateMercury

all.planetTemplateVenus={spacePicts={"C00.png","H00.png"},exteriorPicts={"ln/desert.png","ln/desert2.png","ln/desert3.png"},minRadius=0.1,maxRadius=0.15,descGenerator=descModule.venusDesc,typeName="venus",classification="Glasshouse",mass={0.5,2},planetRadius={0.7,2},ua={0.5,0.9},temperature={500,900},dayLength={40,1000},yearLength={0.4,0.8},nativeFertility={0,0},humanFertility={0,0},minerals={0,0.30},moonTemplate={{template=moonTemplateAsteroid,weight=10},{template=moonTemplateRealMoon,weight=5}},nbMoons={0,0,0,1,1,2}}
allOrdered[#allOrdered+1]=all.planetTemplateVenus

all.planetTemplateJungleVenus={spacePicts={"M02.png","M04.png"},exteriorPicts={"ln/jungle.png","ln/jungle2.png","ln/jungle3.png"},minRadius=0.1,maxRadius=0.15,descGenerator=descModule.jungleVenusDesc,possibleNatives=natives_generator.all.warmTerranNatives,typeName="jungleVenus",classification="Hot Earth-like",mass={0.5,1.2},planetRadius={0.7,1.2},ua={0.5,0.9},temperature={300,320},dayLength={40,1000},yearLength={0.4,0.8},nativeFertility={0.60,1.20},humanFertility={0,0.25},minerals={0.10,0.50},moonTemplate={{template=moonTemplateAsteroid,weight=10},{template=moonTemplateRealMoon,weight=5}},nbMoons={0,0,0,1,1,2}}
allOrdered[#allOrdered+1]=all.planetTemplateJungleVenus

all.planetTemplateWarmTerra={spacePicts={"M05.png","M04.png"},exteriorPicts={"ln/mangrove.png","ln/coast_warm.png","ln/coast_warm2.png"},minRadius=0.2,maxRadius=0.25,descGenerator=descModule.warmTerraDesc,possibleNatives=natives_generator.all.warmTerranNatives,typeName="warmTerra",classification="Warm Earth-like",mass={0.9,1.1},planetRadius={0.8,1.2},ua={0.9,1.2},temperature={292,297},dayLength={0.5,3},yearLength={0.7,2},nativeFertility={0.60,1.00},humanFertility={0.50,0.70},minerals={0.5,1.5},moonTemplate={{template=moonTemplateAsteroid,weight=10},{template=moonTemplateRealMoon,weight=5}},nbMoons={0,0,0,1,1,2}}
allOrdered[#allOrdered+1]=all.planetTemplateWarmTerra

all.planetTemplateTemperateTerra={spacePicts={"M00.png","M01.png","M02.png","M03.png","M04.png","M05.png","M06.png","M07.png","M08.png","M09.png","M10.png","M11.png"},exteriorPicts={"ln/coast_temperate.png","ln/forest_temperate.png","ln/forest_temperate2.png","ln/forest_temperate3.png","ln/coast_rocky.png"},minRadius=0.2,maxRadius=0.25,descGenerator=descModule.temperateTerraDesc,possibleNatives=natives_generator.all.temperateTerranNatives,typeName="temperateTerra",classification="Earth-like",mass={0.9,1.1},planetRadius={0.8,1.2},ua={0.9,1.2},temperature={280,292},dayLength={0.8,1.3},yearLength={0.7,2},nativeFertility={0.60,1.40},humanFertility={0.70,1.10},minerals={0.5,1.5},moonTemplate={{template=moonTemplateAsteroid,weight=10},{template=moonTemplateRealMoon,weight=5}},nbMoons={0,0,0,1,1,2}}
allOrdered[#allOrdered+1]=all.planetTemplateTemperateTerra

all.planetTemplateColdTerra={spacePicts={"P00.png","P01.png","P02.png","P03.png","P04.png","P05.png"},exteriorPicts={"ln/coast_ice.png","ln/forest_pine.png"},minRadius=0.2,maxRadius=0.25,descGenerator=descModule.coldTerraDesc,possibleNatives=natives_generator.all.coldTerranNatives,typeName="coldTerra",classification="Cold Earth-like",mass={0.9,1.1},planetRadius={0.8,1.2},ua={0.9,1.2},temperature={270,280},dayLength={0.5,2},yearLength={0.7,2},nativeFertility={0.40,0.80},humanFertility={0.50,0.70},minerals={0.5,1.5},moonTemplate={{template=moonTemplateAsteroid,weight=10},{template=moonTemplateRealMoon,weight=5}},nbMoons={0,0,0,1,1,2}}
allOrdered[#allOrdered+1]=all.planetTemplateColdTerra

all.planetTemplateMars={spacePicts={"K00.png","K02.png","K03.png","K04.png"},exteriorPicts={"ln/desert_cold.png","ln/desert_cold2.png"},minRadius=0.3,maxRadius=0.35,descGenerator=descModule.marsDesc,typeName="mars",classification="Cold Telluric",mass={0.5,1.0},planetRadius={0.5,1},ua={1.4,1.6},temperature={190,240},dayLength={0.5,2},yearLength={1.5,3},nativeFertility={0.0,0.2},humanFertility={0,0},minerals={0.5,1.5},moonTemplate={{template=moonTemplateAsteroid,weight=10},{template=moonTemplateRealMoon,weight=5}},nbMoons={0,0,0,1,1,2}}
allOrdered[#allOrdered+1]=all.planetTemplateMars

--moons for gas giants
moonTemplateFiery={spacePicts={"moon-A00.png","moon-A01.png","moon-X00.png"},exteriorPicts={"uninhabited-rocky-red-04.png","uninhabited-rocky-red-02.png"},minRadius=500,maxRadius=600,descGenerator=descModule.moonJovianFieryDesc,typeName="moonFiery",classification="Volcanic Moon",mass={0.1,0.3},planetRadius={0.1,0.3},nativeFertility={0.0,0},humanFertility={0,0},minerals={0.5,1}}
allMoonOrdered[#allMoonOrdered+1]=moonTemplateFiery
moonTemplateBarren={spacePicts={"moon-C00.png","moon-C01.png","moon-D00.png","moon-D01.png"},exteriorPicts={"ln/barren_moon.png"},minRadius=600,maxRadius=800,descGenerator=descModule.moonJovianBarrenDesc,typeName="moonBarren",classification="Rocky Moon",mass={0.1,0.3},planetRadius={0.1,0.3},nativeFertility={0.0,0},humanFertility={0,0},minerals={0.5,1}}
allMoonOrdered[#allMoonOrdered+1]=moonTemplateBarren
moonTemplateIce={spacePicts={"moon-G01.png","moon-I00.png","moon-J02.png","moon-P03.png","moon-P01.png","moon-P02.png"},exteriorPicts={"ln/barren_moon.png"},minRadius=800,maxRadius=1000,descGenerator=descModule.moonJovianIceDesc,typeName="moonIce",classification="Ice Moon",mass={0.1,0.3},planetRadius={0.1,0.3},nativeFertility={0.0,0},humanFertility={0,0},minerals={0.2,0.5}}
allMoonOrdered[#allMoonOrdered+1]=moonTemplateIce
moonTemplateMethane={spacePicts={"moon-G00.png","moon-H00.png","moon-H02.png","moon-J01.png"},exteriorPicts={"methane.png"},minRadius=800,maxRadius=1000,descGenerator=descModule.moonJovianMethaneDesc,typeName="moonMethane",classification="Methane Moon",mass={0.1,0.3},planetRadius={0.1,0.3},nativeFertility={0.0,0},humanFertility={0,0},minerals={0.5,1}}
allMoonOrdered[#allMoonOrdered+1]=moonTemplateMethane
moonTemplateVolcanicLife={spacePicts={"moon-P00.png"},exteriorPicts={"ln/mountain_ice.png"},minRadius=800,maxRadius=1000,descGenerator=descModule.moonJovianVolcanicLifeDesc,possibleNatives=natives_generator.all.lavaOasisNatives,typeName="moonVolcanicLife",classification="Volcanic Oasis Moon",mass={0.1,0.3},planetRadius={0.1,0.3},nativeFertility={0.5,0.8},humanFertility={0.3,0.6},minerals={0.5,1}}
allMoonOrdered[#allMoonOrdered+1]=moonTemplateVolcanicLife


--gas giants
all.planetHotJupiter={spacePicts={"J06.png","J08.png"},exteriorPicts={"methane.png"},minRadius=0.005,maxRadius=0.25,descGenerator=descModule.hotJupiterDesc,typeName="hotJupiter",classification="Hot Jupiter",mass={50,500},planetRadius={5,10},ua={0.25,0.7},temperature={400,800},dayLength={0.5,2},yearLength={1.5,3},nativeFertility={0,0},humanFertility={0,0},minerals={0,0},moonTemplate={{template=moonTemplateFiery,weight=10},{template=moonTemplateBarren,weight=5}},nbMoons={0,0,1,1,2}}
allOrdered[#allOrdered+1]=all.planetHotJupiter

all.planetJovian={spacePicts={"J00.png","J01.png","J02.png","J03.png","J04.png","J05.png","J07.png","J09.png"},exteriorPicts={"methane.png"},minRadius=0.3,maxRadius=0.6,descGenerator=descModule.jovianDesc,typeName="jovian",classification="Gas Giant",mass={50,1000},planetRadius={5,10},ua={1.5,4},temperature={120,220},dayLength={0.3,2},yearLength={2,12},nativeFertility={0,0},humanFertility={0,0},minerals={0,0},moonTemplate={{template=moonTemplateFiery,weight=10},{template=moonTemplateBarren,weight=10},{template=moonTemplateIce,weight=3},{template=moonTemplateMethane,weight=5},{template=moonTemplateVolcanicLife,weight=2}},nbMoons={0,0,1,1,2,2,3,4}}
allOrdered[#allOrdered+1]=all.planetJovian


local classMercury={{template=all.planetTemplateMercury,weight=1}}
local classVenus={{template=all.planetTemplateVenus,weight=5},{template=all.planetTemplateJungleVenus,weight=1}}
local classEarth={{template=all.planetTemplateWarmTerra,weight=1},{template=all.planetTemplateTemperateTerra,weight=1},{template=all.planetTemplateColdTerra,weight=1}}
local classMars={{template=all.planetTemplateMars,weight=1}}
local classHotJupiter={{template=all.planetHotJupiter,weight=1}}
local classJovian={{template=all.planetJovian,weight=1}}

local starGiant ={spacePicts={"redgiant01.png","redgiant02.png"},radius=40000,weight=1,nbPlanets={6,15},planets={{planetClass=classHotJupiter,weight=15},{planetClass=classMercury,weight=10},{planetClass=classVenus,weight=10},{planetClass=classEarth,weight=30},{planetClass=classMars,weight=10},{planetClass=classJovian,weight=20}}}
local starBright ={spacePicts={"blue01.png","blue02.png"},radius=20000,weight=2,nbPlanets={4,10},planets={{planetClass=classHotJupiter,weight=10},{planetClass=classMercury,weight=10},{planetClass=classVenus,weight=10},{planetClass=classEarth,weight=50},{planetClass=classMars,weight=10},{planetClass=classJovian,weight=20}}}
local starNormal ={spacePicts={"yellow01.png","yellow02.png"},radius=20000,weight=5,nbPlanets={0,8},planets={{planetClass=classHotJupiter,weight=5},{planetClass=classMercury,weight=10},{planetClass=classVenus,weight=10},{planetClass=classEarth,weight=50},{planetClass=classMars,weight=10},{planetClass=classJovian,weight=20}}}
local starDwarf ={spacePicts={"orange01.png","orange02.png"},radius=15000,weight=2,nbPlanets={0,6},planets={{planetClass=classMercury,weight=5},{planetClass=classVenus,weight=5},{planetClass=classEarth,weight=50},{planetClass=classMars,weight=10},{planetClass=classJovian,weight=20}}}
local starDead ={spacePicts={"orange01.png","orange02.png"},radius=15000,weight=2,nbPlanets={0,0},planets={}}

sun_templates.starsTemplate={starGiant ,starBright ,starNormal ,starDwarf }

sun_templates.starsTemplateCluster={starGiant, starBright}

sun_templates.starsTemplateDead={starDead}

--copying the keys to an id value for future reference
for k,v in pairs(all) do
  v.id=k
end

stellar_templates.default={radius=function() return 80+math.random(40) end,minDistance=function() return 80 end,starNumbers=function() return 2000 end,interference=function() return 0 end,nebuVolatility=function() return 0 end,nebuDensity=function() return 0 end,background=function() return "" end,templates=sun_templates.starsTemplate}


stellar_templates.rift={radius=function() return 0 end,minDistance=function() return 5000 end,starNumbers=function() return 2000 end,interference=function() return 0 end,nebuVolatility=function() return 0 end,nebuDensity=function() return 0 end,background=function() return "" end,templates={}}

stellar_templates.hyades={radius=function() return 50+math.random(20) end,minDistance=function() return 50 end,starNumbers=function() return 5000 end,interference=function() return 10+math.random(100) end,nebuVolatility=function() return 0 end,nebuDensity=function() return 0 end,background=function() return "hyades" end,templates=sun_templates.starsTemplateCluster}

stellar_templates.pleiades={radius=function() return 50+math.random(20) end,minDistance=function() return 50 end,starNumbers=function() return 5000 end,interference=function() return 10+math.random(100) end,nebuVolatility=function() return 0 end,nebuDensity=function() return 0 end,background=function() return "pleiades" end,templates=sun_templates.starsTemplateCluster}

stellar_templates.dead_suns={radius=function() return 80+math.random(40) end,minDistance=function() return 80 end,starNumbers=function() return 2000 end,interference=function() return 0 end,nebuVolatility=function() return 0 end,nebuDensity=function() return 0 end,background=function() return "" end,templates=sun_templates.starsTemplateDead}

stellar_templates.nebula_outer={radius=function() return 80+math.random(40) end,minDistance=function() return 80 end,starNumbers=function() return 500 end,interference=function() return 50+math.random(100) end,nebuVolatility=function() return 0 end,nebuDensity=function() return 50+math.random(100) end,background=function() return "" end,templates=sun_templates.starsTemplate}

stellar_templates.nebula_inner={radius=function() return 80+math.random(40) end,minDistance=function() return 80 end,starNumbers=function() return 500 end,interference=function() return 100+math.random(100) end,nebuVolatility=function() return 100+math.random(100) end,nebuDensity=function() return 200+math.random(200) end,background=function() return "" end,templates=sun_templates.starsTemplate}

