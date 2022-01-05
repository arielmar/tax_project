
** Remove unwanted variables, remove missing values (done for graphs consistency, not regression), create main IV's

clear all
cd "/Users/youngster/Documents/GitHub/tax_project/data/dta"
use WSOMandUE_merge, clear
set more off

describe


gen inc = income_hus
*recode income scale so the coefficient results will be easier to interpret.
recode inc 1=50 2=150 3=250 4=350 5=450 6=550 7=650 8=750
rename home_class class
rename mRCUE RUE
rename mACUE AUE
rename mMLUE MLUE


* keep variables needed for analysis
keep year left_right rd_public cuttax rtax_rserv unemploy pensioner  ///
inc class home_class2 edu ipnr female age indatum RUE MLUE AUE ///
chng_fin chng_mun chng_swe fut_fin fut_mun fut_swe mun_number mun_name


**********************************************************************************************************
*RECODE SURVEY Questions
**********************************************************************************************************

/*
Recode Dependent Variables so the interpretation of output makes more sense.

In most of the opinion question on institutions it looks like:
1-very good proposal, 2-good proposal, 3- (neither good nor bad proposal) neutral, 4-bad proposal, 5-very bad proposal
1-most favorable, 2-favorable, 3-neutral, 4-unfavroable, 5-very unfavorable

Now I reverse it so that 1 becomes - very bad proposal and 5- becomes very good proposal.
this is based on the logic that a lower value (1) is worse (less support) and a higher
value is better (has greater support).
*/

*reduce taxes
recode cuttax 1=5 2=4 3=3 4=2 5=1
* now 1 = bad idea, 5 = good idea

*Raise municip. taxes rather than reducing services
recode rtax_rserv 1=5 2=4 3=3 4=2 5=1
* now 1 = bad idea, 5 = good idea

*reduce the public sector
recode rd_public 1=5 2=4 3=3 4=2 5=1
* now 1 = bad idea, 5 = good idea


/*
recoding and re-scaling control variables for easy interpretation of
regression results.
*/


/* 3pt scale of left_right variable, left is <=2, center-3, right =>4 */
gen left_right3 = left_right
recode left_right3 1=0 2=0 3=1 4=2 5=2

/* add age squared variable for non-linear effects of age*/
gen agesqr = age^2

/*
Education is re-scaled into a binary measure, with 0 representing individuals
that have attained no higher than a high school degree, and 1 for those
that have attained any form of tertiary education (above the high school
level, including vocational, university courses, university degree).
*/
gen edu2 = edu
recode edu2 1=0 2=0 3=0 4=0 5=0 6=1 7=1 8=1

/*recode class into blue=1 white=2, and selfemploy=3 */
gen class3 = class
recode class3 1=1 2=1 3=2 4=2 5=3



/*
Subjective Economic conditions (6 variables)
Original coding range from 1 to 3, 1 - improved, 2 - remain about the same, 3 - deteriorated
I reverse the order so it makes more intuitive sense (higher numbers indicate improvement)
*/
recode chng_fin 1=3 2=2 3=1
recode chng_mun 1=3 2=2 3=1
recode chng_swe 1=3 2=2 3=1
recode fut_fin 1=3 2=2 3=1
recode fut_mun 1=3 2=2 3=1
recode fut_swe 1=3 2=2 3=1


/*evaluate the relationship between the outcome variables.
*factor rd_public cuttax
*factor cuttax rtax_rserv

*gen WSO = rd_public + cuttax
*gen WSO1 = (rd_public + cuttax)/2
*/




* ---------------------------------------------------------------------------------------- *
* Financial crisis(treatment) variable
* ---------------------------------------------------------------------------------------- *

*Relative Change in unemployment (RUE) based on year 2009 (height of crisis in Sweden)
*--------------------------------------*

*treatment measure

gen RUE09temp = RUE if year == 2009
bysort mun_number: egen RUE09 = mean(RUE09temp)			/* unique RUE for each mun_number */
drop if RUE09 == .							/* drop observations if RUE is not available for 2009 */

/*
the coding above, which creates a new variable column (RUE09temp) is executed because I
want to quickly assign unemployment change values for the year 2009 to year 2010 as well.
This cannot be done easily without creating a seconday column.

The reason I assign RUE for 2009 to the same municiaplites in 2010 is because I am tring to
test for lagged effects. Because unemployment changed decreased significanly following 2009,
one could assume this effect lingered or did not manifest immediately. and therefore i assign
2009 values to 2010 so as to distinguish between municipalites worse affected or treated in 2009
versus those that are the control.
*/

*generate crisis variable RUE09 with municipal unique values assinged to 2009 and 2010.
gen ecrisis = RUE09 if year > 2008


*pre-treatment measure
replace ecrisis = RUE if year == 2007  /* fill year 2007 empty cells with corresp. RUE values */
sum ecrisis, detail

browse mun_name mun_number year RUE ecrisis
*years 2005, 2006 and 2008 are left empty. see dissertation for details.



*Mean UE rate (MLUE), alternative crisis measure.
*----------------------------*

/*
for the typical measure of mean level of unemployment i assigned MLUE in 2009 to 2009 and 2010.
And for 2007 to 2007. All other years a left empty.
*/
gen MUE09temp = MLUE if year == 2009
bysort kommun: egen MUE09 = mean(MUE09temp)			/* one MUE09 for each kommun */
drop if MUE09 == .					/* drop observations if MLUE is missing for 2009 */

gen mcrisis = MUE09 if year > 2008		    /* x is treatment intensity variable, Treatment period */
replace mcrisis = MLUE if year == 2007    /* Pre-treatment period */
sum mcrisis, detail

browse mun_name mun_number year MLUE mcrisis



/*
Alternative Relative change measure:
This measure is different since it does not use the difference between the months
of October (year t-1) and september (year t) for 2009 and 2007 but instead relies
on the average annual level of unemployment of all 12 months in 2009 and 2007
to calculate relative change in unemployment between 2007 and 2009. This measure
is likely less precise, than the main measure. ** All pre-treatment years
(2008 and lower) are assigned the value of 0 to represent no treatment.
*/

*organizing data using MLUE to create alternative crisis variable.
gen MLUE09temp = MLUE if year == 2009
bysort mun_number: egen MLUE09 = max(MLUE09temp)		/* one MLUE for each municipality */
drop if MLUE09 == .

gen MLUE07temp = MLUE if year == 2007
bysort mun_number: egen MLUE07 = max(MLUE07temp)		/* one MLUE for each municipality */
drop if MLUE07 == .


*treatment period
gen relCrisis0709 = (MLUE09-MLUE07)/MLUE07  // assigns new measure to 2009 and 2010.

*pre-treatment period
replace relCrisis0709 = 0 if year < 2008  // assigns 0 to years 2008 or lower
sum relCrisis0709, detail



*old coding
/*
gen MLUE05temp = MLUE if year == 2005
bysort mun_number: egen MLUE05 = max(MLUE05temp)	/* one MLUE for each municipality */
drop if MLUE05 == .

replace relCrisis0709 = (MLUE07-MLUE05)/MLUE05 if year == 2007
sum relCrisis0709, detail

*dummy measure
sum relCrisis0709 if year == 2009
gen crisis09temp = 1 if relCrisis0709 > r(mean) & year == 2009
replace crisis09temp = 0 if relCrisis0709 <= r(mean) & year == 2009
bysort mun_number: egen relChigh09 = mean(crisis09temp)

*/



** remove below

{

*** Dont i need to control for repeated observations??? use OCC?

*binary "arithmetic mean" version

sum RUE09temp if year == 2009
gen xhigh09temp = 1 if RUE09temp > r(mean) & year == 2009
replace xhigh09temp = 0 if RUE09temp <= r(mean) & year == 2009
bysort mun_number: egen xhigh09 = mean(xhigh09temp)								/* xhigh09 is high-crises group */

/* Not needed, you do bysort in next do file
gen xhigh = xhigh09 if (year != 2005 | year != 2006 | year != 2007 )		/* xhigh is 0 in 2005 - 2007 (control groups), 1 for treated group in treated year (2008-2011) */
replace xhigh = 0 if (year == 2005 | year == 2006 | year == 2007 )
*/

*binary "median" version

sum RUE09temp if year == 2009, detail
gen xhigh09mtemp = 0 if RUE09temp <= r(p50) & year == 2009
replace xhigh09mtemp = 1 if RUE09temp > r(p50) & year == 2009
bysort mun_number: egen xhigh09med = mean(xhigh09mtemp)

*quartile version

sum RUE09temp if year == 2009, detail
gen xhigh09Qtemp = 0 if RUE09temp <= r(p25) & year == 2009
replace xhigh09Qtemp = 1 if RUE09temp > r(p75) & year == 2009
bysort mun_number: egen xhigh09Quart = mean(xhigh09Qtemp)


* ---------------------------------------------------------------------------------------- *


*Absolute Change (AUE)
*----------------------------*
gen AUE09temp = AUE if year == 2009
bysort mun_number: egen AUE09 = mean(AUE09temp)									/* one RUE for each mun_number */
drop if AUE09 == .															/* mun_number with no observations in 2009 */

gen acrisis = AUE09 if (year != 2005 & year != 2006 & year != 2007 )		/* x is treatment intensity variable */
replace acrisis = AUE if (year == 2005 | year == 2006 | year == 2007)

sum acrisis, detail
* ---------------------------------------------------------------------------------------- *


*binary "arithmetic mean" version

sum MUE09temp if year == 2009
gen mxhigh09temp = 1 if MUE09temp > r(mean) & year == 2009
replace mxhigh09temp = 0 if MUE09temp <= r(mean) & year == 2009
bysort mun_number: egen mxhigh09 = mean(mxhigh09temp)

sort mun_number year
browse mun_number year MUE09temp mxhigh09temp mxhigh09 mcrisis
* ---------------------------------------------------------------------------------------- *


/* Alternative pre-treatment using 2008 instead of only 2007 */
*-----------------------------------------------------------------*
gen x1 = RUE09 if (year != 2008 & year != 2007)			/* x is treatment intensity variable */
replace x1 = RUE if (year == 2008 | year == 2007)

sum x1, detail
* ---------------------------------------------------------------------------------------- *


}
*



/*
create pre and post crisis time period for models using more than two years.
You have to do this because you are running a dynamic DiD and therefore need 2 time periods
when you add more than 2 years.
*/

gen post = .
replace post = 1 if year >= 2009
replace post = 0 if year <= 2007

tab year post

* Ariel's addition:
* ---------------------------------------------------------------------------------------- *
* Create high-income group dummy inchighA based on mean income for each observed year


gen inchighA = .
sum inc if year == 2005, detail
replace inchighA = 0 if inc <= r(mean) & year == 2005
replace inchighA = 1 if inc > r(mean) & inc !=. & year == 2005
sum inc if year == 2006, detail
replace inchighA = 0 if inc <= r(mean) & year == 2006
replace inchighA = 1 if inc > r(mean) & inc !=. & year == 2006
sum inc if year == 2007, detail
replace inchighA = 0 if inc <= r(mean) & year == 2007
replace inchighA = 1 if inc > r(mean) & inc !=. & year == 2007
sum inc if year == 2008, detail
replace inchighA = 0 if inc <= r(mean) & year == 2008
replace inchighA = 1 if inc > r(mean) & inc !=. & year == 2008
sum inc if year == 2009, detail
replace inchighA = 0 if inc <= r(mean) & year == 2009
replace inchighA = 1 if inc > r(mean) & inc !=. & year == 2009
sum inc if year == 2010, detail
replace inchighA = 0 if inc <= r(mean) & year == 2010
replace inchighA = 1 if inc > r(mean) & inc !=. & year == 2010
sum inc if year == 2011, detail
replace inchighA = 0 if inc <= r(mean) & year == 2011
replace inchighA = 1 if inc > r(mean) & inc !=. & year == 2011



* Alternative income quartiles for all years

sum inc, detail
return list
local inc50 = r(p50)
local inc25 = r(p25)
local inc75 = r(p75)

gen inchigh = .
replace inchigh = 1 if inc <= `inc25'
replace inchigh = 2 if inc > `inc25' & inc <= `inc50'
replace inchigh = 3 if inc > `inc50' & inc <= `inc75'
replace inchigh = 4 if inc > `inc75' & inc !=.

tab inchigh inchighA


/*
*old coding by Che

sum inc if year == 2009
local inclimit = r(mean)

gen inchigh = 1 if inc > `inclimit'
replace inchigh = 0 if inc <= `inclimit'

bysort inchigh year: egen xminc1 = mean(x)
bysort inchigh year: egen yminc1 = mean(y)

browse mun_number year inc xminc xminc1
*/




* Create high-income group dummy inchighA based on "median" income for each observed year

gen incp50 = .
sum inc if year == 2005, detail
replace incp50 = 0 if inc <= r(p50) & year == 2005
replace incp50 = 1 if inc > r(p50) & inc !=. & year == 2005
sum inc if year == 2006, detail
replace incp50 = 0 if inc <= r(p50) & year == 2006
replace incp50 = 1 if inc > r(p50) & inc !=. & year == 2006
sum inc if year == 2007, detail
replace incp50 = 0 if inc <= r(p50) & year == 2007
replace incp50 = 1 if inc > r(p50) & inc !=. & year == 2007
sum inc if year == 2008, detail
replace incp50 = 0 if inc <= r(p50) & year == 2008
replace incp50 = 1 if inc > r(p50) & inc !=. & year == 2008
sum inc if year == 2009, detail
replace incp50 = 0 if inc <= r(p50) & year == 2009
replace incp50 = 1 if inc > r(p50) & inc !=. & year == 2009
sum inc if year == 2010, detail
replace incp50 = 0 if inc <= r(p50) & year == 2010
replace incp50 = 1 if inc > r(p50) & inc !=. & year == 2010
sum inc if year == 2011, detail
replace incp50 = 0 if inc <= r(p50) & year == 2011
replace incp50 = 1 if inc > r(p50) & inc !=. & year == 2011



*dont use this variables its worthless, or crap

* Create high-relative crisis (UE) dummy, crisishigh based on "mean" value of UE change for each observed year
gen crisishigh = .
sum RUE if year == 2005, detail
replace crisishigh = 0 if RUE <= r(mean) & year == 2005
replace crisishigh = 1 if RUE > r(mean) & RUE !=. & year == 2005
sum RUE if year == 2006, detail
replace crisishigh = 0 if RUE <= r(mean) & year == 2006
replace crisishigh = 1 if RUE > r(mean) & RUE !=. & year == 2006
sum RUE if year == 2007, detail
replace crisishigh = 0 if RUE <= r(mean) & year == 2007
replace crisishigh = 1 if RUE > r(mean) & RUE !=. & year == 2007
sum RUE if year == 2008, detail
replace crisishigh = 0 if RUE <= r(mean) & year == 2008
replace crisishigh = 1 if RUE > r(mean) & RUE !=. & year == 2008
sum RUE if year == 2009, detail
replace crisishigh = 0 if RUE <= r(mean) & year == 2009
replace crisishigh = 1 if RUE > r(mean) & RUE !=. & year == 2009
sum RUE if year == 2010, detail
replace crisishigh = 0 if RUE <= r(mean) & year == 2010
replace crisishigh = 1 if RUE > r(mean) & RUE !=. & year == 2010
sum RUE if year == 2011, detail
replace crisishigh = 0 if RUE <= r(mean) & year == 2011
replace crisishigh = 1 if RUE > r(mean) & RUE !=. & year == 2011

* Create high-mean level crisis (UE) dummy, Mcrisishigh based on "mean" value of UE change for each observed year
gen Mcrisishigh = .
sum MLUE if year == 2005, detail
replace Mcrisishigh = 0 if MLUE <= r(mean) & year == 2005
replace Mcrisishigh = 1 if MLUE > r(mean) & MLUE !=. & year == 2005
sum MLUE if year == 2006, detail
replace Mcrisishigh = 0 if MLUE <= r(mean) & year == 2006
replace Mcrisishigh = 1 if MLUE > r(mean) & MLUE !=. & year == 2006
sum MLUE if year == 2007, detail
replace Mcrisishigh = 0 if MLUE <= r(mean) & year == 2007
replace Mcrisishigh = 1 if MLUE > r(mean) & MLUE !=. & year == 2007
sum MLUE if year == 2008, detail
replace Mcrisishigh = 0 if MLUE <= r(mean) & year == 2008
replace Mcrisishigh = 1 if MLUE > r(mean) & MLUE !=. & year == 2008
sum MLUE if year == 2009, detail
replace Mcrisishigh = 0 if MLUE <= r(mean) & year == 2009
replace Mcrisishigh = 1 if MLUE > r(mean) & MLUE !=. & year == 2009
sum MLUE if year == 2010, detail
replace Mcrisishigh = 0 if MLUE <= r(mean) & year == 2010
replace Mcrisishigh = 1 if MLUE > r(mean) & MLUE !=. & year == 2010
sum MLUE if year == 2011, detail
replace Mcrisishigh = 0 if MLUE <= r(mean) & year == 2011
replace Mcrisishigh = 1 if MLUE > r(mean) & MLUE !=. & year == 2011



* Create two time periods for evaluation before and after the crisis
tab year

gen TwoYr = 0
replace TwoYr = 1 if year == 2007 | year == 2009
tab year TwoYr

gen FourYr = 0
replace FourYr = 1 if year == 2006 | year == 2007 | year == 2009 | year == 2010
tab year FourYr
tab FourYr TwoYr

browse year FourYr TwoYr

*double check work:
/*
bysort year: gen occ = _n
keep if occ==1
*/


*redefine some variables

label define LABJ 1 "Very Bad Suggestion" 2 "Bad Suggestion" 3 "Neither Good nor Bad Suggestion" 4 "Good Suggestion" 5 "Very Good Suggestion"

label define crisis 0 "0 - Low crisis municipality" 1 "1 - High crisis municipality"
label values xhigh09 crisis

label define ide3 0 "0 - Left-wing" 1 "1 - Centre" 2 "2 - Right-wing"
label values left_right3 ide3



** SAVE **

cd "/Users/youngster/Library/Mobile Documents/com~apple~CloudDocs/Young PhD Files/Crisis Study/Essay3/Data/DTA/WSOM"

save WSOMEstimTax, replace


/*
clear all
set more off
*cd "H:\tax\data\DTA"
cd "/Volumes/YoungBros/tax copy/data/DTA"

use EstimTax, replace


*preserve
bysort mun_number year: gen occ = _n
keep occ RUE year
keep if occ==1
sum RUE, detail
sum RUE if year == 2009, detail
sum RUE if year == 2008, detail
sum RUE if (year != 2008 & year != 2009), detail
*restore
