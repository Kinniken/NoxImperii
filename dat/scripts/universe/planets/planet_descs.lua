include('dat/scripts/general_helper.lua')

descModule = {}

local earthAverageTemp = 287 -- In K, used for comparisons
local temperatureKtoC = 273 -- (approximate)

local function tempHelper(temp)
	return gh.floorTo(temp,-1).."K ("..gh.floorTo(temp-temperatureKtoC,-1).." C)"
end

function descModule.mercuryDesc(planet)

	local descs={}

	--convention: first desc has no criteria, to ensure at least one will be valid
	descs[#descs+1]={weight=10, desc=
		"The barren landscape of #planetname# is protected by only traces of atmosphere. In the shadows of its sharp peaks, "..
		"temperatures reach "..tempHelper(planet.temperature)..". In the ".. 
		"full light of #sunname#, even iron melts."
	}

	descs[#descs+1]={weight=20,weightValidity=function(planet) return planet.dayLength>500 end, desc=
		"#planetname#'s orbit around #sunname# is particularly tight, leaving it hot and barren, with temperatures reaching "..tempHelper(planet.temperature)..". A Mercury-style planet, it is an "..
		"almost tidally-locked inferno, with a short year of just "..gh.floorTo(planet.yearLength,2).." Earth year. "
	}

	descs[#descs+1]={weight=10, desc=
		"#planetname#'s mass of only "..gh.floorTo(planet.mass,2).." TA is too small to preserve an atmosphere so close to #sunname#. "..
		"The result is a fiery landscape of baked rocks and jutting mountains, where no known life could survive. Small amounts of "..
		"mineral wealth seem present below the fiery surface, though too little to justify mining such an inhospitable world."
	}

	descs[#descs+1]={weight=10, desc=
		"The bleak but spectacular landscapes of #planetname# would inspire generation of artists, if only it was possible to survive "..
		"long enough under the rays of #sunname# to admire the view."
	}

	return gh.pickConditionalWeightedObject(descs,planet).desc
end

function descModule.venusDesc(planet) 

	local descs={}

	--convention: first desc has no criteria, to ensure at least one will be valid
	descs[#descs+1]={weight=10, desc=
		"Gripped by a strong greenhouse effect, #planetname# suffocates under a thick atmosphere. "..
		"The planet's year lasts "..gh.floorTo(planet.yearLength,2).." Earth year, though seasons are barely marked. "..
		"What little mineral wealth might hide in such an inhospitable environment is surely not worth the danger."
	}

	descs[#descs+1]={weight=20,weightValidity=function(planet) return planet.planetRadius<1 end, desc=
		"#planetname#'s hot surface is hidden below a permanent cloud cover. A little smaller than Earth, "..
		"it rotates on itself in "..gh.floorTo(planet.dayLength*24,1).." standard day. All in all, #planetname# "..
		"appears to be a fairly typical Venusian planet - not worth the time of any known sapient race."
	}

	descs[#descs+1]={weight=10,desc=
		"#planetname# ended on the wrong side of the habitable zone - too close to #sunname#, it suffers from "..
		"temperatures averaging "..tempHelper(planet.temperature)..". Its thick atmosphere looks beautiful from space, "..
		"but will never shelter life."
	}

	descs[#descs+1]={weight=20,weightValidity=function(planet) return planet.mass>1.5 end, desc=
		"Unusually massive for a rocky world so close to its sun, #planetname# weights a solid "..gh.floorTo(planet.mass,1)..
		" Earth mass. Its high surface gravity helps maintain a thick atmosphere, and the resulting greenhouse effect keeps "..
		" surface temperatures at a boiling "..tempHelper(planet.temperature).."."
	}

	return gh.pickConditionalWeightedObject(descs,planet).desc
end

function descModule.jungleVenusDesc(planet) 

	local descs={}

	--convention: first desc has no criteria, to ensure at least one will be valid
	descs[#descs+1]={weight=10, desc=
		"Under dense clouds, #planetname# hides rolling jungles bordering warm oceans. "..
		"Marine animal larger than any ever seen in Terran oceans roam the shallow seas, "..
		"while marshes extend far inland, populated with massive amphibians."
	}

	descs[#descs+1]={weight=20,weightValidity=function(planet) return planet.lua.humanFertility>0.1 end, desc=
		"#planetname# is one of those almost Earth-like world - too hot and humid for men, "..
		"but with a developed native ecology. Great banks of alga populate the world's waters, "..
		"providing fodder for massive swarms of marine life. Humans are able to survive on #planetname#, though only marginally so."
	}

	descs[#descs+1]={weight=20,weightValidity=function(planet) return planet.lua.nativeFertility<0.8 end, desc=
		"Hot by Terran standards, #planetname# is still home to an active ecology, mainly in coastal areas. "..
		"Further inland, heat and the lack of rain soon turn the landscape to desert. The main deltas however "..
		"are home to a biodiversity to rival Earth's most fertile areas."
	}

	descs[#descs+1]={weight=10,weightValidity=function(planet) return planet.lua.nativeFertility>1 end, desc=
		"Teeming with life despite temperatures in the "..tempHelper(planet.temperature).." range, "..
		"#planetname# seems covered with dense jungles criss-crossed with slow-flowing, broad rivers. "..
		"Massive creatures roam the forests, feeding from colossal trees or each other. "..
		"In fact, #planetname# could have been copied from 19th-century fantasies of a jungle-covered Venus..."
	}

	return gh.pickConditionalWeightedObject(descs,planet).desc
end

function descModule.warmTerraDesc(planet)

	local descs={}

	--convention: first desc has no criteria, to ensure at least one will be valid
	descs[#descs+1]={weight=10, desc=
		"The bright rays of #sunname# give #planetname# a distinct tropical feel, with a temperature averaging a "..
		gh.floorTo(planet.temperature-earthAverageTemp,0).." full degrees above Earth's. "..
		"Only traces of glaciers remain on top of particularly tall mountains. "..
		"The local ecology is varied and developed, in surprisingly Earth-like fashion; ecosystems reminiscent of "..
		"Terran jungles, savannah and mangroves are common."
	}

	descs[#descs+1]={weight=20,weightValidity=function(planet) return planet.lua.nativeFertility>1 end, desc=
		"Generously warmed by the rays of #sunname#, #planetname# looks like a warmer, more fertile Earth, "..
		"something out of the Cretaceous period. Though deserts are common near the equator, the continents are "..
		"very fertile, with rich alluvial plains roamed by herds of large mammal-like animals."
	}

	descs[#descs+1]={weight=20,weightValidity=function(planet) return planet.lua.nativeFertility<0.8 end, desc=
		"#planetname# looks like it could have been an other Earth, but high average temperatures turned "..
		"part of the world barren. Seemingly endless deserts merge into dry savannah, while forests of cactus-like trees cluster "..
		"around rare oasis."
	}

	descs[#descs+1]={weight=20,weightValidity=function(planet) return #planet.lua.settlements==0 end, desc=
		"The oceans of #planetname# are dotted with archipelagos, stretching over thousand of kilometres. Coral-like "..
		"creatures have patiently accumulated into colourful formations inhabited by a varied marine life. The empty beaches of sand "..
		"of unearthly colours seem to be waiting for sapient visitors."
	}

	return gh.pickConditionalWeightedObject(descs,planet).desc
end

function descModule.temperateTerraDesc(planet)

	local descs={}

	--convention: first desc has no criteria, to ensure at least one will be valid
	descs[#descs+1]={weight=10, desc=
		"#planetname# is an impressively Earth-like world, with a day of "..gh.floorTo(planet.dayLength*24).." hours. "..
		"The vegetation has developed in parallel forms, with a green-blue colour dominating and tall fronds covered with "..
		"huge flowers of varied colours. Native animals tend to be viviparous, including the analogues for birds."
	}

	descs[#descs+1]={weight=20,weightValidity=function(planet) return planet.planetRadius>1.05 end, desc=
		"Though a little larger than Earth, with a radius of "..gh.floorTo(planet.planetRadius,1).." TA, #planetname# "..
		"is as close to a sister world as can be found in the Galaxy. Only its higher tectonic activity really differentiates "..
		"it: mountain ranges are sharper and taller, and numerous active volcanoes provide fertile land in-between terrifying "..
		"eruptions."
	}

	descs[#descs+1]={weight=20,weightValidity=function(planet) return planet.lua.minerals>1.1 end, desc=
		"#planetname# is an ecologically rich world, with a biosphere very comparable to Earth's. Its great natural "..
		"resources include mineral-rich mountain ranges and unusually important deposits of rare elements. The oceans "..
		"however are unusually empty, with a striking lack of the large marine animals so common on Earth-like planets."
	}

	descs[#descs+1]={weight=20,weightValidity=function(planet) return planet.lua.nativeFertility>1.1 end, desc=
		"#planetname# is a biologist's paradise; its varied ecosystems span the whole range of Terran types, "..
		"often with greater diversity. Even the Arctic tundras teem with unusually cold-resistant avians. "..
		"Deep oceans with fast current have also led to a more fragmented evolution, with cold-blooded lifeforms "..
		"dominating one of the most isolated continent while mammal-like animals are more present on the rest."
	}

	return gh.pickConditionalWeightedObject(descs,planet).desc
end

function descModule.coldTerraDesc(planet)

	local descs={}

	--convention: first desc has no criteria, to ensure at least one will be valid
	descs[#descs+1]={weight=10, desc=
		"#planetname# is a cold and windy world, though still habitable by humans. Locked in a permanent "..
		"ice age, most of its land areas are made up of barren ice plains. Closer to the equator, tundras "..
		"provide grazing for sparse herds of herbivores covered in thick coats of quasi-feathers."
	}

	descs[#descs+1]={weight=10, desc=
		"The white plains of #planetname# are swept by freezing winds which keep down all vegetations. "..
		"Close to the seas toward the equator, some sheltered valleys host timid forests of tough, "..
		"spindly trees. Animal life is rare outside the oceans."
	}

	descs[#descs+1]={weight=20,weightValidity=function(planet) return planet.lua.humanFertility<0.6 end, desc=
		"During #planetname#'s short summer, the coastal areas along the world's equator can be almost pleasant "..
		"for humans - daytime temperatures rise to 10 or 15 C, the local vegetation enters a growth spurt, and "..
		"most native animals wake from their long hibernations. It would be a mistake however to judge the planet "..
		"based on that short time - during the rest of the year, and permanently beyond the tropics, it is more "..
		"inhospitable than Antarctica."
	}

	descs[#descs+1]={weight=20,weightValidity=function(planet) return planet.yearLength>1.2 end, desc=
		"#planetname# takes a long "..gh.floorTo(planet.yearLength*365).." Earth days to go around "..
		"#sunname#, and most of it is a long, deep winter. Ice sheets cover the world up to the "..
		"tropics, and much of the equatorial areas are occupied by tall mountains from which glaciers flow "..
		"toward almost-frozen oceans. The seas however are filled with life, supported by active underwater volcanoes."
	}

	return gh.pickConditionalWeightedObject(descs,planet).desc
end

function descModule.marsDesc(planet)

	local descs={}

	--convention: first desc has no criteria, to ensure at least one will be valid
	descs[#descs+1]={weight=10, desc=
		"#planetname#'s lonely orbit "..gh.floorTo(planet.ua,2).." UAs from #sunname# last a long "..
		gh.floorTo(planet.yearLength*365).." Earth days. Seasons are of little relevance in any case "..
		"on this world with only traces of atmosphere and no surface liquid water. A few lichens are the "..
		"only remain of an ecosystem that withered long ago."
	}

	descs[#descs+1]={weight=20,weightValidity=function(planet) return planet.planetRadius<0.8 end, desc=
		"#planetname# is small, with a radius only "..gh.floorTo(planet.planetRadius*100).."% that of Earth. "..
		"With almost no atmosphere, no volcanic activity and temperatures stuck in the freezing range, "..
		"it is now a barren world. If the past was any different, no traces are left."
	}

	descs[#descs+1]={weight=10, desc=
		"Only barely-detectable colonies of unicellular organisms remain of #planetname#'s livelier past. "..
		"Today it is a barren world of freezing temperatures and minimal atmosphere. Even volcanic activity "..
		"has stopped, leaving ancient volcanoes jutting out of the landscape, spared erosion now that "..
		"liquid water is gone from the surface."
	}

	return gh.pickConditionalWeightedObject(descs,planet).desc
end

function descModule.hotJupiterDesc(planet)

	local descs={}

	--convention: first desc has no criteria, to ensure at least one will be valid
	descs[#descs+1]={weight=10, desc=
		"A massive world at "..gh.floorTo(planet.mass).." earth masses, #planetname# orbits close to #sunname#. "..
		"Its fiery atmosphere averages temperatures of "..tempHelper(planet.temperature)..", and is shaken "..
		"by massive storms visible from space."
	}

	descs[#descs+1]={weight=10, desc=
		"Worlds like #planetname# were among those first detected from Earth, early in the space age: "..
		"as massive as Jupiter, but orbiting close to their stars - infernos of hurling hurricanes and terrible "..
		"pressures. Even spaceships are not safe deep into its deadly atmosphere."
	}

	descs[#descs+1]={weight=10, desc=
		"Is it a sign of how jaded mankind has become to space that a world like #planetname#, a massive "..
		"planet of "..gh.floorTo(planet.mass).." earth masses, hurricanes that could swallow Terra, and a surface "..
		"more remote and mysterious than the deepest seas of human worlds, would be met with a shrug by most "..
		"captains? There is indeed nothing to gain here, in this fiery Jupiter."
	}

	return gh.pickConditionalWeightedObject(descs,planet).desc
end

function descModule.jovianDesc(planet)

	local descs={}

	--convention: first desc has no criteria, to ensure at least one will be valid
	descs[#descs+1]={weight=10, desc=
		gh.floorTo(planet.ua,1).." UAs from #sunname#, the gas giant #planetname# takes "..gh.floorTo(planet.yearLength*365)..
		" Earth days to complete a single rotation. Despite the small amount of sunlight it receives, its atmosphere "..
		"is extremely active, with vast storms powered by heat generated by the planet's slow compression."
	}

	descs[#descs+1]={weight=10, desc=
		"#planetname# is classified as an cold gas giant, with an atmospheric temperature of around "..tempHelper(planet.temperature)..
		". Its surface is an ill-defined transition from an ever-thicker atmosphere to a rocky core far, far below the storms "..
		"visible from space."
	}

	descs[#descs+1]={weight=20,weightValidity=function(planet) return planet.mass>500 end, desc=
		"#planetname# is massive, even for a Jovian planet, with its "..gh.floorTo(planet.mass).." Earth mass. Its "..
		"atmosphere of hydrogen and helium is rocked by perpetual storms, until in the depth of the giant planet "..
		"the hydrogen turns into exotic forms of ice, a hazy surface which the rays of #sunname# never reaches."
	}

	return gh.pickConditionalWeightedObject(descs,planet).desc
end

