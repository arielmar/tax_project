
//Clean and resahpe population data for municipalities

clear all
cd "/Users/youngster/Documents/GitHub/tax_project/data/derived"
import excel "municipal_pop_yr.xlsx", sheet("UF0507B2") clear

*drops rows below row 4 with unnecessary text
drop if _n > 293
*drops rows above row 4 with unnecessary text
drop if _n < 3
set more off

*install stata module to quickly rename rows.
ssc install nrow
nrow

*rename variables for clarity and to prepare for reshape
rename A mun_number
rename B mun_name
rename _2004 pop2004
rename _2005 pop2005
rename _2006 pop2006
rename _2007 pop2007
rename _2008 pop2008
rename _2009 pop2009
rename _2010 pop2010
rename _2011 pop2011
rename _2012 pop2012

*now destring all variables that should be numerical (except mun_name), since they were imported as string values
ds mun_name, not
foreach var in `r(varlist)' {
	destring `var', replace
}


/* reshape data from wide to long, since population is provided in multiple column values for different years,
will reshape to one column date for */

reshape long pop, i(mun_number) j(year)
sort mun_number year

rename pop pop16to64
order mun_number mun_name year


*check data for missing values
tabmiss _all

*there should be 2610 values, since there are 290 municipalites, and 9 years reported, thus 290*9 = 2610
count
assert r(N) == 2610


/*double check that there are 9 ubnique year observations per municipality, and that all municipalities
contain years between 2004 and 2012*/

bysort mun_number: egen test_obs = count(year)
bysort mun_number: egen test_min = min(year)
bysort mun_number: egen test_max = max(year)

assert test_obs == 9 & test_min == 2004 & test_max == 2012
drop test_*

*year 2012 not included in municipal_ue_final.dta, avoids unmatched values during merge.
drop if year > 2011

/* For merging/appending seperate datasets I NEED To get rid of the two numbers in
front of each kommun, but also maintain hyphens or blank spaces between names.*/
/*
sort mun_name
gen mun_name2 = regexs(0) if regexm(mun_name, "(([a-öA-Ö]+)[ ]*[-]*([a-öA-Ö]+))")
*/

replace mun_name = "Upplands-Väsby" if mun_name == "Upplands Väsby"
replace mun_name = "Malung-Sälen" if mun_name == "Malung" /* for data in years 2004 to 2005 the kommun was named Malung */


cd "/Users/youngster/Documents/GitHub/tax_project/data/dta"
save "municipal_pop_final.dta", replace
