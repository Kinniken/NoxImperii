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
	addBarNews=function(self,factionName,title,message,duration)
		local news={}
		news.faction=factionName
		news.title=title
		news.message=message
		news.duration=duration

		--could simply copy faction name but this ensures the faction exists
		--(otherwise the news would just fail silently)
		if (not factionName) then
			news.faction="Generic"
		else
			local newsfaction=faction.get(factionName)
			if newsfaction then
				news.faction=newsfaction:name()
			else
				error("Unknown faction "..factionName.." in world event!")
			end
		end

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