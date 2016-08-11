include "universe/planets/planet_templates.lua"
include('universe/natives/generate_natives.lua')


function updateUniverseDesc()

	local desc="Empire-Roidhunate Balance of Power: "

	local bop=var.peek("universe_balanceofpower")

	if bop==nil then
		bop=0
	end

	if (bop>80) then
		desc=desc.."Terran edge"
	elseif (bop<-80) then
		desc=desc.."Ardar edge"
	else
		desc=desc.."stalemate"
	end

	if bop>=0 then
		desc=desc.." (+"..bop..")"
	else
		desc=desc.." ("..bop..")"
	end

	desc=desc.."\n\nEmpire of Terra: the Empire is weak and divided, gangrened by corruption and stifled by Imperial bureaucracy. But it is still the mightiest power in the Galaxy, and the Imperial Navy still manages to keep the Roidhunate and the barbarian realms at bay."

	if var.peek("intro_kert_side")==true then
		desc=desc.." A campaign against dereliction of duty among officers in the Navy has boosted troop moral."
	elseif var.peek("intro_breton_side")==true then
		desc=desc.." Increasing corruption and carelessness among noble-born officers is damaging Navy moral."
	end

	if var.peek("empire_missions_5")==true then
		desc=desc.." In a surprising reversal, the Empire has started protecting independent worlds from barbarians again."
	elseif var.peek("empire_missions_4")==true then
		desc=desc.." Pre-emptive attacks against barbarian fleets are reducing raids."
	elseif var.peek("empire_missions_3")==true then
		desc=desc.." More aggressive tactics against barbarian leaders are showing promises."
	end

	if var.peek("harkan_empire_win")==true then
		desc=desc.." The recent takeover of Harkan, and with it its precious supplies of Unobtainium, has given a new edge to the Navy. There is life yet in the old Empire!"
	elseif var.peek("harkan_roidhunate_win")==true then
		desc=desc.." The recent defeat at Harkan, and with it the takeover by the Ardars of the precious supplies of Unobtainium, has dealt a stinging blow to the Navy. Nox Imperii is an hour closer..."
	end

	desc=desc.."\n\nRoidhunate of Ardarshir: disciplined and ambitious, the Roidhunate is dedicated to one goal: installing the Roidhun as overlord of the Galaxy. The young and determined rival of Terra cannot yet challenge the Imperial fleets in all-out war, but every year that passes the gap narrows."

	if var.peek("roidhunate_missions_5") then
		desc=desc.." Ardar fleets have started picking out isolated Imperial fleets, under the thin guise of mercenary activity."
	end

	if var.peek("harkan_empire_win")==true then
		desc=desc.." The failure of the Ardar plans on Harkan have however delayed the Roidhunate's plans. Surely a temporary set back..."
	elseif var.peek("harkan_roidhunate_win")==true then
		desc=desc.." The victory on Harkan is surely the first of many more; once again the Roidhunate has shown that audacity and aggressiveness pays against the decadent Empire."
	end

	desc=desc.."\n\n"..[[Oligarchy of Betelgeuse: the rich Betelgian duchy has always been focused more on trade and exploration than on war, and the Doge is doing his best to keep out of the Terran-Roidhunate rivalry. For now, Betelgeuse grows rich as a trade hub between the two powers, but the day is surely coming where it will have to pick a side.

Kingdom of Ixum and Holy Flame of Ixum: decades into the uprising by the priests of Ixum against the monarchy, there is no end in sight for the Galaxy's bloodiest civil war. Backed by the Roidhunate, the Holy Flame attempts to finish overthrowing the King; backed by the Empire, His Majesty holds on to his shrunken realm.

Independent Worlds: on the fringes of Imperial space, small colonies of human settlers or native species having just reached interstellar travel suffer the brunt of barbarian invasions. In another age, the Empire would have extended its protection to them and gradually assimilated them in Imperial space; today the Imperial Navy is far too stretched-out to venture much beyond Imperial worlds.

Barbarians: beyond the borders of the Empire, barbarian kingdoms are more active than ever. Armed with technology stolen or traded from more advanced species, they raid the fringes of human space with more daring every year. Only their lack of coordination prevents more serious inroad into Imperial space.]]


-- 	desc=desc.."\n\n"..[[Current stability of the Imperial Sectors:

-- ]]

-- 	for _,v in ipairs(imperial_sectors) do
-- 		local stability=var.peek("universe_stability_"..v.key)
-- 		desc=desc..[[	]]..v.name..": "..gh.floorTo(100*stability)..'%\n'
-- 	end

-- 	desc=desc..[[

-- Current barbarian activity:

-- ]]

-- 	for _,v in ipairs(imperial_barbarian_zones_array) do
-- 		local activity=var.peek("universe_barbarian_activity_"..v.key)
-- 		desc=desc..[[	]]..v.name..": "..gh.floorTo(100*activity)..'%\n'
-- 	end

	var.push("universe_status",desc)

end


function updateGreatSurveyDesc()

	local updateGreatSurveyDesc = ""

	local surveyDone=false

	local planetCounters = {}

	for _,v in ipairs(starTemplates.allPlanetsTemplateOrdered) do

		if not v.classification then
			print("Warning: planet without classification! Key: "..k)
		else
			local counter=var.peek("survey_planet_"..v.classification)

			if not counter then
				counter=0
			else
				surveyDone=true
			end

			planetCounters[#planetCounters+1]={v.classification,counter}
		end
	end

	local moonCounters = {}

	for _,v in ipairs(starTemplates.allMoonsTemplateOrdered) do

		if not v.classification then
			print("Warning: moon without classification! Key: "..k)
		else
			local counter=var.peek("survey_planet_"..v.classification)

			if not counter then
				counter=0
			else
				surveyDone=true
			end

			moonCounters[#moonCounters+1]={v.classification,counter}
		end
	end


	local nativeCounters = {}

	for _,v in ipairs(natives_generator.ordered) do
		if not v.label then
			print("Warning: natives without label! Key: "..k)
		else
			local counter=var.peek("survey_natives_"..v.id)

			if not counter then
				counter=0
			else
				surveyDone=true
			end

			nativeCounters[#nativeCounters+1]={v.label,counter}
		end
	end

	local surveyDesc=""
	local planetDesc=""
	local planetCount=""
	local nativesDes=""
	local nativesCount=""

	if not surveyDone then
		surveyDesc="You have not started the Great Survey. Speak to an old pilot on any Imperial world to start it."
	else
		surveyDesc="Explore more worlds outside the influence of the Empire, the Roidhunate, Betelgeuse or Ixum to progress in the Second Great Survey."

		for k,v in ipairs(planetCounters) do
			planetDesc=planetDesc..v[1]..":\n"
			planetCount=planetCount..v[2].."\n"
		end

		planetDesc=planetDesc.."\n"
		planetCount=planetCount.."\n"

		for k,v in ipairs(moonCounters) do
			planetDesc=planetDesc..v[1]..":\n"
			planetCount=planetCount..v[2].."\n"
		end

		nativesDes=""
		nativesCount=""

		for k,v in ipairs(nativeCounters) do
			nativesDes=nativesDes..v[1]..":\n"
			nativesCount=nativesCount..v[2].."\n"
		end
	end

	var.push("great_survey_status",surveyDesc)
	var.push("great_survey_status_worlds",planetDesc)
	var.push("great_survey_status_worlds_count",planetCount)
	var.push("great_survey_status_natives",nativesDes)
	var.push("great_survey_status_natives_count",nativesCount)
end