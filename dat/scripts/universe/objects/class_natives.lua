include('universe/objects/class_settlements.lua')

natives_class = {}

local natives_prototype = {
	civilized = false
}

setmetatable(natives_prototype, settlement_class.settlement_prototype)
natives_prototype.__index = natives_prototype

function natives_class.createNew(name,population,civilized)
	local o={}
	setmetatable(o, natives_prototype)
	o:settlementInit()
	o.name=name
	o.population=population
	o.civilized=civilized
	return o
end