include("dat/scripts/prng.lua")

clouds = {
   "nebula02.png",
   "nebula04.png",
   "nebula12.png",
   "nebula22.png",
   "nebula23.png",
   "nebula24.png",
   "nebula25.png",
   "nebula26.png",
   "nebula27.png",
   "nebula28.png",
   "nebula29.png",
   "nebula30.png",
   "nebula31.png",
   "nebula32.png",
   "nebula33.png",
   "nebula34.png",
}

distant_objects = {
   "galaxy1.png",
   "galaxy2.png",
   "galaxy3.png",
   "galaxy4.png",
   "galaxy6.png",
}

nebulae = {--not used currently
   "nebula10.png",
   "nebula16.png",
   "nebula17.png",
   "nebula19.png",
   "nebula20.png",
   "nebula21.png",
}

stars = {
   "blue01.png",
   "blue02.png",
   "blue04.png",
   "green01.png",
   "green02.png",
   "orange01.png",
   "orange02.png",
   "orange05.png",
   "redgiant01.png",
   "white01.png",
   "white02.png",
   "yellow01.png",
   "yellow02.png"
}


function background ()

   -- We can do systems without nebula
   cur_sys = system.cur()
   local nebud, nebuv = cur_sys:nebula()
   if nebud > 0 then
      return
   end

   -- Start up PRNG based on system name for deterministic nebula
   prng.initHash( cur_sys:name() )

   local r = prng.num()

   if (r>0.8 or (cur_sys:backgroundSpaceName() ~= nil and cur_sys:backgroundSpaceName() ~= "")) then
      background_cloud()
   elseif (r>0.3) then
      background_distant_objects()
   end

   -- Generate stars
   background_stars()
end


function background_cloud ()
   -- Set up parameters
   local path  = "dat/gfx/bkg/"
   local cloud
   if (cur_sys:backgroundSpaceName() == nil or cur_sys:backgroundSpaceName() == '') then
   	cloud = clouds[ prng.range(1,#clouds) ]
   else
   	cloud = cur_sys:backgroundSpaceName();
   end
   local img   = tex.open( path .. cloud )
   local w,h   = img:dim()
   local r     = prng.num() * cur_sys:radius()/2
   local a     = 2*math.pi*prng.num()
   local x     = r*math.cos(a)
   local y     = r*math.sin(a)
   local move  = 0.01 + prng.num()*0.01
   local scale = 1 + (prng.num()*0.5 + 0.5)*((2000+2000)/(w+h))
   if scale > 1.9 then scale = 1.9 end
   bkg.image( img, x, y, move, scale )
end

function background_distant_objects ()
   -- Set up parameters
   local path  = "dat/gfx/bkg/"
   local object

   object = distant_objects[ prng.range(1,#distant_objects) ]

   local img   = tex.open( path .. object )
   local w,h   = img:dim()
   local r     = prng.num() * cur_sys:radius()
   local a     = 2*math.pi*prng.num()
   local x     = r*math.cos(a)
   local y     = r*math.sin(a)
   local move  = 0.01 + prng.num()*0.01
   local scale = 0.5 + (prng.num()*0.5 + 0.5)*((250+250)/(w+h))
   if scale > 1.9 then scale = 1.9 end
   bkg.image( img, x, y, move, scale )

end


function background_stars ()
   -- Chose number to generate
   local n
   
   
   if (#(cur_sys:sunSpaceNames()) == 0) then
		local r = prng.num()
	   if r > 0.97 then
		  n = 3
	   elseif r > 0.94 then
		  n = 2
	   else
		  n = 1
	   end
   
	   -- Generate the stars
	   local i = 0
	   local added = {}
	   while n and i < n do
		  num = star_add( added, i )
		  added[ num ] = true
		  i = i + 1
	   end
   
   else 
		n = #(cur_sys:sunSpaceNames())
		
	   local i = 0
	   while n and i < n do
		  num = star_add( nil, i ) --no check for already added in manual mode
		  i = i + 1
	   end
   end
end


function star_add( added, num_added )
   -- Set up parameters
   local path  = "dat/gfx/bkg/star/"
   -- Avoid repeating stars
   
   local star
   local num
   
   if (#(cur_sys:sunSpaceNames())==0) then 
   
	   num   = prng.range(1,#stars)
	   local i     = 0
	   while added[num] and i < 10 do
		  num = prng.range(1,#stars)
		  i   = i + 1
	   end
   
		star  = stars[ num ]
   
   else
       
     star  = cur_sys:sunSpaceNames()[num_added+1]
   
   end
   
   
   -- Load and set stuff
   local img   = tex.open( path .. star )
   local w,h   = img:dim()
   -- Position should depend on whether there's more than a star in the system
   local r     = prng.num() * cur_sys:radius()/3
   if num_added > 0 then
      r        = r + cur_sys:radius()*2/3
   end
   local a     = 2*math.pi*prng.num()
   local x     = r*math.cos(a)
   local y     = r*math.sin(a)
   local nmove = math.max( .05, prng.num()*0.1 )
   local move  = 0.02 + nmove
   local scale = 1.0 - (1. - nmove/0.2)/5
   bkg.image( img, x, y, move, scale ) -- On the background
   return num
end
