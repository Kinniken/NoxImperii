include "jumpdist.lua"
include "general_helper.lua"

function getTradeDealChatter(sys,callingShip)

	local deal = findGoodTradeDeal(sys,callingShip)

	if not deal then
		return
	end

	local chatters

	if deal.type == "cheap" then
		chatters = {"I'm back from ${planet}, system ${system}, they basically give away ${commodity} there!","I've heard ${commodity} is very cheap on ${planet}. It's in system ${system}."}
	elseif deal.type == "expensive" then
		chatters = {"I've just sold ${commodity} on ${planet}, system ${system}, they pay a fortune for it there!","People pay a fortune for ${commodity} on ${planet} in system ${system}."}
	elseif deal.type == "cheapBulk" then
		chatters = {"If you are looking to buy ${commodity} in bulk, head to ${planet}, system ${system}; prices are decent and the market is deep.","Last time I was on ${planet} in system ${system}, they were selling cheap ${commodity} in large quantities."}
	else
		chatters = {"Looking to sell ${commodity} in bulk? Try ${planet}, system ${system}: they pay decent prices.","I know ${planet} in system ${system} is looking for large quantities of ${commodity} and pay good prices for it."}
	end

	local chatter = chatters[math.random(#chatters)]

	local stringData = {planet=deal.planet:name(),system=deal.planet:system():name(),commodity=deal.commodity:name()}

	return gh.format(chatter,stringData)

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