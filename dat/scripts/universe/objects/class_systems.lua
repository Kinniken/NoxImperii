include('universe/generate_helper.lua')
include('luadata.lua')

system_class = {}

local system_c_debug_prototype = {
	
}

system_c_debug_prototype.__index = system_c_debug_prototype

local system_prototype = {
	save=function (self)
		setSystemLuaData(self.c,self.lua)
	end
}

system_prototype.__index = system_prototype

function system_class.createNew()
	local o={}
	setmetatable(o, system_prototype)

	local c={}
	setmetatable(c, system_c_debug_prototype)
	o.c=c

	return o
end

function system_class.load(c_system)
	local system=system_class.createNew()
	system.c=c_system
	system.lua=getSystemLuaData(system.c)

	return system
end