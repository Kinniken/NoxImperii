
nameGenerator={}

local rawData={}
local standardTable={}

rawData.ixum="A-lem Ad-dis Ze-men A-det Ad-wa Am-ba Ma-riam An-ko-ber Minch Ar-bo-ye A-wa-sa A-wash A-xum Bad-me Ba-hir Dar Ba-ti Be-de-le Bei-ca Bi-che-na Bi-shof-tu Bon-ga Bu-rie Chen-cha Chua-hit che-len-ko Da-bat De-barq De-bre Ber-han Mar-qos Ta-bor Werq Ze-bit De-jen Del-gi Dem-bi-do-lo Be-ye-da  Da-wa Du-ra-me Fi-ni-cha Se-lam Fre-wey-ni Gam-be-la Ge-lem-so Ghim-bi Gi-nir Go-ba Go-de Gon-dar Gon-go-ma Go-re Gor-go-ra Ha-rar Hayq Ho-sae-na Hu-me-ra I-mi Jim-ma Jin-ka Ka-bri Ke-bri Man-gest Ko-bo Kom-bol-cha Kon-so Lim-mu Ge-net May-chew Me-ke-le Men-di Me-tem-ma Me-tu Mi-zan Te-fe-ri Mo-ya-le Ne-gash Ne-ge-le Bo-ran Ne-kem-te Shas-ha-ma-ne Shi-re Shi-la-vo So-ko-ru Ten-ta Ti-ya Tip-pi Tul-lu Mil-ki Tur-mi Wac-ca Wal-wal Wer-der We-re-ta Wol-dia Wo-lai-ta Wa-li-so Wol-le-ka Wu-cha-le Ya-be-lo Ye-ha Yir-ga A-lem Zi-way"

rawData.english="A-ley As-pley As-pley As-twick Bar-ton Bat-tles-den Bead-low Bees-ton Beg-wa-ry Bid-den-ham Bid-well Bil-ling-ton Blet-soe Blun-ham Boln-hurst Boln-hurst Key-soe Brog-bo-rough Brom-ham Broom Bud-na Cad-ding-ton Camp-ton Chick-sands Camp-ton Car-ding-ton Carl-ton Chal-gra-ve Chal-ton Chaw-ston Chel-ling-ton Chick-sands Chil-tern Green Cla-pham Clif-ton Clip-sto-ne Clo-phill Coc-kay-ne Co-les-den Colm-worth Co-ple Cot-ton End Cran-field Dun-ton Ea-ton Ed-worth Eg-ging-ton El-stow E-ver-sholt E-ver-ton E-ye-worth Fair-field Fan-cott Farn-dish Fel-mer-sham Flit-ton Frox-field Gra-ven-hurst Bar-ford Den-ham Green-field Har-ling-ton Har-rold Hatch Hay-nes Hen-low Her-rings Green Hi-gham Hock-lif-fe Hol-me Ho-ly-well Ho-ney-don Hough-ton Hul-co-te Hus-bor-ne Hy-de Ick-well I-re-land Kee-ley Kemp-ston Kens-worth Key-soe Knot-ting Lang-ford Lea-gra-ve Lee-don Lid-ling-ton Mar-ston Maul-den Melch-bour-ne Mep-per-shall Mill-brook Mil-ton Mog-ger-han-ger Nort-hill Oak-ley O-dell War-den Pa-ven-ham Pegs-don Pep-per-stock Per-ten-hall Po-ding-ton Pots-gro-ve Pul-lox-hill Rad-well Ra-vens-den Ren-hold Ridg-mont Ri-se-ley Rox-ton Sal-ford Salph Sed-ding-ton Se-well Sharn-brook Shar-pen-hoe Shel-ton Shil-ling-ton Short-stown Sil-soe Skim-pot Slip Soul-drop Sou-thill Stags-den Stan-bri-dge Stan-ford Sta-ploe Step-pin-gley Ste-ving-ton Ste-wart-by Ston-don Strea-tley Stud-ham Sut-ton Swi-nes-head Teb-worth Temps-ford Thorn Thorn-co-te Thur-leigh Tils-worth Tin-grith Tod-ding-ton Tot-tern-hoe Tur-vey Wes-to-ning Whips-na-de Wil-den Wil-ling-ton Wil-stead Wing-field Wood-si-de Woot-ton Wre-stling-worth Wy-bos-ton Wy-bos-ton Wy-ming-ton Yiel-den"

rawData.french="Pa-ris Mar-seil-le Ly-on Tou-lou-se Ni-ce Nan-tes Stras-bourg Mont-pel-lier Bor-deaux Lil-le Ren-nes Reims Hav-re e-tien-ne Tou-lon Gre-no-ble Di-jon Nimes An-gers Vil-leur-ban-ne Mans De-nis Aix Pro-ven-ce Cler-mont Fer-rand Brest Li-mo-ges Tours A-miens Per-pig-nan Metz Be-san-con Bou-lo-gne Bil-lan-court Or-leans Mul-hou-se Rouen De-nis Caen Ar-gen-teuil Paul Mon-treuil Nan-cy Rou-baix Tour-coing Nan-ter-re A-vig-non Vi-try Cre-teil Dun-kirk Poi-tiers As-nie-res Cour-be-voie Ver-sail-les Co-lom-bes Aul-nay Pier-re Rueil Mal-mai-son Pau Au-ber-vil-liers Tam-pon Cham-pi-gny An-ti-bes Be-ziers Ro-chel-le Can-nes Ca-lais Na-zai-re Me-ri-gnac Dran-cy Col-mar A-jac-cio Bour-ges I-ssy Le-val-lois Per-ret Sey-ne Quim-per Noi-sy Vil-le-neu-ve Neuil-ly Va-len-ce An-to-ny Cer-gy Vé-ni-ssieux Pe-ssac Tro-yes Cli-chy Iv-ry Cham-be-ry Lo-rient A-by-mes Mon-tau-ban Sar-cel-les Niort Vil-le-juif An-dre Hye-res Quen-tin Beau-vais e-pi-nay Ca-yen-ne Mai-sons Al-fort Cho-let Meaux Chel-les Pan-tin ev-ry Fon-te-nay Fre-jus Van-nes Bon-dy Blanc Mes-nil Ro-che Louis Ar-les Cla-mart Nar-bon-ne An-ne-cy Sar-trou-vil-le Gra-sse La-val Bel-fort Bo-bi-gny ev-reux Vin-cen-nes Mont-rou-ge Sev-ran Al-bi Char-le-vil-le Me-zie-res Su-res-nes Mar-ti-gues Cor-beil E-sson-nes Ouen Ba-yon-ne Cag-nes Bri-ve Gail-lar-de Car-ca-sson-ne Ma-ssy Blois Au-ba-gne Brieuc Cha-teau-roux Cha-lon Sao-ne Man-tes Jo-lie Meu-don Ma-lo Cha-lons Cham-pa-gne Al-fort-vil-le Se-te Sa-lon Pro-ven-ce Vaulx Ve-lin Pu-teaux Ros-ny Her-blain Gen-ne-vil-liers Can-net Liv-ry Gar-gan Pri-est Is-tres Va-len-cien-nes Choi-sy Ca-lui-re Bou-lo-gne Bas-tia An-goul-eme Gar-ges Go-ne-sse Cas-tres Thion-vil-le Wat-tre-los Ta-len-ce Douai Noi-sy Tar-bes Ar-ras Al-es Cour-neu-ve Bourg Com-pie-gne Gap Me-lun La-men-tin Re-ze Ger-main"


rawData.other1="A-bau A-du-mo A-gaun A-iam-bak A-i-ta-pe A-le-ka-no A-le-xis-ha-fen A-lo-tau Am-bun-ti An-go-ram A-ra-wa A-sa-ro A-wa-ba Ba-i-mu-ru Ba-iy-er Ba-li-mo Banz Be-na-be-na Ben-na Ben-sbach Be-re-i-na Bo-a-na Bo-gi-a Bo-ri-di Bos-set Brah-man Bu-in Bu-ka Bu-lo-lo Bu-na Chu-a-ve Da-gu-a Da-ha-mo Da-ru De-i E-fo-gi Fa-ne Fer-gu-son Fin-schha-fen Ga-gi-du Ga-pun Gas-ma-ta Go-na Go-ro-ka Gu-mi-ne Gu-sap Hen-ga-no-fi Hos-kins Hu-la Ia-li-bu I-hu Im-bon-ggu I-to-ka-ma Kab-wum Ka-gi Ka-gu-a Ka-ia-pit Ka-i-nan-tu Ka-mu-si Kan-dep Kan-dri-an Ka-ri-mu-i Kar-kar Ka-vi-eng Ke-la-no-a Ke-re-ma Ke-re-vat Ke-ro-wa-gi Ki-e-ta Ki-ko-ri Kim-be Ki-ri-wi-na Ki-un-ga Ko-ko-da Ko-ko-po Kom-pi-am Ko-pi-a-go Kri-sa Ku-na-y-e Kun-di-a-wa Kwi-ki-la Lae La-ga-ip Mur-ra-y La-ma-ri Li-do Lon-do-lo-vit Lo-ren-gau Lo-su-ia Lu-fa Lu-sik Ma-dang Ma-ga-ri-ma Ma-na-ri Man-gu-na Man-ki Ma-prik Ma-ri-en-burg Me-di-bur Men-di Me-ny-a-my-a Minj Mo-ro Ha-gen Mu-ru-a Nad-zab Na-ma-ta-na-i Ne-bi-ly-er Nin-ge-rum Ni-pa Nu-ku O-bo O-ka-pa Ol-so-bip O-non-ge Pan-gu-na Pa-si Po-mi-o Pon-ga-ni Po-pon-det-ta Por-ge-ra Ra-baul Ra-i Co-ast Sa-i-dor Sa-la-mau-a Sa-la-mo Sa-ma-ra-i Sam-be-ri-gi Sa-na-nan-da San-ga-ra Sa-se-re-me Si-a-lum Sim-ba-i Si-o So-pu-ta Su-ki Ta-bi-bu-ga Ta-bu-bil Tad-ji Ta-pi-ni Ta-la-se-a Ta-ri Te-le-fo-min To-ro-ki-na Tsi-li Tu-fi U-ka-rum-pa U-si-no Va-ni-mo Vi-vi-ga-ni Wa-bag Wa-bo Wa-mi-ra Wa-ni-ge-la Wa-pe-na-man-da Wa-su Wau We-wak Wi-pim Wo-i-ta-pe Wo-se-ra Y-an-go-ru Y-on-ggo-mugl"

rawData.other2="Sang-thong May-par-kngum Phong-sa-ly May Khoua Sam-phanh Boun-Neua Yo-tu Boun-Tay Nam-tha Sing Long Vieng-phouk-ha Na-Le Xay La Na-Mo Nga Beng Hou-ne Pak-Beng Houay-Xay Ton-Pheung Meung Phau-dom Pak-Tha Nam-Nhou Lu-ang-Pra-bang Xieng-nge-un Na-ne Pa-ku Nam-Bak Ngoy Pak-Seng Phon-xay Chom-phet Vieng-kham Phouk-hou-ne Phon-thong Xam-Neua Xieng-kho Vi-eng-thong Vieng-xay Houa-meuang Sam-tay Sop-Bao Muang-Et Sai-ny-bu-li Khop Hong-sa Ngeun Xien-gho-ne Phi-ang Par-klai Ke-ne-thao Bo-te-ne Thong-my-xay Pek Kham Nong-Het Khou-ne Mok-May Phou-Kout Pha-xay Phon-hong Thou-lak-hom Keo-dom Ka-sy Vang-vieng"


rawData.other3="Faaa Pu-na-au-ia Pa-pee-te Moo-rea Ma-iao Ma-hi-na Pi-rae Pae-a Ta-ia-ra-pu Pa-pa-ra A-ru-e Hi-ti-a-a Bo-ra-Bo-ra Te-va Ta-ia-ra-pu Hu-a-hi-ne Ta-ha-a Ta-pu-ta-pu-a-te-a Tu-ma-ra-a U-tu-ro-a Ran-gi-ro-a Nu-ku Hi-va Ru-ru-tu Hi-va-O-a U-a-Po-u Tu-bu-a-i Fa-ka-ra-va Ma-ke-mo A-ru-tu-a Gam-bi-er Ha-o Ta-ka-ro-a Ma-ni-hi Mau-pi-ti Ra-i-va-vae A-na-a Ri-ma-ta-ra Ta-hu-a-ta U-a-Hu-ka Fa-tu-Hi-va Re-a-o Ra-pa Na-pu-ka Nu-ku-ta-va-ke Tu-re-ia Fan-ga-tau Ta-ta-ko-to Hi-ku-e-ru Pu-ka-pu-ka "


function nameGenerator.generateNameNatives()

	local nameStart={"mer","bry","roi","brech","y","da","mo","khrai","qan","ur","tach","tel","chydh","gel","fo","mor"}
	local nameMiddle={"thio","dhu","na","dwy","thol","rio","ry","dio","ru"}
	local nameEnd={"thioch","te","dan","dwyr","tholch","rioch","khraich","ryf","diolch","wyr","loch","dhwan","gelch","daich","chan"}
	local name=""

	if (math.random()>0.5) then
		name=nameStart[ math.random(#nameStart)]..nameMiddle[ math.random(#nameMiddle)]..nameEnd[ math.random(#nameEnd)]
	else
		name=nameStart[ math.random(#nameStart)]..nameEnd[ math.random(#nameEnd)]
	end

	name=name:gsub("^%l", string.upper)
	return name
end


function nameGenerator.generateNameBetelgeuse()

	local nameStart={"ve","sal","pra","por","fos","chio","co","mi","mua","cam","do","con"}
	local nameMiddle={"ra","var","ni","tel","val","pa","po"}
	local nameEnd={"zia","ria","za","zio","sto","giore","pia","mia","no","zer","zoggio"}


	local name=nameStart[ math.random(#nameStart)]..nameMiddle[ math.random(#nameMiddle)]..nameEnd[ math.random(#nameEnd)]


	name=name:gsub("^%l", string.upper)
	return name
end



function nameGenerator.generateNameArdarshir()

	local nameStart={"mer","bry","roi","brech","y","da","mo","khrai","qan","ur","tach","tel","chydh","gel","fo","mor"}
	local nameMiddle={"thio","dhu","na","dwy","thol","rio","ry","dio","ru"}
	local nameEnd={"thioch","te","dan","dwyr","tholch","rioch","khraich","ryf","diolch","wyr","loch","dhwan","gelch","daich","chan"}
	local name=""

	if (math.random()>0.5) then
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

--builds a reference table from a list of words seperated with spaces
--each word having its syllables split with hyphens
function buildStandardTable(rawData)
	local standardTable={}

	for word in string.gmatch(rawData, '%S+') do
		local pos=1
		for syllable in string.gmatch(word, '%a+') do 
			if (standardTable[pos]==nil) then
				standardTable[pos]={}
			end
			table.insert(standardTable[pos],syllable)
			pos=pos+1
		end
	end

	return standardTable
end

--use a previously built table to generate a name
--with syllables taken at random from the words provided
function getNameFromStandardTable(type,minSyllables)

  if (minSyllables==nil) then
    minSyllables=2
  end

	if (standardTable[type]==nil) then
		if rawData[type]==nil then
			print("No raw data for standard name generator of type "..type.."!")
			return ""
		end
		standardTable[type]=buildStandardTable(rawData[type])
	end

	local standardTable=standardTable[type]

	local name=""

	local nbNames=#standardTable[1]

	for i=1,#standardTable do
    --always take two syllables
    --above, in proportion to original word list
    if (i<=minSyllables or math.random(nbNames)<=#standardTable[i]) then
    	name=name..standardTable[i][math.random(#standardTable[i])]
    end
end

name=name:lower():gsub("^%l", string.upper)
return name
end

function nameGenerator.generateNameIxum() 
	return getNameFromStandardTable("ixum")
end

function nameGenerator.generateNameEnglish()
	return getNameFromStandardTable("english")
end

function nameGenerator.generateNameFrench()
	return getNameFromStandardTable("french")
end

function nameGenerator.generateNameOther()
  
  local rand=math.random()
  
  if (rand<0.3) then
    return getNameFromStandardTable("other1",3)
  elseif (rand<0.3) then
    return getNameFromStandardTable("other2",3)
  else
    return getNameFromStandardTable("other3",3)
  end
end

--for i=1,200 do
--	print(nameGenerator.generateNameOther()) 
--end
