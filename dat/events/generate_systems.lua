include('universe/objects/class_systems.lua')
include('universe/generate_system.lua')
include('universe/live/live_desc.lua')
include('universe/live/live_universe.lua')
include('universe/objects/class_planets.lua')


function create()
	
	local stepNumber=(debugMode and 10 or 6)
	
	math.randomseed(os.time())
	
	local currentlevel={system.cur()}
	local nextlevel={}
	local visited={}

	for level=0,stepNumber do
		for k,sys in pairs(currentlevel) do
			starGenerator.createAroundStar(sys,nextlevel,level,visited)
		end
		currentlevel=nextlevel
		nextlevel={}
	end

	evt.finish()
end



