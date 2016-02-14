include('dump.lua')

function getPlanetLuaData(c_planet)
  
  local stringdata=c_planet:getLuaData()
  
	if stringdata==nil then
			return "{}"
	end
    
  local data=assert(loadstring("return "..stringdata,c_planet:name()))
  
	return data()
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