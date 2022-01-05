//Western SOM 2005 - 2010 recode//

*year 2011 is excluded since one of the questions on taxation is not available.


//Survey year 2010//

clear all
cd "/Users/youngster/Documents/GitHub/tax_project/data/original"
set more off

*-------------------------
*open file : 10WSOM.dta
*-------------------------
use "10WSOM.dta"

***************************************

gen year=2010

/* for the purposes of knowing the wording of each question I am labeling them below.
I will not label them for subsequent data sets
*/

rename F15A rd_public
label variable rd_public "What is your opinion about reducing the public sector?"

rename F15K cuttax
label variable cuttax "What is your opinion about cutting taxes?"

rename F15I rtax_rserv
label variable rtax_rserv "What is your opinion about raising municipal/regional taxes rather than reducing services?"

rename F13 left_right
label variable left_right "Where would you place yourself on the left-to-right political scale?"

/*for the variables unemploy and pensioner I needed to recode so that I dont cause a problem
when converting 0 to a missing value as done below. Originally unemploy is coded as
1 - unemployed, and 0 - not checked/answered. *see note at end of section for more detail.
*/

rename F61C unemploy
label variable unemploy "Are you unemployed?"
recode unemploy 0=2

rename F61D pensioner
label variable pensioner "Are you a pensioner/retired?"
recode pensioner 0=2

rename F86 income_hus
label variable income_hus "total annual income for all people in household before taxes"
recode income_hus 1=1 2=2 3=3 4=4 5=5 6=6 7=7 8=8 9=8 //see details in "WSOM Survey key" on why I recoded this variable.

rename F87 edu
label variable edu "What level of education have you achieved or are currently undergoing?"

rename F88A home_class
label variable home_class "If you had to describe your current home, which of the following occupational classes best describes it?"

rename F88B home_class2
label variable home_class2 "If you had to describe the home you grew up in, which of the following occupational classes best describes it?"

rename F92AA chng_fin
label variable chng_fin "In your opinion how have the following economic conditions changed over the past 12 months: Your own financial situation?"

rename F92AB chng_mun
label variable chng_mun "In your opinion how have the following economic conditions changed over the past 12 months: Economy in your municipality?"

rename F92AC chng_swe
label variable chng_swe "In your opinion how have the following economic conditions changed over the past 12 months: The Swedish economy?"

rename F92BA fut_fin
label variable fut_fin "In your opinion how do you think the economy will change over the next 12 months: Your own financial situation?"

rename F92BB fut_mun
label variable fut_mun "In your opinion how do you think the economy will change over the next 12 months: Economy in your municipality?"

rename F92BC fut_swe
label variable fut_swe "In your opinion how how do you think the economy will change over the next 12 months: The Swedish economy?"

/*
shorten ipnr number. Only done for year 2010 since the number is too long and
when i perform a concat to designate year it shortens the number and unique values
are lost. hence the code below:
*/
tostring ipnr, replace
gen ipnr2 = regexs(2)+regexs(4) if(regexm(ipnr, "(([0-9][0-9])([0-9][0-9])([0-9][0-9][0-9][0-9]))"))
destring ipnr2, replace
drop ipnr
rename ipnr2 ipnr
label variable ipnr "Unique Identification number of person surveyed"


rename alder age
label variable age "age recorded by respondent"

rename koen female
label variable female "gender from registration number"
//female is coded as 1=women 2=men, recode after removal of missing values.

label variable indatum "Date the survey was received"

rename kommun mun_number
label variable mun_number "municipality of residence"

label variable utb "educational attainment" //this variable is derived from edu


//keep only relevant variables.
keep year ipnr left_right rd_public rtax_rserv cuttax unemploy pensioner ///
home_class home_class2 chng_fin chng_mun chng_swe fut_fin fut_mun fut_swe female age edu utb mun_number indatum income_hus


/*To accurately append surveys across years I must standardize the variable measures created by the SOM survey.

Recode all no answers or survey errors (99, 98, 9999, 9997 and 0) to missing values (.)
This is relevant because.. in some cases 0 represented someone not answering 1 question in an entire set of questions
For example multiple questions on opinions on policies or on trust for different instituions, etc
ALSO - some variables like unemploy, pensioner, etc are coded (0,1), so I needed to recode them earlier (above) so they are
not erased */

mvdecode _all, mv(9999)
mvdecode _all, mv(9997)
mvdecode _all, mv(99)
mvdecode _all, mv(98)
mvdecode _all, mv(0)


//reconversion for (1,2) dummies to (0,1) dummies:
recode female 2=0

//reconversion for (1,2) dummies to (0,1) dummies:
recode unemploy 2=0
recode pensioner 2=0

//Drop all labels for survey files
//this is done for consistency to keep problems from arising when appending the annual datasets
label drop _all

//Sort data by municipality and year for appending
sort mun_number year

*------------------------
*save file as: 10WSOMx.dta under derived folder
*------------------------

cd "/Users/youngster/Documents/GitHub/tax_project/data/derived"

save "10WSOMx", replace


//-----------------------------------------------------------------------------------------------

//Survey year 2009//

clear all
cd "/Users/youngster/Documents/GitHub/tax_project/data/original"
set more off

*-------------------------
*open file : 09WSOM.dta
*-------------------------

use "09WSOM.dta"

/*
Because of a change in Stata14, which has problems recognizing Swedish characters
I need to run a special code namely because the word "Kön" is not recognized.
converts all strings/labels/names in Stata 14 dataset back to an extended ASCII encoding
*/

foreach var of varlist _all {
   local newname = ustrto("`var'", "ISO-8859-10", 1)
   rename `var' `newname'
}

//Renames all variables that start with K and end with n
rename K*n Kn

***************************************

gen year=2009

rename F15 left_right

rename F18A rd_public

rename F18K cuttax

rename F18I rtax_rserv

*for unemploy and pensioner I needed to recode so that I dont create a problem when converting 0 to missing value as done below
rename F66C unemploy
recode unemploy 0=2

rename F66D pensioner
recode pensioner 0=2

rename F89A home_class

rename F89B home_class2

rename F91 income_hus
recode income_hus 1=1 2=2 3=3 4=4 5=5 6=6 7=7 8=8 9=8 //see details in "WSOM Survey key" on why I recoded this variable.

rename F92AA chng_fin

rename F92AB chng_mun

rename F92AC chng_swe

rename F92BA fut_fin

rename F92BB fut_mun

rename F92BC fut_swe

rename kommun mun_number


egen ipnr2 = concat(year ipnr)  //add survey year to beginning of unique identifier
drop ipnr
rename ipnr2 ipnr
destring ipnr, replace

rename Indatum indatum

rename F90 edu

rename alder age

rename Kn female
//female is coded - 1=women 2=men, recode later

//keep only relevant variables.
keep year ipnr left_right rd_public rtax_rserv cuttax unemploy pensioner ///
home_class home_class2 chng_fin chng_mun chng_swe fut_fin fut_mun fut_swe female age edu utb mun_number indatum income_hus

/*To accurately append surveys across years I must standardize the variable measures created by the SOM survey.

Recode all no answers or survey errors (99, 98, 9999, 9997 and 0) to missing values (.)
This is relevant because.. in some cases 0 represented someone not answering 1 question in an entire set of questions
For example multiple questions on opinions on policies or on trust for different instituions, etc
ALSO - some variables like unemploy, pensioner, etc are coded (0,1), so I needed to recode them earlier (above) so they are
not erased */

mvdecode _all, mv(9999)
mvdecode _all, mv(9997)
mvdecode _all, mv(99)
mvdecode _all, mv(98)
mvdecode _all, mv(0)


//reconversion for (1,2) dummies to (0,1) dummies:
recode female 2=0

//reconversion for (1,2) dummies to (0,1) dummies:
recode unemploy 2=0
recode pensioner 2=0

//Drop all labels for survey files
//this is done for consistency to keep problems from arising when appending the annual datasets
label drop _all

//Sort data by municipality and year for appending
sort mun_number year

*------------------------
*save file as: 09WSOMx.dta under derived folder
*------------------------


cd "/Users/youngster/Documents/GitHub/tax_project/data/derived"

save "09WSOMx", replace


//-----------------------------------------------------------------------------------------------

//Survey year 2008//

clear all
cd "/Users/youngster/Documents/GitHub/tax_project/data/original"
set more off

*-------------------------
*open file : 08WSOM.dta
*-------------------------
use "08WSOM.dta"

/*
Because of a change in Stata14, which has problems recognizing Swedish characters
I need to run a special code namely because the word "Kön" is not recognized.
*/

//converts all strings/labels/names in Stata 14 dataset back to an extended ASCII encoding

foreach var of varlist _all {
   local newname = ustrto("`var'", "ISO-8859-10", 1)
   rename `var' `newname'
}

rename K*n Kn

***************************************


gen year=2008

rename F12 left_right

rename F15A rd_public

rename F15J cuttax

rename F15I rtax_rserv

//for unemploy and pensioner I needed to recode so that I dont create a problem when converting 0 to missing value as done below
rename F70C unemploy
recode unemploy 0=2

rename F70D pensioner
recode pensioner 0=2

rename F93A home_class

rename F93B home_class2

rename F94 edu

rename F95 income_hus
recode income_hus 1=1 2=2 3=3 4=4 5=5 6=6 7=7 8=8 9=8

rename F96AA chng_fin

rename F96AB chng_mun

rename F96AC chng_swe

rename F96BA fut_fin

rename F96BB fut_mun

rename F96BC fut_swe

rename kommun mun_number

rename Indatum indatum

egen ipnr2 = concat(year ipnr)
drop ipnr
rename ipnr2 ipnr
destring ipnr, replace
label variable ipnr

rename alder age

rename Kn female
//female is coded - 1=women 2=men, recode below.

rename Utb utb

//keep only relevant variables.
keep year ipnr left_right rd_public rtax_rserv cuttax unemploy pensioner ///
home_class home_class2 chng_fin chng_mun chng_swe fut_fin fut_mun fut_swe female age edu utb mun_number indatum income_hus

/*To accurately append surveys across years I must standardize the variable measures created by the SOM survey.

Recode all no answers or survey errors (99, 98, 9999, 9997 and 0) to missing values (.)
This is relevant because.. in some cases 0 represented someone not answering 1 question in an entire set of questions
For example multiple questions on opinions on policies or on trust for different instituions, etc
ALSO - some variables like unemploy, pensioner, etc are coded (0,1), so I needed to recode them earlier (above) so they are
not erased */

mvdecode _all, mv(9999)
mvdecode _all, mv(9997)
mvdecode _all, mv(99)
mvdecode _all, mv(98)
mvdecode _all, mv(0)

//reconversion for (1,2) dummies to (0,1) dummies:
recode female 2=0

//reconversion for (1,2) dummies to (0,1) dummies:
recode unemploy 2=0
recode pensioner 2=0

//Drop all labels for survey files
//this is done for consistency to keep problems from arising when appending the annual datasets
label drop _all

//Sort data by municipality and year for appending
sort mun_number year


*------------------------
*save file as: 08WSOMx.dta under derived folder
*------------------------


cd "/Users/youngster/Documents/GitHub/tax_project/data/derived"

save "08WSOMx", replace

//-----------------------------------------------------------------------------------------------


//Survey year 2007//

clear all
cd "/Users/youngster/Documents/GitHub/tax_project/data/original"
set more off

*-------------------------
*open file : 07WSOM.dta
*-------------------------

use "07WSOM.dta"

/*
Because of a change in Stata14, which has problems recognizing Swedish characters
I need to run a special code namely because the word "Kön" is not recognized.
*/

//female is coded - 1=women 2=men, recode below.converts all strings/labels/names in Stata 14 dataset back to an extended ASCII encoding

foreach var of varlist _all {
   local newname = ustrto("`var'", "ISO-8859-10", 1)
   rename `var' `newname'
}

rename K*n Kn

***************************************

gen year=2007

rename F14 left_right

rename F20a rd_public

rename F20i cuttax

rename F20j rtax_rserv

//for unemploy and pensioner I needed to recode so that I dont create a problem when converting 0 to missing value as done below
rename F79d unemploy
recode unemploy 0=2

rename F79e pensioner
recode pensioner 0=2

rename F95a home_class

rename F95b home_class2

rename F102 edu

rename F103 income_hus
//no need to recode income_hus

rename F105aa chng_fin

rename F105ab chng_mun

rename F105ac chng_swe

rename F105ba fut_fin

rename F105bb fut_mun

rename F105bc fut_swe

rename kommun mun_number


egen ipnr2 = concat(year ipnr)
drop ipnr
rename ipnr2 ipnr
destring ipnr, replace

rename alder age

//female is coded - 1=women 2=men, recode below.
rename Kn female

//indatum variable doesn't exist, create blank one//
gen indatum=.

//keep only relevant variables.
keep year ipnr left_right rd_public rtax_rserv cuttax unemploy pensioner ///
home_class home_class2 chng_fin chng_mun chng_swe fut_fin fut_mun fut_swe female age edu utb mun_number indatum income_hus


/*To accurately append surveys across years I must standardize the variable measures created by the SOM survey.

Recode all no answers or survey errors (99, 98, 9999, 9997 and 0) to missing values (.)
This is relevant because.. in some cases 0 represented someone not answering 1 question in an entire set of questions
For example multiple questions on opinions on policies or on trust for different instituions, etc
ALSO - some variables like unemploy, pensioner, etc are coded (0,1), so I needed to recode them earlier (above) so they are
not erased */

mvdecode _all, mv(9999)
mvdecode _all, mv(9997)
mvdecode _all, mv(99)
mvdecode _all, mv(98)
mvdecode _all, mv(0)


//reconversion for (1,2) dummies to (0,1) dummies:
recode female 2=0

//reconversion for (1,2) dummies to (0,1) dummies:
recode unemploy 2=0
recode pensioner 2=0

//Drop all labels for survey files
//this is done for consistency to keep problems from arising when appending the annual datasets
label drop _all

//Sort data by municipality and year for appending
sort mun_number year


*------------------------
*save file as: 07WSOMx.dta under derived folder
*------------------------


cd "/Users/youngster/Documents/GitHub/tax_project/data/derived"

save "07WSOMx", replace


//-----------------------------------------------------------------------------------------------

//Survey year 2006//

clear all
cd "/Users/youngster/Documents/GitHub/tax_project/data/original"
set more off

*-------------------------
*open file : 06WSOM.dta
*-------------------------

use "06WSOM.dta"

***************************************

gen year=2006

rename F15 left_right

rename F25a rd_public

rename F25h cuttax

rename F25i rtax_rserv

*for unemploy and pensioner I needed to recode so that I dont create a problem when converting 0 to missing value as done below
rename F76d unemploy
recode unemploy 0=2

rename F76e pensioner
recode pensioner 0=2

rename F93a home_class

rename F93b home_class2

rename F95 edu

rename F96 income_hus
// no need to recode income_hus since it contains only 8 levels

rename F104aa chng_fin

rename F104ab chng_mun

rename F104ac chng_swe

rename F104ba fut_fin

rename F104bb fut_mun

rename F104bc fut_swe

rename kommun mun_number


destring indatum, replace

egen ipnr2 = concat(year ipnr)
drop ipnr
rename ipnr2 ipnr
destring ipnr, replace

rename alder age

rename koen female
//female is coded - 1=women 2=men, recode later


//keep only relevant variables.
keep year ipnr left_right rd_public rtax_rserv cuttax unemploy pensioner ///
home_class home_class2 chng_fin chng_mun chng_swe fut_fin fut_mun fut_swe female age edu utb mun_number indatum income_hus

/*To accurately append surveys across years I must standardize the variable measures created by the SOM survey.

Recode all no answers or survey errors (99, 98, 9999, 9997 and 0) to missing values (.)
This is relevant because.. in some cases 0 represented someone not answering 1 question in an entire set of questions
For example multiple questions on opinions on policies or on trust for different instituions, etc
ALSO - some variables like unemploy, pensioner, etc are coded (0,1), so I needed to recode them earlier (above) so they are
not erased */

mvdecode _all, mv(9999)
mvdecode _all, mv(9997)
mvdecode _all, mv(99)
mvdecode _all, mv(98)
mvdecode _all, mv(0)


//reconversion for (1,2) dummies to (0,1) dummies:
recode female 2=0

//reconversion for (1,2) dummies to (0,1) dummies:
recode unemploy 2=0
recode pensioner 2=0

//Drop all labels for survey files
//this is done for consistency to keep problems from arising when appending the annual datasets
label drop _all

//Sort data by municipality and year for appending
sort mun_number year

*------------------------
*save file as: 06WSOMx.dta under derived folder
*------------------------


cd "/Users/youngster/Documents/GitHub/tax_project/data/derived"

save "06WSOMx", replace


//-----------------------------------------------------------------------------------------------

//Survey year 2005//

clear all
cd "/Users/youngster/Documents/GitHub/tax_project/data/original"
set more off

*-------------------------
*open file : 05WSOM.dta
*-------------------------

use "05WSOM.dta"

***************************************

gen year=2005

rename F19 left_right

rename F38a rd_public

rename F38i cuttax

rename F38k rtax_rserv

//odd variable construction this year for UE and pensioner status, need to generate new variable
rename F102 laborstatus

  //for unemploy and pensioner I needed to recode so that I dont create a problem when converting 0 to missing value as done below
  gen unemploy = 2
  replace unemploy = 1 if laborstatus == 4

  gen pensioner = 2
  replace pensioner = 1 if laborstatus == 5


rename F103 edu

rename F106a home_class

rename F106b home_class2

// no need to recode income_hus since it contains only 8 levels
rename F108 income_hus

rename F112aa chng_fin

rename F112ab chng_mun

rename F112ac chng_swe

rename F112ba fut_fin

rename F112bb fut_mun

rename F112bc fut_swe

rename kommun mun_number



rename Indatum indatum
destring indatum, replace

egen ipnr2 = concat(year ipnr)
drop ipnr
rename ipnr2 ipnr
destring ipnr, replace

rename alder age

rename koen female
*female is coded - 1=women 2=men, recode later

//keep only relevant variables.
keep year ipnr left_right rd_public rtax_rserv cuttax unemploy pensioner ///
home_class home_class2 chng_fin chng_mun chng_swe fut_fin fut_mun fut_swe female age edu utb mun_number indatum income_hus


/*To accurately append surveys across years I must standardize the variable measures created by the SOM survey.

Recode all no answers or survey errors (99, 98, 9999, 9997 and 0) to missing values (.)
This is relevant because.. in some cases 0 represented someone not answering 1 question in an entire set of questions
For example multiple questions on opinions on policies or on trust for different instituions, etc
ALSO - some variables like unemploy, pensioner, etc are coded (0,1), so I needed to recode them earlier (above) so they are
not erased */

mvdecode _all, mv(9999)
mvdecode _all, mv(9997)
mvdecode _all, mv(99)
mvdecode _all, mv(98)
mvdecode _all, mv(0)

*reconversion for (1,2) dummies to (0,1) dummies:
recode female 2=0

*reconversion for (1,2) dummies to (0,1) dummies:
recode unemploy 2=0
recode pensioner 2=0


//Drop all labels for survey files
//this is done for consistency to keep problems from arising when appending the annual datasets
label drop _all

//Sort data by municipality and year for appending
sort mun_number year

*------------------------
*save file as: 05WSOMx.dta under derived folder
*------------------------


cd "/Users/youngster/Documents/GitHub/tax_project/data/derived"

save "05WSOMx", replace
