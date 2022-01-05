

//Clean and reshape unemployment data for municipalities



clear all
cd "/Users/youngster/Documents/GitHub/tax_project/data/derived"
import excel "municipal_ue_month.xlsx", sheet("municipal_unemploy_edit") clear

*drops rows below row 4 with unnecessary text
drop if _n > 298
*drops rows above row 4 with unnecessary text
drop if _n < 8
set more off

*remove variable that provides totals by municipality
drop GZ

* describe data among different variables
describe


/*
Need to run the ds, has code so that I can shorten my work and use `r(varlist)'
The ds command compactly lists variables with specified properties, in this case
string variables

Now I need to remove any symbols (./-) from the text in (only
in the first row) since I will be replacing the variables with these names.
I only select the first row because I need to keep the hyphen in many of the
municipality names, for when I merge the data.

The subinstr() function requires four arguments. The fourth argument,
which is the number of occurrences (counting from the beginning of the string)
to be replaced. If you want to remove them all, you can specify . as the
value for the last argument. So it can be "missing value" but it cannot
be omitted. */

ds, has(type string)
foreach v in `r(varlist)'  {
	replace `v' = subinstr(`v', "-", "", .) if _n == 1
}


/* For merging/appending seperate datasets I NEED To convert the data from long
to wide format, and will therefore add "UE" so I can sort the data according
to unemployment values by municipality */
ds A, not
foreach v in `r(varlist)' {
  replace `v' = "UE" + `v' if _n == 1
}

*install stata module to quickly rename rows.
ssc install nrow
nrow

*rename variables for clarity and to prepare for reshape
rename A mun_name


reshape long UE, i(mun_name) j(date)
sort mun_name date

*destring variables, such as UE
ds mun_name, not
foreach var in `r(varlist)' {
	destring `var', replace
	}
*


*Other dataset uses the hyphen, therefore I must make them consistent
replace mun_name = "Upplands-Väsby" if mun_name == "Upplands Väsby"



*create year variable to allow for a proper merge with population dataset.
gen year = .

replace year = 2004 if date > 200312 & date <= 200412
replace year = 2005 if date > 200412 & date <= 200512
replace year = 2006 if date > 200512 & date <= 200612
replace year = 2007 if date > 200612 & date <= 200712
replace year = 2008 if date > 200712 & date <= 200812
replace year = 2009 if date > 200812 & date <= 200912
replace year = 2010 if date > 200912 & date <= 201012
replace year = 2011 if date > 201012 & date <= 201112


*remove dates that will not be used for IV variable measure
drop if date > 201112
drop if date < 200401

format %10.0g year
describe



*check data for missing values
tabmiss _all

*there should be 27,840 unqie values, since there are 290 municipalites, 8 years reported, and 12 months
*thus 290*8*12 = 27,840
count
assert r(N) == 27840


/*double check that there are 8*12=96 ubnique year observations per municipality, and that all municipalities
contain years between 2004 and 2011*/

bysort mun_name: egen test_obs = count(year)
bysort mun_name: egen test_min = min(year)
bysort mun_name: egen test_max = max(year)

assert test_obs == 96 & test_min == 2004 & test_max == 2011
drop test_*




cd "/Users/youngster/Documents/GitHub/tax_project/data/dta"
save "municipal_ue_final.dta", replace
