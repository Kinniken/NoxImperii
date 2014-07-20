include('universe/live/live_services.lua')

worldevent_class = {}

local worldevent_prototype = {
	applyOnWorld=function(self,planet)

		self.applyOnWorldCustom(self,planet)

		generatePlanetServices(planet)

		planet:save()

	end,
	applyOnWorldCustom=function(self,planet)

	end,
	getEventMessage=function(self,planet)
		return "Event trigger for planet "..planet.c:name()
	end,
	getWorldHistoryMessage=function(self,planet)
		return "Event triggered for planet "..planet.c:name().." at time "..time.str(time.get())
	end
}

worldevent_prototype.__index = worldevent_prototype

function worldevent_class.createNew()
	local o={}
	setmetatable(o, worldevent_prototype)
	o.weight=10
	return o
end