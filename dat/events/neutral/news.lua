include('universe/generate_nameGenerator.lua')

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
   header_table["Empire of Terra"] =      {"Welcome to the Empire News Centre."
                      }                             
   header_table["Independent Worlds"] = {"Welcome to the Syndicated Independent Press Agency."
                                 }
   header_table["Roidhunate of Ardarshir"] =      {"The latest from the Roidhunate."
                      }
   header_table["Oligarchy of Betelgeuse"] =      {"Trade, economy, stock markets - all the news, curtsy of our sponsors!"
                                 }
   header_table["Pirate"] =      {"Pirate News. News that matters."
                                 }
   header_table["Barbarians"] =  {"Welcome to the Raiding Network."
                                 }                                                            

   
   greet_table={}

   greet_table["Generic"] =      {""
                                 }
   greet_table["Empire of Terra"] =       {"News from the court and more minor topics."
                                 }
   greet_table["Independent Worlds"] =      {"News from the Fringe."
                                 }
   greet_table["Roidhunate of Ardarshir"] =      {"Greating from the Roidhunate."
                                 }
   greet_table["Oligarchy of Betelgeuse"] =      {"Stocks of the day, goods to watch!"
                                 }                                                                                          

   greet_table["Pirate"] =       {"News that matters.",
                                 "Adopt a cat today!",
                                 "Laughing at the Emperor.",
                                 "On top of the world.",
                                 "Piracy has never been better."
                                 }
   greet_table["Barbarians"] =      {"Raiding your homeworld."
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

   articles["Empire of Terra"]={
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
      {
         title = "A Failed Colony Abandoned for Greener Pastures",
         desc = "The colony of "..nameGenerator.getEmpireNameGenerator().." was finally emptied of colonists last month. \"This small, distant planet was never worth it\", explained His Eminence the Imperial Representative in the sub-sector to journalists on the way to a major cocktail party. \"The colonists will be much better off in the Core Worlds.\". We thank His Eminence for his time."
      },
      --[[
         Politics
      --]]
      {
         title = "Pacifying Mission Being Prepared",
         desc = "His Imperial Majesty in person is said to have participated to the plans of a major pacifying operation against Barbarians coreward."
      },
      {
         title = "A Firm Hand for the Empire",
         desc = "His Excellency the Imperial Envoy to Ardarshir yesterday demonstrated again the firm hand of the Empire by sternly warning the Roidhun against continued encroachments on Imperial systems, failing which stern consequences would follow. No doubt the Ardar leadership was suitably impressed."
      },
      --[[
         Human interest.
      --]]
      {
         title = "Games for Young Pilots",
         desc = "Want your child to have a chance at a career as a space pilot?  Games like Super Julio Omniverse and SpaceFox help your child develop twitch muscles."
      }
   }

   articles["Independent Worlds"]={
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

   articles["Roidhunate of Ardarshir"]={
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

   articles["Pirate"]={
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

   articles["Oligarchy of Betelgeuse"]={
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
   articles["Barbarians"]={
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
      header=news_table[rnum]["title"]
      desc=news_table[rnum]["desc"]

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
