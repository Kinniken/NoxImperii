

include "dat/factions/standing/skel.lua"


_fcap_kill     = 30 -- Kill cap
_fdelta_distress = {0, 0} -- Maximum change constraints
_fdelta_kill     = {0, 0} -- Maximum change constraints
_fcap_misn     = 30 -- Starting mission cap, gets overwritten
_fcap_misn_var = "_fcap_barbarian"
_fthis         = faction.get("Barbarians")


function faction_hit( current, amount, source, secondary )
    return default_hit(current, amount, source, secondary)
end
