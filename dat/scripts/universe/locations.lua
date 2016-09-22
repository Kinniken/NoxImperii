


local x,y

x,y=system.get("Sol"):coords()
local earth_pos={x=x,y=y}

x,y=system.get("Zarathu"):coords()
local ardarshir_pos={x=x,y=y}

x,y=system.get("Betelgeuse"):coords()
local betelgeuse_pos={x=x,y=y}

x,y=system.get("Sinop"):coords()
local tigray_pos={x=x,y=y}

x,y=system.get("Aksun"):coords()
local gonder_pos={x=x,y=y}

x,y=system.get("Hikari"):coords()
local shin_kyoto_pos={x=x,y=y}

x,y=system.get("Zora"):coords()
local new_rila_pos={x=x,y=y}

x,y=system.get("Varuna"):coords()
local kashi_pos={x=x,y=y}

x,y=system.get("Virgil"):coords()
local naeris_pos={x=x,y=y}

x,y=system.get("Noor"):coords()
local fez_pos={x=x,y=y}

local sol_sector={x=0,y=0}

imperial_sectors={{key="arcturus",centre=shin_kyoto_pos,innerName="Sector Arcturus",outerName="Outer Arcturus",fringeName="Arcturus Fringe"},
						{key="taurus",centre=new_rila_pos,innerName="Taurus March",outerName="Outer Taurus",fringeName="Taurus Fringe"},
						{key="antares",centre=kashi_pos,innerName="Sector Antares",outerName="Outer Antares",fringeName="Antares Fringe"},
						{key="alphacrucis",centre=naeris_pos,innerName="Sector Alphacrucis",outerName="Outer Alphacrucis",fringeName="Alphacrucis Fringe"}}

imperial_stability_zones={"Sector Sol","Hyades Cluster","Blessed Worlds","Sector Arcturus","Outer Arcturus","Taurus March","Outer Taurus","Sector Antares","Outer Antares","Sector Alphacrucis","Outer Alphacrucis"}


local function get_closest_imperial_sector(star)

	local sector=nil
	local best_dist_sq=nil

	for _,v in ipairs(imperial_sectors) do
		if not sector then
			sector=v
			best_dist_sq=gh.calculateDistanceSquare(v.centre,star)
		else
			if (gh.calculateDistanceSquare(v.centre,star)<best_dist_sq) then
				sector=v
				best_dist_sq=gh.calculateDistanceSquare(v.centre,star)
			end
		end
	end

	return sector
end

imperial_barbarian_zones={	coreward_barb={name="Coreward Barbarian Wastes",key="coreward_barb"},
rimward_barb={name="Rimward Barbarian Wastes",key="rimward_barb"},
spinward_barb={name="Spinward Barbarian Wastes",key="spinward_barb"},
contra_barb={name="Contraward Barbarian Wastes",key="contra_barb"}}

imperial_barbarian_zones_array={imperial_barbarian_zones.coreward_barb,imperial_barbarian_zones.rimward_barb,imperial_barbarian_zones.spinward_barb,imperial_barbarian_zones.contra_barb}


roidhunate_barbarian_zones={	coreward_barb={name="Coreward Roidhunate Barbarian Wastes",key="coreward_barb"},
rimward_barb={name="Rimward Roidhunate Barbarian Wastes",key="rimward_barb"},
spinward_barb={name="Spinward Roidhunate Barbarian Wastes",key="spinward_barb"},
contra_barb={name="Contraward Roidhunate Barbarian Wastes",key="contra_barb"}}

roidhunate_barbarian_zones_array={roidhunate_barbarian_zones.coreward_barb,roidhunate_barbarian_zones.rimward_barb,roidhunate_barbarian_zones.spinward_barb,roidhunate_barbarian_zones.contra_barb}

ixum_barb={name="Ixum Barbarian Wastes",key="ixum_barb"}

function get_nearest_barbarian_zone(star)

	local dist_earth=gh.calculateDistance(earth_pos,star)
	local dist_ardarshir=gh.calculateDistance(ardarshir_pos,star)
	local dist_gonder=gh.calculateDistance(gonder_pos,star)

	if (dist_earth<dist_ardarshir and dist_earth<dist_gonder) then

		local dx=star.x-earth_pos.x
		local dy=star.y-earth_pos.y

		if math.abs(dx)>math.abs(dy) then
			if (dx>0) then
				return imperial_barbarian_zones.spinward_barb
			else
				return imperial_barbarian_zones.contra_barb
			end
		else
			if (dy>0) then
				return imperial_barbarian_zones.coreward_barb
			else
				return imperial_barbarian_zones.rimward_barb
			end
		end
	elseif (dist_ardarshir<dist_gonder) then
		local dx=star.x-ardarshir_pos.x
		local dy=star.y-ardarshir_pos.y

		if math.abs(dx)>math.abs(dy) then
			if (dx>0) then
				return roidhunate_barbarian_zones.spinward_barb
			else
				return roidhunate_barbarian_zones.contra_barb
			end
		else
			if (dy>0) then
				return roidhunate_barbarian_zones.coreward_barb
			else
				return roidhunate_barbarian_zones.rimward_barb
			end
		end
	else
		return ixum_barb
	end
end

local function barbarian_fringes_names(star)
	return get_nearest_barbarian_zone(star).name
end

local function barbarian_priority(star)
	if (gh.calculateDistance(earth_pos,star)<1500 or gh.calculateDistance(ardarshir_pos,star)<1000 or gh.calculateDistance(gonder_pos,star)<700) then
		return 5
	end

	return 0
end

local priority_distance=function(centre,star,radius,priority)
	local distance=gh.calculateDistance(centre,star)

	if (distance<radius) then
		return priority
	end

	return 0
end


local function imperial_sector_names(star)

	local sector=nil
	local bestdist=nil

	for _,v in pairs(imperial_sectors) do
		if v.nospread==nil then
			if not sector then
				sector=v.name
				bestdist=gh.calculateDistance(v.center,star)
			else
				if (gh.calculateDistance(v.center,star)<bestdist) then
					sector=v.name
					bestdist=gh.calculateDistance(v.center,star)
				end
			end
		end
	end

	return sector
end

locations={}

locations.great_outer={
	priority=function(star) 
		return 1 end,
	zoneName=function(star) return "Great Outer" end,
	star_template="default",
	pop_template="great_outer"
}


locations.hyades={
	priority=function(star) 
		return priority_distance(fez_pos,star,150,1000)
	end,
	zoneName=function(star) return "Hyades Cluster" end,
	star_template="hyades",
	pop_template="empire_hyades"
}

locations.pleiades={priority=function(star) 
	return priority_distance({x=1980,y=350},star,150,1000)
	end,
	zoneName=function(star) return "The Pleiades" end,
	star_template="pleiades",
	pop_template="ardarshir_outer"
}

locations.orion_outer={priority=function(star) 
		return 	priority_distance({x=-580,y=1070},star,130,1000) + 
				priority_distance({x=-380,y=1080},star,180,1000) + 
				priority_distance({x=-160,y=1080},star,160,1000) +
				priority_distance({x=50,y=1090},star,110,1000) +
				priority_distance({x=-550,y=1310},star,130,1000)
	end,
	zoneName=function(star) return "Outer Orion Nebula" end,
	star_template="nebula_outer",
	pop_template="barbarian_heavy"
}


locations.orion_inner={priority=function(star) 
		return 	priority_distance({x=-420,y=1110},star,75,10000) + 
				priority_distance({x=-330,y=1110},star,75,10000) +
				priority_distance({x=-240,y=1110},star,75,10000)
	end,
	zoneName=function(star) return "Inner Orion Nebula" end,
	star_template="nebula_inner",
	pop_template="barbarian_heavy"
}

locations.eagle_outer={priority=function(star) 
		return 	priority_distance({x=2250,y=-1260},star,310,1000) + 
				priority_distance({x=2180,y=-1000},star,240,1000) + 
				priority_distance({x=2420,y=-860},star,260,1000) + 
				priority_distance({x=2560,y=-750},star,260,1000)
	end,
	zoneName=function(star) return "Outer Eagle Nebula" end,
	star_template="nebula_outer",
	pop_template="barbarian_heavy"
}

locations.eagle_inner={priority=function(star) 
		return 	priority_distance({x=2250,y=-1140},star,150,10000) + 
				priority_distance({x=2350,y=-960},star,150,10000) + 
				priority_distance({x=2480,y=-830},star,150,10000)
	end,
	zoneName=function(star) return "Inner Eagle Nebula" end,
	star_template="nebula_inner",
	pop_template="barbarian_heavy"
}


locations.rift={priority=function(star) 
	return 
		priority_distance({x=-1050,y=-50},star,200,2000) + 
		priority_distance({x=-1000,y=-200},star,200,2000) + 
		priority_distance({x=-900,y=-150},star,200,2000) + 
		priority_distance({x=-800,y=-300},star,200,2000) + 
		priority_distance({x=-700,y=-450},star,200,2000) +
		priority_distance({x=-600,y=-600},star,200,2000)
	end,
	zoneName=function(star) return "The Rift" end,
	star_template="rift",
	pop_template="great_outer"
}

locations.blessed={priority=function(star) 
	return 
		priority_distance({x=-800,y=-50},star,200,1000) + 
		priority_distance({x=-700,y=-200},star,200,1000) + 
		priority_distance({x=-600,y=-350},star,200,1000) +
		priority_distance({x=-500,y=-500},star,200,1000)
	end,
	zoneName=function(star) return "Blessed Worlds" end,
	star_template="default",
	pop_template="empire_blessed"
}

locations.devilclaw={priority=function(star) 
	return 
		priority_distance({x=1860,y=-160},star,75,10000) + 
		priority_distance({x=1920,y=-230},star,150,10000) + 
		priority_distance({x=1970,y=-280},star,150,10000) + 
		priority_distance({x=1950,y=-330},star,150,10000) + 
		priority_distance({x=2050,y=-390},star,200,10000) + 
		priority_distance({x=2210,y=-360},star,150,10000) + 
		priority_distance({x=1950,y=-430},star,150,10000) + 
		priority_distance({x=1840,y=-470},star,100,10000) + 
		priority_distance({x=1950,y=-430},star,120,10000) + 
		priority_distance({x=1850,y=-490},star,120,10000) + 
		priority_distance({x=1790,y=-540},star,100,10000)
	end,
	zoneName=function(star) return "The Devil's Claw" end,
	star_template="rift",
	pop_template="great_outer"
}

locations.transclaw={priority=function(star) 
	return 
		priority_distance({x=1940,y=-710},star,220,500) + 
		priority_distance({x=2190,y=-580},star,220,500)
	end,
	zoneName=function(star) return "Trans-Claw Fringe" end,
	star_template="default",
	pop_template="ardarshir_outer"
}




locations.dead_suns={priority=function(star) 
	return priority_distance({x=-600,y=600},star,300,10)+priority_distance({x=-850,y=600},star,300,10)+priority_distance({x=-1100,y=-500},star,300,10)
	end,
	zoneName=function(star) return "Sea of Dead Suns" end,
	star_template="dead_suns",
	pop_template="great_outer"
}

locations.empire_inner={
	priority=function(star) return priority_distance(earth_pos,star,250,100) end,
	zoneName=function(star) return "Sector Sol" end,
	star_template="default",
	pop_template="empire_inner"
}

locations.empire_inner_sectors={
	priority=function(star) return priority_distance(earth_pos,star,600,50) end,
	zoneName=function(star)
		local sector=get_closest_imperial_sector(star)

		return sector.innerName
	end,
	star_template="default",
	pop_template="empire_outer"
}

locations.empire_outer_sectors={
	priority=function(star) return priority_distance(earth_pos,star,900,20) end,
	zoneName=function(star)
		local sector=get_closest_imperial_sector(star)

		return sector.outerName
	end,
	star_template="default",
	pop_template="empire_outer"
}

locations.empire_fringe={
	priority=function(star) return priority_distance(earth_pos,star,1200,10) end,
	zoneName=function(star)
		local sector=get_closest_imperial_sector(star)

		return sector.fringeName
	end,
	star_template="default",
	pop_template="empire_fringe"
}

locations.orion_fringe={
	priority=function(star)
		if star.y>0 and star.y>star.x and star.y>-star.x then
			return priority_distance(earth_pos,star,1200,15)--above normal fringe
		end
		return 0
	end,
	zoneName=function(star) return "Orion Fringe" end,
	star_template="default",
	pop_template="empire_orion_fringe"
}

locations.empire_ardarshir_border={
	priority=function(star)
		local distanceEarthSq=gh.calculateDistanceSquare(earth_pos,star)
		local distanceArdarshirSq=gh.calculateDistanceSquare(ardarshir_pos,star)

		if (distanceEarthSq<1200^2 and distanceArdarshirSq<1200^2) then
			return 15
		end
		return 0
	end,
	zoneName=function(star) return "Buffer Zone" end,
	star_template="default",
	pop_template="empire_ardarshir_border"
}

locations.barbarian_fringe={
	priority=barbarian_priority,
	zoneName=barbarian_fringes_names,
	star_template="default",
	pop_template="barbarian_fringe"
}

locations.ardarshir_inner={
	priority=function(star) return priority_distance(ardarshir_pos,star,250,100) end,
	zoneName=function(star) return "Inner Roidhunate" end,
	star_template="default",
	pop_template="ardarshir_inner"
}

locations.ardarshir_outer={
	priority=function(star) return priority_distance(ardarshir_pos,star,500,45) end,
	zoneName=function(star) return "Outer Roidhunate" end,
	star_template="default",
	pop_template="ardarshir_outer"
}

locations.ardarshir_fringe={
	priority=function(star) return priority_distance(ardarshir_pos,star,700,18) end,
	zoneName=function(star) return "Roidhunate Fringes" end,
	star_template="default",
	pop_template="ardarshir_fringe"
}

locations.betelgeuse={
	priority=function(star) return priority_distance(betelgeuse_pos,star,200,100) end,
	zoneName=function(star) return "Betelgeuse" end,
	star_template="default",
	pop_template="betelgeuse"
}

locations.kingdom_of_ixum={
	priority=function(star) return priority_distance(tigray_pos,star,200,1000) end,
	zoneName=function(star) return "Ixum" end,
	star_template="default",
	pop_template="kingdom_of_ixum"
}

locations.holy_flame_of_ixum={
	priority=function(star) return priority_distance(gonder_pos,star,350,900) end,
	zoneName=function(star) return "Ixum" end,
	star_template="default",
	pop_template="holy_flame_of_ixum"
}

for k,v in pairs(locations) do
	v.id=k
end

function get_zone(star)
	local pickedZone
	local priority=0

	for k,zone in pairs(locations) do
		if (not pickedZone) then
			pickedZone=zone
			priority=zone.priority(star)
		elseif (zone.priority(star)>priority) then
			pickedZone=zone
			priority=zone.priority(star)
		end
	end

	return pickedZone
end




