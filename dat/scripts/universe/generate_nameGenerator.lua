
nameGenerator={}

local rawData={}
local standardTable={}

-- prepared using http://marello.org/tools/syllabifier/ plus manual fixes
rawData.ixum="A-lem Ad-dis Ze-men A-det Ad-wa Am-ba Ma-riam An-ko-ber Minch Ar-bo-ye A-wa-sa A-wash A-xum Bad-me Ba-hir Dar Ba-ti Be-de-le Bei-ca Bi-che-na Bi-shof-tu Bon-ga Bu-rie Chen-cha Chua-hit che-len-ko Da-bat De-barq De-bre Ber-han Mar-qos Ta-bor Werq Ze-bit De-jen Del-gi Dem-bi-do-lo Be-ye-da  Da-wa Du-ra-me Fi-ni-cha Se-lam Fre-wey-ni Gam-be-la Ge-lem-so Ghim-bi Gi-nir Go-ba Go-de Gon-dar Gon-go-ma Go-re Gor-go-ra Ha-rar Hayq Ho-sae-na Hu-me-ra I-mi Jim-ma Jin-ka Ka-bri Ke-bri Man-gest Ko-bo Kom-bol-cha Kon-so Lim-mu Ge-net May-chew Me-ke-le Men-di Me-tem-ma Me-tu Mi-zan Te-fe-ri Mo-ya-le Ne-gash Ne-ge-le Bo-ran Ne-kem-te Shas-ha-ma-ne Shi-re Shi-la-vo So-ko-ru Ten-ta Ti-ya Tip-pi Tul-lu Mil-ki Tur-mi Wac-ca Wal-wal Wer-der We-re-ta Wol-dia Wo-lai-ta Wa-li-so Wol-le-ka Wu-cha-le Ya-be-lo Ye-ha Yir-ga A-lem Zi-way"

rawData.english="A-ley As-pley As-pley As-twick Bar-ton Bat-tles-den Bead-low Bees-ton Beg-wa-ry Bid-den-ham Bid-well Bil-ling-ton Blet-soe Blun-ham Boln-hurst Boln-hurst Key-soe Brog-bo-rough Brom-ham Broom Bud-na Cad-ding-ton Camp-ton Chick-sands Camp-ton Car-ding-ton Carl-ton Chal-gra-ve Chal-ton Chaw-ston Chel-ling-ton Chick-sands Chil-tern Green Cla-pham Clif-ton Clip-sto-ne Clo-phill Coc-kay-ne Co-les-den Colm-worth Co-ple Cot-ton End Cran-field Dun-ton Ea-ton Ed-worth Eg-ging-ton El-stow E-ver-sholt E-ver-ton E-ye-worth Fair-field Fan-cott Farn-dish Fel-mer-sham Flit-ton Frox-field Gra-ven-hurst Bar-ford Den-ham Green-field Har-ling-ton Har-rold Hatch Hay-nes Hen-low Her-rings Green Hi-gham Hock-lif-fe Hol-me Ho-ly-well Ho-ney-don Hough-ton Hul-co-te Hus-bor-ne Hy-de Ick-well I-re-land Kee-ley Kemp-ston Kens-worth Key-soe Knot-ting Lang-ford Lea-gra-ve Lee-don Lid-ling-ton Mar-ston Maul-den Melch-bour-ne Mep-per-shall Mill-brook Mil-ton Mog-ger-han-ger Nort-hill Oak-ley O-dell War-den Pa-ven-ham Pegs-don Pep-per-stock Per-ten-hall Po-ding-ton Pots-gro-ve Pul-lox-hill Rad-well Ra-vens-den Ren-hold Ridg-mont Ri-se-ley Rox-ton Sal-ford Salph Sed-ding-ton Se-well Sharn-brook Shar-pen-hoe Shel-ton Shil-ling-ton Short-stown Sil-soe Skim-pot Slip Soul-drop Sou-thill Stags-den Stan-bri-dge Stan-ford Sta-ploe Step-pin-gley Ste-ving-ton Ste-wart-by Ston-don Strea-tley Stud-ham Sut-ton Swi-nes-head Teb-worth Temps-ford Thorn Thorn-co-te Thur-leigh Tils-worth Tin-grith Tod-ding-ton Tot-tern-hoe Tur-vey Wes-to-ning Whips-na-de Wil-den Wil-ling-ton Wil-stead Wing-field Wood-si-de Woot-ton Wre-stling-worth Wy-bos-ton Wy-bos-ton Wy-ming-ton Yiel-den"

rawData.french="Pa-ris Mar-seil-le Ly-on Tou-lou-se Ni-ce Nan-tes Stras-bourg Mont-pel-lier Bor-deaux Lil-le Ren-nes Reims Hav-re e-tien-ne Tou-lon Gre-no-ble Di-jon Nimes An-gers Vil-leur-ban-ne Mans De-nis Aix Pro-ven-ce Cler-mont Fer-rand Brest Li-mo-ges Tours A-miens Per-pig-nan Metz Be-san-con Bou-lo-gne Bil-lan-court Or-leans Mul-hou-se Rouen De-nis Caen Ar-gen-teuil Paul Mon-treuil Nan-cy Rou-baix Tour-coing Nan-ter-re A-vig-non Vi-try Cre-teil Dun-kirk Poi-tiers As-nie-res Cour-be-voie Ver-sail-les Co-lom-bes Aul-nay Pier-re Rueil Mal-mai-son Pau Au-ber-vil-liers Tam-pon Cham-pi-gny An-ti-bes Be-ziers Ro-chel-le Can-nes Ca-lais Na-zai-re Me-ri-gnac Dran-cy Col-mar A-jac-cio Bour-ges I-ssy Le-val-lois Per-ret Sey-ne Quim-per Noi-sy Vil-le-neu-ve Neuil-ly Va-len-ce An-to-ny Cer-gy Vé-ni-ssieux Pe-ssac Tro-yes Cli-chy Iv-ry Cham-be-ry Lo-rient A-by-mes Mon-tau-ban Sar-cel-les Niort Vil-le-juif An-dre Hye-res Quen-tin Beau-vais e-pi-nay Ca-yen-ne Mai-sons Al-fort Cho-let Meaux Chel-les Pan-tin ev-ry Fon-te-nay Fre-jus Van-nes Bon-dy Blanc Mes-nil Ro-che Louis Ar-les Cla-mart Nar-bon-ne An-ne-cy Sar-trou-vil-le Gra-sse La-val Bel-fort Bo-bi-gny ev-reux Vin-cen-nes Mont-rou-ge Sev-ran Al-bi Char-le-vil-le Me-zie-res Su-res-nes Mar-ti-gues Cor-beil E-sson-nes Ouen Ba-yon-ne Cag-nes Bri-ve Gail-lar-de Car-ca-sson-ne Ma-ssy Blois Au-ba-gne Brieuc Cha-teau-roux Cha-lon Sao-ne Man-tes Jo-lie Meu-don Ma-lo Cha-lons Cham-pa-gne Al-fort-vil-le Se-te Sa-lon Pro-ven-ce Vaulx Ve-lin Pu-teaux Ros-ny Her-blain Gen-ne-vil-liers Can-net Liv-ry Gar-gan Pri-est Is-tres Va-len-cien-nes Choi-sy Ca-lui-re Bou-lo-gne Bas-tia An-goul-eme Gar-ges Go-ne-sse Cas-tres Thion-vil-le Wat-tre-los Ta-len-ce Douai Noi-sy Tar-bes Ar-ras Al-es Cour-neu-ve Bourg Com-pie-gne Gap Me-lun La-men-tin Re-ze Ger-main"


rawData.chinese="Bei-jing Shang-hai Chong-qing Guang-zhou Shen-zhen Tian-jin Wu-han Dong-guan Fos-han Nan-jing Hang-zhou Xian Har-bin Su-zhou Qing-dao Da-lian Shan-tou Ji-nan Kun-ming Shi-jia-zhuang Chang-sha Xia-men Wen-zhou Nan-ning Ning-bo Gui-yang Lan-zhou Zi-bo Chang-zhou Tang-shan Nan-chang Xu-zhou"

rawData.arab="Ab-nub A-bu-kir A-da-bi-ya A-ga A-ga-mi A-gee-ba Akh-mim Ar-mant As-fun Ma-tai-na Ash-mun As-siut A-syut At-fih Az-Za-fa-ra-na Az--Za-ga-ziq Bagh-dad Ba-lat Bal-tim Ba-ni Ma-zar Ba-ni Su-waif Ban-ha Bar-da-wil Bar-dis Ba-ris Bar-ra-mi-ya Ben-ha Be-ni Suef Be-re-ni-ce Bi-ba Bil-bais Bil-qas Bim-ban Bir-kat Bi-ya-la Blon-die Bu-laq Buq-buq Da-hab Dai-rut Dal-ja Da-man-hur Da-mas Da-raw Di-kar-nis Di-shna Di-suq Du-mi-at Dschir-dscha Ed-fu E-lat Es-na Fa-qus Fa-ras-kur Fa-ris Far-shut Fay-yum Fi-di-mi-in Fu-ka Fu-wa Gharb Gha-zal Gha-zi Gil-ba-na Gir-ga Gi-za Go-gar Gu-hai-na Ha-ma-ta Ham-mam Hawr Hawsh He-lu-an Hi-ga-za Hur-gha-da Ib-sha-way Id-ku Id-mu Is-mai-li-ya Is-mai-lia It-li-dim It-sa Iz-bat Ja-bal Jir-za Ka-frat Cai-ro Kawm Kha-ni-ka Ki-man Kir-da-sa Kom Lu-xor Mag-hag-ha Ma-hal-lat Mai-dun Mal-la-wi Man-dis-ka Man-fa-lut Man-qa-bad Ma-said Ma-tay Mi-nuf Mi-nya Mit Mo-ne-ra Mut Na-dir Na-fi-sha Nag Nakhl Na-qa-da Nu-wei-ba Qa-la-mun Qa-lyub Qa-ra Qe-na Qi-na Qift Qi-man Qul-lin  Qu-sair Ra-ma-dan Ra-ma-na Ras-hid Sab-da-fa Sa-fa-ga Sal-wa Sa-ma-lut Sa-ma-nud San-nur Sau-hadsh Sa-ra-bi-yum Sa-ta-mu-ni Sawl Sher-bin Shir-bin Sin-nu-ris Si-wa So-hag Saq-qa-ra Ta-ba Tah-ta Ta-la Tal-cha Tal-la Ta-mi-ya Tan-ta Ti-ma Tukh Tu-nai-da Zai-tun Zif-ta Za-ga-zig"


rawData.hindi="A-dhar A-hi-rau-li A-nant An-dha-ri Ar-jun A-tar-di-ha Babh-nau-li Babh-nau-li Ba-buia Ba-dal Ba-dal Ba-dal Bad-ha-ra Bad-rau-na Bad-wa Bagh-par-na Bag-la-ha Ba-ha-dur-ganj Ba-he-lia Ba-he-ra Ba-hor Ba-hor Ba-ho-ra Bai-ra-gi Ba-ku-la-dah Bal Bal Bal-deo Bal-di-ha Ba-li Bal-ku-dia Ba-lo-cha-ha Ba-lua-hi Ban-dhu Ban-dhu Ban-dhu Bandh-wa Ban-di Ban-ja-ri Ba-ra-haj Ba-rah-ra Ba-ra-wa-pur-dil Bar-ga-ha Bar-gaon Barh-wa-lia Ba-h-wa-lia Bar-wa Bar-wa Bar-wa Bar-wa Bar-wa Ba-sant-pur Ba-sant-pur Ba-sant-pur Ba-sau-li Bas-di-la Bas-di-la Bas-di-la Bas-hi-a Ba-ti-sa-ha Ba-trau-li Be-la-hi Bel-wa Bel-wa Bel-wa Bel-wa Be-ti-a Bhag-wan-pur Bha-i-sa-ha Bha-jan Bhar-wa-lia Bhat-wa-lia Bhe-ri Bhe-ri-ha-ri Bhe-ri-ha-ri Bhi-mal Bhis-wa Bhis-wa Bhi-tha Bho-jau-li Bho-jau-li Bhui Bhu-jau-li Bi-jai Bind-wa-lia Bi-raith Bir-bal Bi-shesh-war-pur Bi-shun-pu-ra Bi-shun-pu-ra Bi-shun-pu-ra Bo-dhi Bu-lah-wa Bur-ha-wa Chain Chai-ti Chak Chak-dhar Chak-ha-ni Chakh-ni Chakh-ni Chakh-ni-pu-ran Cha-kia Cha-mar Chan-dar-pur Cha-tur Chau-pa-ria Chau-ra Chau-ria Chhi-tan Chhi-tao-ni Chhi-tau-ni Chir-go-ra Chi-ta-ha Dal Dam-ba-tia Dan-do-pur Dan-gar-ha Dan-kut-wa Dar-ba-ha-gan-ga Dar-gau-li De-o De-o-ri-a De-o-ri-a De-o-ta-ha De-vi-pur Dha-mau-li Dhan Dha-nau-ji Dhan-ha Dha-ram-pur Dha-ram-pur Dha-ram-pur Dhar-mau-li Dhar-ni Dhau-ra-ha-ra Dheer Dhi-nu-hua Dhir Dho-lah Dhol-ha Dho-ra-hi Dhu-ri Dib-ni Do-man Do-ma-ra Du-bau-li Dud-ha-hi Dukh-ran Du-mar Du-ma-ra Du-ma-ri Ek-dan-ga Ek-dan-gi Ek-wan-hi Ek-wan-hi Fa-ki-ra Fe-ru Gai-thi-haw Gam-bha-ria Gam-bhi-ria Gan-bhir Ga-ne-shi Gan-gau-li Gan-gra-ni Gar-hia Ga-rib Ghor-gha-tia Ghur Goh-ti Goh-ti Gon-hi Go-pal-pur Gu-lel-ha Gul-ri-ha Ha-ja-ri Ha-nu-man-ganj Har Ha-rai-ya Ha-rai-ya Ha-ri-har-pur Har-ju Har-ka Har-ka Har-ka Har-ka Har-pur Har-pur Har-pur Har-pur Has-na Ha-thia Hir-na-ha Hir-na-ha Ho-ri-la-pur In-dra Jai Jai Jai Ja-khi-nia Ja-min Jan-gal Jan-gal Jan-gal Jan-ki Ja-rar Jar-ha Jo-gi Ju-da-van Ju-dawn Jun-gal Ju-ra Ju-ra Jur-wa-ni-ya Jwa-la-pur Kal-wa-ri Ka-lyan Ka-nau-ra Kan-thi Kan-thi Kar-dah Kar-hia Kar-ma-i-ni Kar-mha. Ka-ru-a-wa-na Ka-si-a Ka-ta-hi-mar Ka-thi-na-hi-a Ka-thku-ia Ka-ti Ka-ty-a Kau-wa-sar Kes-he-o Ke-wal Khad-da Khad-da Khad-da Khad-da Khad-da Khad-di Khai-ra-tia Khai-ri Khair-tia Kha-ju-ri Kha-ju-ria Kha-nu Khan-war Khar Khe-du Khe-man Khe-si-a Kho-ta-hi Khu-dra Kin-ner Ko-dau-na Ko-har Ko-har-wa-li-a Koh-ra Kop Ko-ta-wa Kot-wa Ku-ia Kuk-ra-ha Kul-man Kun-de-li Kur-maul Kur-sa-ha Lak-hua Lam-kan La-mu-ha Lan-ga-ri Lau-ka-ria Lax-mi-pur Li-la Lux-mi-pur Ma-dan-pur Ma-dar Ma-da-ri-ha Mad-ho-pur Mad-ho-pur Mag-hi Ma-ha-ra-ni Mah-de-va Ma-hes-ha-ra Ma-hu-a-wa Ma-hu-a-wa Ma-hu-la-ni-a Ma-i-la Maj-ra Mak-han-ha Mal-hi-a Mal-hia Man-gal-pur Ma-ni Ma-nia Man-sha Man-sha Man-sha Ma-ri-chah-wa Ma-thia Ma-thi-ya Ma-thi-ya Ma-thu-ra Ma-ti-ha-nia Ma-ti-ha-ni-a Mhu-a-wa Mil-ki Mis-hrau-li Mi-sir Mis-rau-li Mis-rau-li Mis-rau-li Mi-thha Mo-ja-hi-da Mo-ja-hi-da Mo-ja-hi-di Mo-ti Mo-ti Mo-ti-pur Mud-mud-wa Mun-de-ra Mun-de-ra Mu-zo-hi-da Na-dah Na-ga-ri Nand Nan-da Nar Na-ra-in-pur Na-ra-in-pur Nar-ha-ria Nar-ka-ha-wa Nar-ku Nau-ga-on Nau-ga-wan Nau-ran-gi-a Nau-tan Nau-tar Na-wal Ne-bu-a Ne-waz Nir-mal O-har-wa-li-a Pach Pa-chphe-ra Pa-da-ri Pa-da-ri Pa-dra-hi Pa-drau-na Pa-dri Pa-ga-ra Pa-har-pur Pa-ka-ri Pa-ka-ri-ha-wa Pa-ka-ri-par Pa-ka-ri-yar Pak-ha Pak-han-ha Pak-ri Pak-ri Pak-ri Pa-lat Pa-li-a Pan-de Pan-hi-wa Par-bat Par-gan Par-sad-pur Par-sau-ni Par-sau-ni Par-si-a Par-su Pa-ta-ri-ya Pa-te-ra Pa-te-ra Pa-ter-ha Pa-ti-lar Pat-khau-li Pat-khau-li Pha-tak Pha-tak Pi-par Pi-pa-ri-a Pi-par-pa-ti Pi-pra Pi-pra-si Pi-pra-si Pi-pra-war Pi-pri-a Prad-han Pur-na-ha Pur-na-ha Ra-ha-su Ra-i-ganj Ra-i-pur Raj-man Ram-ji Ram-na-gar Ram-na-gar Ram-na-gar Ram-pur Ran-ji-ta Ra-sul-pur Ra-tan-wa Rua-ri Ru-dra-pur Sa-di Sa-di Sa-di Sa-gar Sa-gar Sa-haj-wa-lia Sa-ho-dar Sa-hua-dih Sak-hya Sa-lik-pur Sa-rang Sa-rang Sar-ga-ri-a Sar-ga-ti-a Sar-pa-thi Sar-pa-thi Sa-ry-a Saur-ha Saur-ha Se-hu-i Sek-hu-i Sek-hu-Sek-hui Sek-hui Se-ma-ra Sem-ra Sem-ra Sem-ria Sem-ria Se-wak Se-wak Shah-pur Sham-bhu Sham-pur Shes-ha Shiv Shiv-pur Shob-ha Shob-ha Shri-pa-ti Shu-kul Sid-hu-a Sid-hu-a Si-gan-jo-ri Sig-ha Sik-ta Sir-si-a Si-sa-i Sis-han Sis-wa Si-ta So-ha-na-ri-a Soh-rau-na Soh-rau-na Soh-rau-na Son-bar-sa Son-wal Su-ga-hi Sukh Suk-ha-ri Su-raj-pur Sus-wa-lia Ta-da-wa Teen Tej-wa-lia Ter-hi Thag-da Tin-par-sa Tir-lok-pur Tir-lok-pur Tur-ka-ha Tur-khi U-dho Vi-jai-pur Vi-jay-pur Vin-dhya-chal-pur Vis-hun-pur Vis-hun-pu-ra"


rawData.other1="A-bau A-du-mo A-gaun A-iam-bak A-i-ta-pe A-le-ka-no A-le-xis-ha-fen A-lo-tau Am-bun-ti An-go-ram A-ra-wa A-sa-ro A-wa-ba Ba-i-mu-ru Ba-iy-er Ba-li-mo Banz Be-na-be-na Ben-na Ben-sbach Be-re-i-na Bo-a-na Bo-gi-a Bo-ri-di Bos-set Brah-man Bu-in Bu-ka Bu-lo-lo Bu-na Chu-a-ve Da-gu-a Da-ha-mo Da-ru De-i E-fo-gi Fa-ne Fer-gu-son Fin-schha-fen Ga-gi-du Ga-pun Gas-ma-ta Go-na Go-ro-ka Gu-mi-ne Gu-sap Hen-ga-no-fi Hos-kins Hu-la Ia-li-bu I-hu Im-bon-ggu I-to-ka-ma Kab-wum Ka-gi Ka-gu-a Ka-ia-pit Ka-i-nan-tu Ka-mu-si Kan-dep Kan-dri-an Ka-ri-mu-i Kar-kar Ka-vi-eng Ke-la-no-a Ke-re-ma Ke-re-vat Ke-ro-wa-gi Ki-e-ta Ki-ko-ri Kim-be Ki-ri-wi-na Ki-un-ga Ko-ko-da Ko-ko-po Kom-pi-am Ko-pi-a-go Kri-sa Ku-na-y-e Kun-di-a-wa Kwi-ki-la Lae La-ga-ip Mur-ra-y La-ma-ri Li-do Lon-do-lo-vit Lo-ren-gau Lo-su-ia Lu-fa Lu-sik Ma-dang Ma-ga-ri-ma Ma-na-ri Man-gu-na Man-ki Ma-prik Ma-ri-en-burg Me-di-bur Men-di Me-ny-a-my-a Minj Mo-ro Ha-gen Mu-ru-a Nad-zab Na-ma-ta-na-i Ne-bi-ly-er Nin-ge-rum Ni-pa Nu-ku O-bo O-ka-pa Ol-so-bip O-non-ge Pan-gu-na Pa-si Po-mi-o Pon-ga-ni Po-pon-det-ta Por-ge-ra Ra-baul Ra-i Co-ast Sa-i-dor Sa-la-mau-a Sa-la-mo Sa-ma-ra-i Sam-be-ri-gi Sa-na-nan-da San-ga-ra Sa-se-re-me Si-a-lum Sim-ba-i Si-o So-pu-ta Su-ki Ta-bi-bu-ga Ta-bu-bil Tad-ji Ta-pi-ni Ta-la-se-a Ta-ri Te-le-fo-min To-ro-ki-na Tsi-li Tu-fi U-ka-rum-pa U-si-no Va-ni-mo Vi-vi-ga-ni Wa-bag Wa-bo Wa-mi-ra Wa-ni-ge-la Wa-pe-na-man-da Wa-su Wau We-wak Wi-pim Wo-i-ta-pe Wo-se-ra Y-an-go-ru Y-on-ggo-mugl"

rawData.other2="Sang-thong May-par-kngum Phong-sa-ly May Khoua Sam-phanh Boun-Neua Yo-tu Boun-Tay Nam-tha Sing Long Vieng-phouk-ha Na-Le Xay La Na-Mo Nga Beng Hou-ne Pak-Beng Houay-Xay Ton-Pheung Meung Phau-dom Pak-Tha Nam-Nhou Lu-ang-Pra-bang Xieng-nge-un Na-ne Pa-ku Nam-Bak Ngoy Pak-Seng Phon-xay Chom-phet Vieng-kham Phouk-hou-ne Phon-thong Xam-Neua Xieng-kho Vi-eng-thong Vieng-xay Houa-meuang Sam-tay Sop-Bao Muang-Et Sai-ny-bu-li Khop Hong-sa Ngeun Xien-gho-ne Phi-ang Par-klai Ke-ne-thao Bo-te-ne Thong-my-xay Pek Kham Nong-Het Khou-ne Mok-May Phou-Kout Pha-xay Phon-hong Thou-lak-hom Keo-dom Ka-sy Vang-vieng"


rawData.other3="Faaa Pu-na-au-ia Pa-pee-te Moo-rea Ma-iao Ma-hi-na Pi-rae Pae-a Ta-ia-ra-pu Pa-pa-ra A-ru-e Hi-ti-a-a Bo-ra-Bo-ra Te-va Ta-ia-ra-pu Hu-a-hi-ne Ta-ha-a Ta-pu-ta-pu-a-te-a Tu-ma-ra-a U-tu-ro-a Ran-gi-ro-a Nu-ku Hi-va Ru-ru-tu Hi-va-O-a U-a-Po-u Tu-bu-a-i Fa-ka-ra-va Ma-ke-mo A-ru-tu-a Gam-bi-er Ha-o Ta-ka-ro-a Ma-ni-hi Mau-pi-ti Ra-i-va-vae A-na-a Ri-ma-ta-ra Ta-hu-a-ta U-a-Hu-ka Fa-tu-Hi-va Re-a-o Ra-pa Na-pu-ka Nu-ku-ta-va-ke Tu-re-ia Fan-ga-tau Ta-ta-ko-to Hi-ku-e-ru Pu-ka-pu-ka "

rawData.barbarian1="A-dal-funs a-dal-rik a-la-ric a-la-ri-ca al-hreiks al-hva-ha-ryis a-ma-la-reiks an-da-gis an-si-la a-ra-reiks a-tha-la-gild a-tha-la-reiks a-tha-la-ric a-tha-na-gild a-tha-na-reiks a-tha-na-ric at-ta au-do au-doa-cer au-dvakr au-stra-gu-ta aus-vin-thus a-va-gis ba-dwi-la be-re-mud bo-the-ric chil-de-fon-sus chin-das-vinth chin-das-win-tha dag e-bo-ric e-bri-muth e-diulf e-gi-ca ei-riks er-ma-na-ric er-me-ni-geld er-min-gild er-mi-ni-geld eu-ric eu-tha-ric e-ver-mud e-vo-ric fer-ho-nanths fri-de-ger fri-thi-gern fri-ti-gern"

rawData.barbarian2="Ye-su-gei Nei-kun Da-ri-tai Chi-lei-du Bar-tan Te-mu-jin U-ge Kho-ri Bu-ka Kha-jiun Te-mu-ja Ku-tu-la Al-tan Meng-ge-tu Tar-gu-tai Dai Se-chen Mung-lik Am-ba-khai Cha-ra-kha To-daan Gir-ta Ka-sar Bek-tair Bel-gu-tai Bo-don-char Chim-bai Chi-laun Sor-khan Shi-ra Na-khu Boor-chu To-ghrul Kur-cha-khus Tokh-toa Er-ke Jel-mei Su-be-tai Ja-mu-kha Ja-kha Gam-bu Dair U-sun Kha-gha-ta Dar-ma-la Chil-gei Jo-chi Al-tan Khu-char Sa-cha Tai-chu Ku-chu Ko-ko-chu Kha-daan Ong-gur Je-be Khor-chi Mu-khal-khu Tai-chu O-kin Bar-kak Khu-char O-go-lai Jo-chi Dar-ma-la Tai-char Jur-cha-dai Khu-yil-dar Ku-tuk-to Yur-ki Shi-kiur Bu-ri Bo-ke Me-gu-jin"

rawData.barbarian3="Ach-cauh-tli a-hui-liz-tli a-mox-tli atl chi-ca-hua chi-mal-li chi-pa-hua ci-pact-li cit-la-li coatl coa-xoch co-yotl cual-li cuauh-te-moc cuet-lach-tli cuetz-pal-li cuix-tli e-he-catl e-leuia e-tal-pal-li ez-tli hue-mac hui-tzi-li-huitl hui-tzil-li ic-cauh-tli ich-ta-ca ic-no-yotl i-hui-catl il-hi-ca-mi-na il-huitl i-to-tia itz-tli iuitl ixtli ma-hui-zoh ma-nauia ma-tlal ma-tla-li-huitl ma-zatl me-catl mez-tli mict-lan-te-cuh-tli mi-lin-ti-ca mo-moz-tli mo-yo-le-hua-ni na-huatl na-ma-cuix ne-cal-li ne-cua-metl nel-li ne-za-hual-co-yotl ne-za-hual-pil-li no-che-huatl noch-tli no-pal-tzin oh-tli ol-lin pat-li quauht-li quet-zal-coatl te-noch teo-xi-huitl te-pil-tzin tez-ca-coatl tla-cae-lel tla-ce-lel tla-chi-nol-li tla-loc tla-nex-tic tla-nex-tli tla-zoh-tla-lo-ni tla-zo-pil-li tle-xi-ctli tlil-po-ton-qui toch-tli tol-te-catl to-nauac to-totl ue-man ue-tzca-yotl xi-coh-ten-catl xi-huitl xi-pil xi-pil-li xiuh-coatl xo-chi-pe-pe xo-chi-pil-li yaotl ya-yauh-qui yo-lo-tli yol-ya-ma-ni-tzin zi-pac-to-nal zo-lin"

local ALPHABET="ABCDEFGHIJKLMNOPQRSTUVWXYZ"

function getRandomLetter()
	return string.char(ALPHABET:byte(math.random(1, #ALPHABET)))
end

function nameGenerator.generateNameEmpty()
	local name=getRandomLetter()..getRandomLetter().."-"..math.random(1, 999)

	return name
end

function nameGenerator.generateNameArdarshir()

	local nameStart={"mer","bry","roi","brech","y","da","mo","krai","qan","ur","tach","tel","chyd","gel","fo","mor"}
	local nameMiddle={"tio","du","na","dwy","tol","rio","ry","dio","ru"}
	local nameEnd={"tioch","te","dan","dwyr","tolch","rioch","kraich","ryf","diolch","wyr","loch","dwan","gelch","daich","chan"}
	local name=""

	if (math.random()>0.5) then
		name=nameStart[ math.random(#nameStart)]..nameMiddle[ math.random(#nameMiddle)]..nameEnd[ math.random(#nameEnd)]
	else
		name=nameStart[ math.random(#nameStart)]..nameEnd[ math.random(#nameEnd)]
	end

	name=name:gsub("^%l", string.upper)
	return name
end


function nameGenerator.generateNameNatives()
	return nameGenerator.generateNameOther()
end


function nameGenerator.generateNameBetelgeuse()

	local nameStart={"ve","sal","pra","por","fos","chio","co","mi","mua","cam","do","con"}
	local nameMiddle={"ra","var","ni","tel","val","pa","po"}
	local nameEnd={"zia","ria","za","zio","sto","giore","pia","mia","no","zer","zoggio"}


	local name=nameStart[ math.random(#nameStart)]..nameMiddle[ math.random(#nameMiddle)]..nameEnd[ math.random(#nameEnd)]


	name=name:gsub("^%l", string.upper)
	return name
end


function nameGenerator.getEmpireNameGenerator()

	if (math.random()<0.4) then
		return nameGenerator.generateNameEnglish
	elseif (math.random()<0.6) then
		return nameGenerator.generateNameChinese
	elseif (math.random()<0.8) then
		return nameGenerator.generateNameHindi
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

function nameGenerator.generateNameArab()
	return getNameFromStandardTable("arab")
end

function nameGenerator.generateNameChinese()
	return getNameFromStandardTable("chinese")
end

function nameGenerator.generateNameHindi()
	return getNameFromStandardTable("hindi")
end

function nameGenerator.getRandomNativeGenerator()
	local rand=math.random()
  
	  if (rand<0.3) then
	    return function() return getNameFromStandardTable("other1",3) end
	  elseif (rand<0.6) then
	    return function() return getNameFromStandardTable("other2",3) end
	  else
	    return function() return getNameFromStandardTable("other3",3) end
	  end
end

function nameGenerator.getRandomBarbarianGenerator()
	local rand=math.random()
  
	  if (rand<0.3) then
	    return function() return getNameFromStandardTable("barbarian1",2) end
	  elseif (rand<0.6) then
	    return function() return getNameFromStandardTable("barbarian2",2) end
	  else
	    return function() return getNameFromStandardTable("barbarian3",2) end
	  end
end

function nameGenerator.generateNameOther()
  
  local rand=math.random()
  
  if (rand<0.3) then
    return getNameFromStandardTable("other1",3)
  elseif (rand<0.6) then
    return getNameFromStandardTable("other2",3)
  else
    return getNameFromStandardTable("other3",3)
  end
end

function nameGenerator.generateNameBarbarian()
  local rand=math.random()
  
  if (rand<0.3) then
    return getNameFromStandardTable("barbarian1",2)
  elseif (rand<0.6) then
    return getNameFromStandardTable("barbarian2",2)
  else
    return getNameFromStandardTable("barbarian3",2)
  end
end

