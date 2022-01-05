

clear all
cd "/Users/youngster/Documents/GitHub/tax_project/data/derived"
set more off

/*
*===============================================================
** MERGE SURVEY DATA
*===============================================================
For appending WSOM survey years 2005 to 2010
load 2010 survey (base file), "10WSOMx.dta" to append other data to it.
make sure other files are in the same working directory as 2010 data
*/

use "10WSOMx.dta", clear

append using 09WSOMx

append using 08WSOMx

append using 07WSOMx

append using 06WSOMx

append using 05WSOMx

label drop _all


*review missing values
misstable sum


sort mun_number year
browse cuttax rtax_rserv rd_public

misstable sum cuttax rtax_rserv rd_public


**********************************************************************************************************

***********
*found individuals without a municipality assignment, so I will drop them.
drop if mun_number==.
sort mun_number year



*--------------------------------------
*save file as: "WSOM_2005to2011.dta"
*--------------------------------------
cd "/Users/youngster/Documents/GitHub/tax_project/data/dta"
save "WSOM_2005to2010", replace



**********************************************************************************************************
*Merge Employment DATA with WSOM Survey DATA
**********************************************************************************************************
*--------------------------------------
*Open file named: "WSOM_2005to2010.dta"
*--------------------------------------
clear all
cd "/Users/youngster/Documents/GitHub/tax_project/data/dta"
set more off

use "WSOM_2005to2010.dta", clear


*conduct merge

merge m:1 mun_number year using mun_labor_final

/*
NOTE: When I complete this merge approx. 33 kommun years are not matched, this is because the survey had
no individual respondents (ipnr missing) for those particular kommun years. Thus it is not a coding error
just the absence of a survey observation to match the labor/unemployment statistics data.

*/


browse mun_name mun_number year mMLUE mRCUE mACUE _merge ipnr

drop if _merge == 2
drop _merge

sort mun_number year

destring ipnr, replace


describe
bysort mun_number: gen uniq_mun = _n
sum mun_number if uniq_mun==1
*should be 50


*--------------------------------------------
** save file as "WSOMandUE_merge.dta"
*--------------------------------------------

save "WSOMandUE_merge", replace
******************************************************


browse mun_name mun_number year cuttax rtax_rserv rd_public mMLUE mRCUE mACUE
