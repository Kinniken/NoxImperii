--[[

Class A Geothermal (Gothos)
Class B Geomorteus (Mercury)
Class C Geoinactive (Psi 2000)
Class D Asteroid/Moon (Luna)
Class E Geoplastic (Excalbia)
Class F Geometallic (Janus VI)
Class G Geocrystaline (Delta Vega)
Class H Desert (Rigel XII)
Class I Gas Supergiant (Q'tahL)
Class J Gas Giant (Jupiter)
Class K Adaptable (Mars)
Class L Marginal (Indri VIII)
Class M Terrestrial (Earth)
Class N Reducing (Venus)
Class O Pelagic (Argo)
Class P Glaciated (Breen)
Class Q Variable (Genesis Planet)
Class R Rogue (Dakala)
Class S and T Ultragiants
Class X, Y and Z Demon (Tholian homeworld (Class Y))

]]

starTemplates = {} 

include('universe/planets/planet_descs.lua')
include('universe/natives/generate_natives.lua')

local all={}

starTemplates.allPlanetsTemplate = all

--[[
	Note: the world's physical charactistic attributes and scores (mass,dayLength, fertility...) are typically expressed compared to Earth. Exceptions:
		- Temperature in K (Earth: 287)

	The minRadius and maxRadius are multipliers for the system's radius (i.e. by default the bigger a star system, the further the planets are from the sun)
]]

--terrestoid planets
all.planetTemplateMercury={spacePicts={"A00.png","A01.png"},exteriorPicts={"ln/desert3.png"},minRadius=0.05,maxRadius=0.1,descGenerator=descModule.mercuryDesc,typeName="mercury",classification="B",mass={0.03,0.1},planetRadius={0.2,0.5},ua={0.25,0.5},temperature={380,500},dayLength={40,1000},yearLength={0.1,0.5},nativeFertility={0,0},humanFertility={0,0},minerals={0,0.15}}
all.planetTemplateVenus={spacePicts={"C00.png","H00.png"},exteriorPicts={"ln/desert.png","ln/desert2.png","ln/desert3.png"},minRadius=0.1,maxRadius=0.15,descGenerator=descModule.venusDesc,typeName="venus",classification="N",mass={0.5,2},planetRadius={0.7,2},ua={0.5,0.9},temperature={500,900},dayLength={40,1000},yearLength={0.4,0.8},nativeFertility={0,0},humanFertility={0,0},minerals={0,0.30}}
all.planetTemplateJungleVenus={spacePicts={"M02.png","M04.png"},exteriorPicts={"ln/jungle.png","ln/jungle2.png","ln/jungle3.png"},minRadius=0.1,maxRadius=0.15,descGenerator=descModule.jungleVenusDesc,possibleNatives=natives_generator.warmTerranNatives,typeName="jungleVenus",classification="L",mass={0.5,1.2},planetRadius={0.7,1.2},ua={0.5,0.9},temperature={300,320},dayLength={40,1000},yearLength={0.4,0.8},nativeFertility={0.60,1.20},humanFertility={0,0.25},minerals={0.10,0.50}}
all.planetTemplateWarmTerra={spacePicts={"M05.png","M04.png"},exteriorPicts={"ln/mangrove.png","ln/coast_warm.png","ln/coast_warm2.png"},minRadius=0.2,maxRadius=0.25,descGenerator=descModule.warmTerraDesc,possibleNatives=natives_generator.warmTerranNatives,typeName="warmTerra",classification="M",mass={0.9,1.1},planetRadius={0.8,1.2},ua={0.9,1.2},temperature={292,297},dayLength={0.5,3},yearLength={0.7,2},nativeFertility={0.60,1.00},humanFertility={0.50,0.70},minerals={0.5,1.5}}
all.planetTemplateTemperateTerra={spacePicts={"M00.png","M01.png","M02.png","M03.png","M04.png","M05.png","M06.png","M07.png","M08.png","M09.png","M10.png","M11.png"},exteriorPicts={"ln/coast_temperate.png","ln/forest_temperate.png","ln/forest_temperate2.png","ln/forest_temperate3.png","ln/coast_rocky.png"},minRadius=0.2,maxRadius=0.25,descGenerator=descModule.temperateTerraDesc,possibleNatives=natives_generator.temperateTerranNatives,typeName="temperateTerra",classification="M",mass={0.9,1.1},planetRadius={0.8,1.2},ua={0.9,1.2},temperature={280,292},dayLength={0.8,1.3},yearLength={0.7,2},nativeFertility={0.60,1.40},humanFertility={0.70,1.10},minerals={0.5,1.5}}
all.planetTemplateColdTerra={spacePicts={"P00.png","P01.png","P02.png","P03.png","P04.png","P05.png"},exteriorPicts={"ln/coast_ice.png","ln/forest_pine.png"},minRadius=0.2,maxRadius=0.25,descGenerator=descModule.coldTerraDesc,possibleNatives=natives_generator.coldTerranNatives,typeName="coldTerra",classification="M",mass={0.9,1.1},planetRadius={0.8,1.2},ua={0.9,1.2},temperature={270,280},dayLength={0.5,2},yearLength={0.7,2},nativeFertility={0.40,0.80},humanFertility={0.50,0.70},minerals={0.5,1.5}}
all.planetTemplateMars={spacePicts={"K00.png","K02.png","K03.png","K04.png"},exteriorPicts={"ln/desert_cold.png","ln/desert_cold2.png"},minRadius=0.3,maxRadius=0.35,descGenerator=descModule.marsDesc,typeName="mars",classification="K",mass={0.5,1.0},planetRadius={0.5,1},ua={1.4,1.6},temperature={190,240},dayLength={0.5,2},yearLength={1.5,3},nativeFertility={0.0,0.2},humanFertility={0,0},minerals={0.5,1.5}}

--gas giants
all.planetHotJupiter={spacePicts={"J06.png","J08.png"},exteriorPicts={"methane.png"},minRadius=0.005,maxRadius=0.25,descGenerator=descModule.hotJupiterDesc,typeName="hotJupiter",classification="J",mass={50,500},planetRadius={5,10},ua={0.25,0.7},temperature={400,800},dayLength={0.5,2},yearLength={1.5,3},nativeFertility={0,0},humanFertility={0,0},minerals={0,0}}

all.planetJovian={spacePicts={"J00.png","J01.png","J02.png","J03.png","J04.png","J05.png","J07.png","J09.png"},exteriorPicts={"methane.png"},minRadius=0.3,maxRadius=0.6,descGenerator=descModule.jovianDesc,typeName="jovian",classification="J",mass={50,1000},planetRadius={5,10},ua={1.5,4},temperature={120,220},dayLength={0.3,2},yearLength={2,12},nativeFertility={0,0},humanFertility={0,0},minerals={0,0}}


local classMercury={{template=all.planetTemplateMercury,weight=1}}
local classVenus={{template=all.planetTemplateVenus,weight=5},{template=all.planetTemplateJungleVenus,weight=1}}
local classEarth={{template=all.planetTemplateWarmTerra,weight=1},{template=all.planetTemplateTemperateTerra,weight=1},{template=all.planetTemplateColdTerra,weight=1}}
local classMars={{template=all.planetTemplateMars,weight=1}}
local classHotJupiter={{template=all.planetHotJupiter,weight=1}}
local classJovian={{template=all.planetJovian,weight=1}}

local starGiant ={spacePicts={"redgiant01.png","redgiant02.png"},radius=40000,weight=1,nbPlanets={2,8},planets={{planetClass=classHotJupiter,weight=15},{planetClass=classMercury,weight=10},{planetClass=classVenus,weight=10},{planetClass=classEarth,weight=30},{planetClass=classMars,weight=10},{planetClass=classJovian,weight=20}}}
local starBright ={spacePicts={"blue01.png","blue02.png"},radius=20000,weight=2,nbPlanets={1,5},planets={{planetClass=classHotJupiter,weight=10},{planetClass=classMercury,weight=10},{planetClass=classVenus,weight=10},{planetClass=classEarth,weight=30},{planetClass=classMars,weight=10},{planetClass=classJovian,weight=20}}}
local starNormal ={spacePicts={"yellow01.png","yellow02.png"},radius=20000,weight=5,nbPlanets={0,4},planets={{planetClass=classHotJupiter,weight=5},{planetClass=classMercury,weight=10},{planetClass=classVenus,weight=10},{planetClass=classEarth,weight=30},{planetClass=classMars,weight=10},{planetClass=classJovian,weight=20}}}
local starDwarf ={spacePicts={"orange01.png","orange02.png"},radius=15000,weight=2,nbPlanets={0,3},planets={{planetClass=classMercury,weight=5},{planetClass=classVenus,weight=5},{planetClass=classEarth,weight=30},{planetClass=classMars,weight=10},{planetClass=classJovian,weight=20}}}

starTemplates.starsTemplate={starGiant ,starBright ,starNormal ,starDwarf }

--copying the keys to an id value for future reference
for k,v in pairs(all) do
  v.id=k
end
