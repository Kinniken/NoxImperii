include "universe/live/live_info.lua"
include "universe/live/live_missions.lua"


function refreshStatus()
	print("status refresh")
	updateUniverseDesc()
	updateMissionsDesc()
	updateGreatSurveyDesc()
end