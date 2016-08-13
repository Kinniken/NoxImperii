function getGreatSurveyDesc()

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

	local surveyDesc=" "
	local planetDesc=" "
	local planetCount=" "
	local nativesDes=" "
	local nativesCount=" "

	if not surveyDone then
		surveyDesc="You have not started the Great Survey. Speak to an old pilot on any Imperial world to start it."
	else
		surveyDesc="Explore more worlds outside the influence of the Empire, the Roidhunate, Betelgeuse or Ixum to progress in the Second Great Survey."

		planetDesc=""
		planetCount=""

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

	return surveyDesc,planetDesc,planetCount,nativesDes,nativesCount
end