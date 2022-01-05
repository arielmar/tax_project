
** Create primary and secondary IV's consisting of Municipal Unemployment changes.


clear all
cd "/Users/youngster/Library/Mobile Documents/com~apple~CloudDocs/Young PhD Files/Crisis Study/Master Dataset/Population data"
use "kommunPOP2004_2013.dta"

drop kommunname

*change kommun variable type to "integer" type so they are treated as numbers and not as text

describe

destring kommun, generate(kommun2)
describe

drop kommun

rename kommun2 kommun
describe

save "kommunPOP2004_2013_edit.dta", replace



clear all
cd "/Users/youngster/Library/Mobile Documents/com~apple~CloudDocs/Young PhD Files/Crisis Study/Master Dataset/Employment data"
use "OpenUEkommunFIN.dta"
set more off
describe
sort kommun year


cd "/Users/youngster/Library/Mobile Documents/com~apple~CloudDocs/Young PhD Files/Crisis Study/Master Dataset/Population data"


merge m:1 kommun year using kommunPOP2004_2013_edit

drop _merge


*--------------------------------------
*save file as: "UEandLaborMerge2020.dta"
*--------------------------------------
cd "/Users/youngster/Library/Mobile Documents/com~apple~CloudDocs/Young PhD Files/Crisis Study/Master Dataset/Employment data"
save "UEandLaborMerge2020.dta", replace








clear all
set more off
cd "/Users/youngster/Library/Mobile Documents/com~apple~CloudDocs/Young PhD Files/Crisis Study/Master Dataset/Employment data"
use "UEandLaborMerge2020.dta"

*remove dates that will not be used for IV variable measure
drop if date > 201109
drop if date < 200410

/*create new time variable because I cannot use the variable date with forvalues
because it creates too many empty cells*/
order kommun year date
sort kommun year date
bysort kommun: gen time = _n 

/* create 84 new UErate variables based on "time" variable. They are municipal and month
unique. There are 84, representing 84 months, 12 months across 7 years for each 
municipality. This allows you to add them up to create the mMLUE variable below */
sum time, meanonly 
forvalues time = `r(min)'/`r(max)' {
	gen UE`time' = OpenUE if time == `time'
	bysort kommun: egen UErate`time' = min(UE`time'/pop16to64)
}
*
*create mMLUE, Annual Mean Municipal UE level
*need to collapse across variables 
*for example m12 creates = 12, 24, 36, 48 .. 84
*and m2 creates = 2, 14, 26, 38 .. 74  
set more off
foreach yr of numlist 1/7 {
	local m12 = `yr'*12
	local m11 = (`yr'*12)-1
	local m10 = (`yr'*12)-2
	local m9 = (`yr'*12)-3
	local m8 = (`yr'*12)-4
	local m7 = (`yr'*12)-5
	local m6 = (`yr'*12)-6
	local m5 = (`yr'*12)-7
	local m4 = (`yr'*12)-8
	local m3 = (`yr'*12)-9
	local m2 = (`yr'*12)-10
	local m1 = (`yr'*12)-11
	generate mMLUE`yr' = (UErate`m1' + UErate`m2' + UErate`m3' + UErate`m4' + UErate`m5' + UErate`m6' + UErate`m7' + UErate`m8' + UErate`m9' + UErate`m10' + UErate`m11' + UErate`m12')/12
}
*
rename mMLUE1 mMLUE05
rename mMLUE2 mMLUE06
rename mMLUE3 mMLUE07
rename mMLUE4 mMLUE08
rename mMLUE5 mMLUE09
rename mMLUE6 mMLUE10
rename mMLUE7 mMLUE11

*browse kommun year date OpenUE pop16to64 time mMLUE05 mMLUE06 mMLUE07 mMLUE08 mMLUE09

gen mMLUE = .

replace mMLUE = mMLUE05 if year == 2005
replace mMLUE = mMLUE06 if year == 2006
replace mMLUE = mMLUE07 if year == 2007
replace mMLUE = mMLUE08 if year == 2008
replace mMLUE = mMLUE09 if year == 2009
replace mMLUE = mMLUE10 if year == 2010
replace mMLUE = mMLUE11 if year == 2011

*Old Method:

{
/*

sort kommun year

*Mean from 10.2004 to 09.2005
*----------------------------

gen UE1004 = OpenUE if date==200410
bysort kommun year : egen UEoct04 = min(UE1004)
bysort kommun: egen UErate1004 = min(UEoct04/pop16to64) 

gen UE1104 = OpenUE if date==200411
bysort kommun year : egen UEnov04 = min(UE1104)
bysort kommun: egen UErate1104 = min(UEnov04/pop16to64) 

gen UE1204 = OpenUE if date==200412
bysort kommun year : egen UEdec04 = min(UE1204)
bysort kommun: egen UErate1204 = min(UEdec04/pop16to64) 

gen UE0105 = OpenUE if date==200501
bysort kommun year : egen UEjan05 = min(UE0105)
bysort kommun: egen UErate0105 = min(UEjan05/pop16to64) 

gen UE0205 = OpenUE if date==200502
bysort kommun year : egen UEfeb05 = min(UE0205)
bysort kommun: egen UErate0205 = min(UEfeb05/pop16to64) 

gen UE0305 = OpenUE if date==200503
bysort kommun year : egen UEmar05 = min(UE0305)
bysort kommun: egen UErate0305 = min(UEmar05/pop16to64) 

gen UE0405 = OpenUE if date==200504
bysort kommun year : egen UEapr05 = min(UE0405)
bysort kommun: egen UErate0405 = min(UEapr05/pop16to64) 

gen UE0505 = OpenUE if date==200505
bysort kommun year : egen UEmay05 = min(UE0505)
bysort kommun: egen UErate0505 = min(UEmay05/pop16to64) 

gen UE0605 = OpenUE if date==200506
bysort kommun year : egen UEjun05 = min(UE0605)
bysort kommun: egen UErate0605 = min(UEjun05/pop16to64) 

gen UE0705 = OpenUE if date==200507
bysort kommun year : egen UEjul05 = min(UE0705)
bysort kommun: egen UErate0705 = min(UEjul05/pop16to64) 

gen UE0805 = OpenUE if date==200508
bysort kommun year : egen UEaug05 = min(UE0805)
bysort kommun: egen UErate0805 = min(UEaug05/pop16to64) 

gen UE0905 = OpenUE if date==200509
bysort kommun year : egen UEsep05 = min(UE0905)
bysort kommun: egen UErate0905 = min(UEsep05/pop16to64) 

gen MLUE05x = ((UErate1004 + UErate1104 + UErate1204 + UErate0105 + UErate0205 + UErate0305 + UErate0405 + UErate0505 + UErate0605 + UErate0705 + UErate0805 + UErate0905)/12)
*/
}
*
*

*clean up data by removing unnecessary municipal-year values needed to calculate annual change. 
* in other words keep observations for when date = 200410, 200509, 200510, 200609, etc.

drop if date > 200410 & date < 200509
drop if date > 200510 & date < 200609
drop if date > 200610 & date < 200709
drop if date > 200710 & date < 200809
drop if date > 200810 & date < 200909
drop if date > 200910 & date < 201009
drop if date > 201010 & date < 201109

*keep values needed to calculate relative and absolute change
keep UErate1 UErate12 UErate13 UErate24 UErate25 UErate36 UErate37 UErate48 UErate49 ///
UErate60 UErate61 UErate72 UErate73 UErate84 kommun year date OpenUE pop16to64 time ///
mMLUE05 mMLUE06 mMLUE07 mMLUE08 mMLUE09 mMLUE10 mMLUE11 mMLUE


sort kommun time

*Relative Change
foreach yr of numlist 1/7 {
	local m2 = `yr'*12
	local m1 = (`yr'*12)-11
	bysort kommun: egen mRCUE`yr' = min((UErate`m2' - (UErate`m1'))/(UErate`m1'))	
}
*
*
*Absolute Change
foreach yr of numlist 1/7 {
	local m2 = `yr'*12
	local m1 = (`yr'*12)-11
	bysort kommun: egen mACUE`yr' = min(UErate`m2' - UErate`m1')	
}
*

*Old Method:

{
/*

*create Relative change in MLUE and Absolute change in MLUE variable for all 7 time periods (from 2005 to 2011)

*10.2004 to 09.2005
*------------------------

gen kUE1004 = OpenUE if date==200410

bysort kommun year : egen kUEoct04 = min(kUE1004) 

bysort kommun : egen kUErate1004 = min(kUEoct04/pop16to64)
 

gen kUE0905 = OpenUE if date==200509

bysort kommun year : egen kUEsept05 = min(kUE0905) 

bysort kommun: egen kUErate0905 = min(kUEsept05/pop16to64)

* Relative:
gen RChgkUE05 = ((kUErate0905 - kUErate1004)/(kUErate1004))

* Absolute:
gen AChgkUE05 = (kUErate0905 - kUErate1004)
*/
}

tabmiss


rename mRCUE1 mRCUE05
rename mRCUE2 mRCUE06
rename mRCUE3 mRCUE07
rename mRCUE4 mRCUE08
rename mRCUE5 mRCUE09
rename mRCUE6 mRCUE10
rename mRCUE7 mRCUE11

rename mACUE1 mACUE05
rename mACUE2 mACUE06
rename mACUE3 mACUE07
rename mACUE4 mACUE08
rename mACUE5 mACUE09
rename mACUE6 mACUE10
rename mACUE7 mACUE11


gen mRCUE = .
replace mRCUE = mRCUE05 if year == 2005
replace mRCUE = mRCUE06 if year == 2006
replace mRCUE = mRCUE07 if year == 2007
replace mRCUE = mRCUE08 if year == 2008
replace mRCUE = mRCUE09 if year == 2009
replace mRCUE = mRCUE10 if year == 2010
replace mRCUE = mRCUE11 if year == 2011

gen mACUE = .
replace mACUE = mACUE05 if year == 2005
replace mACUE = mACUE06 if year == 2006
replace mACUE = mACUE07 if year == 2007
replace mACUE = mACUE08 if year == 2008
replace mACUE = mACUE09 if year == 2009
replace mACUE = mACUE10 if year == 2010
replace mACUE = mACUE11 if year == 2011



/*clean up data by removing municipal-years duplicates*/
*this is the more complicated way:
sort kommun year 
quietly by kommun year:  gen dup = cond(_N==1,0,_n)
tab dup
drop if dup>1

*easy way:
*drop if time == 12 | time == 24 | time == 36 | time == 48 | time == 60 | time == 72

/* Other way but doesnt work well since it removes observations for 2011.  
drop all dates ending with "09", thus I will keep all dates ending with "10".
this code only works for numeric variables. for numeric use this code:
drop if substr(date, 5, 6) == "09"
drop if substr(string(date), 5, 6) == "09" 
*/


* remove unnecessary year.
drop if year == 2004
tabmiss


cd "/Users/youngster/Library/Mobile Documents/com~apple~CloudDocs/Young PhD Files/Crisis Study/Master Dataset/Employment data"
save "UEandLaborFinal2020.dta", replace


