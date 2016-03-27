include('universe/objects/class_worldevents.lua')
include('universe/objects/class_systems.lua')
include('universe/live/live_universe.lua')
include('universe/generate_nameGenerator.lua')
include('dat/crew_names.lua')


world_events= {} --public interface
world_events.events={}

include('universe/worldevents/empire.lua')
include('universe/worldevents/roidhunate.lua')
include('universe/worldevents/fringe.lua')
include('universe/worldevents/betelgeuse.lua')
