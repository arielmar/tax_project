// master merge


clear all
cd "/Users/youngster/Documents/GitHub/tax_project/data/dta"
use "municipal_ue_final.dta"
set more off
describe
sort mun_name year date

merge m:1 mun_name year using municipal_pop_final

drop _merge

order mun_name mun_number year date

save "mun_pop_ue_merge", replace


/*remove dates that will not be used for IV variable measure. Because the IV measure
is supposed to capture the change in unemployment from when the survey was typically
first collected (October), the period between October and then September the
following year (12 months) will be used to measure change in unemployment.
As one can see below month 1 will be assigned to October, and month 12 to September,
and not the typical calendar year of January representing month 1 and December month 12.
*/
drop if date > 201109
drop if date < 200410


/*create new time variable because I cannot use the variable date with forvalues
because it creates too many empty cells*/
order mun_name mun_number year date
sort mun_number year date
bysort mun_number: gen time = _n

/* create 84 new UErate variables based on "time" variable. They are municipal and month
unique. There are 84, representing 84 months, 12 months across 7 years for each
municipality. This allows one to add them up to create the mMLUE variable below */
sum time, meanonly
forvalues time = `r(min)'/`r(max)' {
	gen UE`time' = UE if time == `time'
	bysort mun_number: egen UErate`time' = min(UE`time'/pop16to64)
}
*
*create mMLUE, Annual Mean Municipal UE level
/*
need to collapse across variables
for example m12 (representing the month of Septemeber) creates = 12, 24, 36, 48 .. 84
and m2 (representing the month of November) creates = 2, 14, 26, 38 .. 74
*/
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
	generate mMLUE`yr' = (UErate`m1' + UErate`m2' + UErate`m3' + UErate`m4' + UErate`m5' + UErate`m6' + UErate`m7' ///
  + UErate`m8' + UErate`m9' + UErate`m10' + UErate`m11' + UErate`m12')/12
}
*
rename mMLUE1 mMLUE05
rename mMLUE2 mMLUE06
rename mMLUE3 mMLUE07
rename mMLUE4 mMLUE08
rename mMLUE5 mMLUE09
rename mMLUE6 mMLUE10
rename mMLUE7 mMLUE11

browse mun_number year date UE pop16to64 time mMLUE05 mMLUE06 mMLUE07 mMLUE08 mMLUE09

gen mMLUE = .

replace mMLUE = mMLUE05 if year == 2005
replace mMLUE = mMLUE06 if year == 2006
replace mMLUE = mMLUE07 if year == 2007
replace mMLUE = mMLUE08 if year == 2008
replace mMLUE = mMLUE09 if year == 2009
replace mMLUE = mMLUE10 if year == 2010
replace mMLUE = mMLUE11 if year == 2011


*clean up data by removing unnecessary municipal-year values needed to calculate annual change.
* in other words keep observations for when date = 200410, 200509, 200510, 200609, etc.
*recall october is the start date and september in the following year is the end date.

drop if date > 200410 & date < 200509
drop if date > 200510 & date < 200609
drop if date > 200610 & date < 200709
drop if date > 200710 & date < 200809
drop if date > 200810 & date < 200909
drop if date > 200910 & date < 201009
drop if date > 201010 & date < 201109

*keep values needed to calculate relative and absolute change
keep mun_name UErate1 UErate12 UErate13 UErate24 UErate25 UErate36 UErate37 UErate48 UErate49 ///
UErate60 UErate61 UErate72 UErate73 UErate84 mun_number year date UE pop16to64 time ///
mMLUE05 mMLUE06 mMLUE07 mMLUE08 mMLUE09 mMLUE10 mMLUE11 mMLUE


sort mun_number time

*m2 creates = 12, 24, 36, ...
*m1 creates = 1, 13
*Relative Change
foreach yr of numlist 1/7 {
	local m12 = `yr'*12
	local m1 = (`yr'*12)-11
	bysort mun_number: egen mRCUE`yr' = min((UErate`m12' - (UErate`m1'))/(UErate`m1'))
}
*
*
*Absolute Change
foreach yr of numlist 1/7 {
	local m12 = `yr'*12
	local m1 = (`yr'*12)-11
	bysort mun_number: egen mACUE`yr' = min(UErate`m12' - UErate`m1')
}
*

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



/*clean up data by removing municipal-years duplicates, since there are two
2004 observations for each municipality, and you only want one. This is because
when creating the change measure i used october and september obs for the same year
*/

*Note the capitalization of _N and _n. (Stata interprets _N to mean the total
*number of observations in the by-group and _n to be the observation number within the by-group

sort mun_number year
quietly by mun_number year: gen dup = cond(_N==1,0,_n)
tab dup
drop if dup>1

* remove unnecessary year.
drop if year == 2004
drop UE time date dup
browse mun_name mun_number year mMLUE mRCUE mACUE pop16to64



/*double check that there are 7 unique year observations of unemployment per municipality, and that all municipalities
contain years between 2004 and 2012*/

bysort mun_number: egen test_obs = count(year)
bysort mun_number: egen test_min = min(year)
bysort mun_number: egen test_max = max(year)

assert test_obs == 7 & test_min == 2005 & test_max == 2011
drop test_*


*easy way:
*drop if time == 12 | time == 24 | time == 36 | time == 48 | time == 60 | time == 72

/* Other way but doesnt work well since it removes observations for 2011.
drop all dates ending with "09", thus I will keep all dates ending with "10".
this code only works for numeric variables. for numeric use this code:
drop if substr(date, 5, 6) == "09"
drop if substr(string(date), 5, 6) == "09"
*/

cd "/Users/youngster/Documents/GitHub/tax_project/data/dta"
save "mun_labor_final", replace
