include('universe/generate_system.lua')
include('universe/live/live_desc.lua')
include('universe/live/live_universe.lua')
include('dat/scripts/general_helper.lua')
include('universe/objects/class_planets.lua')

-- Master tutorial script.
-- This script allows the player to choose a tutorial module to run, or return to the main menu.

-- localization stuff, translators would work here
lang = naev.lang()
if lang == "es" then
else -- default english
    menutitle = "Tutorial Menu"
    menutext = "Welcome to the Nox Imperii tutorial menu. Please select a tutorial module from the list below:"
    
    menuall = "Play All"

    menubasic = "Tutorial: Basic Operation"
    --menudiscover = "Tutorial: Exploration and Discovery"
    menuinterstellar = "Tutorial: Interstellar Flight"
    menubasiccombat = "Tutorial: Basic Combat"
    menumisscombat = "Tutorial: Missile Combat"
    menuheat = "Tutorial: Heat"
    menuaoutfits = "Tutorial: Activated Outfits"
    menudisable = "Tutorial: Disabling"
    menuplanet = "Tutorial: The Planetary Screen"
    menutrade = "Tutorial: Trade"
    menumissions = "Tutorial: Missions and Events"
    menucomms = "Tutorial: Communications"
    menux = "Quit to Main Menu"
end

function create()
    --initialised the planets

    math.randomseed(os.time())

    for k,c_planet in pairs(planet.getAll()) do
        planet=planet_class.load(c_planet)

        if (not planet.lua.initialized) then
            generatePlanetServices(planet)
            planet.lua.initialized=true
            planet:save()

        end
    end

    --only for the zone name
    for k,c_system in pairs(system.getAll()) do
        local pos={}
        pos.x,pos.y = c_system:coords()

        local population_template=pickPopulationTemplate(pos)

        c_system:setZone(population_template.zoneName(pos))
    end




    -- Set defaults just in case.
    local pp = player.pilot()
    player.teleport("Mohawk")
    player.msgClear()
    player.swapShip("Endeavour", "Tutorial Endeavour", "Paul 2", true, true)
    player.rmOutfit("all")
    pp = player.pilot()
    pp:rmOutfit("all")
    pp:setEnergy(100)
    pp:setHealth(100, 100)
    player.refuel()
    player.cinematics(true, { no2x = true })

    pp:setPos(vec2.new(0, 0))
    pp:setVel(vec2.new(0, 0))
    pp:setHealth(100, 100)
    pp:control(false)
    pp:setNoLand(false)
    pp:setNoJump(false)

    system.get("Mohawk"):setKnown(false, true)
    system.get("Cherokee"):setKnown(false, true)
    system.get("Iroquois"):setKnown(false, true)
    system.get("Navajo"):setKnown(false, true)
    system.get("Sioux"):setKnown(false, true)

    -- List of all tutorial modules, in order of appearance.
    -- HACK: Add "menux" to the end of this table, because the unpack() function has to be at the end of the tk.choice call.
    local modules = {menubasic, menuinterstellar, menucomms, menubasiccombat, menumisscombat, menuheat, menuaoutfits, menudisable, menuplanet, menumissions, menux}

    if var.peek("tut_next") then
        if var.peek("tut_next") == #modules-1 then
            var.pop("tut_next")
        else
            var.push("tut_next", var.peek("tut_next") + 1)
            startModule(modules[var.peek("tut_next")])
        end
    end

    -- Create menu.
    _, selection = tk.choice(menutitle, menutext, menuall, unpack(modules))
    
    startModule(selection)
end

-- Helper function for starting the tutorial modules
function startModule(module)
    if selection == menux then -- Quit to main menu
        tut.main_menu()
    elseif selection == menuall then
        var.push("tut_next", 1)
        module = menubasic
    end
    player.cinematics(false)
    naev.eventStart(module)
    evt.finish(true) -- While the module is running, this event should not.
end
