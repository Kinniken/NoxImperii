include('universe/generate_nameGenerator.lua')
include('dat/scripts/general_helper.lua')

--[[
-- Event for creating generic news
--
--]]

lang = naev.lang()
if lang == 'es' then --not translated atm
else --default english

   header_table={}

   header_table["Generic"] =     {"We bring you the latest news in the galaxy."
                                 }
   header_table[G.EMPIRE] =      {"Welcome to the Empire News Centre."
                      }                             
   header_table[G.INDEPENDENT_WORLDS] = {"Welcome to the Syndicated Independent Press Agency."
                                 }
   header_table[G.ROIDHUNATE] =      {"The latest from the Roidhunate."
                      }
   header_table[G.BETELGEUSE] =      {"Trade, economy, stock markets - all the news, curtsy of our sponsors!"}
   header_table[G.ROYAL_IXUM] =      {"Straight from the Court."}
   header_table[G.HOLY_FLAME] =      {"Broadcast from the Council of Guardians"}
   header_table[G.PIRATES] =      {"Pirate News. News that matters."
                                 }
   header_table[G.BARBARIANS] =  {"Welcome to the Raiding Network."
                                 }   

   header_table[G.NATIVES] =  {"We bring you the latest news in the galaxy."
                                 }                                                                                          

   
   greet_table={}

   greet_table["Generic"] =      {""
                                 }
   greet_table[G.EMPIRE] =       {"News from the court and more minor topics."
                                 }
   greet_table[G.INDEPENDENT_WORLDS] =      {"News from the Fringe."
                                 }
   greet_table[G.ROIDHUNATE] =      {"Greating from the Roidhunate."}

   greet_table[G.BETELGEUSE] =      {"Stocks of the day, goods to watch!"}

   greet_table[G.ROYAL_IXUM] =      {"The Royal News Network."}

   greet_table[G.HOLY_FLAME] =      {"Seek your Salvation in the Flame."}                                                                                         

   greet_table[G.PIRATES] =       {"News that matters.",
                                 "Adopt a cat today!",
                                 "Laughing at the Emperor.",
                                 "On top of the world.",
                                 "Piracy has never been better."
                                 }
   greet_table[G.BARBARIANS] =      {"Raiding your homeworld."
                                 }

   greet_table[G.NATIVES] =      {""
                                 }                              

   
   articles={}

   articles["Generic"] = {
      --[[
         Science and technology
      --]]
      
      --[[
         Business
      --]]
      
      --[[
         Politics
      --]]
      
      --[[
         Human interest.
      --]]
      
      
   }

   articles[G.EMPIRE]={
      --[[
         Science and technology
      --]]
      {
         title = "Experiment Produces Cold Fusion",
         desc = "In an interview with Bleeding Edge anchor McKenzie Kruft, a researcher at Eureka labs says he has produced a tabletop atomic reaction. He hopes to publish his results in a science journal later this year."
      },
      --[[
         Business
      --]]
      --[[
         Politics
      --]]
      {
         title = "Pacifying Mission Being Prepared",
         desc = "His Imperial Majesty in person is said to have participated to the plans of a major pacifying operation against Barbarians coreward."
      },      
      {
         title ="Diplomatic Mission on Betelgeuse",
         desc = "A new Imperial envoy to Betelgeuse was presented to the Doge yesterday and received a warm welcome from leading Betelgian families. It is hoped that he will succeed in convincing the Oligarchy of the perils of appeasing the expansionist Roidhunate."
      },
      {
         title ="Virtualised War Games: a Terran Innovation",
         desc = "The largest war games ever performed by the Imperial Navy have just been completed - in a brand new AI on Luna! While the primitive Roidhunate continues to practice manoeuvres in space, Terra once again demonstrates its technological leadership by allowing its officers to train - from the comfort of their home!"
      },
      --[[
         Ardar
      --]]

      --[[
         Human interest.
      --]]
      {
         title = "Games for Young Pilots",
         desc = "Want your child to have a chance at a career as a space pilot?  Games like Super Julio Omniverse and SpaceFox help your child develop twitch muscles."
      }
   }

   articles[G.INDEPENDENT_WORLDS]={
      --[[
         Science and technology
      --]]

      --[[
         Business
      --]]
      --[[
         Politics
      --]]
      --[[
         Human interest.
      --]]
   }

   articles[G.ROIDHUNATE]={
      --[[
         Science and technology
      --]]
      --[[
         Business
      --]]
      --[[
         Politics
      --]]
      --[[
         Human interest.
      --]]
   }

   articles[G.PIRATES]={
      --[[
         Science and technology
      --]]
      --[[
         Business
      --]]
      --[[
         Politics
      --]]
      --[[
         Human interest.
      --]]
      {
         title = "Cats in New Haven",
         desc = "An explosion in the cat population of New Haven has created an adoption campaign with the slogan, \"Pirate Cats, for those lonely space trips.\". Is your space vessel full of vermin? Adopt a cat today!"
      }
   }

   articles[G.BETELGEUSE]={
      --[[
         Science and technology
      --]]
      --[[
         Business
      --]]
      --[[
         Politics
      --]]
      --[[
         Human interest.
      --]]
   }
   articles[G.ROYAL_IXUM]={
      --[[
         Science and technology
      --]]
      --[[
         Business
      --]]
      --[[
         Politics
      --]]
      --[[
         Human interest.
      --]]

   }
   articles[G.HOLY_FLAME]={
      --[[
         Science and technology
      --]]
      --[[
         Business
      --]]
      --[[
         Politics
      --]]
      --[[
         Human interest.
      --]]

   }
   articles[G.BARBARIANS]={
      --[[
         Science and technology
      --]]
      --[[
         Business
      --]]
      --[[
         Politics
      --]]
      --[[
         Human interest.
      --]]

   }



end



   --create generic news
function create()

   if (planet.cur()==nil) then
      return
   end

   if planet.cur():faction()== nil then
      return
   end

   faction = planet.cur():faction():name()

   remove_header(faction)

   rm_genericarticles("Generic")
   rm_genericarticles(faction)

   add_header(faction)
   add_articles("Generic",math.random(3,4))
   add_articles(faction,math.random(1,2))

end

function add_header(faction)

   remove_header('Generic')

   if header_table[faction] == nil then
      warn( 'News: Faction \''..faction..'\' does not have entry in faction table!' )
      faction = 'Generic'
   end

   header=header_table[faction][1]
   desc=greet_table[faction][math.random(#greet_table[faction])]

   news.add(faction,header,desc,50000000000005,50000000000005)

end

function remove_header(faction)

   local news_table=news.get(faction)

   for _,v in ipairs(news.get(faction)) do

      for _,v0 in ipairs(header_table[faction]) do
         if v:title()==v0 then
            v:rm()
         end
      end

   end

   return 0

end


function add_articles(faction,num)

   if articles[faction]==nil then
      return 0
   end

   num=math.min(num,#articles[faction])
   news_table=articles[faction]

   local header
   local desc
   local rnum

   for i=1,num do

      rnum=math.random(#news_table)

      if (news_table[rnum].data==nil) then
         header=news_table[rnum]["title"]
         desc=news_table[rnum]["desc"]
      else
         local data=news_table[rnum].data()
         header=gh.format(news_table[rnum]["title"],data)
         desc=gh.format(news_table[rnum]["desc"],data)
      end

      
      

      news.add(faction,header,desc,500000000000000,0)

      table.remove(news_table,rnum)

   end

end

function rm_genericarticles(faction)

   local news_table=news.get(faction)

   if articles[faction]==nil then return 0 end

   for _,v in ipairs(news_table) do

      for _,v0 in ipairs(articles[faction]) do
         if v:title()==v0["title"] then
            v:rm()
            break
         end
      end
   
   end


end
