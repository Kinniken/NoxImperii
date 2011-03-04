-- Template for tutorial modules.
-- Each module should start by setting up the tutorial environment and enforcing rules.
-- Each module should clean up and return to the main tutorial menu when ending or aborting.

-- localization stuff, translators would work here
lang = naev.lang()
if lang == "es" then
else -- default english
    
end

function create()
    misn.accept()
    
    -- Set up the player here.
    player.teleport("Mohawk")
end

-- Abort hook.
function abort()
    cleanup()
end

-- Cleanup function. Should be the exit point for the module in all cases.
function cleanup()
    -- Function to return to the tutorial menu here
end