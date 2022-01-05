
clear all
set more off


cd "/Users/youngster/Documents/GitHub/tax_project/data/do_file"
run "wsom_survey_05_10.do" /* survey clean and org.  */

cd "/Users/youngster/Documents/GitHub/tax_project/data/do_file"
run "mun_pop_yr.do" /* import municipal population stats. and clean */

cd "/Users/youngster/Documents/GitHub/tax_project/data/do_file"
run "mun_ue_month.do" /* import municipal unemployment stats. and clean */

cd "/Users/youngster/Documents/GitHub/tax_project/data/do_file"
run "pop_ue_merge.do" /* merge population and unemployment stats. and clean */

cd "/Users/youngster/Documents/GitHub/tax_project/data/do_file"
run "survey_labor_merge.do" /* merge survey and labor stats. */

cd "/Users/youngster/Documents/GitHub/tax_project/data/do_file"
run "curate_tax.do" /* create variables and clean data for running statisitcal analysis */
