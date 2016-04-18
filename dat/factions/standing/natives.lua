

include "dat/factions/standing/skel.lua"


_fcap_kill     = 5 -- Kill cap
_fdelta_distress = {-1, 0} -- Maximum change constraints
_fdelta_kill     = {-5, 1} -- Maximum change constraints
_fcap_misn     = 100 -- Starting mission cap, gets overwritten
_fcap_misn_var = "_fcap_natives"
_fthis         = faction.get(G.NATIVES)


function faction_hit( current, amount, source, secondary )
    return default_hit(current, amount, source, secondary)
end
