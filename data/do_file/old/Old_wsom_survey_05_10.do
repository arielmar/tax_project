**Final 2005 - 2011 recode//


clear all
*cd "/Volumes/YoungBros/tax copy/data/NSOM/original"
cd "H:\tax\data\WSOM\original"
set more off


*//Survey year 2011//

*-------------------------
*open file : 11WSOM.dta
*-------------------------

use "11WSOM.dta"

***************************************


gen year=2011

label variable ipnr "Unique Identification number of person surveyed" 

rename F15A rd_public
label variable rd_public "Åsikt om förslag  - Minska den offentliga sektorn"

rename F15J cuttax
label variable cuttax "Åsikt om förslag  - Sänka skatterna"

*/rtax_rserv variable is not in 2011 survey
gen rtax_rserv=.

rename F12 left_right
label variable left_right "Var någonstans skulle du placera dig själv på en sådan vänster–högerskala?"

rename F26B trust_ParPol
label variable trust_ParPol "Allmänt sett, hur stort förtroende har du för det sätt på vilket följande grupper sköter sitt arbete? - Rikspolitiker"

rename F26E trust_KommPol
label variable trust_KommPol "Allmänt sett, hur stort förtroende har du för det sätt på vilket följande grupper sköter sitt arbete? - Kommunens politiker"

rename F26C trust_VGPol
label variable trust_VGPol "Allmänt sett, hur stort förtroende har du för det sätt på vilket följande grupper sköter sitt arbete? - Västra Götalandsregionens politiker"

*for unemploy and pensioner I needed to recode so that I dont create a problem when converting 0 to missing value as done below
rename F61C unemploy
label variable unemploy "Vilken grupp tillhör du för närvarande - Arbetslös"
recode unemploy 0=2 

rename F61D pensioner
label variable pensioner "Vilken grupp tillhör du för närvarande - Ålderspensionär/avtalspensionär"
recode pensioner 0=2 

rename lder age
label variable age "age recorded by respondent" 

rename Kn female
label variable female "gender from registration number"
*female is coded - 1=women 2=men, recode below.

rename F91AA chng_fin
label variable chng_fin "Ekonomiska förhållanden förändrats de senaste 12 månaderna - Din egen eko"

rename F91AB chng_mun
label variable chng_mun "Ekonomiska förhållanden förändrats de senaste 12 månaderna - Ekonomin i d"

rename F91AC chng_swe
label variable chng_swe "Ekonomiska förhållanden förändrats de senaste 12 månaderna - Den svenska"

rename F91BA fut_fin
label variable fut_fin "Uppskattade förändringar i ekonomin de kommande 12 månaderna - Din egen e"

rename F91BB fut_mun
label variable fut_mun "Uppskattade förändringar i ekonomin de kommande 12 månaderna - Ekonomin i"

rename F91BC fut_swe
label variable fut_swe "Uppskattade förändringar i ekonomin de kommande 12 månaderna - Den svensk"

rename F88A home_class
label variable home_class "Vilket alternativ stämmer bäst - Ditt nuvarande hem"

rename F88B home_class2
label variable home_class2 "Vilket alternativ stämmer bäst - Det hem du växte upp i"

rename Indatum indatum
label variable indatum "Datum enkäten kom in"

label variable kommun "municipality of residence"

label variable utb "educational attainment"

rename F89 edu
label variable edu "What level of education have you achieved or are currently undergoing?"

rename F86 income_hus
label variable income_hus "total annual income for all people in household before tax" 
recode income_hus 1=1 2=2 3=3 4=4 5=5 6=6 7=7 8=8 9=8 10=8 11=8 12=8

egen ipnr2 = concat(year ipnr)
drop ipnr
rename ipnr2 ipnr
label variable ipnr "Unique Identification number of person surveyed" 

*//

keep year ipnr left_right rd_public cuttax trust_ParPol trust_KommPol trust_VGPol unemploy pensioner home_class home_class2 ///
chng_fin chng_mun chng_swe fut_fin fut_mun fut_swe female age edu utb kommun indatum income_hus

*/For appending surveys do the following to standardize:
*// 1. Open all files individually and run the following commands to standardize the surveys

/* 1A. Recode all no answers or survey errors (99, 98, 9999, 9997 and 0) to missing values (.)
This is relevant because.. in some cases 0 represented someone not answering 1 question in an entire set of questions
For example multiple questions on opinions on policies or on trust for different instituions, etc
ALSO - some variables like unemploy, pensioner, etc are coded (0,1), so I have to convert them before hand so they wont
be erased */

mvdecode _all, mv(9999)
mvdecode _all, mv(9997)
mvdecode _all, mv(99)
mvdecode _all, mv(98)
mvdecode _all, mv(0)

* value 6 and 9 for these variables was that there was no answer in part of the entire question set
* i will convert this to missing since it has no bearing and it should not be interpreted as a higher value 
mvdecode trust_ParPol trust_KommPol trust_VGPol, mv(6)
mvdecode trust_ParPol trust_KommPol trust_VGPol, mv(9)


*reconversion for (1,2) dummies to (0,1) dummies:
recode female 2=0 

*reconversion for (1,2) dummies to (0,1) dummies:
recode unemploy 2=0 
recode pensioner 2=0 

*// 1B. drop all labels for survey files 
*//this is done for consistency to keep problems from arising during the append 

label drop _all

sort kommun year


*------------------------
*save file as: 11WSOMx.dta
*------------------------
cd "H:\tax\data\WSOM\derived"
*cd "/Volumes/YoungBros/tax copy/data/NSOM/derived"

save "11WSOMx", replace


*//-----------------------------------------------------------------------------------------------

clear all
*cd "/Volumes/YoungBros/tax copy/data/NSOM/original"
cd "H:\tax\data\WSOM\original"
set more off

*//Survey year 2010//

*-------------------------
*open file : 10WSOM.dta
*-------------------------

use "10WSOM.dta"

***************************************

gen year=2010

label variable ipnr "Unique Identification number of person surveyed" 

rename F15A rd_public
label variable rd_public "Åsikt om förslag  - Minska den offentliga sektorn"

rename F15K cuttax
label variable cuttax "Åsikt om förslag  - Sänka skatterna"

rename F15I rtax_rserv
label variable rtax_rserv "Åsikt om förslag  - Höja kommunal-/regionskatten hellre än att minska serv"

rename F13 left_right
label variable left_right "Var någonstans skulle du placera dig själv på en sådan vänster–högerskala?"

rename F27B trust_ParPol
label variable trust_ParPol "Allmänt sett, hur stort förtroende har du för det sätt på vilket följande grupper sköter sitt arbete? - Rikspolitiker"

rename F27D trust_KommPol
label variable trust_KommPol "Allmänt sett, hur stort förtroende har du för det sätt på vilket följande grupper sköter sitt arbete? - Kommunens politiker"

rename F27C trust_VGPol
label variable trust_VGPol "Allmänt sett, hur stort förtroende har du för det sätt på vilket följande grupper sköter sitt arbete? - Västra Götalandsregionens politiker"

*for unemploy and pensioner I needed to recode so that I dont create a problem when converting 0 to missing value as done below
rename F61C unemploy
label variable unemploy "Vilken grupp tillhör du för närvarande - Arbetslös"
recode unemploy 0=2 

rename F61D pensioner
label variable pensioner "Vilken grupp tillhör du för närvarande - Ålderspensionär/avtalspensionär"
recode pensioner 0=2

rename alder age
label variable age "age recorded by respondent"

rename koen female
label variable female "gender from registration number"
*female is coded - 1=women 2=men, recode below.

rename F92AA chng_fin
label variable chng_fin "Ekonomiska förhållanden förändrats de senaste 12 månaderna - Din egen eko"

rename F92AB chng_mun
label variable chng_mun "Ekonomiska förhållanden förändrats de senaste 12 månaderna - Ekonomin i d"

rename F92AC chng_swe
label variable chng_swe "Ekonomiska förhållanden förändrats de senaste 12 månaderna - Den svenska"

rename F92BA fut_fin
label variable fut_fin "Uppskattade förändringar i ekonomin de kommande 12 månaderna - Din egen e"

rename F92BB fut_mun
label variable fut_mun "Uppskattade förändringar i ekonomin de kommande 12 månaderna - Ekonomin i"

rename F92BC fut_swe
label variable fut_swe "Uppskattade förändringar i ekonomin de kommande 12 månaderna - Den svensk"

rename F88A home_class
label variable home_class "Vilket alternativ stämmer bäst - Ditt nuvarande hem"

rename F88B home_class2
label variable home_class2 "Vilket alternativ stämmer bäst - Det hem du växte upp i"

label variable indatum "Datum enkäten kom in"

label variable kommun "municipality of residence"

label variable utb "educational attainment"

rename F87 edu
label variable edu "What level of education have you achieved or are currently undergoing?"

rename F86 income_hus
label variable income_hus "total annual income for all people in household before tax" 
recode income_hus 1=1 2=2 3=3 4=4 5=5 6=6 7=7 8=8 9=8

egen ipnr2 = concat(year ipnr)
drop ipnr
rename ipnr2 ipnr
label variable ipnr "Unique Identification number of person surveyed" 

*//

keep year ipnr left_right rd_public rtax_rserv cuttax trust_ParPol trust_KommPol trust_VGPol unemploy pensioner ///
home_class home_class2 chng_fin chng_mun chng_swe fut_fin fut_mun fut_swe female age edu utb kommun indatum income_hus

*//

*/For appending surveys do the following to standardize:

*// 1. Open all files individually and run the following commands to standardize the surveys

/* 1A. Recode all no answers or survey errors (99, 98, 9999, 9997 and 0) to missing values (.)
This is relevant because.. in some cases 0 represented someone not answering 1 question in an entire set of questions
For example multiple questions on opinions on policies or on trust for different instituions, etc
ALSO - some variables like unemploy, pensioner, etc are coded (0,1), so I have to convert them before hand so they wont
be erased */

mvdecode _all, mv(9999)
mvdecode _all, mv(9997)
mvdecode _all, mv(99)
mvdecode _all, mv(98)
mvdecode _all, mv(0)

* value 6 and 9 for these variables was that there was no answer in part of the entire question set
* i will convert this to missing since it has no bearing and it should not be interpreted as a higher value 
mvdecode trust_ParPol trust_KommPol trust_VGPol, mv(6)
mvdecode trust_ParPol trust_KommPol trust_VGPol, mv(9)

*reconversion for (1,2) dummies to (0,1) dummies:
recode female 2=0 

*reconversion for (1,2) dummies to (0,1) dummies:
recode unemploy 2=0 
recode pensioner 2=0 

*// 1B. drop all labels for survey files 
*//this is done for consistency to keep problems from arising during the append 

label drop _all

sort kommun year

*------------------------
*save file as: 10WSOMx.dta
*------------------------
cd "H:\tax\data\WSOM\derived"
*cd "/Volumes/YoungBros/tax copy/data/NSOM/derived"

save "10WSOMx", replace


*//-----------------------------------------------------------------------------------------------

clear all
*cd "/Volumes/YoungBros/tax copy/data/NSOM/original"
cd "H:\tax\data\WSOM\original"
set more off

*//Survey year 2009//

*-------------------------
*open file : 09WSOM.dta
*-------------------------

use "09WSOM.dta"

/*
Because of a change in Stata14, which has problems recognizing Swedish characters
I need to run a special code namely because the word "Kön" is not recognized.
*/

*converts all strings/labels/names in Stata 14 dataset back to an extended ASCII encoding

foreach var of varlist _all {
   local newname = ustrto("`var'", "ISO-8859-10", 1) 
   rename `var' `newname'
}

*Renames all variables that start with K and end with n  
rename K*n Kn 

***************************************



gen year=2009

label variable ipnr "Unique Identification number of person surveyed" 

rename F15 left_right
label variable left_right "Var någonstans skulle du placera dig själv på en sådan vänster–högerskala?"

rename F18A rd_public
label variable rd_public "Åsikt om förslag  - Minska den offentliga sektorn"

rename F18K cuttax
label variable cuttax "Åsikt om förslag  - Sänka skatterna"

rename F18I rtax_rserv
label variable rtax_rserv "Åsikt om förslag  - Höja kommunal-/regionskatten hellre än att minska serv"

rename F29B trust_ParPol
label variable trust_ParPol "Allmänt sett, hur stort förtroende har du för det sätt på vilket följande grupper sköter sitt arbete? - Rikspolitiker"

rename F29D trust_KommPol
label variable trust_KommPol "Allmänt sett, hur stort förtroende har du för det sätt på vilket följande grupper sköter sitt arbete? - Kommunens politiker"

rename F29C trust_VGPol
label variable trust_VGPol "Allmänt sett, hur stort förtroende har du för det sätt på vilket följande grupper sköter sitt arbete? - Västra Götalandsregionens politiker"

*for unemploy and pensioner I needed to recode so that I dont create a problem when converting 0 to missing value as done below
rename F66C unemploy
label variable unemploy "Vilken grupp tillhör du för närvarande - Arbetslös"
recode unemploy 0=2 

rename F66D pensioner
label variable pensioner "Vilken grupp tillhör du för närvarande - Ålderspensionär/avtalspensionär"
recode pensioner 0=2

rename alder age
label variable age "age recorded by respondent"

rename Kn female
label variable female "gender from registration number"
*female is coded - 1=women 2=men, recode later

rename F92AA chng_fin
label variable chng_fin "Ekonomiska förhållanden förändrats de senaste 12 månaderna - Din egen eko"

rename F92AB chng_mun
label variable chng_mun "Ekonomiska förhållanden förändrats de senaste 12 månaderna - Ekonomin i d"

rename F92AC chng_swe
label variable chng_swe "Ekonomiska förhållanden förändrats de senaste 12 månaderna - Den svenska"

rename F92BA fut_fin
label variable fut_fin "Uppskattade förändringar i ekonomin de kommande 12 månaderna - Din egen e"

rename F92BB fut_mun
label variable fut_mun "Uppskattade förändringar i ekonomin de kommande 12 månaderna - Ekonomin i"

rename F92BC fut_swe
label variable fut_swe "Uppskattade förändringar i ekonomin de kommande 12 månaderna - Den svensk"

rename F89A home_class
label variable home_class "Vilket alternativ stämmer bäst - Ditt nuvarande hem"

rename F89B home_class2
label variable home_class2 "Vilket alternativ stämmer bäst - Det hem du växte upp i"

rename Indatum indatum
label variable indatum "Datum enkäten kom in"

label variable kommun "municipality of residence"

label variable utb "educational attainment"

rename F90 edu
label variable edu "What level of education have you achieved or are currently undergoing?"


rename F91 income_hus
label variable income_hus "total annual income for all people in household before tax" 
recode income_hus 1=1 2=2 3=3 4=4 5=5 6=6 7=7 8=8 9=8

egen ipnr2 = concat(year ipnr)
drop ipnr
rename ipnr2 ipnr
label variable ipnr "Unique Identification number of person surveyed" 

*//

keep year ipnr left_right rd_public rtax_rserv cuttax trust_ParPol trust_KommPol trust_VGPol unemploy pensioner ///
home_class home_class2 chng_fin chng_mun chng_swe fut_fin fut_mun fut_swe female age edu utb kommun indatum income_hus

*//

*/For appending surveys do the following to standardize:

*// 1. Open all files individually and run the following commands to standardize the surveys

/* 1A. Recode all no answers or survey errors (99, 98, 9999, 9997 and 0) to missing values (.)
This is relevant because.. in some cases 0 represented someone not answering 1 question in an entire set of questions
For example multiple questions on opinions on policies or on trust for different instituions, etc
ALSO - some variables like unemploy, pensioner, etc are coded (0,1), so I have to convert them before hand so they wont
be erased */

mvdecode _all, mv(9999)
mvdecode _all, mv(9997)
mvdecode _all, mv(99)
mvdecode _all, mv(98)
mvdecode _all, mv(0)

* value 6 and 9 for these variables was that there was no answer in part of the entire question set
* i will convert this to missing since it has no bearing and it should not be interpreted as a higher value 
mvdecode trust_ParPol trust_KommPol trust_VGPol, mv(6)
mvdecode trust_ParPol trust_KommPol trust_VGPol, mv(9)

*reconversion for (1,2) dummies to (0,1) dummies:
recode female 2=0 

*reconversion for (1,2) dummies to (0,1) dummies:
recode unemploy 2=0 
recode pensioner 2=0 

*// 1B. drop all labels for survey files 
*//this is done for consistency to keep problems from arising during the append 

label drop _all

sort kommun year

*------------------------
*save file as: 09WSOMx.dta
*------------------------
cd "H:\tax\data\WSOM\derived"
*cd "/Volumes/YoungBros/tax copy/data/NSOM/derived"

save "09WSOMx", replace


*//-----------------------------------------------------------------------------------------------

clear all
*cd "/Volumes/YoungBros/tax copy/data/NSOM/original"
cd "H:\tax\data\WSOM\original"
set more off


*//Survey year 2008//

*-------------------------
*open file : 08WSOM.dta
*-------------------------

use "08WSOM.dta"

/*
Because of a change in Stata14, which has problems recognizing Swedish characters
I need to run a special code namely because the word "Kön" is not recognized.
*/

*converts all strings/labels/names in Stata 14 dataset back to an extended ASCII encoding

foreach var of varlist _all {
   local newname = ustrto("`var'", "ISO-8859-10", 1) 
   rename `var' `newname'
}

rename K*n Kn

***************************************


gen year=2008

label variable ipnr "Unique Identification number of person surveyed" 

rename F12 left_right
label variable left_right "Var någonstans skulle du placera dig själv på en sådan vänster–högerskala?"

rename F15A rd_public
label variable rd_public "Åsikt om förslag  - Minska den offentliga sektorn"

rename F15J cuttax
label variable cuttax "Åsikt om förslag  - Sänka skatterna"

rename F15I rtax_rserv
label variable rtax_rserv "Åsikt om förslag  - Höja kommunal-/regionskatten hellre än att minska serv"

rename F32B trust_ParPol
label variable trust_ParPol "Allmänt sett, hur stort förtroende har du för det sätt på vilket följande grupper sköter sitt arbete? - Rikspolitiker"

rename F32D trust_KommPol
label variable trust_KommPol "Allmänt sett, hur stort förtroende har du för det sätt på vilket följande grupper sköter sitt arbete? - Kommunens politiker"

rename F32C trust_VGPol
label variable trust_VGPol "Allmänt sett, hur stort förtroende har du för det sätt på vilket följande grupper sköter sitt arbete? - Västra Götalandsregionens politiker"

*for unemploy and pensioner I needed to recode so that I dont create a problem when converting 0 to missing value as done below
rename F70C unemploy
label variable unemploy "Vilken grupp tillhör du för närvarande - Arbetslös"
recode unemploy 0=2 

rename F70D pensioner
label variable pensioner "Vilken grupp tillhör du för närvarande - Ålderspensionär/avtalspensionär"
recode pensioner 0=2

rename alder age
label variable age "age recorded by respondent"

rename Kn female
label variable female "gender from registration number"
*female is coded - 1=women 2=men, recode below.

rename F96AA chng_fin
label variable chng_fin "Ekonomiska förhållanden förändrats de senaste 12 månaderna - Din egen eko"

rename F96AB chng_mun
label variable chng_mun "Ekonomiska förhållanden förändrats de senaste 12 månaderna - Ekonomin i d"

rename F96AC chng_swe
label variable chng_swe "Ekonomiska förhållanden förändrats de senaste 12 månaderna - Den svenska"

rename F96BA fut_fin
label variable fut_fin "Uppskattade förändringar i ekonomin de kommande 12 månaderna - Din egen e"

rename F96BB fut_mun
label variable fut_mun "Uppskattade förändringar i ekonomin de kommande 12 månaderna - Ekonomin i"

rename F96BC fut_swe
label variable fut_swe "Uppskattade förändringar i ekonomin de kommande 12 månaderna - Den svensk"

rename F93A home_class
label variable home_class "Vilket alternativ stämmer bäst - Ditt nuvarande hem"

rename F93B home_class2
label variable home_class2 "Vilket alternativ stämmer bäst - Det hem du växte upp i"

rename Indatum indatum
label variable indatum "Datum enkäten kom in"

label variable kommun "municipality of residence"

rename F94 edu
label variable edu "What level of education have you achieved or are currently undergoing?"

rename Utb utb
label variable utb "educational attainment"

rename F95 income_hus
label variable income_hus "total annual income for all people in household before tax" 

recode income_hus 1=1 2=2 3=3 4=4 5=5 6=6 7=7 8=8 9=8

egen ipnr2 = concat(year ipnr)
drop ipnr
rename ipnr2 ipnr
label variable ipnr "Unique Identification number of person surveyed" 

*//

keep year ipnr left_right rd_public rtax_rserv cuttax trust_ParPol trust_KommPol trust_VGPol unemploy pensioner ///
home_class home_class2 chng_fin chng_mun chng_swe fut_fin fut_mun fut_swe female age edu utb kommun indatum income_hus

*//


*/For appending surveys do the following to standardize:

*// 1. Open all files individually and run the following commands to standardize the surveys

/* 1A. Recode all no answers or survey errors (99, 98, 9999, 9997 and 0) to missing values (.)
This is relevant because.. in some cases 0 represented someone not answering 1 question in an entire set of questions
For example multiple questions on opinions on policies or on trust for different instituions, etc
ALSO - some variables like unemploy, pensioner, etc are coded (0,1), so I have to convert them before hand so they wont
be erased */

mvdecode _all, mv(9999)
mvdecode _all, mv(9997)
mvdecode _all, mv(99)
mvdecode _all, mv(98)
mvdecode _all, mv(0)

* value 6 and 9 for these variables was that there was no answer in part of the entire question set
* i will convert this to missing since it has no bearing and it should not be interpreted as a higher value 
mvdecode trust_ParPol trust_KommPol trust_VGPol, mv(6)
mvdecode trust_ParPol trust_KommPol trust_VGPol, mv(9)

*reconversion for (1,2) dummies to (0,1) dummies:
recode female 2=0 

*reconversion for (1,2) dummies to (0,1) dummies:
recode unemploy 2=0 
recode pensioner 2=0 

*// 1B. drop all labels for survey files 
*//this is done for consistency to keep problems from arising during the append 

label drop _all

sort kommun year


*------------------------
*save file as: 08WSOMx.dta
*------------------------
cd "H:\tax\data\WSOM\derived"
*cd "/Volumes/YoungBros/tax copy/data/NSOM/derived"

save "08WSOMx", replace

*//-----------------------------------------------------------------------------------------------

clear all
*cd "/Volumes/YoungBros/tax copy/data/NSOM/original"
cd "H:\tax\data\WSOM\original"
set more off


//Survey year 2007//

*-------------------------
*open file : 07WSOM.dta
*-------------------------

use "07WSOM.dta"

/*
Because of a change in Stata14, which has problems recognizing Swedish characters
I need to run a special code namely because the word "Kön" is not recognized.
*/

*converts all strings/labels/names in Stata 14 dataset back to an extended ASCII encoding

foreach var of varlist _all {
   local newname = ustrto("`var'", "ISO-8859-10", 1) 
   rename `var' `newname'
}

rename K*n Kn

***************************************


gen year=2007

label variable ipnr "Unique Identification number of person surveyed" 

rename F14 left_right
label variable left_right "Var någonstans skulle du placera dig själv på en sådan vänster–högerskala?"

rename F20a rd_public
label variable rd_public "Åsikt om förslag  - Minska den offentliga sektorn"

rename F20i cuttax
label variable cuttax "Åsikt om förslag  - Sänka skatterna"

rename F20j rtax_rserv
label variable rtax_rserv "Åsikt om förslag  - Höja kommunal-/regionskatten hellre än att minska serv"

rename F30b trust_ParPol
label variable trust_ParPol "Allmänt sett, hur stort förtroende har du för det sätt på vilket följande grupper sköter sitt arbete? - Rikspolitiker"

rename F30d trust_KommPol
label variable trust_KommPol "Allmänt sett, hur stort förtroende har du för det sätt på vilket följande grupper sköter sitt arbete? - Kommunens politiker"

rename F30c trust_VGPol
label variable trust_VGPol "Allmänt sett, hur stort förtroende har du för det sätt på vilket följande grupper sköter sitt arbete? - Västra Götalandsregionens politiker"

*for unemploy and pensioner I needed to recode so that I dont create a problem when converting 0 to missing value as done below
rename F79d unemploy
label variable unemploy "Vilken grupp tillhör du för närvarande - Arbetslös"
recode unemploy 0=2 

rename F79e pensioner
label variable pensioner "Vilken grupp tillhör du för närvarande - Ålderspensionär/avtalspensionär"
recode pensioner 0=2

rename alder age
label variable age "age recorded by respondent"

rename Kn female
label variable female "gender from registration number"
*female is coded - 1=women 2=men, recode below.

rename F105aa chng_fin
label variable chng_fin "Ekonomiska förhållanden förändrats de senaste 12 månaderna - Din egen eko"

rename F105ab chng_mun
label variable chng_mun "Ekonomiska förhållanden förändrats de senaste 12 månaderna - Ekonomin i d"

rename F105ac chng_swe
label variable chng_swe "Ekonomiska förhållanden förändrats de senaste 12 månaderna - Den svenska"

rename F105ba fut_fin
label variable fut_fin "Uppskattade förändringar i ekonomin de kommande 12 månaderna - Din egen e"

rename F105bb fut_mun
label variable fut_mun "Uppskattade förändringar i ekonomin de kommande 12 månaderna - Ekonomin i"

rename F105bc fut_swe
label variable fut_swe "Uppskattade förändringar i ekonomin de kommande 12 månaderna - Den svensk"

rename F95a home_class
label variable home_class "Vilket alternativ stämmer bäst - Ditt nuvarande hem"

rename F95b home_class2
label variable home_class2 "Vilket alternativ stämmer bäst - Det hem du växte upp i"

label variable kommun "municipality of residence"

rename F102 edu
label variable edu "What level of education have you achieved or are currently undergoing?"

label variable utb "educational attainment"

egen ipnr2 = concat(year ipnr)
drop ipnr
rename ipnr2 ipnr
label variable ipnr "Unique Identification number of person surveyed" 

rename F103 income_hus
label variable income_hus "total annual income for all people in household before tax" 
* no need to recode income_hus

*//indatum variable doesn't exist, create blank one//

gen indatum=.

keep year ipnr left_right rd_public rtax_rserv cuttax trust_ParPol trust_KommPol trust_VGPol unemploy pensioner ///
home_class home_class2 chng_fin chng_mun chng_swe fut_fin fut_mun fut_swe female age edu utb kommun indatum income_hus

*//

*/For appending surveys do the following to standardize:

*// 1. Open all files individually and run the following commands to standardize the surveys

/* 1A. Recode all no answers or survey errors (99, 98, 9999, 9997 and 0) to missing values (.)
This is relevant because.. in some cases 0 represented someone not answering 1 question in an entire set of questions
For example multiple questions on opinions on policies or on trust for different instituions, etc
ALSO - some variables like unemploy, pensioner, etc are coded (0,1), so I have to convert them before hand so they wont
be erased */

mvdecode _all, mv(9999)
mvdecode _all, mv(9997)
mvdecode _all, mv(99)
mvdecode _all, mv(98)
mvdecode _all, mv(0)

* value 6 and 9 for these variables was that there was no answer in part of the entire question set
* i will convert this to missing since it has no bearing and it should not be interpreted as a higher value 
mvdecode trust_ParPol trust_KommPol trust_VGPol, mv(6)
mvdecode trust_ParPol trust_KommPol trust_VGPol, mv(9)

*reconversion for (1,2) dummies to (0,1) dummies:
recode female 2=0 

*reconversion for (1,2) dummies to (0,1) dummies:
recode unemploy 2=0 
recode pensioner 2=0 

*// 1B. drop all labels for survey files 
*//this is done for consistency to keep problems from arising during the append 

label drop _all

sort kommun year


*------------------------
*save file as: 07WSOMx.dta
*------------------------
cd "H:\tax\data\WSOM\derived"
*cd "/Volumes/YoungBros/tax copy/data/NSOM/derived"

save "07WSOMx", replace


*//-----------------------------------------------------------------------------------------------

clear all
*cd "/Volumes/YoungBros/tax copy/data/NSOM/original"
cd "H:\tax\data\WSOM\original"
set more off


*//Survey year 2006//

*-------------------------
*open file : 06WSOM.dta
*-------------------------

use "06WSOM.dta"

***************************************


gen year=2006

label variable ipnr "Unique Identification number of person surveyed" 

rename F15 left_right
label variable left_right "Var någonstans skulle du placera dig själv på en sådan vänster–högerskala?"

rename F25a rd_public
label variable rd_public "Åsikt om förslag  - Minska den offentliga sektorn"

rename F25h cuttax
label variable cuttax "Åsikt om förslag  - Sänka skatterna"

rename F25i rtax_rserv
label variable rtax_rserv "Åsikt om förslag  - Höja kommunal-/regionskatten hellre än att minska serv"

rename F32b trust_ParPol
label variable trust_ParPol "Allmänt sett, hur stort förtroende har du för det sätt på vilket följande grupper sköter sitt arbete? - Rikspolitiker"

rename F32c trust_KommPol
label variable trust_KommPol "Allmänt sett, hur stort förtroende har du för det sätt på vilket följande grupper sköter sitt arbete? - Kommunens politiker"

rename F32d trust_VGPol
label variable trust_VGPol "Allmänt sett, hur stort förtroende har du för det sätt på vilket följande grupper sköter sitt arbete? - Västra Götalandsregionens politiker"

*for unemploy and pensioner I needed to recode so that I dont create a problem when converting 0 to missing value as done below
rename F76d unemploy
label variable unemploy "Vilken grupp tillhör du för närvarande - Arbetslös"
recode unemploy 0=2 

rename F76e pensioner
label variable pensioner "Vilken grupp tillhör du för närvarande - Ålderspensionär/avtalspensionär"
recode pensioner 0=2

rename alder age
label variable age "age recorded by respondent"

rename koen female
label variable female "gender from registration number"
*female is coded - 1=women 2=men, recode later

rename F104aa chng_fin
label variable chng_fin "Ekonomiska förhållanden förändrats de senaste 12 månaderna - Din egen eko"

rename F104ab chng_mun
label variable chng_mun "Ekonomiska förhållanden förändrats de senaste 12 månaderna - Ekonomin i d"

rename F104ac chng_swe
label variable chng_swe "Ekonomiska förhållanden förändrats de senaste 12 månaderna - Den svenska"

rename F104ba fut_fin
label variable fut_fin "Uppskattade förändringar i ekonomin de kommande 12 månaderna - Din egen e"

rename F104bb fut_mun
label variable fut_mun "Uppskattade förändringar i ekonomin de kommande 12 månaderna - Ekonomin i"

rename F104bc fut_swe
label variable fut_swe "Uppskattade förändringar i ekonomin de kommande 12 månaderna - Den svensk"

rename F93a home_class
label variable home_class "Vilket alternativ stämmer bäst - Ditt nuvarande hem"

rename F93b home_class2
label variable home_class2 "Vilket alternativ stämmer bäst - Det hem du växte upp i"

rename F95 edu
label variable edu "What level of education have you achieved or are currently undergoing?"

label variable indatum "Datum enkäten kom in"
destring indatum, replace

label variable kommun "municipality of residence"

label variable utb "educational attainment"

egen ipnr2 = concat(year ipnr)
drop ipnr
rename ipnr2 ipnr
label variable ipnr "Unique Identification number of person surveyed" 

rename F96 income_hus
label variable income_hus "total annual income for all people in household before tax" 
* no need to recode income_hus since it contains only 8 levels


keep year ipnr left_right rd_public rtax_rserv cuttax trust_ParPol trust_KommPol trust_VGPol unemploy pensioner ///
home_class home_class2 chng_fin chng_mun chng_swe fut_fin fut_mun fut_swe female age edu utb kommun indatum income_hus

*//

*/For appending surveys do the following to standardize:

*// 1. Open all files individually and run the following commands to standardize the surveys

/* 1A. Recode all no answers or survey errors (99, 98, 9999, 9997 and 0) to missing values (.)
This is relevant because.. in some cases 0 represented someone not answering 1 question in an entire set of questions
For example multiple questions on opinions on policies or on trust for different instituions, etc
ALSO - some variables like unemploy, pensioner, etc are coded (0,1), so I have to convert them before hand so they wont
be erased */

mvdecode _all, mv(9999)
mvdecode _all, mv(9997)
mvdecode _all, mv(99)
mvdecode _all, mv(98)
mvdecode _all, mv(0)

* value 6 and 9 for these variables was that there was no answer in part of the entire question set
* i will convert this to missing since it has no bearing and it should not be interpreted as a higher value 
mvdecode trust_ParPol trust_KommPol trust_VGPol, mv(6)
mvdecode trust_ParPol trust_KommPol trust_VGPol, mv(9)

*reconversion for (1,2) dummies to (0,1) dummies:
recode female 2=0 

*reconversion for (1,2) dummies to (0,1) dummies:
recode unemploy 2=0 
recode pensioner 2=0 

*// 1B. drop all labels for survey files 
*//this is done for consistency to keep problems from arising during the append 

label drop _all

sort kommun year

*------------------------
*save file as: 06WSOMx.dta
*------------------------
cd "H:\tax\data\WSOM\derived"
*cd "/Volumes/YoungBros/tax copy/data/NSOM/derived"

save "06WSOMx", replace


*//-----------------------------------------------------------------------------------------------


clear all
*cd "/Volumes/YoungBros/tax copy/data/NSOM/original"
cd "H:\tax\data\WSOM\original"
set more off

*//Survey year 2005//

*-------------------------
*open file : 05WSOM.dta
*-------------------------

use "05WSOM.dta"

***************************************


gen year=2005

label variable ipnr "Unique Identification number of person surveyed" 

rename F19 left_right
label variable left_right "Var någonstans skulle du placera dig själv på en sådan vänster–högerskala?"

rename F38a rd_public
label variable rd_public "Åsikt om förslag  - Minska den offentliga sektorn"

rename F38i cuttax
label variable cuttax "Åsikt om förslag  - Sänka skatterna"

rename F38k rtax_rserv
label variable rtax_rserv "Åsikt om förslag  - Höja kommunal-/regionskatten hellre än att minska serv"

rename F33b trust_ParPol
label variable trust_ParPol "Allmänt sett, hur stort förtroende har du för det sätt på vilket följande grupper sköter sitt arbete? - Rikspolitiker"

rename F33c trust_KommPol
label variable trust_KommPol "Allmänt sett, hur stort förtroende har du för det sätt på vilket följande grupper sköter sitt arbete? - Kommunens politiker"

rename F33d trust_VGPol
label variable trust_VGPol "Allmänt sett, hur stort förtroende har du för det sätt på vilket följande grupper sköter sitt arbete? - Västra Götalandsregionens politiker"


*odd variable construction this year for UE and pensioner status, need to generate new variable
rename F102 laborstatus
label variable laborstatus "Vilken av de har grupperns tillhör du för närvarande?"

*for unemploy and pensioner I needed to recode so that I dont create a problem when converting 0 to missing value as done below
gen unemploy = 2 
replace unemploy = 1 if laborstatus == 4

gen pensioner = 2 
replace pensioner = 1 if laborstatus == 5

*browse kommun laborstatus unemploy pensioner

rename alder age
label variable age "age recorded by respondent"

rename koen female
label variable female "gender from registration number"
*female is coded - 1=women 2=men, recode later

rename F112aa chng_fin
label variable chng_fin "Ekonomiska förhållanden förändrats de senaste 12 månaderna - Din egen eko"

rename F112ab chng_mun
label variable chng_mun "Ekonomiska förhållanden förändrats de senaste 12 månaderna - Ekonomin i d"

rename F112ac chng_swe
label variable chng_swe "Ekonomiska förhållanden förändrats de senaste 12 månaderna - Den svenska"

rename F112ba fut_fin
label variable fut_fin "Uppskattade förändringar i ekonomin de kommande 12 månaderna - Din egen e"

rename F112bb fut_mun
label variable fut_mun "Uppskattade förändringar i ekonomin de kommande 12 månaderna - Ekonomin i"

rename F112bc fut_swe
label variable fut_swe "Uppskattade förändringar i ekonomin de kommande 12 månaderna - Den svensk"

rename F106a home_class
label variable home_class "Vilket alternativ stämmer bäst - Ditt nuvarande hem"

rename F106b home_class2
label variable home_class2 "Vilket alternativ stämmer bäst - Det hem du växte upp i"

rename Indatum indatum
label variable indatum "Datum enkäten kom in"
destring indatum, replace

label variable kommun "municipality of residence"

rename F103 edu
label variable edu "What level of education have you achieved or are currently undergoing?"

label variable utb "educational attainment"

egen ipnr2 = concat(year ipnr)
drop ipnr
rename ipnr2 ipnr
label variable ipnr "Unique Identification number of person surveyed" 

rename F108 income_hus
label variable income_hus "total annual income for all people in household before tax" 
* no need to recode income_hus since it contains only 8 levels


keep year ipnr left_right rd_public rtax_rserv cuttax trust_ParPol trust_KommPol trust_VGPol unemploy pensioner ///
home_class home_class2 chng_fin chng_mun chng_swe fut_fin fut_mun fut_swe female age edu utb kommun indatum income_hus

*//

*/For appending surveys do the following to standardize:

*// 1. Open all files individually and run the following commands to standardize the surveys

/* 1A. Recode all no answers or survey errors (99, 98, 9999, 9997 and 0) to missing values (.)
This is relevant because.. in some cases 0 represented someone not answering 1 question in an entire set of questions
For example multiple questions on opinions on policies or on trust for different instituions, etc
ALSO - some variables like unemploy, pensioner, etc are coded (0,1), so I have to convert them before hand so they wont
be erased */


mvdecode _all, mv(9999)
mvdecode _all, mv(9997)
mvdecode _all, mv(99)
mvdecode _all, mv(98)
mvdecode _all, mv(0)

* value 6 and 9 for these variables was that there was no answer in part of the entire question set
* i will convert this to missing since it has no bearing and it should not be interpreted as a higher value 
mvdecode trust_ParPol trust_KommPol trust_VGPol, mv(6)
mvdecode trust_ParPol trust_KommPol trust_VGPol, mv(9)

*reconversion for (1,2) dummies to (0,1) dummies:
recode female 2=0 

*reconversion for (1,2) dummies to (0,1) dummies:
recode unemploy 2=0 
recode pensioner 2=0 


*// 1B. drop all labels for survey files 
*//this is done for consistency to keep problems from arising during the append 

label drop _all

sort kommun year

*------------------------
*save file as: 05WSOMx.dta
*------------------------
cd "H:\tax\data\WSOM\derived"
*cd "/Volumes/YoungBros/tax copy/data/NSOM/derived"

save "05WSOMx", replace

