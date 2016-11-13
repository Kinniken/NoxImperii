include "jumpdist.lua"
include "general_helper.lua"

local chatter_random = {}
local chatter_tags = {}
local chatter_trade = {}

function add_chatter(chatter)
	chatter_random[#chatter_random+1] = chatter
end

function add_tag_chatter(tag,chatter)
	if chatter_tags[tag] then
		chatter_tags[tag][#chatter_tags[tag]+1] = {chatter=chatter,tag=tag}
	else
		chatter_tags[tag] = {{chatter=chatter,tag=tag}}
	end
end

function add_trade_chatter(type,chatter)
	if chatter_trade[type] then
		chatter_trade[type][#chatter_trade[type]+1] = {chatter=chatter,type=type}
	else
		chatter_trade[type] = {{chatter=chatter,type=type}}
	end
end

function chatter(sys,callingShip)
	p = player.pilot()
   
   if p:exists() then
      r = rnd.rnd(100)

      if (r > chatter_chance) then
      	return
      end

      r = rnd.rnd(chatter_trade_weight+chatter_tag_weight+chatter_random_weight)

      if r < chatter_trade_weight then
         local tradeChatter = getTradeDealChatter(sys,callingShip)

         if tradeChatter then
           ai.pilot():comm(tradeChatter)
         end
      elseif r < chatter_trade_weight + chatter_tag_weight then
         local tagChatter = getTagChatter(sys)

         if tagChatter then
           ai.pilot():comm(tagChatter)
         end
      else
      	ai.pilot():comm(chatter_random[math.random(#chatter_random)])
      end
   end
end

function getTradeDealChatter(sys,callingShip)
	local deal = findGoodTradeDeal(sys,callingShip)

	if not deal then
		return
	end

	if not chatter_trade[deal.type] then
		error("AI has trade chatter but not chatter of type "..deal.type)
		return
	end

	local chatter = chatter_trade[deal.type][math.random(#chatter_trade[deal.type])]

	if not chatter then
		error("No trade chatter of type "..deal.type)
		gh.tprintError(chatter_trade[deal.type])
	end

	local stringData = {planet=deal.planet:name(),system=deal.planet:system():name(),commodity=deal.commodity:name()}

	return gh.format(chatter.chatter,stringData)
end

function getTagChatter(sys)

	local taggedWorld = findTaggedWorld(sys)

	if not taggedWorld then
		return
	end

	local chatter = chatter_tags[taggedWorld.tag][math.random(#chatter_tags[taggedWorld.tag])]

	local stringData = {planet=taggedWorld.planet:name(),system=taggedWorld.planet:system():name()}

	return gh.format(chatter.chatter,stringData)
end

function findGoodTradeDeal(sys,callingShip)
	local systems = getsysatdistance(sys,1,3)

	local dealType = math.random(1,4)

	local deals = {}

	for _,v in ipairs(systems) do
		for _,pl in ipairs(v:planets()) do
			if (pl:faction() and not callingShip:faction():areEnemies(pl:faction())) then
				for _,td in ipairs(pl:tradeDatas()) do
					if dealType == 1 and td.priceFactor < 0.3 and td.buyingQuantity > 0 then
						deals[#deals+1] = {planet=pl,commodity=td.commodity,type="cheap"}
					elseif dealType == 2 and td.priceFactor > 3 and td.sellingQuantity > 0 then
						deals[#deals+1] = {planet=pl,commodity=td.commodity,type="expensive"}
					elseif dealType == 3 and td.priceFactor < 0.7 and td.buyingQuantity > 500 then
						deals[#deals+1] = {planet=pl,commodity=td.commodity,type="cheapBulk"}
					elseif td.priceFactor > 1.5 and td.sellingQuantity > 500 then
						deals[#deals+1] = {planet=pl,commodity=td.commodity,type="expensiveBulk"}
					end
				end
			end
		end
	end

	if #deals == 0 then
		return
	end

	return deals[math.random(#deals)]
end

function findTaggedWorld(sys)
	local systems = getsysatdistance(sys,1,3)

	local worlds = {}

	for _,v in ipairs(systems) do
		for _,pl in ipairs(v:planets()) do
			for _,tag in pairs(pl:tags()) do
				if chatter_tags[tag] then
					worlds[#worlds + 1] = {planet=pl,tag=tag}
				end
			end
		end
	end

	if #worlds == 0 then
		return
	end

	return worlds[math.random(#worlds)]
end