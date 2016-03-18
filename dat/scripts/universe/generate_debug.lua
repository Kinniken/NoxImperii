

includeFolders={"live",G.NATIVES,"objects","planets","settlements",".."}

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

include('dat/scripts/general_helper.lua')

include('universe/live/live_universe.lua')

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
for i=0,10 do
	--debugGenerateStar(0,0)
	
  --Ardar core
  --debugGenerateStar(1800,-100)
	
  --Betelgeuse
  --debugGenerateStar(1000,460)
  
  --Great Beyond
  debugGenerateStar(5000,5000)
end

