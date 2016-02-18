
include "jumpdist.lua"
include "numstring.lua"
include "universe/generate_helper.lua"
include('universe/objects/class_planets.lua')
include "universe/live/live_universe.lua"
include "dat/missions/greatsurvey/great_survey_utils.lua"

-- Mission Details
misn_title = "The Great Survey"
misn_reward = "Variable, based on the interest of the planets found."
misn_desc = "Explore planets beyond the influence of major powers."

-- defines Previous Planets table
prevPlanets = {}
prevPlanets.__save = true



title = {}  --stage titles
text = {}   --mission text

finishedtitle = "One more entry added!"
finishedtxt = [[You follow the usual survey procedure, scanning the world from orbit and taking samples. You feed the results to the survey computer and after a few seconds its preliminary analysis appears:
Distance from Sol: ${rewardDistance} cr
Presence of native sapients: ${rewardNatives} cr
Fertility for humans: ${rewardFertility} cr
Mineral riches: ${rewardMinerals} cr

Grand total: ${rewardTotal} cr

You have added one more line to the great enterprise, and boosted your bank account to boot!]]

function create ()
   misn.accept()
   landhook = hook.land ("land")

   misn.setTitle( misn_title )
   misn.setReward( misn_reward )
   misn.setDesc( misn_desc )
end

function land ()

   local successful=handlePlanet(planet.cur(), finishedtxt)

end


function abort()

end
