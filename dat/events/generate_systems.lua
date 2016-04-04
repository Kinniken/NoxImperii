include('universe/objects/class_systems.lua')
include('universe/generate_system.lua')
include('universe/live/live_desc.lua')
include('universe/live/live_universe.lua')
include('universe/objects/class_planets.lua')



local function nameTakenSystem(name)	
	return (system.exists(name))
end

local function nameTakenPlanet(name)		
	return (planet.exists(name))
end

local function createAroundStar(c_sys,nextlevel,level,visited)

	visited[c_sys:name()]=true

	local known=(debugMode and true or false)

	local sys=system_class.load(c_sys)

	if (not sys.lua.generatedNearbySystems) then
		local x,y=sys.c:coords()

		for i=1,25 do

			local radius=80+math.random(40)
			local angle=math.random()*math.pi*2

			local targetx = x + radius * math.cos(angle);
			local targety = y + radius * math.sin(angle);

			local existingSystems=system.withinRadius(targetx,targety,80)

			if (#existingSystems==0) then

				local star=starGenerator.generateStar(targetx,targety,nameTakenSystem,nameTakenPlanet)

				system.createSystem(star.name,targetx,targety,500,star.template.radius,"",star.zone,known)

				local newsys=system.get(star.name)

				newsys:addStar(star.spacePict)

				for k2,p in pairs(star.planets) do



					newsys:createPlanet(p.name,p.x,p.y,p.spacePict,p.exteriorPict,p.factionPresence,p.factionRange,p.faction,p.baseDesc,"","History"," ",0,0,p.template.classification,1,"",p.services.fuel,p.services.bar,p.services.missions,p.services.commodity,p.services.outfits,p.services.shipyard,known)

					p.c=planet.get(p.name)

					generatePlanetServices(p)

					p.lua.initialized=true
					p:save()
				end

				system.createJump(newsys,sys.c,true,known)

				local nearbySystems=system.withinRadius(targetx,targety,105)

				for k2,nearbySystem in pairs(nearbySystems) do
					if (nearbySystem~=newsys) then
						system.createJump(newsys,nearbySystem,true,known)
					end
				end

				--if not enough jumps we try targeting somewhat father systems
				if (#(system.jumps(newsys))<3) then
					nearbySystems=system.withinRadius(targetx,targety,120)

					for k2,nearbySystem in pairs(nearbySystems) do
						if (nearbySystem~=newsys) then
							system.createJump(newsys,nearbySystem,true,known)
						end
					end
				end

				nextlevel[#nextlevel+1]=newsys
			end
		end
	
		sys.lua.generatedNearbySystems=true
		sys:save()
	else
		for k,nearbySysC in pairs(sys.c:adjacentSystems(true)) do
			nearbySys=system_class.load(nearbySysC)

			if not visited[nearbySysC:name()] then
				nextlevel[#nextlevel+1]=nearbySysC
			end
		end
	end
end

function create()
	
	local stepNumber=(debugMode and 10 or 3)
	
	math.randomseed(os.time())
	
	local currentlevel={system.cur()}
	local nextlevel={}
	local visited={}

	for level=0,stepNumber do
		for k,sys in pairs(currentlevel) do
			createAroundStar(sys,nextlevel,level,visited)
		end
		currentlevel=nextlevel
		nextlevel={}
	end

	evt.finish()
end



