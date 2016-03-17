include('universe/live/live_universe.lua')

worldevent_class = {}

local worldevent_prototype = {
	applyOnWorld=function(self,planet,textData)

		self.applyOnWorldCustom(self,planet,textData)

		generatePlanetServices(planet)

		planet:save()

	end,
	applyOnWorldCustom=function(self,planet,textData)

	end,
	getEventMessage=function(self,planet)
		return nil
	end,
	getWorldHistoryMessage=function(self,planet)
		return nil
	end,
	getBarNews=function(self,planet)
		return {}
	end
}

worldevent_prototype.__index = worldevent_prototype

function worldevent_class.createNew()
	local o={}
	setmetatable(o, worldevent_prototype)
	o.weight=10
	return o
end