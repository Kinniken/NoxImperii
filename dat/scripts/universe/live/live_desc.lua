
include('universe/generate_helper.lua')

local industryQualifier,agricultureQualifier,technologyQualifier,createSettlementDesc

function generateLiveHistoryDesc(planet)

	if (not planet.lua.worldHistory or #planet.lua.worldHistory==0) then
		return "No recent events have been recorded for this world."
	end

	desc=""

	for k,event in ipairs(planet.lua.worldHistory) do
		desc=desc..(event.time)..": "..event.msg.."\n\n"
	end

	return desc
end

function generateLiveSettlementsDesc(planet)

	desc=""

	if (planet.lua.natives) then
		desc=desc.."The native population is estimated at "..gh.prettyLargeNumber(planet.lua.natives.population).."."
		if (#planet.lua.natives.extraGoodsDemand>0) then
			desc=desc.." They are eager to buy "
			for k,v in pairs(planet.lua.natives.extraGoodsDemand) do
				if (k>1 and k<#planet.lua.natives.extraGoodsDemand) then
					desc=desc..", "
				elseif (k>1 and k==(#planet.lua.natives.extraGoodsDemand)) then
					desc=desc.." and "
				end
				desc=desc..v.type
			end
			desc=desc.." from passing traders."
		end

		if (#planet.lua.natives.extraGoodsSupply>0) then
			desc=desc.." They will sell "
			for k,v in pairs(planet.lua.natives.extraGoodsSupply) do
				if (k>1 and k<#planet.lua.natives.extraGoodsSupply) then
					desc=desc..", "
				elseif (k>1 and k==(#planet.lua.natives.extraGoodsSupply)) then
					desc=desc.." and "
				end
				desc=desc..v.type
			end
			if (#planet.lua.natives.extraGoodsDemand>0) then
				desc=desc.." in exchange."
			else
				desc=desc.." to passing traders."
			end
		end

		desc=desc.."\n\n"
	end

	if (planet.lua.settlements) then
		for k,settlement in pairs(planet.lua.settlements) do

			if (k=="natives") then
				desc=desc.."The native population is estimated at "..gh.prettyLargeNumber(settlement.population)..". They have assimilated into the galactic economy, and now form a community with a "..industryQualifier(settlement.industry).." industry, a "..agricultureQualifier(settlement.agriculture).." agriculture and a "..serviceQualifier(settlement.services).." service economy."
				desc=desc.." Their technology level is "..technologyQualifier(settlement.technology)..", "
				desc=desc.." and their native militias amount to a "..militaryQualifier(settlement.military).." military force. "
				desc=desc.." The native leaders' control over the population is "..stabilityQualifier(settlement.stability).."."
				if (settlement.extraGoodsDemand and #settlement.extraGoodsDemand>0) then
					desc=desc.." They have a particularly strong demand for "
					for k,v in pairs(settlement.extraGoodsDemand) do
						if (k>1 and k<#settlement.extraGoodsDemand) then
							desc=desc..", "
						elseif (k>1 and k==(#settlement.extraGoodsDemand)) then
							desc=desc.." and "
						end
						desc=desc..v.type
					end
					desc=desc.."."
				end
			else
				local popName=k

				if (k=="royalixumites" or k=="holyflame") then
					popName="Ixumite"
				end



				desc=desc.."The "..popName.." population is estimated at "..gh.prettyLargeNumber(settlement.population)
				desc=desc..", with a "..industryQualifier(settlement.industry).." industry, a "..agricultureQualifier(settlement.agriculture).." agriculture and a "..serviceQualifier(settlement.services).." service economy."
				desc=desc.." The technology level on the world is "..technologyQualifier(settlement.technology).."."
				desc=desc.." The military presence on the world is "..militaryQualifier(settlement.military).."."

				if (not settlement.stability) then
					print("error, settlement has no stability: "..k)
				end

				desc=desc.." The government's control over the population is "..stabilityQualifier(settlement.stability).."."
			end

			if (settlement.extraGoodsDemand and #settlement.extraGoodsDemand>0) then
				local specialDesc=""
				for k,v in pairs(settlement.extraGoodsDemand) do
					if (not v.effectId) then--event-based trade effects are described separately 
						if (k>1 and k<#settlement.extraGoodsDemand) then
							specialDesc=specialDesc..", "
						elseif (k>1 and k==(#settlement.extraGoodsDemand)) then
							specialDesc=specialDesc.." and "
						end
						specialDesc=specialDesc..v.type
					end
				end
				if (specialDesc ~= "") then
					desc=desc.." They have a particularly strong demand for "..specialDesc.."."
				end
			end
			
			if (settlement.extraGoodsSupply and #settlement.extraGoodsSupply>0) then
				local specialDesc=""
				
				for k,v in pairs(settlement.extraGoodsSupply) do
					if (not v.effectId) then--event-based trade effects are described separately 
						if (k>1 and k<#settlement.extraGoodsSupply) then
							specialDesc=specialDesc..", "
						elseif (k>1 and k==(#settlement.extraGoodsSupply)) then
							specialDesc=specialDesc.." and "
						end
						specialDesc=specialDesc..v.type
					end
				end
				if (specialDesc ~= "") then
					desc=desc.." They are known for producing "..specialDesc.."."
				end
			end

			if (settlement.lesserGoodsDemand and #settlement.lesserGoodsDemand>0) then
				local specialDesc=""
				for k,v in pairs(settlement.lesserGoodsDemand) do
					if (not v.effectId) then--event-based trade effects are described separately 
						if (k>1 and k<#settlement.lesserGoodsDemand) then
							specialDesc=specialDesc..", "
						elseif (k>1 and k==(#settlement.lesserGoodsDemand)) then
							specialDesc=specialDesc.." and "
						end
						specialDesc=specialDesc..v.type
					end
				end
				if (specialDesc ~= "") then
					desc=desc.." Demand for "..specialDesc.." is unusually low."
				end
			end
			
			if (settlement.lesserGoodsSupply and #settlement.lesserGoodsSupply>0) then
				local specialDesc=""
				for k,v in pairs(settlement.lesserGoodsSupply) do
					if (not v.effectId) then--event-based trade effects are described separately 
						if (k>1 and k<#settlement.lesserGoodsSupply) then
							specialDesc=specialDesc..", "
						elseif (k>1 and k==(#settlement.lesserGoodsSupply)) then
							specialDesc=specialDesc.." and "
						end
						specialDesc=specialDesc..v.type
					end
				end

				if (specialDesc ~= "") then
					desc=desc.." Their production of "..specialDesc.." is unusually low."
				end
			end

			for k,effect in ipairs(settlement.activeEffects) do
				desc=desc.." "..effect.desc
			end

			desc=desc.."\n\n"
		end
	end

	if desc=="" then
		desc="There are no sapient species on this world."
	end
	
	return desc
end

function industryQualifier(industry)
	if (industry<0.25) then
		return "under-developed"
	elseif (industry<0.50) then
		return "limited"
	elseif (industry<0.75) then
		return "basic"
		elseif (industry<1) then
			return "solid"
		else
			return "flourishing"
		end
	end

			function agricultureQualifier(agriculture)
				if (agriculture<0.25) then
					return "survival"
					elseif (agriculture<0.50) then
						return "limited"
						elseif (agriculture<0.75) then
							return "established"
							elseif (agriculture<1) then
								return "productive"
							else
								return "thriving"
							end
						end

						function serviceQualifier(service)
							if (service<0.25) then
								return "under-developed"
								elseif (service<0.50) then
									return "limited"
									elseif (service<0.75) then
										return "basic"
										elseif (service<1) then
											return "solid"
										else
											return "flourishing"
										end
									end

									function technologyQualifier(technology)
										if (technology<0.25) then
											return "primitive"
											elseif (technology<0.50) then
												return "obsolete"
												elseif (technology<0.75) then
													return "backward"
													elseif (technology<1) then
														return "modern"
													else
														return "cutting-edge"
													end
												end

												function militaryQualifier(military)
													if (military<0.25) then
														return "very light"
														elseif (military<0.50) then
															return "limited"
															elseif (military<0.75) then
																return "significant"
																elseif (military<1) then
																	return "important"
																else
																	return "massive"
																end
															end

												function stabilityQualifier(stability)
													if (stability<0.25) then
														return "inexistent"
														elseif (stability<0.50) then
															return "breaking down"
															elseif (stability<0.75) then
																return "limited"
																elseif (stability<1) then
																	return "good"
																else
																	return "absolute"
																end
															end