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
	addBarNews=function(self,faction,title,message,duration)
		local news={}
		news.faction=faction
		news.title=title
		news.message=message
		news.duration=duration

		table.insert(self.barNews,news)
	end
}

worldevent_prototype.__index = worldevent_prototype

function worldevent_class.createNew()
	local o={}
	setmetatable(o, worldevent_prototype)
	o.weight=10
	o.barNews=nil
	o.eventMessage=nil
	o.worldHistoryMessage=nil
	o.barNews={}
	return o
end