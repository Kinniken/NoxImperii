include("dat/scripts/prng.lua")
include("general_helper.lua")

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
   "galaxy5.png",
   "galaxy6.png",
   "galaxy7.png",
   "galaxy8.png",
   "galaxy9.png",
   "galaxy10.png",
   "galaxy11.png",
   "galaxy12.png",
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

local x,y=system.get("Noor"):coords()
local fez_pos={x=x,y=y}

map_objects = {
   {pict="orion.png",x=-330,y=1110,view_distance=600,in_distance=0.1},
   {pict="hyades.png",x=fez_pos.x,y=fez_pos.y,view_distance=600,min_scale=0.1},
   {pict="eagle.png",x=2350,y=-960,view_distance=600,in_distance=0.1},
   {pict="pleiades.png",x=1980,y=350,view_distance=600,min_scale=0.1},
}


function background ()

   -- We can do systems without nebula
   cur_sys = system.cur()
   local nebud, nebuv = cur_sys:nebula()
   if nebud > 0 then
      return
   end

   background_map_objects()

   --background_distant_stars()

      -- Start up PRNG based on system name for deterministic nebula
   prng.initHash( cur_sys:name() )

   local r = prng.num()

   if (r>0.7) then
      background_cloud()
   else
      background_distant_objects()
   end

   -- Generate stars
   background_stars()
end

function background_map_objects()

   local path  = "dat/gfx/bkg/"
   local sx,sy=cur_sys:coords()

   for k,v in ipairs(map_objects) do

      local dist=gh.calculateDistance({x=sx,y=sy},v)

      if (dist<v.view_distance) then

         local img   = tex.open( path .. v.pict )
         local w,h   = img:dim()
         local x     = (v.x-sx)*3
         local y     = (v.y-sy)*3
         local move  = 0.01
         local scale = 0.05+1.5*((v.view_distance-dist)/v.view_distance)
         bkg.image( img, x, y, move, scale )

      end

   end

end

function background_cloud ()
   -- Set up parameters
   local path  = "dat/gfx/bkg/"
   local cloud
   cloud = clouds[ prng.range(1,#clouds) ]
   local img   = tex.open( path .. cloud )
   local w,h   = img:dim()
   local move  = 0.02 + prng.num()*0.02
   local scale = 1 + (prng.num()*0.5 + 0.5)*((2000+2000)/(w+h))
   if scale > 1.9 then scale = 1.9 end
   bkg.image( img, 0, 0, move, scale, 1 )
end

function background_distant_objects ()
   -- Set up parameters
   local path  = "dat/gfx/bkg/"
   local object
   local n, i
   local r = prng.num()
   
   if r > 0.5 then
        n = 3
      elseif r > 0.2 then
        n = 2
      else
        n = 1
      end

   i = 0

   local taken = {}
   local positions = {}

   while n and i < n do

      object = distant_objects[ prng.range(1,#distant_objects) ]

      local found=false

      for k,v in ipairs(taken) do
         if v == object then
            found=true
         end
      end

      if not found then
         taken[#taken+1] = object

         local img   = tex.open( path .. object )
         local w,h   = img:dim()
         local r     = prng.num() * 1000
         local a     = 2*math.pi*prng.num()
         local x     = r*math.cos(a)
         local y     = r*math.sin(a)

         local conflict=false

         for k,v in ipairs(positions) do
            if math.abs(x-v.x) < 1000 and math.abs(y-v.y) < 1000 then
               conflict=true
            end
         end   

         if not conflict then      
            local move  = 0.005
            local scale = 0.5 + (prng.num()*0.5)
            if scale > 1.9 then scale = 1.9 end
            bkg.image( img, x, y, move, scale )
            positions[#positions+1]={x=x,y=y}
            i = i + 1
         else
            if (prng.num()>0.95) then--failsafe if no solution found
               i = i + 1
            end
         end
      else
         if (prng.num()>0.95) then--failsafe if no solution found
            i = i + 1
         end
      end
   end

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
   local r     = 0
   if num_added > 0 then
      r        = r + 300
   end
   local a     = 2*math.pi*prng.num()
   local x     = r*math.cos(a)
   local y     = r*math.sin(a)
   local move  = 0.1
   local scale = 1.0 - prng.num()/5
   bkg.image( img, x, y, move, scale, 1 ) -- On the foreground
   return num
end
