include "dat/status/great_survey.lua"
include "dat/status/storyline.lua"
include "dat/status/universe.lua"


function refreshStatus()
	local universeDesc=getUniverseDesc()
	local storyDesc=getMissionsDesc()
	local surveyDesc,surveyWorlds,surveyWorldsCount,surveyNatives,surveyNativesCount=getGreatSurveyDesc()

	return surveyNativesCount,surveyNatives,surveyWorldsCount,surveyWorlds,surveyDesc,storyDesc,universeDesc
	--return surveyNativesCount,surveyNatives,surveyWorldsCount,surveyWorlds,storyDesc,universeDesc
	--return universeDesc,storyDesc,surveyDesc,surveyWorlds,surveyWorldsCount,surveyNatives,surveyNativesCount
end