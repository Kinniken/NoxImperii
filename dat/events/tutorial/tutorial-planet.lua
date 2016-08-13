-- This is tutorial: the planetary screen.

include("dat/events/tutorial/tutorial-common.lua")
include "universe/live/live_universe.lua"

-- localization stuff, translators would work here
lang = naev.lang()
if lang == "es" then
else -- default english
    title1 = "Tutorial: The Planetary Screen"
    message1 = [[Welcome to the planetary screen tutorial.

In this tutorial you will learn about what you can expect on a planet or station once you land on it. We'll start by landing on Paul 2. Landing is covered in another tutorial, so for now we'll land automatically.]]
    message2 = [[Once landed, you will be presented with the landing screen. This is the default screen for all planets or stations you land on. The landing screen gives you information about the planet or station in general and lets you refuel.

The main description on the top-left of the screen provides background information on the world. Some of it has effects on the game, some doesn't.

The "History of the world" section lists events that happened there. Some are due to random events, some are the results of missions you did. As you can see, you've already left a mark on this world!

The "Settlements" description at the bottom-left provides detailed information on who is living on the world and what goods they produce. It will give you some ideas of what to expect from the Commodity tab. Sometimes you will see mentions of special time-limited events, such as a festival driving up demand for luxury goods - or a new captain in need of drinks.

To access the more interesting facilities on Paul 2, you will need to click on the tabs at the bottom of the planet menu. Each tab represents a different area of the spaceport. Some spaceports may not have all of the facilities you see here, and the things on offer will vary from planet to planet. Sometimes you will have to fly to another planet to get what you need.

Select any tab now to view a short explanation on what you can do there. Once you have seen enough, press the takeoff button to end this tutorial.]]
    message3 = [[This is the outfit seller. Here you may buy and sell things such as weapons, ship upgrades and ammunition. Note that you need to visit the equipment facility to actually install most outfits into your ship.]]
    message4 = [[This is the spaceport bar. Here you may find people who are interested in giving you missions. You will also see a news feed on the right of the screen. You can approach patrons by clicking on their portrait and then clicking on the "approach" button.

There are no mission givers here at the moment. Missions are explained in more detail in another tutorial.

You can also recruit new crew members from the bar. Their portraits are decorated with a star rating indicating how good (and how expensive!) they are and a little icon showing what role they would have on your ship (pilot, engineer...). Some can be hired from the start of the game, others require conditions to be met. Try hiring one!]]
    message5 = [[This is the mission computer. This is where you can find work if you're in need of credits. Most missions here will initially involve ferrying passengers or cargo, but you may be able to unlock more mission types during the course of the game.

There is no work available right now. Missions are explained in more detail in another tutorial.]]
    message6a = [[This is the equipment screen, where you can customize your ship, as well as switch to another ship if you own more than one.

You have been given a modest selection of equipment. Try installing it in your ship by right-clicking the item boxes in the inventory panel. You can uninstall them again by right-clicking on the ship slots they are installed in. There are a few things to keep in mind:

- Each outfit is either a Structure, Utility or Weapon outfit, and can ONLY be installed in an appropriate slot.

- Each outfit has a size. Possible sizes are small, medium and large. Outfits can ONLY be installed in a slot that's big enough. Sizes are indicated with icons.

- Each outfit uses up a certain amount of CPU. Your CPU capacity is shown as a green bar that turns red as CPU is used up. You can only take off if you haven't exceeded your CPU capacity.

- Each outfit has a mass that will be added to your ship when installed. If your ship's mass exceeds the engine's mass limit, your speed and thrust will be reduced.]]
    message6b = [[If you look at your ship's slots on the right hand side of the menu, you will see that some weapon slots are marked as "turrets". That means these slots can accept turreted weapons on top of regular weapons; only those special slots can hold turrets. Some ships cannot equip turrets at all.]]

    message7 = [[This is the shipyard. You can buy new ships and sell ships you currently own here.]]
    message8 = [[This is the commodity exchange. Here you can buy and sell goods.

The list of available goods and their prices fluctuates from world to world, based on local needs and production.]]

    message9 = [[This is the Crew section. This shows crew members that you have hired from the bar.

Crew members can be of four different types, with only one of each active at any one point. Only active crew members provide bonuses. Each crew member gets paid a salary at the beginning of the month, whether he is active or not.]]
end

function create()
    -- Set up the player here.
    player.teleport("Mohawk")
    player.pilot():setPos(planet.get("Paul 2"):pos())
    player.swapShip("Voyager Frigate", "Voyager Frigate", "Paul 2", true, true)
    player.msgClear()
    player.pay(10000)

    tk.msg(title1, message1)

    player.pay(-player.credits())
    player.addOutfit("Laser Cannon MK1", 2)
    player.addOutfit("Plasma Blaster MK1", 1)
    player.addOutfit("Engine Reroute", 1)
    player.addOutfit("Civilian Scrambler", 1)
    player.addOutfit("Cargo Pod", 1)
    player.pilot():control()
    player.pilot():land(planet.get("Paul 2"))

    mainland = hook.land("land")
    outfitsland = hook.land("outfits", "outfits")
    barland = hook.land("bar", "bar")
    missionland = hook.land("mission", "mission")
    equipmentland = hook.land("equipment", "equipment")
    shipyardland = hook.land("shipyard", "shipyard")
    commodityland = hook.land("commodity", "commodity_func")
    crewland = hook.land("crew", "crew")
    hook.takeoff("takeoff")
end

-- Land hook.
function land()

    local curPlanet=planet_class.load(planet.cur())

    curPlanet.lua.worldHistory={}
    curPlanet.lua.settlements.humans.activeEffects={}

    local effectId=curPlanet.lua.settlements.humans:addActiveEffect("The arrival of a new captain has increased demand for liquor.",
        (time.get() + time.create(0,1,0,0,0,0)):tonumber(), "new_captain" )
    curPlanet.lua.settlements.humans:addGoodDemand(C.TELLOCH,200,3,effectId)

    curPlanet:addHistory("A young captain started his journey to the stars by following a quick tutorial.")
    generatePlanetServices(curPlanet)
    curPlanet:save()

    tk.msg(title1, message2)
    hook.rm(mainland)
end

function outfits()
    tk.msg(title1, message3)
    hook.rm(outfitsland)
end

function bar()
    tk.msg(title1, message4)
    hook.rm(barland)
end

function mission()
    tk.msg(title1, message5)
    hook.rm(missionland)
end

function equipment()
    tk.msg(title1, message6a)
    tk.msg(title1, message6b)
    hook.rm(equipmentland)
end

function shipyard()
    tk.msg(title1, message7)
    hook.rm(shipyardland)
end

function commodity_func()
    tk.msg(title1, message8)
    hook.rm(commodityland)
end

function crew()
    tk.msg(title1, message9)
    hook.rm(crewland)
end

function takeoff()
    hook.safe("cleanup")
end

-- Cleanup function. Should be the exit point for the module in all cases.
function cleanup()
    naev.keyEnableAll()
    naev.eventStart("Tutorial")
    evt.finish(true)
end
