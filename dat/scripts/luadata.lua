include('dump.lua')

function getPlanetLuaData(c_planet)
	return loadstring("return "..c_planet:getLuaData())()
end

function setPlanetLuaData(c_planet,luaData)
	local stringdata,err=dump.tostring(luaData)
	if (err) then
		print("Error when saving data: "..err)
		gh.tprint(luaData)
		print("Error when saving data: "..err)
	end
	c_planet:setLuaData(stringdata)
end

function getSystemLuaData(c_sys)
	return loadstring("return "..c_sys:getLuaData())()
end

function setSystemLuaData(c_sys,luaData)
	local stringdata,err=dump.tostring(luaData)
	if (err) then
		print("Error when saving data: "..err)
		gh.tprint(luaData)
		print("Error when saving data: "..err)
	end
	c_sys:setLuaData(stringdata)
end