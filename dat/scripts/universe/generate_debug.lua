

includeFolders={"live","natives","objects","planets","settlements",".."}

package.path = package.path .. ";?.lua"

for k,v in pairs(includeFolders) do
	package.path=package.path..";"..v.."/?.lua"
end

function include(file)
	local path=file:match("([^/]+)%.lua")
	require(path)
end

commodity = {get=function(name) return name end}


include('universe/generate_system.lua')

include('universe/generate_helper.lua')

include('universe/live/live_services.lua')

include('universe/objects/class_planets.lua')


function debugGenerateStar(x,y)

	local star=starGenerator.generateStar(x,y,nameTaken,nameTaken)

	print(star.name..":"..star.spacePict..":"..star.populationTemplate.name)

	for k,planet in pairs(star.planets) do 
		generatePlanetServices(planet)
		print(planet.name.." "..planet.spacePict.." "..planet.x.."/"..planet.y.." "..planet.template.typeName)
		print("---")
		print(dump.tostring(planet.lua))
		print("---")
		print(planet.baseDesc)
		print("---")
		print(generateLiveSettlementsDesc(planet))
		print("---")
		print(planet.c:displayTradeData())

		print()
	end

	print ("")
	print ("")

end 

function nameTaken(name)
	if (math.random()>0.9) then
		return true
	else
		return false
	end
end



math.randomseed( tonumber(tostring(os.time()):reverse():sub(1,6)) )

--Brute-force method to try and ensure all paths get taken
for i=0,2000 do
	starGenerator.generateStar(math.random(6000)-3000,math.random(6000)-3000,nameTaken,nameTaken)
end

--a few samples
for i=0,3 do
	--debugGenerateStar(0,0)
	--debugGenerateStar(50,50)
	debugGenerateStar(-1000,0)
end

local human_advanced_planet=planet_class.createNew()
human_advanced_planet.lua.humanFertility = 0.8
human_advanced_planet.lua.minerals = 1
human_advanced_planet.lua.nativeFertility = 0.7
human_advanced_planet.lua.settlements = {
		humans = {
			agriculture = 0.9,
			industry = 1.5,
			military = 0.5,
			population = 33085390,
			services = 1.3,
			stability = 0.9,
			technology = 1.5,
			activeEffects = { },
			extraGoodsSupply = { },
			suppressGoodDemand = {  },
			suppressGoodSupply = {  }
		}
	}
generatePlanetServices(human_advanced_planet)
print(generateLiveSettlementsDesc(human_advanced_planet))
print(human_advanced_planet.c:displayTradeData())

local human_outer_planet=planet_class.createNew()
human_outer_planet.lua.humanFertility = 0.8
human_outer_planet.lua.minerals = 1
human_outer_planet.lua.nativeFertility = 0.7
human_outer_planet.lua.settlements = {
		humans = {
			agriculture = 0.8,
			industry = 1,
			military = 0.8,
			population = 60131261,
			services = 0.9,
			stability = 1,
			technology = 0.63,
			activeEffects = { },
			extraGoodsSupply = { },
			suppressGoodDemand = { },
			suppressGoodSupply = { }
		}
	}
generatePlanetServices(human_outer_planet)
print(generateLiveSettlementsDesc(human_outer_planet))
print(human_outer_planet.c:displayTradeData())


local human_primitive_planet=planet_class.createNew()
human_primitive_planet.lua.humanFertility = 0.8
human_primitive_planet.lua.minerals = 1
human_primitive_planet.lua.nativeFertility = 0.7
human_primitive_planet.lua.settlements = {
		humans = {
			agriculture = 0.6,
			industry = 0.6,
			military = 1.3,
			population = 6131261,
			services = 0.62,
			stability = 0.9,
			technology = 0.24,
			activeEffects = { },
			extraGoodsSupply = { },
			suppressGoodDemand = { },
			suppressGoodSupply = { }
		}
	}
generatePlanetServices(human_primitive_planet)
print(generateLiveSettlementsDesc(human_primitive_planet))
print(human_primitive_planet.c:displayTradeData())


local native_planet=planet_class.createNew()
native_planet.lua.humanFertility = 0.05717078692148
native_planet.lua.minerals = 0.29106526290582
native_planet.lua.nativeFertility = 0.77104404176168
native_planet.lua.natives = {
		agriculture = 1,
		civilized = false,
		industry = 1,
		military = 1,
		name = "Brechdiodaich",
		population = 15625087.832369,
		services = 1,
		stability = 1,
		technology = 1,
		activeEffects = { },
		goodsDemand = { },
		suppressGoodDemand = { },
		suppressGoodSupply = { },
		extraGoodsDemand = {
			{
				demand = 1,
				price = 1,
				type = "Non-Industrial Weapons",
			},
			{
				demand = 0.5,
				price = 1,
				type = "Non-Industrial Tools",
			},
			{
				demand = 0.5,
				price = 1,
				type = "Primitive Armament",
			},
			{
				demand = 0.5,
				price = 1,
				type = "Primitive Industrial Goods",
			},
			{
				demand = 0.2,
				price = 1,
				type = "Primitive Consumer Goods",
			},
		},
		extraGoodsSupply = {
			{
				price = 0.5,
				supply = 14.387644934593,
				type = "Exotic Food",
			},
		},
	}
native_planet.lua.settlements = { }


generatePlanetServices(native_planet)
print(generateLiveSettlementsDesc(native_planet))
print(native_planet.c:displayTradeData())


local merseia_planet=planet_class.createNew()
merseia_planet.lua={
	humanFertility = 1,
	minerals = 0.5,
	nativeFertility = 1,
	settlements = {
		merseians = {
			agriculture = 1.2,
			industry = 1.5,
			population = 5485425968,
			technology = 1.2,
			services = 1.5,
			military = 1.5,
			stability = 1,
			extraGoodsSupply = { {type="Roidhun Fine Telloch",supply=20,price=0.1} },
			extraGoodsDemand = { {type="Bordeaux Grands Crus",demand=20,price=3} },
			suppressGoodDemand = { {type="Roidhun Fine Telloch"} }
		},
	},
}
generatePlanetServices(merseia_planet)
print(generateLiveSettlementsDesc(merseia_planet))
print(merseia_planet.c:displayTradeData())