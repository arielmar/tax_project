*Evaluate the samples overall response to reducing taxes (cuttax) variable, aggregate model analysis


clear all
cd "/Users/youngster/Documents/GitHub/tax_project/data/dta"
use WSOMTax

/* save analysis in results folder */
cd "/Users/youngster/Documents/GitHub/tax_project/results"
set matsize 10000
set more off


/* Table Title */
local Tablename Cuttax07&09_main

*/* Main Predictor variable */
local x ecrisis

/* Dependent variables */
local y cuttax

/* Control variables */
local controlA ib1.chng_fin ib1.fut_fin age agesqr female edu2 ib1.inchigh ib1.class3 unemploy
local controlC ib1.chng_fin ib1.fut_fin age agesqr female edu2 ib1.inchigh ib1.class3 unemploy ib0.left_right3

/*Keep only 2007 and 2009 since I am analyzing the effect of the crisis using dynamic DiD model*/
keep if year == 2007 | year == 2009

/* set municipality as fixed effect */
xtset mun_number


sort mun_number year
set more off

/* DiD model, no controls, no fixed effects, no year effects and no cluster RSE */
quietly xi: xtreg `y' `x'
outreg2 using DiD-`Tablename'.doc, replace symbol(***, **, *) alpha(0.001, 0.01, 0.05) ///
title("Table 1 - Support for Cutting Taxes (Diff-in-Diff model), 2007 & 2009") ///
ctitle(1) keep(`x') sortvar(`x') ///
addtext(Indiv. Controls, no, Municipal FE, no, Year FE, no, Cluster RSE, no)

/* DiD model, no controls, yes fixed effects, yes year effects and yes cluster RSE */
quietly xi: xtreg `y' `x' i.year, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.doc, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ///
ctitle(2) keep(`x') ///
addtext(Indiv. Controls, no, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

/* DiD model, yes controls, yes fixed effects, yes year effects and yes cluster RSE */
quietly xi: xtreg `y' `x' `controlA' i.year, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.doc, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ///
ctitle(3) keep(`x' `controlA') sortvar(`x') ///
addtext(Indiv. Controls, yes, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

/* DiD model, yes controls (with Ideology), yes fixed effects, yes year effects and yes cluster RSE */
quietly xi: xtreg `y' `x' `controlC' i.year, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.doc, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ///
ctitle(4) keep(`x' `controlC') sortvar(`x' 1.left_right3 2.left_right3) ///
addtext(Indiv. Controls, yes, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)


*----------------------------------


/*
Evaluate the samples overall response to raising taxes rather than reducing services
(rtax_rserv) variable, aggregate model analysis
*/


clear all
cd "/Users/youngster/Documents/GitHub/tax_project/data/dta"
use WSOMTax

/* save analysis in results folder */
cd "/Users/youngster/Documents/GitHub/tax_project/results"
set matsize 10000
set more off


/* Table Title */
local Tablename Rtax07&09_main

*/* Main Predictor variable */
local x ecrisis

/* Dependent variables */
local y rtax_rserv

/* Control variables */
local controlA ib1.chng_fin ib1.fut_fin age agesqr female edu2 ib1.inchigh ib1.class3 unemploy
local controlC ib1.chng_fin ib1.fut_fin age agesqr female edu2 ib1.inchigh ib1.class3 unemploy ib0.left_right3

/*Keep only 2007 and 2009 since I am analyzing the effect of the crisis using dynamic DiD model*/
keep if year == 2007 | year == 2009

/* set municipality as fixed effect */
xtset mun_number


sort mun_number year
set more off

/* DiD model, no controls, no fixed effects, no year effects and no cluster RSE */
quietly xi: xtreg `y' `x'
outreg2 using DiD-`Tablename'.doc, replace symbol(***, **, *) alpha(0.001, 0.01, 0.05) ///
title("Table 2 - Support for Raising Taxes instead of Reducing services (Diff-in-Diff model), 2007 & 2009") ///
ctitle(1) keep(`x') sortvar(`x') ///
addtext(Indiv. Controls, no, Municipal FE, no, Year FE, no, Cluster RSE, no)

/* DiD model, no controls, yes fixed effects, yes year effects and yes cluster RSE */
quietly xi: xtreg `y' `x' i.year, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.doc, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ///
ctitle(2) keep(`x') ///
addtext(Indiv. Controls, no, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

/* DiD model, yes controls, yes fixed effects, yes year effects and yes cluster RSE */
quietly xi: xtreg `y' `x' `controlA' i.year, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.doc, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ///
ctitle(3) keep(`x' `controlA') sortvar(`x') ///
addtext(Indiv. Controls, yes, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

/* DiD model, yes controls (with Ideology), yes fixed effects, yes year effects and yes cluster RSE */
quietly xi: xtreg `y' `x' `controlC' i.year, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.doc, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ///
ctitle(4) keep(`x' `controlC') sortvar(`x' 1.left_right3 2.left_right3) ///
addtext(Indiv. Controls, yes, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)



*---------------------------------------

* DiD Interactive model - Table 1.1 (HE table, interaction between Ecrisis and Ideology)

clear all
cd "/Users/youngster/Documents/GitHub/tax_project/data/dta"
use WSOMTax

/* save analysis in results folder */
cd "/Users/youngster/Documents/GitHub/tax_project/results"
set matsize 10000
set more off

/* Table Title */
local Tablename Cuttax07&09_Ide

*/* Main Predictor variable */
local x ecrisis

/* Dependent variables */
local y cuttax

/* Control variables */
local controlA ib1.chng_fin ib1.fut_fin age agesqr female edu2 ib1.inchigh ib1.class3 unemploy


keep if year == 2007 | year == 2009

sort mun_number year
set more off
xtset mun_number


quietly xi: xtreg `y' `x' i.year if left_right3 == 0, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.doc, replace title("Table 1.1 - Support for Cutting Taxes by Ideology group (H.E. model), 2007 & 2009") ///
symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Left) keep(`x') ///
addtext(Indiv. Controls, no, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' i.year if left_right3 == 1, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.doc, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Center) keep(`x') ///
addtext(Indiv. Controls, no, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' i.year if left_right3 == 2, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.doc, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Right) keep(`x') ///
addtext(Indiv. Controls, no, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' `controlA' i.year if left_right3 == 0, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.doc, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Left) keep(`x' `controlA') ///
addtext(Indiv. Controls, yes, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' `controlA' i.year if left_right3 == 1, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.doc, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Center) keep(`x' `controlA') ///
addtext(Indiv. Controls, yes, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' `controlA' i.year if left_right3 == 2, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.doc, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Right) keep(`x' `controlA') ///
addtext(Indiv. Controls, yes, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)



*-------------------------------------------------------------------


* DiD Interactive model - Table 2.1 (HE table, interaction between Ecrisis and Ideology)

clear all
cd "/Users/youngster/Documents/GitHub/tax_project/data/dta"
use WSOMTax

/* save analysis in results folder */
cd "/Users/youngster/Documents/GitHub/tax_project/results"
set matsize 10000
set more off

/* Table Title */
local Tablename Rtax07&09_Ide

*/* Main Predictor variable */
local x ecrisis

/* Dependent variables */
local y rtax_rserv

/* Control variables */
local controlA ib1.chng_fin ib1.fut_fin age agesqr female edu2 ib1.inchigh ib1.class3 unemploy


keep if year == 2007 | year == 2009

sort mun_number year
set more off
xtset mun_number

quietly xi: xtreg `y' `x' i.year if left_right3 == 0, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.doc, replace title("Table 2.1 - Support for Raising Taxes instead of Reducing services by Ideology group (H.E. model), 2007 & 2009") ///
symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Left) keep(`x') ///
addtext(Indiv. Controls, no, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' i.year if left_right3 == 1, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.doc, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Center) keep(`x') ///
addtext(Indiv. Controls, no, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' i.year if left_right3 == 2, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.doc, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Right) keep(`x') ///
addtext(Indiv. Controls, no, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' `controlA' i.year if left_right3 == 0, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.doc, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Left) keep(`x' `controlA') ///
addtext(Indiv. Controls, yes, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' `controlA' i.year if left_right3 == 1, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.doc, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Center) keep(`x' `controlA') ///
addtext(Indiv. Controls, yes, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' `controlA' i.year if left_right3 == 2, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.doc, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Right) keep(`x' `controlA') ///
addtext(Indiv. Controls, yes, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

*-------------------------------------------------------------------










*-----------------------
** ROBUSTNESS test
*-----------------------


* DiD Interactive model - Table ? (robustness table, similar to main table with an expanding time period before and after crisis)


clear all

cd "H:\tax\data\DTA\WSOM"
*cd "/Volumes/YoungBros/tax copy/data/DTA"
use WSOMEstimTax, replace

cd "H:\tax\data\TABLES\WSOM"
*cd "/Volumes/YoungBros/tax copy/data/TABLES"
set matsize 10000
set more off


local x ecrisis												/* Main Predictor variable */
local Tablename Tax06_10_Cuttax@Ide							/* Table Title */


local y cuttax
/* Control variables */
local controlA ib1.chng_fin ib1.fut_fin age agesqr female edu2 ib1.inchigh ib1.class3 unemploy

drop if year == 2005 | year == 2008 | year == 2011


sort mun_number year
set more off
xtset mun_number

/*recall that you are using "i.post" in place of year because the crisis measure you use did not go up
every year, only up until 2009. so if I use i.year I am incorrecrly modeling the situation
see the photo and recorded notes from the meetings with Che as well as discussion of the measure in the thesis*/

quietly xi: xtreg `y' `x' i.post if left_right3 == 0, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.doc, replace title("Table C.1 - Support for Cutting Taxes (H.E. model), 2006 to 2010") ///
symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Left) keep(`x') ///
addtext(Indiv. Controls, no, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' i.post if left_right3 == 1, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.doc, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Center) keep(`x') addtext(Indiv. Controls, no, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' i.post if left_right3 == 2, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.doc, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Right) keep(`x') addtext(Indiv. Controls, no, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' `controlA' i.post if left_right3 == 0, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.doc, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Left) keep(`x' `controlA') addtext(Indiv. Controls, yes, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' `controlA' i.post if left_right3 == 1, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.doc, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Center) keep(`x' `controlA') addtext(Indiv. Controls, yes, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' `controlA' i.post if left_right3 == 2, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.doc, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Right) keep(`x' `controlA') addtext(Indiv. Controls, yes, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)


*-------------------------------------------------------------------




*--------------------
*** ALSO..ROBUSTNESS TESTS
*--------------------
*---------------------------------------------------------------------------------------------------------------------------


* DiD interactive model - Main Robustness Table (interacting Ecrisis with Ideology among the Higheset Income households)

clear all

cd "H:\tax\data\DTA\WSOM"
*cd "/Volumes/YoungBros/tax copy/data/DTA"
use WSOMEstimTax, replace

cd "H:\tax\data\TABLES\WSOM"
*cd "/Volumes/YoungBros/tax copy/data/TABLES"
set matsize 10000
set more off


local x ecrisis												/* Main Predictor variable */
local Tablename 2006to10_Cuttax_HighestInc@IdeTest

local y cuttax
/* Control variables */
local controlA ib1.fut_fin ib1.chng_fin age agesqr female edu2 ib1.inchigh ib1.class3 unemploy

drop if year == 2005 | year == 2008 | year == 2011
keep if inchigh == 4

sort mun_number year
set more off
xtset mun_number


quietly xi: xtreg `y' `x' `controlA' i.post if left_right3 == 0, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.xml, replace title("Robustness Table - Support for Cutting Taxes among Higher Income earners by Ideology Group (H.E. model), 2006 to 2010") ///
symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Left) keep(`x' `controlA') addtext(Indiv. Controls, yes, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' `controlA' i.post if left_right3 == 1, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.xml, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Center) keep(`x' `controlA') ///
addtext(Indiv. Controls, yes, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' `controlA' i.post if left_right3 == 2, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.xml, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Right) keep(`x' `controlA') ///
addtext(Indiv. Controls, yes, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

*------------------------


clear all

*cd "H:\tax\data\DTA\WSOM"
cd "/Users/youngster/Library/Mobile Documents/com~apple~CloudDocs/Young PhD Files/Crisis Study/Essay3/Data/DTA/WSOM"
use WSOMEstimTax, replace

*cd "H:\tax\data\TABLES\WSOM"
cd "/Users/youngster/Library/Mobile Documents/com~apple~CloudDocs/Young PhD Files/Crisis Study/Essay3/Data/TABLES/WSOM"
set matsize 10000
set more off


local x ecrisis										/* Main Predictor variable */
local Tablename Tax07&09_retrospective				/* Table Title */


/* Dependent variables */
local y cuttax

/* Control variables */

local controlA ib3.chng_mun ib3.fut_mun
local controlX ib3.chng_swe ib3.fut_swe

local controlB ib3.chng_fin ib3.fut_fin age agesqr female edu2 ib1.inchigh ib1.class3 unemploy ib0.left_right3
local controlC ib3.chng_mun ib3.fut_mun ib1.chng_fin ib1.fut_fin age agesqr female edu2 ib1.inchigh ib1.class3 unemploy ib0.left_right3


/* Main Outcome variable */
keep if year == 2007 | year == 2009
sort mun_number year
set more off
xtset mun_number


quietly xi: xtreg `y' `x' i.year, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.doc, replace title("Table 2007 & 2009 DiD") ctitle(0) keep(`x') addtext(Indiv. Controls, no, Municipal FE, no, Year dummy, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' `controlA' i.year, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.doc, append ctitle(1) keep(`x' `controlA') addtext(Indiv. Controls, yes, Municipal FE, yes, Year dummy, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' `controlX' i.year, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.doc, append ctitle(1) keep(`x' `controlX') addtext(Indiv. Controls, yes, Municipal FE, yes, Year dummy, yes, Cluster RSE, yes)


*------------------------------------


clear all

*cd "H:\tax\data\DTA\WSOM"
cd "/Users/youngster/Library/Mobile Documents/com~apple~CloudDocs/Young PhD Files/Crisis Study/Essay3/Data/DTA/WSOM"
use WSOMEstimTax, replace

*cd "H:\tax\data\TABLES\WSOM"
cd "/Users/youngster/Library/Mobile Documents/com~apple~CloudDocs/Young PhD Files/Crisis Study/Essay3/Data/TABLES/WSOM"
set matsize 10000
set more off


											/* Main Predictor variable */
local Tablename Tax07&09_Cuttax@other						/* Table Title */

local y cuttax
/* Control variables */
local controlA ib3.chng_swe age agesqr female edu2 ib1.inchigh ib1.class3 unemploy


keep if year == 2007 | year == 2008

sort mun_number year
set more off
xtset mun_number


quietly xi: xtreg `y' `x' i.year if left_right3 == 0, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.doc, replace title("Table 3.2 - Support for Cutting Taxes by Ideology group (H.E. model), 2007 & 2009") ///
symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Left) keep(`x') ///
addtext(Indiv. Controls, no, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' i.year if left_right3 == 1, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.doc, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Center) keep(`x') ///
addtext(Indiv. Controls, no, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' i.year if left_right3 == 2, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.doc, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Right) keep(`x') ///
addtext(Indiv. Controls, no, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' `controlA' i.year if left_right3 == 0, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.doc, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Left) keep(`x' `controlA') ///
addtext(Indiv. Controls, yes, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' `controlA' i.year if left_right3 == 1, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.doc, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Center) keep(`x' `controlA') ///
addtext(Indiv. Controls, yes, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' `controlA' i.year if left_right3 == 2, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.doc, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Right) keep(`x' `controlA') ///
addtext(Indiv. Controls, yes, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

*------------------------------------

* DiD Interactive model - Various robustness models (varying income group and expected income performance over next 12mos)


clear all

cd "H:\tax\data\DTA\WSOM"
*cd "/Volumes/YoungBros/tax copy/data/DTA"
use WSOMEstimTax, replace

cd "H:\tax\data\TABLES\WSOM"
*cd "/Volumes/YoungBros/tax copy/data/TABLES"
set matsize 10000
set more off


local x ecrisis												/* Main Predictor variable */
*local Tablename 2007&09_Cuttax@Ide_Inc4&FutFin3							/* Table Title */
*local Tablename 2007&09_Cuttax@Ide_Inc1&FutFin1							/* Table Title */
*local Tablename 2007&09_Cuttax@Ide_Inc1&FutFin3
*local Tablename 2007&09_Cuttax@Ide_Inc4&FutFin2
local Tablename 2007&09_Cuttax@Ide_Inc4

local y cuttax
/* Control variables */
local controlA ib1.chng_fin age agesqr female edu2 ib1.inchigh ib1.class3 unemploy

keep if year == 2007 | year == 2009
*keep if inchigh == 4 & fut_fin == 3
*keep if inchigh == 1 & fut_fin == 1
*keep if inchigh == 1 & fut_fin == 3
*keep if inchigh == 4 & fut_fin == 2
keep if inchigh == 4

sort mun_number year
set more off
xtset mun_number


quietly xi: xtreg `y' `x' `controlA' i.year if left_right3 == 0, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.xml, replace title("Table 2 - Support for Cutting Taxes by Ideology Group - 2007 & 2009 Crisis") ///
symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Left) keep(`x' `controlA') addtext(Indiv. Controls, yes, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' `controlA' i.year if left_right3 == 1, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.xml, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Center) keep(`x' `controlA') ///
addtext(Indiv. Controls, yes, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' `controlA' i.year if left_right3 == 2, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.xml, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Right) keep(`x' `controlA') ///
addtext(Indiv. Controls, yes, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

*------------


{
*------------

/*

clear all

cd "H:\tax\data\DTA\WSOM"
*cd "/Volumes/YoungBros/tax copy/data/DTA"
use WSOMEstimTax, replace

cd "H:\tax\data\TABLES\WSOM"
*cd "/Volumes/YoungBros/tax copy/data/TABLES"
set matsize 10000
set more off


local x ib1.fut_fin												/* Main Predictor variable */
local Tablename 2007&09_Cuttax@LowInc&Right_wLowvsHighCrisis							/* Table Title */
local y cuttax
/* Control variables */
local controlA age agesqr female edu2 ib1.inchigh ib1.class3 unemploy
local controlB ib1.chng_fin age agesqr female edu2 ib1.inchigh ib1.class3 unemploy

keep if year == 2007 | year == 2009
keep if inchigh == 1
keep if left_right3 == 2

sort mun_number year
set more off
xtset mun_number


quietly xi: xtreg `y' `x' i.year if xhigh09 == 0, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.xml, replace title("Table ? - Support for Cutting Taxes among Poor Right-Wing living in a low or high crisis area- 2007 & 2009 Crisis") ///
symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Simple Low Crisis) keep(`x') addtext(Indiv. Controls, no, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' i.year if xhigh09 == 1, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.xml, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Simple High Crisis) keep(`x') addtext(Indiv. Controls, no, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' `controlA' i.year if xhigh09 == 0, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.xml, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Controls Low Crisis) keep(`x' `controlA') addtext(Indiv. Controls, yes, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' `controlA' i.year if xhigh09 == 1, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.xml, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Controls High Crisis) keep(`x' `controlA') addtext(Indiv. Controls, yes, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)


*--------------



clear all

cd "H:\tax\data\DTA\WSOM"
*cd "/Volumes/YoungBros/tax copy/data/DTA"
use WSOMEstimTax, replace

cd "H:\tax\data\TABLES\WSOM"
*cd "/Volumes/YoungBros/tax copy/data/TABLES"
set matsize 10000
set more off


local x ecrisis											/* Main Predictor variable */
local Tablename 2007&09_Cuttax@LowInc&Right_ecrisis							/* Table Title */
local y cuttax
/* Control variables */
local controlB age agesqr female edu2 ib1.class3 unemploy
local controlA ib1.chng_fin age agesqr female edu2 ib1.class3 unemploy

keep if year == 2007 | year == 2009
keep if inchigh <= 2
keep if left_right3 == 2

sort mun_number year
set more off
xtset mun_number


quietly xi: xtreg `y' `x' i.year if fut_fin == 1, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.xml, replace title("Table ? - Support for Cutting Taxes among Lower income Right-Wing living in a low vs high crisis area- 2007 & 2009 Crisis") ///
symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Simple Worsened Fin) keep(`x') addtext(Indiv. Controls, no, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' i.year if fut_fin == 2, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.xml, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Simple Same Fin) keep(`x') addtext(Indiv. Controls, no, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' i.year if fut_fin == 3, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.xml, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Simple Improved Fin) keep(`x') addtext(Indiv. Controls, no, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' `controlA' i.year if fut_fin == 1, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.xml, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Controls Worsened Fin) keep(`x' `controlA') addtext(Indiv. Controls, yes, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' `controlA' i.year if fut_fin == 2, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.xml, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Controls Same Fin) keep(`x' `controlA') addtext(Indiv. Controls, yes, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' `controlA' i.year if fut_fin == 3, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.xml, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Controls Improved Fin) keep(`x' `controlA') addtext(Indiv. Controls, yes, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)



*--------------



clear all

cd "H:\tax\data\DTA\WSOM"
*cd "/Volumes/YoungBros/tax copy/data/DTA"
use WSOMEstimTax, replace

cd "H:\tax\data\TABLES\WSOM"
*cd "/Volumes/YoungBros/tax copy/data/TABLES"
set matsize 10000
set more off


local x ecrisis											/* Main Predictor variable */
local Tablename 2007&09_Cuttax@Mod&HighInc&Right_ecrisis							/* Table Title */
local y cuttax
/* Control variables */
local controlB age agesqr female edu2 ib1.class3 unemploy
local controlA ib1.chng_fin age agesqr female edu2 ib1.class3 unemploy

keep if year == 2007 | year == 2009
keep if inchigh >= 3
keep if left_right3 == 2

sort mun_number year
set more off
xtset mun_number


quietly xi: xtreg `y' `x' i.year if fut_fin == 1, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.xml, replace title("Table ? - Support for Cutting Taxes among Higher Inc Right-Wing living in a low vs high crisis area- 2007 & 2009 Crisis") ///
symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Simple Worsened Fin) keep(`x') addtext(Indiv. Controls, no, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' i.year if fut_fin == 2, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.xml, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Simple Same Fin) keep(`x') addtext(Indiv. Controls, no, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' i.year if fut_fin == 3, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.xml, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Simple Improved Fin) keep(`x') addtext(Indiv. Controls, no, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' `controlA' i.year if fut_fin == 1, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.xml, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Controls Worsened Fin) keep(`x' `controlA') addtext(Indiv. Controls, yes, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' `controlA' i.year if fut_fin == 2, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.xml, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Controls Same Fin) keep(`x' `controlA') addtext(Indiv. Controls, yes, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' `controlA' i.year if fut_fin == 3, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.xml, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Controls Improved Fin) keep(`x' `controlA') addtext(Indiv. Controls, yes, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)



*---------------------------------------------------------------------------------------------------------------------------




*--------------



* OLS Additive model - Table ? (reference table for how all variables perform between 2005 and 2011)

clear all

cd "H:\tax\data\DTA\WSOM"
*cd "/Volumes/YoungBros/tax copy/data/DTA"
use WSOMEstimTax, replace

cd "H:\tax\data\TABLES\WSOM"
*cd "/Volumes/YoungBros/tax copy/data/TABLES"
set matsize 10000
set more off


local x RUE										/* Main Predictor variable */
local Tablename 2005to2011_RUE							/* Table Title */

/* Dependent variables */
local y cuttax


/* Control variables */
local controlA age agesqr female edu2 ib1.inchigh ib1.class3 unemploy
local controlB ib1.chng_fin ib1.fut_fin age agesqr female edu2 ib1.inchigh ib1.class3 unemploy 			/* Control variables */


sort mun_number year
set more off
xtset mun_number


quietly xi: xtreg `y' `x'
outreg2 using OLS-`Tablename'.doc, replace title("OLS Support for Cutting Taxes - 2005 to 2011") ///
symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(1) keep(`x') sortvar(`x') ///
addtext(Indiv. Controls, no, Municipal FE, no, Year FE, no, Cluster RSE, no)

quietly xi: xtreg `y' `x' i.year, fe cluster(mun_number)
outreg2 using OLS-`Tablename'.doc, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(2) keep(`x') ///
sortvar(`x') addtext(Indiv. Controls, no, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `controlA' i.year, fe cluster(mun_number)
outreg2 using OLS-`Tablename'.doc, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(3) keep(`controlA') ///
addtext(Indiv. Controls, Some, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `controlB' i.year, fe cluster(mun_number)
outreg2 using OLS-`Tablename'.doc, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(4) keep(`controlB') ///
addtext(Indiv. Controls, Some, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `controlB' ib0.left_right3 i.year, fe cluster(mun_number)
outreg2 using OLS-`Tablename'.doc, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(5) keep(1.left_right3 2.left_right3 `controlB') ///
addtext(Indiv. Controls, all, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' `controlB' ib0.left_right3 i.year, fe cluster(mun_number)
outreg2 using OLS-`Tablename'.doc, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(6) keep(`x' 1.left_right3 2.left_right3 `controlB') ///
sortvar(`x' 1.left_right3 2.left_right3) addtext(Indiv. Controls, all, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

*-------------------------------------------------------------------------


* OLS Additive model - Table ? (reference table with only right-wing sample between 2005 and 2011)

clear all

cd "H:\tax\data\DTA\WSOM"
*cd "/Volumes/YoungBros/tax copy/data/DTA"
use WSOMEstimTax, replace

cd "H:\tax\data\TABLES\WSOM"
*cd "/Volumes/YoungBros/tax copy/data/TABLES"
set matsize 10000
set more off


local x RUE										/* Main Predictor variable */
local Tablename 2005to2011_RUE_Rightw							/* Table Title */
keep if left_right3 == 2						/* Keep only right-wing respondents*/

/* Dependent variables */
local y cuttax

/* Control variables */
local controlA age agesqr female edu2 ib1.inchigh ib1.class3 unemploy
local controlB ib1.chng_fin ib1.fut_fin age agesqr female edu2 ib1.inchigh ib1.class3 unemploy 			/* Control variables */

sort mun_number year
set more off
xtset mun_number


quietly xi: xtreg `y' `x'
outreg2 using OLS-`Tablename'.doc, replace title("Table C.3 - Support for Cutting Taxes among Right Wing (OLS model)") ///
symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(1) keep(`x') sortvar(`x') addtext(Indiv. Controls, no, Municipal FE, no, Year FE, no, Cluster RSE, no)

quietly xi: xtreg `y' `x' i.year, fe cluster(mun_number)
outreg2 using OLS-`Tablename'.doc, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(2) keep(`x') sortvar(`x') addtext(Indiv. Controls, no, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `controlA' i.year, fe cluster(mun_number)
outreg2 using OLS-`Tablename'.doc, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(3) keep(`controlA') addtext(Indiv. Controls, Some, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `controlB' i.year, fe cluster(mun_number)
outreg2 using OLS-`Tablename'.doc, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(4) keep(`controlB') addtext(Indiv. Controls, Some, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' `controlB' i.year, fe cluster(mun_number)
outreg2 using OLS-`Tablename'.doc, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(5) keep(`x' `controlB') sortvar(`x') addtext(Indiv. Controls, all, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)







clear all

cd "H:\tax\data\DTA\WSOM"
*cd "/Volumes/YoungBros/tax copy/data/DTA"
use WSOMEstimTax, replace

cd "H:\tax\data\TABLES\WSOM"
*cd "/Volumes/YoungBros/tax copy/data/TABLES"
set matsize 10000
set more off


local x ecrisis										/* Main Predictor variable */
local Tablename all_exc_07to09							/* Table Title */

/* Dependent variables */
local y cuttax


/* Control variables */
local controlA ib1.chng_fin ib1.fut_fin age agesqr female edu2 ib1.inchigh unemploy
local controlB ib1.chng_fin ib1.fut_fin age agesqr female edu2 ib1.inchigh ib1.class3 unemploy 			/* Control variables */
local controlC ib1.chng_fin ib1.fut_fin age agesqr female edu2 ib1.inchigh ib1.class3 unemploy left_right3

drop if year == 2007 | year == 2008 | year == 2009

sort mun_number year
set more off
xtset mun_number


quietly xi: xtreg `y' `x' i.year
outreg2 using DiD-`Tablename'.xml, replace title("Table 5 - Support for Redistribution Policies - 2007 & 2009 Crisis") symbol(***, **, *) alpha(0.001, 0.01, 0.05) ///
ctitle(1) keep(`x') addtext(Indiv. Controls, no, Municipal FE, no, Year FE, yes, Cluster RSE, no)

quietly xi: xtreg `y' `x' i.year, fe
outreg2 using DiD-`Tablename'.xml, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(2) keep(`x') addtext(Indiv. Controls, no, Municipal FE, yes, Year FE, yes, Cluster RSE, no)

quietly xi: xtreg `y' `x' i.year, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.xml, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(3) keep(`x') addtext(Indiv. Controls, no, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `controlA' i.year, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.xml, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(4) keep(`controlA') addtext(Indiv. Controls, Some, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `controlB' i.year, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.xml, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(5) keep(`controlB') addtext(Indiv. Controls, Some, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `controlC' i.year, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.xml, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(6) keep(`controlC') addtext(Indiv. Controls, all, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' `controlA' i.year, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.xml, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(7) keep(`x' `controlA') addtext(Indiv. Controls, Some, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' `controlC' i.year, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.xml, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(8) keep(`x' `controlC') addtext(Indiv. Controls, all, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

*/

*------------

}









clear all

cd "H:\tax\data\DTA\WSOM"
*cd "/Volumes/YoungBros/tax copy/data/DTA"
use WSOMEstimTax, replace

cd "H:\tax\data\TABLES\WSOM"
*cd "/Volumes/YoungBros/tax copy/data/TABLES"
set matsize 10000
set more off

*Binary measure of crisis

bysort xhigh09 left_right3 year: egen xmi = mean(ecrisis)
bysort xhigh09 left_right3 year: egen ymi = mean(cuttax)


local x xmi 												/* Main Predictor variable */
local Tablename 2007&09_Cuttax@Ide_binary							/* Table Title */

local y ymi
/* Control variables */
local controlA xhigh09 ib1.chng_fin ib1.fut_fin age female edu2 ib1.inchigh ib1.class3 unemploy


keep if year == 2007 | year == 2009

sort mun_number year
set more off
xtset mun_number

quietly xi: xtreg `y' `x' i.year if left_right3 == 0, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.xml, replace title("Table 2.1 - Support for Cutting Taxes by Ideology Group - 2007 & 2009 Binary Crisis") symbol(***, **, *) alpha(0.001, 0.01, 0.05) ///
ctitle(Left) keep(`x') addtext(Indiv. Controls, no, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' i.year if left_right3 == 1, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.xml, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Center) keep(`x') addtext(Indiv. Controls, no, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' i.year if left_right3 == 2, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.xml, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Right) keep(`x') addtext(Indiv. Controls, no, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' `controlA' i.year if left_right3 == 0, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.xml, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Left) keep(`x' `controlA') addtext(Indiv. Controls, yes, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' `controlA' i.year if left_right3 == 1, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.xml, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Center) keep(`x' `controlA') addtext(Indiv. Controls, yes, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' `controlA' i.year if left_right3 == 2, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.xml, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Right) keep(`x' `controlA') addtext(Indiv. Controls, yes, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)








clear all

cd "H:\tax\data\DTA\WSOM"
use WSOMEstimTax, replace

keep if year == 2007 | year == 2009
sort mun_number year
xtset mun_number
set more off

xi: xtreg cuttax c.ecrisis##c.left_right3 i.year*left_right3 i.mun_number*left_right3, fe cluster(mun_number)
margins, dydx(ecrisis) at(left_right3=(0(1)2)) vsquish
marginsplot, recast(line) recastci(rline) ciopts(lpattern(dash)) yline(0) xtitle("Left to Right Ideology") ytitle("Marginal Impact of Crisis (2009) on support for Reducing Taxes")



xi: xtreg cuttax c.ecrisis##c.left_right3 i.year*left_right3 i.mun_number*left_right3 ib1.chng_fin ib1.fut_fin age inc female edu2 class2, fe cluster(mun_number)
margins, dydx(ecrisis) at(left_right3=(0(1)2)) vsquish
marginsplot, recast(line) recastci(rline) ciopts(lpattern(dash)) yline(0) xtitle("Left to Right Ideology") ytitle("Marginal Impact of Crisis (2009) on support for Reducing Taxes")



*--------------------------


*this is crap dont use it
/*
clear all

cd "H:\tax\data\DTA\WSOM"
use WSOMEstimTax, replace

gen CrisIde3 = ecrisis*left_right3
gen AgeIde3 = age*left_right3

keep if year == 2007 | year == 2009
sort mun_number year
xtset mun_number
set more off


xi: xtreg cuttax ecrisis left_right3 CrisIde3 i.year*i.left_right3 i.mun_number*i.left_right3 i.chng_fin*i.left_right3 i.fut_fin*i.left_right3 AgeIde3 i.inchigh*i.left_right3 i.female*i.left_right3 i.edu2*i.left_right3 i.class2*i.left_right3, fe cluster(mun_number)
margins, dydx(ecrisis) at(left_right3=(0(1)2)) vsquish
marginsplot, recast(line) recastci(rline) ciopts(lpattern(dash)) yline(0) xtitle("Left to Right Ideology") ytitle("Marginal Impact of Crisis (2009) on support for Reducing Taxes")



* Run diff-in-diff-in-diff (corresponding to subtracting high-income DD estimate from low-income DD estimate

gen xinchighA = x*inchighA											/* generate binary interaction variable to reproduce figures */
gen xinc = x*inc													/* generate binary interaction variable */
gen xmiInc = xmi*inc
gen xmiInchighA = xmi*inchighA

keep if year == 2007 | year == 2009

xi: xtreg y x xinc inc i.year, fe i(mun_number)							/* this is basically your interactive estimates */
xi: xtreg y x xinchigh inc i.year, fe i(mun_number)						/* binary interactive estimates */

* I have thought: the DDD needs year specific income effects (allow income to have different effect each year
* Can be implemented in stata as i.year*inc, read in "xi:" command. Can also separately create income*year variable

xi: xtreg y x xinc i.year*inc, fe i(mun_number)							/* now, no effects left, which confirms what we see in interactive figure */
xi: xtreg y x xinchigh inc i.year*inc, fe i(mun_number)					/* even with binary income groups */

*/










clear all

cd "H:\tax\data\DTA\WSOM"
*cd "/Volumes/YoungBros/tax copy/data/DTA"
use WSOMEstimTax, replace

local x ecrisis												/* Main Predictor variable */
local y cuttax
local controlA ib1.left_right3 ib1.chng_fin ib1.fut_fin age agesqr female edu2 ib1.inchigh ib1.class3 unemploy
*local controlA age agesqr female edu2 ib1.inchigh ib1.class3 unemploy

keep if year == 2007 | year == 2009

sort mun_number year
set more off
xtset mun_number

xi: xtreg `y' `x' `controlA' i.year, fe cluster(mun_number)




*-------------------------------------------------------------------

*-----------------------
** ROBUSTNESS test
*-----------------------


clear all

cd "H:\tax\data\DTA\WSOM"
*cd "/Volumes/YoungBros/tax copy/data/DTA"
use WSOMEstimTax, replace

cd "H:\tax\data\TABLES\WSOM"
*cd "/Volumes/YoungBros/tax copy/data/TABLES"
set matsize 10000
set more off


local x ecrisis												/* Main Predictor variable */
*local Tablename 2006_2009_Cuttax@Ide							/* Table Title */
local Tablename ALL_Cuttax@Ide							/* Table Title */


local y cuttax
/* Control variables */
local controlA ib1.chng_fin ib1.fut_fin age agesqr female edu2 ib1.inchigh ib1.class3 unemploy

drop if year == 2008


sort mun_number year
set more off
xtset mun_number


quietly xi: xtreg `y' `x' i.year if left_right3 == 0, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.doc, replace title("Table ? - Support for Cutting Taxes by Ideology Group") symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Left) keep(`x') addtext(Indiv. Controls, no, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' i.year if left_right3 == 1, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.doc, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Center) keep(`x') addtext(Indiv. Controls, no, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' i.year if left_right3 == 2, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.doc, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Right) keep(`x') addtext(Indiv. Controls, no, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' `controlA' i.year if left_right3 == 0, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.doc, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Left) keep(`x' `controlA') addtext(Indiv. Controls, yes, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' `controlA' i.year if left_right3 == 1, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.doc, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Center) keep(`x' `controlA') addtext(Indiv. Controls, yes, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)

quietly xi: xtreg `y' `x' `controlA' i.year if left_right3 == 2, fe cluster(mun_number)
outreg2 using DiD-`Tablename'.doc, append symbol(***, **, *) alpha(0.001, 0.01, 0.05) ctitle(Right) keep(`x' `controlA') addtext(Indiv. Controls, yes, Municipal FE, yes, Year FE, yes, Cluster RSE, yes)
