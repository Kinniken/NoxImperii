nameGenerator={}

function nameGenerator.generateNameMerseia()

	nameStart={"mer","bry","roi","brech","y","da","mo","khrai","qan","ur","tach","tel","chydh","gel","fo","mor"}
	nameMiddle={"thio","dhu","na","dwy","thol","rio","ry","dio","ru"}
	nameEnd={"thioch","te","dan","dwyr","tholch","rioch","khraich","ryf","diolch","wyr","loch","dhwan","gelch","daich","chan"}

	if (math.random()>0.5) then
		name=nameStart[ math.random(#nameStart)]..nameMiddle[ math.random(#nameMiddle)]..nameEnd[ math.random(#nameEnd)]
	else
		name=nameStart[ math.random(#nameStart)]..nameEnd[ math.random(#nameEnd)]
	end

	name=name:gsub("^%l", string.upper)
	return name
end

function nameGenerator.generateNameEnglish()

	nameStart={"Ac","Ad","Al","Am","An","Ash","Ax","Ay","bar","Bas","Baw","Bex","Black","ches","Car","Chin","col","dar","dev","dun","dur",
				"Ea","eg","em","fa","ford","gil","gran","hal","har","het","hod","il","kes","kim","lei","lu","ma","mar","mos","new","nor",
				"pad","pet","ram","roth","shep","sand","thor","twy","war","wey"}
	nameMiddle={"rin","cle","cest","fre","bur","bor","les","nold","min","ken","dul","les","wi","lin","mer","wor"}
	nameEnd={"ton","burgh","wick","cham","ger","side","bury","hill","sey","ford","ster","ham","ing","ley","rod"}

	if (math.random()>0.7) then
		name=nameStart[ math.random(#nameStart)]..nameMiddle[ math.random(#nameMiddle)]..nameEnd[ math.random(#nameEnd)]
	else
		name=nameStart[ math.random(#nameStart)]..nameEnd[ math.random(#nameEnd)]
	end

	name=name:gsub("^%l", string.upper)
	return name
end

function nameGenerator.generateNameFrench()

	nameStart={"bou","lau","o","ar","car","au","bra","sav","ho","mar","be","vil","gra","lan","ca","bour","blai","fon","coi","far"}
	nameMiddle={"ca","que","ste","ti","le","ron","mo","li","le","ne","ga","vin","tel","bour","na","bar"}
	nameEnd={"de","les","ran","lon","vat","mons","reux","ge","net","gean","fond","court","lais","vol","nois","seuil","ne"}

	if (math.random()>0.7) then
		name=nameStart[ math.random(#nameStart)]..nameMiddle[ math.random(#nameMiddle)]..nameEnd[ math.random(#nameEnd)]
	else
		name=nameStart[ math.random(#nameStart)]..nameEnd[ math.random(#nameEnd)]
	end

	name=name:gsub("^%l", string.upper)
	return name
end

function nameGenerator.getEmpireNameGenerator()

	if (math.random()<0.7) then
		return nameGenerator.generateNameEnglish
	else
		return nameGenerator.generateNameFrench
	end

end

