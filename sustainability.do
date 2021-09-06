/*

This do file replicates the main analyses conducted in:

Nakajima, N., Hasan, A., Jung, H., Kinnell, A., Maika, A., & Pradhan, M. (2021). 
Built to Last: Sustainability of Early Childhood Education Services in Rural Indonesia. 
The Journal of Development Studies, 1-20.

(https://www.tandfonline.com/doi/full/10.1080/00220388.2021.1873283) 

*/


set matsize 11000
set scheme lean2

tempfile a b


u "panel_village_facility_2010-2016 long v12.dta", replace


*------------------------------------------------------------------------------*
* Key tables, figures, and statistics in our paper
*------------------------------------------------------------------------------*

*------------------------------------------------------------------------------*
* Figure 1*
*------------------------------------------------------------------------------*

// Conceptual framework diagram


*------------------------------------------------------------------------------*
* Figure 2 *
*------------------------------------------------------------------------------*

// Data for Figure 2a
preserve

keep if sample2==1

replace closed_dateyr = 2013 if sample2==1 & closed_dateyr<2013
 
gen open2010 = 1 if tpk==1
gen open2011 = 1 if tpk==1
  replace open2011 = 0 if tpk==1 & closed_dateyr<=2011
gen open2012 = 1 if tpk==1
  replace open2012 = 0 if tpk==1 & closed_dateyr<=2012
gen open2013 = 1 if tpk==1
  replace open2013 = 0 if tpk==1 & closed_dateyr<=2013
gen open2014 = 1 if tpk==1
  replace open2014 = 0 if tpk==1 & closed_dateyr<=2014
gen open2015 = 1 if tpk==1
  replace open2015 = 0 if tpk==1 & closed_dateyr<=2015
gen open2016 = 1 if tpk==1 
  replace open2016 = 0 if tpk==1 & closed_dateyr<=2016

keep if year==4
summ open20* 

reshape long open, i(facilityid) j(time)
bysort time: tab open

restore


// Data for Figure 2b
preserve

keep if sample2==1

gen ts2010 = 1 if tc_proj == 1 & year == 2
gen ts2013 = 1 if tc_proj == 1 & year == 3
gen ts2016 = 1 if tc_proj == 1 & year == 4
bysort facilityid: egen twoteach2010 = min(ts2010)
bysort facilityid: egen twoteach2013 = min(ts2013)
bysort facilityid: egen twoteach2016 = min(ts2016)
replace twoteach2010 = 0 if missing(twoteach2010)
replace twoteach2013 = 0 if missing(twoteach2013)
replace twoteach2016 = 0 if missing(twoteach2016)

keep if year==4
summ twoteach20*

reshape long twoteach, i(facilityid) j(time)
bysort time: tab twoteach

restore


// Data for Figure 2c
preserve

keep if sample2==1

gen ts2010 = 1 if tc_proj == 2 & year == 2
gen ts2013 = 1 if tc_proj == 2 & year == 3
gen ts2016 = 1 if tc_proj == 2 & year == 4
bysort facilityid: egen twoteach2010 = min(ts2010)
bysort facilityid: egen twoteach2013 = min(ts2013)
bysort facilityid: egen twoteach2016 = min(ts2016)
replace twoteach2010 = 0 if missing(twoteach2010)
replace twoteach2013 = 0 if missing(twoteach2013)
replace twoteach2016 = 0 if missing(twoteach2016)

keep if year==4
summ twoteach20*

reshape long twoteach, i(facilityid) j(time)
bysort time: tab twoteach

restore


// Input data for plotting Figure 2
preserve
clear
input year open one two
2010 1 .6857 .2898
2011 1 . .
2012 1 . .
2013 .9551 .6041 .3143
2014 .9306 . .
2015 .9224 . .
2016 .9184 .4041 .3469
end

twoway (con open year, mcolor(black) msymbol(o) lcolor(black) lpattern(solid)) ///
	   (con one year, mcolor(black) msymbol(th) lcolor(black) lpattern(shortdash_dot)) ///
	   (con two year, mcolor(black) msymbol(oh)lcolor(black) lpattern(dash)), ///
  xtitle(Year) xlabel(2010(1)2017, nogrid) ylabel(0(0.2)1.2, nogrid) ///
  ytitle(Proportion of centers) ///
  legend(label(1 "Open center") label(2 "Open & 1 trained teacher") label(3 "Open & 2+ trained teachers") col(1) pos(6)) ///
  xline(2013, lpattern(dash) lcolor(gs10)) ///
  text(1.13 2010.3 "100%" "(N=245)") ///
  text(1.04 2013.4 "95.51%") ///
  text(1.00 2016.4 "91.84%") ///
  text(0.75 2010.3 "68.57%") ///
  text(0.65 2013.4 "60.41%") ///
  text(0.41 2016.4 "40.41%") ///
  text(0.23 2010.3 "28.98%") ///
  text(0.25 2013.4 "31.43%") ///
  text(0.30 2016.4 "34.69%") 
graph export figure2.pdf, replace

restore  
*/

* Compare Figure 2 to closure of other ECD *
*------------------------------------------------------------------------------*

tab closed_facility center_type if year == 4

	// kindergarten:
	di (50 - 3 + 66 - 3) / (50 + 66)

	
*------------------------------------------------------------------------------*
* Table 4*
*------------------------------------------------------------------------------*

estimates drop _all 
foreach var in closed_whyB closed_whyA closed_whyC closed_whyE closed_whyD ///
closed_builduse3 closed_builduse2 closed_builduse4 closed_builduse1 ///
closed_toysuse3 closed_toysuse2 closed_toysuse1 ///
closed_teachCpct closed_teachApct closed_teachBpct closed_teachVYpct closed_teachDpct {
estpost tabstat `var' if sample1==1 & year==4 & closed_facility==1, statistics(mean sd) columns(statistics) listwise
est store `var'
}
esttab closed_whyB closed_whyA closed_whyC closed_whyE closed_whyD ///
closed_builduse3 closed_builduse2 closed_builduse4 closed_builduse1 ///
closed_toysuse3 closed_toysuse2 closed_toysuse1 ///
closed_teachCpct closed_teachApct closed_teachBpct closed_teachVYpct closed_teachDpct ///
using "$output/table4_all.csv", replace cells("mean(fmt(2)) sd(par fmt(2))") label	


estimates drop _all 
foreach var in closed_whyB closed_whyA closed_whyC closed_whyE closed_whyD ///
closed_builduse3 closed_builduse2 closed_builduse4 closed_builduse1 ///
closed_toysuse3 closed_toysuse2 closed_toysuse1 ///
closed_teachCpct closed_teachApct closed_teachBpct closed_teachVYpct closed_teachDpct{
estpost tabstat `var' if sample2==1 & year==4 & closed_facility==1, statistics(mean sd) columns(statistics) listwise
est store `var'
}
esttab closed_whyB closed_whyA closed_whyC closed_whyE closed_whyD ///
closed_builduse3 closed_builduse2 closed_builduse4 closed_builduse1 ///
closed_toysuse3 closed_toysuse2 closed_toysuse1 ///
closed_teachCpct closed_teachApct closed_teachBpct closed_teachVYpct closed_teachDpct ///
using "$output/table4_balpal.csv", replace cells("mean(fmt(2)) sd(par fmt(2))") label	


*------------------------------------------------------------------------------*
* Appendix Table 1 *
*------------------------------------------------------------------------------*

replace sample2=0 if sample1==1 & sample2==.

*check if difference is signficant between total sample & balanced panel 
gen dummy=0 if sample1==1 & sample2==1
replace dummy=1 if sample1==1 & sample2==0


estimates drop _all 
foreach var in ///
shared_adm shared_child shared_infra shared_teacher shared_outsup ///
fee_freq4 fee_mand_n ///
teacher_edu_pspct teacher_exppct ///
center_number teacher_total center_sched hoursperday ///
nratkchd nnonplgchd dist_center dist_fac1 ///
supp1 supp2 supp3 zparentinv zwealth_va {
estpost tabstat `var' if dummy==0 & year==2, statistics(mean sd) columns(statistics) listwise
est store `var'
}
esttab shared_adm shared_child shared_infra shared_teacher shared_outsup ///
fee_freq4 fee_mand_n ///
teacher_edu_pspct teacher_exppct ///
center_number teacher_total center_sched hoursperday ///
nratkchd nnonplgchd dist_center dist_fac1 ///
supp1 supp2 supp3 zparentinv zwealth_va ///
using "$output/appendix1_panel.csv", replace cells("mean(fmt(2)) sd(par fmt(2))") label

estimates drop _all 
foreach var in ///
shared_adm shared_child shared_infra shared_teacher shared_outsup ///
fee_freq4 fee_mand_n ///
teacher_edu_pspct teacher_exppct ///
center_number teacher_total center_sched hoursperday ///
nratkchd nnonplgchd dist_center dist_fac1 ///
supp1 supp2 supp3 zparentinv zwealth_va {
estpost tabstat `var' if dummy==1 & year==2, statistics(mean sd) columns(statistics) listwise
est store `var'
}
esttab shared_adm shared_child shared_infra shared_teacher shared_outsup ///
fee_freq4 fee_mand_n ///
teacher_edu_pspct teacher_exppct ///
center_number teacher_total center_sched hoursperday ///
nratkchd nnonplgchd dist_center dist_fac1 ///
supp1 supp2 supp3 zparentinv zwealth_va ///
using "$output/appendix1_nonpanel.csv", replace cells("mean(fmt(2)) sd(par fmt(2))") label		 



mat drop _all
foreach var in ///
shared_adm shared_child shared_infra shared_teacher shared_outsup ///
fee_freq4 fee_mand_n ///
teacher_edu_pspct teacher_exppct ///
center_number teacher_total center_sched hoursperday ///
nratkchd nnonplgchd dist_center dist_fac1 ///
supp1 supp2 supp3 zparentinv zwealth_va {
reg `var' dummy if year==2, clus(facid) 
est store `var'
}
esttab shared_adm shared_child shared_infra shared_teacher shared_outsup ///
fee_freq4 fee_mand_n ///
teacher_edu_pspct teacher_exppct ///
center_number teacher_total center_sched hoursperday ///
nratkchd nnonplgchd dist_center dist_fac1 ///
supp1 supp2 supp3 zparentinv zwealth_va ///
using "$output/appendix1_diff.csv", replace drop (_cons) b(2) se(2)



* Generate key outcome variable in 2016*
*------------------------------------------------------------------------------*

gen depvar2 = 0 if depvar1 == 0
replace depvar2 = 1 if depvar1 == 1
replace depvar2 = 2 if depvar4 == 1

la var depvar2 "One/Two trained teachers"

bysort year: summ depvar1 depvar2
bysort year: tab depvar2


*------------------------------------------------------------------------------*
keep if sample2 == 1
*------------------------------------------------------------------------------*



*------------------------------------------------------------------------------*
/* Appendix Table 2 *
*------------------------------------------------------------------------------*

estimates drop _all
foreach var in ///
shared_adm shared_child shared_infra shared_teacher shared_outsup ///
fee_freq4 fee_mand_n ///
teacher_edu_pspct teacher_exppct ///
center_number teacher_total center_sched hoursperday ///
nratkchd nnonplgchd dist_center dist_fac1 ///
supp1 supp2 supp3 zparentinv zwealth_va {
estpost tabstat `var' if year == 2, by(depvar1) statistics(mean sd min max n) columns(statistics) listwise
est store `var'
}
esttab ///
shared_adm shared_child shared_infra shared_teacher shared_outsup ///
fee_freq4 fee_mand_n ///
teacher_edu_pspct teacher_exppct ///
center_number teacher_total center_sched hoursperday ///
nratkchd nnonplgchd dist_center dist_fac1 ///
supp1 supp2 supp3 zparentinv zwealth_va ///
using "$output/table2_2010.csv", replace cells("mean(fmt(2)) sd(par fmt(2))") label


estimates drop _all
foreach var in ///
af1 af3 af4 ///
shared_adm shared_child shared_infra shared_teacher shared_outsup ///
fee_freq4 fee_mand_n ///
standards_indonesia ///
teacher_edu_pspct teacher_exppct ///
center_number teacher_total center_sched hoursperday ///
nratkchd nnonplgchd dist_center dist_fac1 ///
supp1 supp2 supp3 zparentinv zwealth_va {
estpost tabstat `var' if year == 3, by(depvar1) statistics(mean sd min max n) columns(statistics) listwise
est store `var'
}
esttab ///
af1 af3 af4 ///
shared_adm shared_child shared_infra shared_teacher shared_outsup ///
fee_freq4 fee_mand_n ///
standards_indonesia ///
teacher_edu_pspct teacher_exppct ///
center_number teacher_total center_sched hoursperday ///
nratkchd nnonplgchd dist_center dist_fac1 ///
supp1 supp2 supp3 zparentinv zwealth_va ///
using "$output/table2_2013.csv", replace cells("mean(fmt(2)) sd(par fmt(2))") label


estimates drop _all
foreach var in ///
af1 af3 af4 ///
fee_freq4 fee_mand_n ///
teacher_edu_pspct teacher_exppct ///
center_number teacher_total center_sched hoursperday ///
nratkchd nnonplgchd dist_center dist_fac1 ///
supp1 supp2 supp3 zparentinv zwealth_va {
estpost tabstat `var' if year == 4, by(depvar1) statistics(mean sd min max n) columns(statistics) listwise
est store `var'
}
esttab ///
af1 af3 af4 ///
fee_freq4 fee_mand_n ///
teacher_edu_pspct teacher_exppct ///
center_number teacher_total center_sched hoursperday ///
nratkchd nnonplgchd dist_center dist_fac1 ///
supp1 supp2 supp3 zparentinv zwealth_va ///
using "$output/table2_2016.csv", replace cells("mean(fmt(2)) sd(par fmt(2))") label


*check if difference is signficant between groups:

estimates drop _all
foreach var in ///
shared_adm shared_child shared_infra shared_teacher shared_outsup ///
fee_freq4 fee_mand_n ///
teacher_edu_pspct teacher_exppct ///
center_number teacher_total center_sched hoursperday ///
nratkchd nnonplgchd dist_center dist_fac1 ///
supp1 supp2 supp3 zparentinv zwealth_va {
reg `var' i.depvar1 if year==2, cluster(facid) 
est store `var'
}
esttab ///
shared_adm shared_child shared_infra shared_teacher shared_outsup ///
fee_freq4 fee_mand_n ///
teacher_edu_pspct teacher_exppct ///
center_number teacher_total center_sched hoursperday ///
nratkchd nnonplgchd dist_center dist_fac1 ///
supp1 supp2 supp3 zparentinv zwealth_va ///
using "$output/table2_2010_diff.csv", replace drop (_cons) b(2) se(2) 

estimates drop _all
foreach var in ///
af1 af3 af4 ///
shared_adm shared_child shared_infra shared_teacher shared_outsup ///
fee_freq4 fee_mand_n ///
standards_indonesia ///
teacher_edu_pspct teacher_exppct ///
center_number teacher_total center_sched hoursperday ///
nratkchd nnonplgchd dist_center dist_fac1 ///
supp1 supp2 supp3 zparentinv zwealth_va {
reg `var' i.depvar1 if year==3, cluster(facid) 
est store `var'
}
esttab ///
af1 af3 af4 ///
shared_adm shared_child shared_infra shared_teacher shared_outsup ///
fee_freq4 fee_mand_n ///
standards_indonesia ///
teacher_edu_pspct teacher_exppct ///
center_number teacher_total center_sched hoursperday ///
nratkchd nnonplgchd dist_center dist_fac1 ///
supp1 supp2 supp3 zparentinv zwealth_va ///
using "$output/table2_2013_diff.csv", replace drop (_cons) b(2) se(2) 


*check if difference is signficant across time:

foreach var in ///
af1 af3 af4 ///
shared_adm shared_child shared_infra shared_teacher shared_outsup ///
fee_freq4 fee_mand_n ///
standards_indonesia ///
teacher_edu_pspct teacher_exppct ///
center_number teacher_total center_sched hoursperday ///
nratkchd nnonplgchd dist_center dist_fac1 ///
supp1 supp2 supp3 zparentinv zwealth_va {
reg `var' ib2.year if depvar1==0, cluster(facid) 
est store `var'
}
esttab af1 af3 af4 ///
shared_adm shared_child shared_infra shared_teacher shared_outsup ///
fee_freq4 fee_mand_n ///
standards_indonesia ///
teacher_edu_pspct teacher_exppct ///
center_number teacher_total center_sched hoursperday ///
nratkchd nnonplgchd dist_center dist_fac1 ///
supp1 supp2 supp3 zparentinv zwealth_va ///
using "$output/table2_diff1.csv", replace drop (_cons) b(2) se(2) 

foreach var in ///
af1 af3 af4 ///
shared_adm shared_child shared_infra shared_teacher shared_outsup ///
fee_freq4 fee_mand_n ///
standards_indonesia ///
teacher_edu_pspct teacher_exppct ///
center_number teacher_total center_sched hoursperday ///
nratkchd nnonplgchd dist_center dist_fac1 ///
supp1 supp2 supp3 zparentinv zwealth_va {
reg `var' ib2.year if depvar1==1, cluster(facid) 
est store `var'
}
esttab af1 af3 af4 ///
shared_adm shared_child shared_infra shared_teacher shared_outsup ///
fee_freq4 fee_mand_n ///
standards_indonesia ///
teacher_edu_pspct teacher_exppct ///
center_number teacher_total center_sched hoursperday ///
nratkchd nnonplgchd dist_center dist_fac1 ///
supp1 supp2 supp3 zparentinv zwealth_va ///
using "$output/table2_diff2.csv", replace drop (_cons) b(2) se(2) 


foreach var in af1 af3 af4 ///
shared_adm shared_child shared_infra shared_teacher shared_outsup ///
fee_freq4 fee_mand_n ///
standards_indonesia ///
teacher_edu_pspct teacher_exppct ///
center_number teacher_total center_sched hoursperday ///
nratkchd nnonplgchd dist_center dist_fac1 ///
supp1 supp2 supp3 zparentinv zwealth_va {
reg `var' ib3.year if depvar1==1, cluster(facid) 
est store `var'
}
esttab af1 af3 af4 ///
shared_adm shared_child shared_infra shared_teacher shared_outsup ///
fee_freq4 fee_mand_n ///
standards_indonesia ///
teacher_edu_pspct teacher_exppct ///
center_number teacher_total center_sched hoursperday ///
nratkchd nnonplgchd dist_center dist_fac1 ///
supp1 supp2 supp3 zparentinv zwealth_va ///
using "$output/table2_diff3.csv", replace drop (_cons) b(2) se(2) 

*/

*------------------------------------------------------------------------------*
* Appendix Table 3 *
*------------------------------------------------------------------------------*

estimates drop _all
foreach var in ///
shared_adm shared_child shared_infra shared_teacher shared_outsup ///
fee_freq4 fee_mand_n ///
teacher_edu_pspct teacher_exppct ///
center_number teacher_total center_sched hoursperday ///
nratkchd nnonplgchd dist_center dist_fac1 ///
supp1 supp2 supp3 zparentinv zwealth_va {
estpost tabstat `var' if year == 2, by(depvar2) statistics(mean sd min max n) columns(statistics) listwise
est store `var'
}
esttab ///
shared_adm shared_child shared_infra shared_teacher shared_outsup ///
fee_freq4 fee_mand_n ///
teacher_edu_pspct teacher_exppct ///
center_number teacher_total center_sched hoursperday ///
nratkchd nnonplgchd dist_center dist_fac1 ///
supp1 supp2 supp3 zparentinv zwealth_va ///
using "$output/table3_2010.csv", replace cells("mean(fmt(2)) sd(par fmt(2))") label


estimates drop _all
foreach var in ///
af1 af3 af4 ///
shared_adm shared_child shared_infra shared_teacher shared_outsup ///
fee_freq4 fee_mand_n ///
standards_indonesia ///
teacher_edu_pspct teacher_exppct ///
center_number teacher_total center_sched hoursperday ///
nratkchd nnonplgchd dist_center dist_fac1 ///
supp1 supp2 supp3 zparentinv zwealth_va {
estpost tabstat `var' if year == 3, by(depvar2) statistics(mean sd min max n) columns(statistics) listwise
est store `var'
}
esttab ///
af1 af3 af4 ///
shared_adm shared_child shared_infra shared_teacher shared_outsup ///
fee_freq4 fee_mand_n ///
standards_indonesia ///
teacher_edu_pspct teacher_exppct ///
center_number teacher_total center_sched hoursperday ///
nratkchd nnonplgchd dist_center dist_fac1 ///
supp1 supp2 supp3 zparentinv zwealth_va ///
using "$output/table3_2013.csv", replace cells("mean(fmt(2)) sd(par fmt(2))") label


estimates drop _all
foreach var in ///
af1 af3 af4 ///
fee_freq4 fee_mand_n ///
teacher_edu_pspct teacher_exppct ///
center_number teacher_total center_sched hoursperday ///
nratkchd nnonplgchd dist_center dist_fac1 ///
supp1 supp2 supp3 zparentinv zwealth_va {
estpost tabstat `var' if year == 4, by(depvar2) statistics(mean sd min max n) columns(statistics) listwise
est store `var'
}
esttab ///
af1 af3 af4 ///
fee_freq4 fee_mand_n ///
teacher_edu_pspct teacher_exppct ///
center_number teacher_total center_sched hoursperday ///
nratkchd nnonplgchd dist_center dist_fac1 ///
supp1 supp2 supp3 zparentinv zwealth_va ///
using "$output/table3_2016.csv", replace cells("mean(fmt(2)) sd(par fmt(2))") label


*check if difference is signficant between groups:

estimates drop _all
foreach var in ///
shared_adm shared_child shared_infra shared_teacher shared_outsup ///
fee_freq4 fee_mand_n ///
teacher_edu_pspct teacher_exppct ///
center_number teacher_total center_sched hoursperday ///
nratkchd nnonplgchd dist_center dist_fac1 ///
supp1 supp2 supp3 zparentinv zwealth_va {
reg `var' i.depvar2 if year==2, cluster(facid) 
est store `var'
}
esttab ///
shared_adm shared_child shared_infra shared_teacher shared_outsup ///
fee_freq4 fee_mand_n ///
teacher_edu_pspct teacher_exppct ///
center_number teacher_total center_sched hoursperday ///
nratkchd nnonplgchd dist_center dist_fac1 ///
supp1 supp2 supp3 zparentinv zwealth_va ///
using "$output/table3_2010_diff1.csv", replace drop (_cons) b(2) se(2) 


estimates drop _all
foreach var in ///
shared_adm shared_child shared_infra shared_teacher shared_outsup ///
fee_freq4 fee_mand_n ///
teacher_edu_pspct teacher_exppct ///
center_number teacher_total center_sched hoursperday ///
nratkchd nnonplgchd dist_center dist_fac1 ///
supp1 supp2 supp3 zparentinv zwealth_va {
reg `var' ib1.depvar2 if year==2, cluster(facid) 
est store `var'
}
esttab ///
shared_adm shared_child shared_infra shared_teacher shared_outsup ///
fee_freq4 fee_mand_n ///
teacher_edu_pspct teacher_exppct ///
center_number teacher_total center_sched hoursperday ///
nratkchd nnonplgchd dist_center dist_fac1 ///
supp1 supp2 supp3 zparentinv zwealth_va ///
using "$output/table3_2010_diff2.csv", replace drop (_cons) b(2) se(2) 


estimates drop _all
foreach var in ///
af1 af3 af4 ///
shared_adm shared_child shared_infra shared_teacher shared_outsup ///
fee_freq4 fee_mand_n ///
standards_indonesia ///
teacher_edu_pspct teacher_exppct ///
center_number teacher_total center_sched hoursperday ///
nratkchd nnonplgchd dist_center dist_fac1 ///
supp1 supp2 supp3 zparentinv zwealth_va {
reg `var' i.depvar2 if year==3, cluster(facid) 
est store `var'
}
esttab ///
af1 af3 af4 ///
shared_adm shared_child shared_infra shared_teacher shared_outsup ///
fee_freq4 fee_mand_n ///
standards_indonesia ///
teacher_edu_pspct teacher_exppct ///
center_number teacher_total center_sched hoursperday ///
nratkchd nnonplgchd dist_center dist_fac1 ///
supp1 supp2 supp3 zparentinv zwealth_va ///
using "$output/table3_2013_diff1.csv", replace drop (_cons) b(2) se(2) 

estimates drop _all
foreach var in ///
af1 af3 af4 ///
shared_adm shared_child shared_infra shared_teacher shared_outsup ///
fee_freq4 fee_mand_n ///
standards_indonesia ///
teacher_edu_pspct teacher_exppct ///
center_number teacher_total center_sched hoursperday ///
nratkchd nnonplgchd dist_center dist_fac1 ///
supp1 supp2 supp3 zparentinv zwealth_va {
reg `var' ib1.depvar2 if year==3, cluster(facid) 
est store `var'
}
esttab ///
af1 af3 af4 ///
shared_adm shared_child shared_infra shared_teacher shared_outsup ///
fee_freq4 fee_mand_n ///
standards_indonesia ///
teacher_edu_pspct teacher_exppct ///
center_number teacher_total center_sched hoursperday ///
nratkchd nnonplgchd dist_center dist_fac1 ///
supp1 supp2 supp3 zparentinv zwealth_va ///
using "$output/table3_2013_diff2.csv", replace drop (_cons) b(2) se(2) 


estimates drop _all
foreach var in ///
af1 af3 af4 ///
fee_freq4 fee_mand_n ///
teacher_edu_pspct teacher_exppct ///
center_number teacher_total center_sched hoursperday ///
nratkchd nnonplgchd dist_center dist_fac1 ///
supp1 supp2 supp3 zparentinv zwealth_va {
reg `var' ib1.depvar2 if year==4, cluster(facid) 
est store `var'
}
esttab ///
af1 af3 af4 ///
fee_freq4 fee_mand_n ///
teacher_edu_pspct teacher_exppct ///
center_number teacher_total center_sched hoursperday ///
nratkchd nnonplgchd dist_center dist_fac1 ///
supp1 supp2 supp3 zparentinv zwealth_va ///
using "$output/table3_2016_diff2.csv", replace drop (_cons) b(2) se(2) 


*check if difference is signficant across time:

foreach var in ///
af1 af3 af4 ///
shared_adm shared_child shared_infra shared_teacher shared_outsup ///
fee_freq4 fee_mand_n ///
standards_indonesia ///
teacher_edu_pspct teacher_exppct ///
center_number teacher_total center_sched hoursperday ///
nratkchd nnonplgchd dist_center dist_fac1 ///
supp1 supp2 supp3 zparentinv zwealth_va {
reg `var' ib2.year if depvar2==0, cluster(facid) 
est store `var'
}
esttab af1 af3 af4 ///
shared_adm shared_child shared_infra shared_teacher shared_outsup ///
fee_freq4 fee_mand_n ///
standards_indonesia ///
teacher_edu_pspct teacher_exppct ///
center_number teacher_total center_sched hoursperday ///
nratkchd nnonplgchd dist_center dist_fac1 ///
supp1 supp2 supp3 zparentinv zwealth_va ///
using "$output/table3_diff1.csv", replace drop (_cons) b(2) se(2) 

foreach var in ///
af1 af3 af4 ///
shared_adm shared_child shared_infra shared_teacher shared_outsup ///
fee_freq4 fee_mand_n ///
standards_indonesia ///
teacher_edu_pspct teacher_exppct ///
center_number teacher_total center_sched hoursperday ///
nratkchd nnonplgchd dist_center dist_fac1 ///
supp1 supp2 supp3 zparentinv zwealth_va {
reg `var' ib2.year if depvar2==1, cluster(facid) 
est store `var'
}
esttab af1 af3 af4 ///
shared_adm shared_child shared_infra shared_teacher shared_outsup ///
fee_freq4 fee_mand_n ///
standards_indonesia ///
teacher_edu_pspct teacher_exppct ///
center_number teacher_total center_sched hoursperday ///
nratkchd nnonplgchd dist_center dist_fac1 ///
supp1 supp2 supp3 zparentinv zwealth_va ///
using "$output/table3_diff2.csv", replace drop (_cons) b(2) se(2) 

foreach var in ///
af1 af3 af4 ///
shared_adm shared_child shared_infra shared_teacher shared_outsup ///
fee_freq4 fee_mand_n ///
standards_indonesia ///
teacher_edu_pspct teacher_exppct ///
center_number teacher_total center_sched hoursperday ///
nratkchd nnonplgchd dist_center dist_fac1 ///
supp1 supp2 supp3 zparentinv zwealth_va {
reg `var' ib2.year if depvar2==2, cluster(facid) 
est store `var'
}
esttab af1 af3 af4 ///
shared_adm shared_child shared_infra shared_teacher shared_outsup ///
fee_freq4 fee_mand_n ///
standards_indonesia ///
teacher_edu_pspct teacher_exppct ///
center_number teacher_total center_sched hoursperday ///
nratkchd nnonplgchd dist_center dist_fac1 ///
supp1 supp2 supp3 zparentinv zwealth_va ///
using "$output/table3_diff3.csv", replace drop (_cons) b(2) se(2) 

foreach var in ///
af1 af3 af4 ///
shared_adm shared_child shared_infra shared_teacher shared_outsup ///
fee_freq4 fee_mand_n ///
standards_indonesia ///
teacher_edu_pspct teacher_exppct ///
center_number teacher_total center_sched hoursperday ///
nratkchd nnonplgchd dist_center dist_fac1 ///
supp1 supp2 supp3 zparentinv zwealth_va {
reg `var' ib3.year if depvar2==1, cluster(facid) 
est store `var'
}
esttab af1 af3 af4 ///
shared_adm shared_child shared_infra shared_teacher shared_outsup ///
fee_freq4 fee_mand_n ///
standards_indonesia ///
teacher_edu_pspct teacher_exppct ///
center_number teacher_total center_sched hoursperday ///
nratkchd nnonplgchd dist_center dist_fac1 ///
supp1 supp2 supp3 zparentinv zwealth_va ///
using "$output/table3_diff4.csv", replace drop (_cons) b(2) se(2) 

foreach var in ///
af1 af3 af4 ///
shared_adm shared_child shared_infra shared_teacher shared_outsup ///
fee_freq4 fee_mand_n ///
standards_indonesia ///
teacher_edu_pspct teacher_exppct ///
center_number teacher_total center_sched hoursperday ///
nratkchd nnonplgchd dist_center dist_fac1 ///
supp1 supp2 supp3 zparentinv zwealth_va {
reg `var' ib3.year if depvar2==2, cluster(facid) 
est store `var'
}
esttab af1 af3 af4 ///
shared_adm shared_child shared_infra shared_teacher shared_outsup ///
fee_freq4 fee_mand_n ///
standards_indonesia ///
teacher_edu_pspct teacher_exppct ///
center_number teacher_total center_sched hoursperday ///
nratkchd nnonplgchd dist_center dist_fac1 ///
supp1 supp2 supp3 zparentinv zwealth_va ///
using "$output/table3_diff5.csv", replace drop (_cons) b(2) se(2) 


*------------------------------------------------------------------------------*
* FIGURE 3
*------------------------------------------------------------------------------*

* Amount of money received

preserve

keep facid year depvar1 af1 af3 af4
rename (af1 af3 af4) (af1 af2 af3)  

reshape long af, i(facid year) j(category)

save tempfile, replace
statsby, by(category year depvar1) : ci mean af

generate order = _n

twoway (bar mean order if depvar1 == 0) ///
	   (bar mean order if depvar1 == 1) ///
       (rcap ub lb order), ///
       legend(row(1) order(1 "Closed in 2016" 2 "Open in 2016") pos(6) ) ///
       xlabel(3.5 "2013"  4.5`" " "   "Government" "' 5.5 "2016" ///
	          9.5 "2013" 10.5`" " "   "Non-govt org" "'11.5 "2016" ///
			  15.5 "2013" 16.5`" " "   "Local community" "'17.5 "2016", noticks) ///
	   ylabel(,nogrid) ///	  
	   xtitle("Year & Source of Funding", height(8)) ///
	   ytitle("Amount (million IDR)") 

	   graph export "$output/fig3a.pdf", replace
	   
restore


preserve

keep facid year depvar2 af1 af3 af4
rename (af1 af3 af4) (af1 af2 af3)  

reshape long af, i(facid year) j(category)

save tempfile, replace
statsby, by(category year depvar2) : ci mean af

drop if year == 2

generate order = _n
replace order = order + 1 if order > 6
replace order = order + 1 if order > 13

twoway (bar mean order if depvar2 == 0) ///
	   (bar mean order if depvar2 == 1) ///
	   (bar mean order if depvar2 == 2) ///
       (rcap ub lb order), ///
       legend(col(1) order(1 "Closed in 2016" 2 "Open w/ 1 teacher in 2016" 3 "Open w/ 2+ trained teachers in 2016") pos(6) ) ///
       xlabel(2 "2013"  3.5`" " "   "Government" "' 5 "2016" ///
	          9 "2013" 10.5`" " "   "Non-govt org" "' 12 "2016" ///
			  16 "2013" 17.5`" " "   "Local community" "' 19 "2016", noticks) ///
	   ylabel(-10(10)40, nogrid) ///	  
	   xtitle("Year & Source of Funding", height(8)) ///
	   ytitle("Amount (million IDR)") 

	   graph export "$output/fig3a_2.pdf", replace
	   
restore


* Percent spent on...

preserve

keep facid year depvar1 shared_adm shared_child shared_infra shared_teacher shared_outsup
rename (shared_adm shared_child shared_infra shared_teacher shared_outsup) (s1 s2 s3 s4 s5)  

reshape long s, i(facid year) j(category)

save tempfile, replace
statsby, by(category year depvar1) : ci mean s

generate order = _n

twoway (bar mean order if depvar1 == 0) ///
	   (bar mean order if depvar1 == 1) ///
       (rcap ub lb order), ///
       legend(row(1) order(1 "Closed in 2016" 2 "Open in 2016") pos(6) ) ///
       xlabel(1.5 "2010" 2.5`" " " "Admin" "' 3.5 "2013" ///
	          7.5 "2010" 8.5`" " "  "Children" "' 9.5 "2013" ///
			  13.5 "2010" 14.5`" " " "Infrastructure" "' 15.5 "2013" ///
			  19.5 "2010" 20.5`" " " "Teachers" "' 21.5 "2013" ///
			  25.5 "2010" 26.5`" " " "Outreach" "' 27.5 "2013" ///
			  , noticks) ///
	   ylabel(,nogrid) ///	  	  
	   xtitle("Year & Spending Category", height(8)) ///
	   ytitle("Proportion of project block grant spent annually") 

	   graph export "$output/fig3b.pdf", replace
	   
restore


preserve

keep facid year depvar2 shared_adm shared_child shared_infra shared_teacher shared_outsup
rename (shared_adm shared_child shared_infra shared_teacher shared_outsup) (s1 s2 s3 s4 s5)  

reshape long s, i(facid year) j(category)

save tempfile, replace
statsby, by(category year depvar2) : ci mean s

drop if year == 4

generate order = _n
replace order = order + 1 if order > 3
replace order = order + 1 if order > 7
replace order = order + 1 if order > 11
replace order = order + 1 if order > 15
replace order = order + 1 if order > 19
replace order = order + 1 if order > 23
replace order = order + 1 if order > 27
replace order = order + 1 if order > 31
replace order = order + 1 if order > 35

twoway (bar mean order if depvar2 == 0) ///
	   (bar mean order if depvar2 == 1) ///
	   (bar mean order if depvar2 == 2) ///
       (rcap ub lb order), ///
       legend(col(1) order(1 "Closed in 2016" 2 "Open w/ 1 teacher in 2016" 3 "Open w/ 2+ trained teachers in 2016") pos(6) ) ///
       xlabel(2 "2010" 4`" " " "Admin" "' 6 "2013" ///
	          10 "2010" 12`" " "  "Children" "' 14 "2013" ///
			  18 "2010" 20`" " " "Infrastructure" "' 22 "2013" ///
			  26 "2010" 28`" " " "Teachers" "' 30 "2013" ///
			  34 "2010" 36`" " " "Outreach" "' 38 "2013" ///
			  , noticks) ///
	   ylabel(-.1(0.1)0.5, nogrid) ///	  	  
	   xtitle("Year & Spending Category", height(8)) ///
	   ytitle("Prop. of project block" "grant spent annually") 

	   graph export "$output/fig3b_2.pdf", replace
	   
restore


* Percent of children attending with no fee 

preserve

keep facid year depvar1 fee_freq4
 
save tempfile, replace
statsby, by(year depvar1) : ci mean fee_freq4

generate order = 1 if year == 2 & depvar == 0
replace order = 2 if year == 2 & depvar == 1
replace order = 4 if year == 3 & depvar == 0
replace order = 5 if year == 3 & depvar == 1
replace order = 7 if year == 4 & depvar == 0
replace order = 8 if year == 4 & depvar == 1


twoway (bar mean order if depvar1 == 0) ///
	   (bar mean order if depvar1 == 1) ///
       (rcap ub lb order), ///
       legend(row(1) order(1 "Closed in 2016" 2 "Open in 2016") pos(6) ) ///
       xlabel(1.5 "2010" 4.5 "2013" 7.5 "2016", noticks) ///
	   ylabel(,nogrid) ///	  	  
	   xtitle("Year", height(8)) ///
	   ytitle("Prop. children attending w/ no fee") ///
	   ylabel(0(.2)1)

	   graph export "$output/fig3c.pdf", replace	   
	   	   
restore


preserve

keep facid year depvar2 fee_freq4
 
save tempfile, replace
statsby, by(year depvar2) : ci mean fee_freq4

generate order = 1 if year == 2 & depvar2 == 0
replace order = 2 if year == 2 & depvar2 == 1
replace order = 3 if year == 2 & depvar2 == 2

replace order = 5 if year == 3 & depvar2 == 0
replace order = 6 if year == 3 & depvar2 == 1
replace order = 7 if year == 3 & depvar2 == 2

replace order = 9 if year == 4 & depvar2 == 0
replace order = 10 if year == 4 & depvar2 == 1
replace order = 11 if year == 4 & depvar2 == 2


twoway (bar mean order if depvar2 == 0) ///
	   (bar mean order if depvar2 == 1) ///
	   (bar mean order if depvar2 == 2) ///
       (rcap ub lb order), ///
	   legend(col(1) order(1 "Closed in 2016" 2 "Open w/ 1 teacher in 2016" 3 "Open w/ 2+ trained teachers in 2016") pos(6) ) ///       
	   xlabel(2 "2010" 6 "2013" 10 "2016", noticks) ///
	   ylabel(-0.2(.2)1, nogrid) ///  	  
	   xtitle("Year", height(8)) ///
	   ytitle("Prop. children attending w/ no fee") 

	   graph export "$output/fig3c_2.pdf", replace	   
	   	   
restore


* Monthly fee
preserve

keep facid year depvar1 fee_mand_n
 
save tempfile, replace
statsby, by(year depvar1) : ci mean fee_mand_n

generate order = 1 if year == 2 & depvar == 0
replace order = 2 if year == 2 & depvar == 1
replace order = 4 if year == 3 & depvar == 0
replace order = 5 if year == 3 & depvar == 1
replace order = 7 if year == 4 & depvar == 0
replace order = 8 if year == 4 & depvar == 1


twoway (bar mean order if depvar1 == 0) ///
	   (bar mean order if depvar1 == 1) ///
       (rcap ub lb order), ///
       legend(row(1) order(1 "Closed in 2016" 2 "Open in 2016") pos(6) ) ///
       xlabel(1.5 "2010" 4.5 "2013" 7.5 "2016", noticks) ///
	   ylabel(,nogrid) ///	  	  
	   xtitle("Year", height(8)) ///
	   ytitle("Amount of monthly fee (IDR)") ///
	   ylabel(0(5000)25000)

	   graph export "$output/fig3d.pdf", replace	   
	   	   
restore


preserve

keep facid year depvar2 fee_mand_n
 
save tempfile, replace
statsby, by(year depvar2) : ci mean fee_mand_n

generate order = 1 if year == 2 & depvar2 == 0
replace order = 2 if year == 2 & depvar2 == 1
replace order = 3 if year == 2 & depvar2 == 2

replace order = 5 if year == 3 & depvar2 == 0
replace order = 6 if year == 3 & depvar2 == 1
replace order = 7 if year == 3 & depvar2 == 2

replace order = 9 if year == 4 & depvar2 == 0
replace order = 10 if year == 4 & depvar2 == 1
replace order = 11 if year == 4 & depvar2 == 2


twoway (bar mean order if depvar == 0) ///
	   (bar mean order if depvar == 1) ///
	   (bar mean order if depvar == 2) ///	   
       (rcap ub lb order), ///
       legend(col(1) order(1 "Closed in 2016" 2 "Open w/ 1 teacher in 2016" 3 "Open w/ 2+ trained teachers in 2016") pos(6) ) ///
       xlabel(2 "2010" 6 "2013" 10 "2016", noticks) ///
	   ylabel(,nogrid) ///	  	  
	   xtitle("Year", height(8)) ///
	   ytitle("Amount of monthly fee (IDR)") ///
	   ylabel(0(5000)25000)

	   graph export "$output/fig3d_2.pdf", replace	   
	   	   
restore


*------------------------------------------------------------------------------*
* FIGURE 4
*------------------------------------------------------------------------------*

* Classroom observation

preserve

keep facid year depvar1 standards_indonesia
 
save tempfile, replace
statsby, by(year depvar1) : ci mean standards_indonesia

generate order = 1 if year == 2 & depvar == 0
replace order = 2 if year == 2 & depvar == 1
replace order = 4 if year == 3 & depvar == 0
replace order = 5 if year == 3 & depvar == 1
replace order = 7 if year == 4 & depvar == 0
replace order = 8 if year == 4 & depvar == 1


twoway (bar mean order if depvar1 == 0) ///
	   (bar mean order if depvar1 == 1) ///
       (rcap ub lb order), ///
       legend(row(1) order(1 "Closed in 2016" 2 "Open in 2016") pos(6) ) ///
       xlabel(1.5 "2010" 4.5 "2013" 7.5 "2016", noticks) ///
	   ylabel(,nogrid) ///	  	  
	   xtitle("Year", height(8)) ///
	   ytitle("Quality: Classroom observation (ECERS-R)") ///
	   ylabel(1(1)7)

	   graph export "$output/fig4a.pdf", replace	   
	   	   
restore


preserve

keep facid year depvar2 standards_indonesia
 
save tempfile, replace
statsby, by(year depvar2) : ci mean standards_indonesia

generate order = 1 if year == 2 & depvar2 == 0
replace order = 2 if year == 2 & depvar2 == 1
replace order = 3 if year == 2 & depvar2 == 2

replace order = 5 if year == 3 & depvar2 == 0
replace order = 6 if year == 3 & depvar2 == 1
replace order = 7 if year == 3 & depvar2 == 2

replace order = 9 if year == 4 & depvar2 == 0
replace order = 10 if year == 4 & depvar2 == 1
replace order = 11 if year == 4 & depvar2 == 2


twoway (bar mean order if depvar2 == 0) ///
	   (bar mean order if depvar2 == 1) ///
	   (bar mean order if depvar2 == 2) ///
       (rcap ub lb order), ///
       legend(col(1) order(1 "Closed in 2016" 2 "Open w/ 1 teacher in 2016" 3 "Open w/ 2+ trained teachers in 2016") pos(6) ) ///
       xlabel(2 "2010" 6 "2013" 10 "2016", noticks) ///
	   ylabel(,nogrid) ///	  	  
	   xtitle("Year", height(8)) ///
	   ytitle("Quality: Classroom obs. (ECERS-R)") ///
	   ylabel(1(1)7)

	   graph export "$output/fig4a_2.pdf", replace	   
	   	   
restore


* Teacher characteristics

preserve

keep facid year depvar1 teacher_edu_pspct teacher_exppct
rename (teacher_edu_pspct teacher_exppct) (s1 s2)  

reshape long s, i(facid year) j(category)

save tempfile, replace
statsby, by(category year depvar1) : ci mean s

generate order = _n
replace order = order + 1 if order > 6

twoway (bar mean order if depvar1 == 0) ///
	   (bar mean order if depvar1 == 1) ///
       (rcap ub lb order), ///
       legend(row(1) order(1 "Closed in 2016" 2 "Open in 2016") pos(6) ) ///
       xlabel(1.5 "2010" 3.5`" " " "with post-sec edu degree" "' 3.5 "2013" 5.5 "2016" ///
	          8.5 "2010" 10.5`" " "  "with teaching experience" "' 10.5 "2013" 12.5 "2016" ///
			  , noticks) ///
	   ylabel(,nogrid) ///	  	  
	   xtitle("Year & Teacher characteristics", height(8)) ///
	   ytitle("Prop. of teachers...") 

	   graph export "$output/fig4b.pdf", replace
	   
restore


preserve

keep facid year depvar2 teacher_edu_pspct teacher_exppct
rename (teacher_edu_pspct teacher_exppct) (s1 s2)  

reshape long s, i(facid year) j(category)

save tempfile, replace
statsby, by(category year depvar2) : ci mean s

generate order = _n
replace order = order + 1 if order > 3
replace order = order + 1 if order > 7
replace order = order + 1 if order > 11
replace order = order + 1 if order > 15
replace order = order + 1 if order > 19

twoway (bar mean order if depvar2 == 0) ///
	   (bar mean order if depvar2 == 1) ///
	   (bar mean order if depvar2 == 2) ///
       (rcap ub lb order), ///
       legend(col(1) order(1 "Closed in 2016" 2 "Open w/ 1 teacher in 2016" 3 "Open w/ 2+ trained teachers in 2016") pos(6) ) ///
       xlabel(2 "2010" 6`" " " "with post-sec edu degree" "' 6 "2013" 10 "2016" ///
			  14 "2010" 18`" " "  "with teaching experience" "' 18 "2013" 22 "2016", ///
			  noticks) ///
	   ylabel(-0.1(0.1)0.5,nogrid) ///	  	  
	   xtitle("Year & Teacher characteristics", height(8)) ///
	   ytitle("Prop. of teachers...") 

	   graph export "$output/fig4b_2.pdf", replace
	   
restore


*  Number of students and teachers

preserve

keep facid year depvar1 center_number
 
save tempfile, replace
statsby, by(year depvar1) : ci mean center_number

generate order = 1 if year == 2 & depvar == 0
replace order = 2 if year == 2 & depvar == 1
replace order = 4 if year == 3 & depvar == 0
replace order = 5 if year == 3 & depvar == 1
replace order = 7 if year == 4 & depvar == 0
replace order = 8 if year == 4 & depvar == 1


twoway (bar mean order if depvar1 == 0) ///
	   (bar mean order if depvar1 == 1) ///
       (rcap ub lb order), ///
       legend(row(1) order(1 "Closed in 2016" 2 "Open in 2016") pos(6) ) ///
       xlabel(1.5 "2010" 4.5 "2013" 7.5 "2016", noticks labsize(large)) ///
	   ylabel(,nogrid labsize(large)) ///	  	  
	   xtitle("Year", size(large) height(8)) ///
	   ytitle("Number of students", size(large)) ///
	   ylabel(0(10)50) name(fig4c1, replace)
	   
restore	   

*********

preserve

keep facid year depvar1 teacher_total
 
save tempfile, replace
statsby, by(year depvar1) : ci mean teacher_total

generate order = 1 if year == 2 & depvar == 0
replace order = 2 if year == 2 & depvar == 1
replace order = 4 if year == 3 & depvar == 0
replace order = 5 if year == 3 & depvar == 1
replace order = 7 if year == 4 & depvar == 0
replace order = 8 if year == 4 & depvar == 1


twoway (bar mean order if depvar1 == 0) ///
	   (bar mean order if depvar1 == 1) ///
       (rcap ub lb order), ///
       legend(row(1) order(1 "Closed in 2016" 2 "Open in 2016") pos(6) ) ///
       xlabel(1.5 "2010" 4.5 "2013" 7.5 "2016", labsize(large) noticks) ///
	   ylabel(,labsize(large) nogrid) ///	  	  
	   xtitle("Year", size(large) height(8)) ///
	   ytitle("Number of teachers", size(large) ) ///
	   ylabel(0(1)5) name(fig4c2, replace)
  
restore	  
	     
grc1leg fig4c1 fig4c2	   
graph export "$output/fig4c.pdf", replace	   
	
	
	
preserve

keep facid year depvar2 center_number
 
save tempfile, replace
statsby, by(year depvar2) : ci mean center_number

generate order = _n
replace order = order + 1 if order > 3
replace order = order + 1 if order > 7

twoway (bar mean order if depvar == 0) ///
	   (bar mean order if depvar == 1) ///
	   (bar mean order if depvar == 2) ///
       (rcap ub lb order), ///
       legend(col(1) order(1 "Closed in 2016" 2 "Open w/ 1 teacher in 2016" 3 "Open w/ 2+ trained teachers in 2016") pos(6) ) ///
       xlabel(2 "2010" 6 "2013" 10 "2016", noticks labsize(large)) ///
	   ylabel(,nogrid labsize(large)) ///	  	  
	   xtitle("Year", size(large) height(8)) ///
	   ytitle("Number of students", size(large)) ///
	   ylabel(-10(10)60) name(fig4c1, replace)
	   
restore	   

*********

preserve

keep facid year depvar2 teacher_total
 
save tempfile, replace
statsby, by(year depvar2) : ci mean teacher_total

generate order = _n
replace order = order + 1 if order > 3
replace order = order + 1 if order > 7

twoway (bar mean order if depvar == 0) ///
	   (bar mean order if depvar == 1) ///
	   (bar mean order if depvar == 2) ///
       (rcap ub lb order), ///
       legend(col(1) order(1 "Closed in 2016" 2 "Open w/ 1 teacher in 2016" 3 "Open w/ 2+ trained teachers in 2016") pos(6) ) ///
       xlabel(2 "2010" 6 "2013" 10 "2016", noticks labsize(large)) ///
	   ylabel(,labsize(large) nogrid) ///	  	  
	   xtitle("Year", size(large) height(8)) ///
	   ytitle("Number of teachers", size(large) ) ///
	   ylabel(-1(1)5) name(fig4c2, replace)
  
restore	  
	     
grc1leg fig4c1 fig4c2	   
graph export "$output/fig4c_2.pdf", replace		
	   
	   
*  Days and hours of center

preserve

keep facid year depvar1 center_sched 
 
save tempfile, replace
statsby, by(year depvar1) : ci mean center_sched 

generate order = 1 if year == 2 & depvar == 0
replace order = 2 if year == 2 & depvar == 1
replace order = 4 if year == 3 & depvar == 0
replace order = 5 if year == 3 & depvar == 1
replace order = 7 if year == 4 & depvar == 0
replace order = 8 if year == 4 & depvar == 1


twoway (bar mean order if depvar1 == 0) ///
	   (bar mean order if depvar1 == 1) ///
       (rcap ub lb order), ///
       legend(row(1) order(1 "Closed in 2016" 2 "Open in 2016") pos(6) ) ///
       xlabel(1.5 "2010" 4.5 "2013" 7.5 "2016", labsize(large) noticks) ///
	   ylabel(, labsize(large) nogrid) ///	  	  
	   xtitle("Year", size(large) height(8)) ///
	   ytitle("Number of days per week", size(large)) ///
	   name(fig4d1, replace)
	   
restore	   

*********

preserve

keep facid year depvar1 hoursperday
 
save tempfile, replace
statsby, by(year depvar1) : ci mean hoursperday

generate order = 1 if year == 2 & depvar == 0
replace order = 2 if year == 2 & depvar == 1
replace order = 4 if year == 3 & depvar == 0
replace order = 5 if year == 3 & depvar == 1
replace order = 7 if year == 4 & depvar == 0
replace order = 8 if year == 4 & depvar == 1


twoway (bar mean order if depvar1 == 0) ///
	   (bar mean order if depvar1 == 1) ///
       (rcap ub lb order), ///
       legend(row(1) order(1 "Closed in 2016" 2 "Open in 2016") pos(6) ) ///
       xlabel(1.5 "2010" 4.5 "2013" 7.5 "2016", labsize(large) noticks) ///
	   ylabel(, labsize(large) nogrid) ///	  	  
	   xtitle("Year", height(8) size(large)) ///
	   ytitle("Number of hours per day", size(large)) ///
	   name(fig4d2, replace)
  
restore	  
	     
grc1leg fig4d1 fig4d2	   
graph export "$output/fig4d.pdf", replace	   
	   

	   
preserve

keep facid year depvar2 center_sched 
 
save tempfile, replace
statsby, by(year depvar2) : ci mean center_sched 

generate order = _n
replace order = order + 1 if order > 3
replace order = order + 1 if order > 7

twoway (bar mean order if depvar2 == 0) ///
	   (bar mean order if depvar2 == 1) ///
	   (bar mean order if depvar2 == 2) ///
       (rcap ub lb order), ///
       legend(col(1) order(1 "Closed in 2016" 2 "Open w/ 1 teacher in 2016" 3 "Open w/ 2+ trained teachers in 2016") pos(6) ) ///
       xlabel(2 "2010" 6 "2013" 10 "2016", noticks labsize(large)) ///
	   ylabel(-1(1)6, labsize(large) nogrid) ///	  	  
	   xtitle("Year", size(large) height(8)) ///
	   ytitle("Number of days per week", size(large)) ///
	   name(fig4d1, replace)
	   
restore	   

*********

preserve

keep facid year depvar2 hoursperday
 
save tempfile, replace
statsby, by(year depvar2) : ci mean hoursperday

generate order = _n
replace order = order + 1 if order > 3
replace order = order + 1 if order > 7

twoway (bar mean order if depvar2 == 0) ///
	   (bar mean order if depvar2 == 1) ///
	   (bar mean order if depvar2 == 2) ///
       (rcap ub lb order), ///
       legend(col(1) order(1 "Closed in 2016" 2 "Open w/ 1 teacher in 2016" 3 "Open w/ 2+ trained teachers in 2016") pos(6) ) ///
       xlabel(2 "2010" 6 "2013" 10 "2016", noticks labsize(large)) ///
	   ylabel(-0.5(1)3, labsize(large) nogrid) ///	  	  
	   xtitle("Year", height(8) size(large)) ///
	   ytitle("Number of hours per day", size(large)) ///
	   name(fig4d2, replace)
  
restore	  
	     
grc1leg fig4d1 fig4d2	   
graph export "$output/fig4d_2.pdf", replace


*------------------------------------------------------------------------------*
* FIGURE 5
*------------------------------------------------------------------------------*

* Number of kindergartens & other playgroups

preserve

keep facid year depvar1 nratkchd 
 
save tempfile, replace
statsby, by(year depvar1) : ci mean nratkchd 

generate order = 1 if year == 2 & depvar == 0
replace order = 2 if year == 2 & depvar == 1
replace order = 4 if year == 3 & depvar == 0
replace order = 5 if year == 3 & depvar == 1
replace order = 7 if year == 4 & depvar == 0
replace order = 8 if year == 4 & depvar == 1


twoway (bar mean order if depvar1 == 0) ///
	   (bar mean order if depvar1 == 1) ///
       (rcap ub lb order), ///
       legend(row(1) order(1 "Closed in 2016" 2 "Open in 2016") pos(6) ) ///
       xlabel(1.5 "2010" 4.5 "2013" 7.5 "2016", labsize(large) noticks) ///
	   ylabel(, labsize(large) nogrid) ///	  	  
	   xtitle("Year", size(large) height(8)) ///
	   ytitle("Number of kindergartens" "in village per 100 children", size(large)) ///
	   name(fig5a1, replace)
	   
restore	   

*********

preserve

keep facid year depvar1 nnonplgchd
 
save tempfile, replace
statsby, by(year depvar1) : ci mean nnonplgchd

generate order = 1 if year == 2 & depvar == 0
replace order = 2 if year == 2 & depvar == 1
replace order = 4 if year == 3 & depvar == 0
replace order = 5 if year == 3 & depvar == 1
replace order = 7 if year == 4 & depvar == 0
replace order = 8 if year == 4 & depvar == 1


twoway (bar mean order if depvar1 == 0) ///
	   (bar mean order if depvar1 == 1) ///
       (rcap ub lb order), ///
       legend(row(1) order(1 "Closed in 2016" 2 "Open in 2016") pos(6) ) ///
       xlabel(1.5 "2010" 4.5 "2013" 7.5 "2016", labsize(large) noticks) ///
	   ylabel(, labsize(large) nogrid) ///	  	  
	   xtitle("Year", height(8) size(large)) ///
	   ytitle("Number of other playgroups " "in village per 100 children", size(large)) ///
	   name(fig5a2, replace)
  
restore	  
	     
grc1leg fig5a1 fig5a2	   
graph export "$output/fig5a.pdf", replace	   



preserve

keep facid year depvar2 nratkchd 
 
save tempfile, replace
statsby, by(year depvar2) : ci mean nratkchd 

generate order = _n
replace order = order + 1 if order > 3
replace order = order + 1 if order > 7

twoway (bar mean order if depvar2 == 0) ///
	   (bar mean order if depvar2 == 1) ///
	   (bar mean order if depvar2 == 2) ///
       (rcap ub lb order), ///
       legend(col(1) order(1 "Closed in 2016" 2 "Open w/ 1 teacher in 2016" 3 "Open w/ 2+ trained teachers in 2016") pos(6) ) ///
       xlabel(2 "2010" 6 "2013" 10 "2016", noticks labsize(large)) ///
	   ylabel(-0.5(0.5)2.5, labsize(large) nogrid) ///	  	  
	   xtitle("Year", size(large) height(8)) ///
	   ytitle("Number of kindergartens" "in village per 100 children", size(large)) ///
	   name(fig5a1, replace)
	   
restore	   

*********

preserve

keep facid year depvar2 nnonplgchd
 
save tempfile, replace
statsby, by(year depvar2) : ci mean nnonplgchd

generate order = _n
replace order = order + 1 if order > 3
replace order = order + 1 if order > 7

twoway (bar mean order if depvar2 == 0) ///
	   (bar mean order if depvar2 == 1) ///
	   (bar mean order if depvar2 == 2) ///
       (rcap ub lb order), ///
       legend(col(1) order(1 "Closed in 2016" 2 "Open w/ 1 teacher in 2016" 3 "Open w/ 2+ trained teachers in 2016") pos(6) ) ///
       xlabel(2 "2010" 6 "2013" 10 "2016", noticks labsize(large)) ///
	   ylabel(-0.5(0.5)2.5, labsize(large) nogrid) ///	  	  
	   xtitle("Year", height(8) size(large)) ///
	   ytitle("Number of other playgroups " "in village per 100 children", size(large)) ///
	   name(fig5a2, replace)
  
restore	  
	     
grc1leg fig5a1 fig5a2	   
graph export "$output/fig5a_2.pdf", replace	   


* Distance to village center / other playgroups

preserve

keep facid year depvar1 dist_center 
 
save tempfile, replace
statsby, by(year depvar1) : ci mean dist_center 

generate order = 1 if year == 2 & depvar == 0
replace order = 2 if year == 2 & depvar == 1
replace order = 4 if year == 3 & depvar == 0
replace order = 5 if year == 3 & depvar == 1
replace order = 7 if year == 4 & depvar == 0
replace order = 8 if year == 4 & depvar == 1


twoway (bar mean order if depvar1 == 0) ///
	   (bar mean order if depvar1 == 1) ///
       (rcap ub lb order), ///
       legend(row(1) order(1 "Closed in 2016" 2 "Open in 2016") pos(6) ) ///
       xlabel(1.5 "2010" 4.5 "2013" 7.5 "2016", labsize(large) noticks) ///
	   ylabel(, labsize(large) nogrid) ///	  	  
	   xtitle("Year", size(large) height(8)) ///
	   ytitle("Distance to village center (km)", size(large)) ///
	   name(fig5b1, replace)
	   
restore	   

*********

preserve

keep facid year depvar1 dist_fac1
 
save tempfile, replace
statsby, by(year depvar1) : ci mean dist_fac1

generate order = 1 if year == 2 & depvar == 0
replace order = 2 if year == 2 & depvar == 1
replace order = 4 if year == 3 & depvar == 0
replace order = 5 if year == 3 & depvar == 1
replace order = 7 if year == 4 & depvar == 0
replace order = 8 if year == 4 & depvar == 1


twoway (bar mean order if depvar1 == 0) ///
	   (bar mean order if depvar1 == 1) ///
       (rcap ub lb order), ///
       legend(row(1) order(1 "Closed in 2016" 2 "Open in 2016") pos(6) ) ///
       xlabel(1.5 "2010" 4.5 "2013" 7.5 "2016", labsize(large) noticks) ///
	   ylabel(, labsize(large) nogrid) ///	  	  
	   xtitle("Year", height(8) size(large)) ///
	   ytitle("Distance to nearest playgroup (km)", size(large)) ///
	   name(fig5b2, replace)
  
restore	  
	     
grc1leg fig5b1 fig5b2	   
graph export "$output/fig5b.pdf", replace



preserve

keep facid year depvar2 dist_center 
 
save tempfile, replace
statsby, by(year depvar2) : ci mean dist_center 

generate order = _n
replace order = order + 1 if order > 3
replace order = order + 1 if order > 7

twoway (bar mean order if depvar2 == 0) ///
	   (bar mean order if depvar2 == 1) ///
	   (bar mean order if depvar2 == 2) ///
       (rcap ub lb order), ///
       legend(col(1) order(1 "Closed in 2016" 2 "Open w/ 1 teacher in 2016" 3 "Open w/ 2+ trained teachers in 2016") pos(6) ) ///
       xlabel(2 "2010" 6 "2013" 10 "2016", noticks labsize(large)) ///
	   ylabel(-0.5(0.5)2, labsize(large) nogrid) ///	  	  
	   xtitle("Year", size(large) height(8)) ///
	   ytitle("Distance to village center (km)", size(large)) ///
	   name(fig5b1, replace)
	   
restore	   

*********

preserve

keep facid year depvar2 dist_fac1
 
save tempfile, replace
statsby, by(year depvar2) : ci mean dist_fac1

generate order = _n
replace order = order + 1 if order > 3
replace order = order + 1 if order > 7

twoway (bar mean order if depvar2 == 0) ///
	   (bar mean order if depvar2 == 1) ///
	   (bar mean order if depvar2 == 2) ///
       (rcap ub lb order), ///
       legend(col(1) order(1 "Closed in 2016" 2 "Open w/ 1 teacher in 2016" 3 "Open w/ 2+ trained teachers in 2016") pos(6) ) ///
       xlabel(2 "2010" 6 "2013" 10 "2016", noticks labsize(large)) ///
	   ylabel(-0.5(1)3.5, labsize(large) nogrid) ///	  	  
	   xtitle("Year", height(8) size(large)) ///
	   ytitle("Distance to nearest playgroup (km)", size(large)) ///
	   name(fig5b2, replace)
  
restore	  
	     
grc1leg fig5b1 fig5b2	   
graph export "$output/fig5b_2.pdf", replace


*------------------------------------------------------------------------------*
* FIGURE 6
*------------------------------------------------------------------------------*

* Supplementary services

preserve

keep facid year depvar1 supp1 supp2 supp3

reshape long supp, i(facid year) j(category)

save tempfile, replace
statsby, by(category year depvar1) : ci mean supp

generate order = _n
replace order = order + 2 if category == 3
replace order = order + 1 if category == 2

twoway (bar mean order if depvar1 == 0) ///
	   (bar mean order if depvar1 == 1) ///
       (rcap ub lb order), ///
       legend(row(1) order(1 "Closed in 2016" 2 "Open in 2016") pos(6) ) ///
       xlabel(1.5 "2010"  3.5`" " "   "Food program" "' 3.5 "2013" 5.5 "2016" ///
			  8.5 "2010"  10.5`" " "   "Vitamin" "' 10.5 "2013" 12.5 "2016" ///
			  15.5 "2010" 17.5`" " "   "Deworming" "' 17.5 "2013" 19.5 "2016" ///
	          , noticks) ///
	   ylabel(0(0.2)1, nogrid) ///	  
	   xtitle("Year & Type of supplementary services", height(8)) ///
	   ytitle("Proportion of centers") 

	   graph export "$output/fig6.pdf", replace
	   
restore


preserve

keep facid year depvar2 supp1 supp2 supp3

reshape long supp, i(facid year) j(category)

save tempfile, replace
statsby, by(category year depvar2) : ci mean supp

generate order = _n
replace order = order + 1 if order > 3
replace order = order + 1 if order > 7
replace order = order + 1 if order > 11
replace order = order + 1 if order > 15
replace order = order + 1 if order > 19
replace order = order + 1 if order > 23
replace order = order + 1 if order > 27
replace order = order + 1 if order > 31

twoway (bar mean order if depvar == 0) ///
	   (bar mean order if depvar == 1) ///
	   (bar mean order if depvar == 2) ///
       (rcap ub lb order), ///
       legend(col(1) order(1 "Closed in 2016" 2 "Open w/ 1 teacher in 2016" 3 "Open w/ 2+ trained teachers in 2016") pos(6) ) ///
	   xlabel(2 "2010"  6`" " "   "Food program" "' 6 "2013" 10 "2016" ///
			  14 "2010"  18`" " "   "Vitamin" "' 18 "2013" 22 "2016" ///
			  26 "2010" 30`" " "   "Deworming" "' 30 "2013" 34 "2016" ///
	          , noticks) ///
	   ylabel(-0.2(0.2)1, nogrid) ///	  
	   xtitle("Year & Type of supplementary services", height(8)) ///
	   ytitle("Proportion of centers") 

	   graph export "$output/fig6_2.pdf", replace
	   
restore


*------------------------------------------------------------------------------*
* FIGURE 7
*------------------------------------------------------------------------------*

* Parental involvement index

preserve

keep facid year depvar1 zparentinv 

save tempfile, replace
statsby, by(year depvar1) : ci mean zparentinv 

generate order = 1 if year == 2 & depvar == 0
replace order = 2 if year == 2 & depvar == 1
replace order = 4 if year == 3 & depvar == 0
replace order = 5 if year == 3 & depvar == 1
replace order = 7 if year == 4 & depvar == 0
replace order = 8 if year == 4 & depvar == 1


twoway (bar mean order if depvar1 == 0) ///
	   (bar mean order if depvar1 == 1) ///
       (rcap ub lb order), ///
       legend(row(1) order(1 "Closed in 2016" 2 "Open in 2016") pos(6) ) ///
       xlabel(1.5 "2010" 4.5 "2013" 7.5 "2016", noticks) ///
	   ylabel(,nogrid) ///	  	  
	   xtitle("Year", height(8)) ///
	   ytitle("Parental involvement index (z-score)")

	   graph export "$output/fig7a.pdf", replace	   
	   	   
restore


preserve

keep facid year depvar2 zparentinv 

save tempfile, replace
statsby, by(year depvar2) : ci mean zparentinv 

generate order = _n
replace order = order + 1 if order > 3
replace order = order + 1 if order > 7

twoway (bar mean order if depvar == 0) ///
	   (bar mean order if depvar == 1) ///
	   (bar mean order if depvar == 2) ///
       (rcap ub lb order), ///
       legend(col(1) order(1 "Closed in 2016" 2 "Open w/ 1 teacher in 2016" 3 "Open w/ 2+ trained teachers in 2016") pos(6) ) ///
       xlabel(2 "2010" 6 "2013" 10 "2016", noticks) ///
	   ylabel(,nogrid) ///	  	  
	   xtitle("Year", height(8)) ///
	   ytitle("Parental involvement index (z-score)")

	   graph export "$output/fig7a_2.pdf", replace	   
	   	   
restore



* Wealth

preserve

keep facid year depvar1 zwealth_va

save tempfile, replace
statsby, by(year depvar1) : ci mean zwealth_va

generate order = 1 if year == 2 & depvar == 0
replace order = 2 if year == 2 & depvar == 1
replace order = 4 if year == 3 & depvar == 0
replace order = 5 if year == 3 & depvar == 1
replace order = 7 if year == 4 & depvar == 0
replace order = 8 if year == 4 & depvar == 1


twoway (bar mean order if depvar1 == 0) ///
	   (bar mean order if depvar1 == 1) ///
       (rcap ub lb order), ///
       legend(row(1) order(1 "Closed in 2016" 2 "Open in 2016") pos(6) ) ///
       xlabel(1.5 "2010" 4.5 "2013" 7.5 "2016", noticks) ///
	   ylabel(,nogrid) ///	  	  
	   xtitle("Year", height(8)) ///
	   ytitle("Average wealth of household in village (z-score)")

	   graph export "$output/fig7b.pdf", replace	   
	   	   
restore


preserve

keep facid year depvar2 zwealth_va

save tempfile, replace
statsby, by(year depvar2) : ci mean zwealth_va

generate order = _n
replace order = order + 1 if order > 3
replace order = order + 1 if order > 7

twoway (bar mean order if depvar == 0) ///
	   (bar mean order if depvar == 1) ///
	   (bar mean order if depvar == 2) ///
       (rcap ub lb order), ///
       legend(col(1) order(1 "Closed in 2016" 2 "Open w/ 1 teacher in 2016" 3 "Open w/ 2+ trained teachers in 2016") pos(6) ) ///
       xlabel(2 "2010" 6 "2013" 10 "2016", noticks) ///
	   ylabel(,nogrid) ///	  	  
	   xtitle("Year", height(8)) ///
	   ytitle("Average wealth of household in village" "(z-score)")

	   graph export "$output/fig7b_2.pdf", replace	   
	   	   
restore


*------------------------------------------------------------------------------*
* Model selection using lasso * 
*------------------------------------------------------------------------------*
destring ea, gen(eaid)

tempfile a 

* construct lagged variable

preserve
  replace year = 2010 if year==2
  replace year = 2013 if year==3
  replace year = 2016 if year==4
  keep facid year shared_adm shared_child shared_infra shared_teacher shared_outsup ///
fee_freq4 fee_mand_n ///
teacher_edu_pspct teacher_exppct ///
center_number teacher_total center_sched hoursperday ///
nratkchd nnonplgchd ///
supp1 supp2 supp3 zparentinv zwealth_va
  
  reshape wide shared_adm shared_child shared_infra shared_teacher shared_outsup ///
fee_freq4 fee_mand_n ///
teacher_edu_pspct teacher_exppct ///
center_number teacher_total center_sched hoursperday ///
nratkchd nnonplgchd ///
supp1 supp2 supp3 zparentinv zwealth_va, i(facid) j(year)
  save `a', replace

restore

  merge m:1 facid using `a'
  drop _merge

		 	
* convert amount from million to 100 million IDR
*foreach var in af1 af3 af4{
*replace `var' = `var'/100
*}

keep if year==3
	

* recode outcome to two	
gen two = 0 if depvar2 == 1
replace two = 1 if depvar2 == 2
	
	
* replace misings	
replace fee_mand_n2010 = 0 if missing(fee_mand_n2010)
replace fee_mand_n2013 = 0 if missing(fee_mand_n2013)

foreach var in ///
center_number2010 center_number2013 teacher_total2010 ///
center_sched2010 center_sched2013 hoursperday2010 hoursperday2013 {
	
	gen `var'_m = `var' ==.
	
	summ `var' 
	local mean = r(mean)
	replace `var' = `mean' if `var'_m == 1
}
	

* set variables for lasso
keep facid depvar1 two ///
af1 af3 af4 ///
shared_adm2010 shared_child2010 shared_infra2010 shared_teacher2010 shared_outsup2010 ///
shared_adm2013 shared_child2013 shared_infra2013 shared_teacher2013 shared_outsup2013 ///
fee_freq42010 fee_freq42013 fee_mand_n2010 fee_mand_n2013 ///
standards_indonesia ///
teacher_edu_pspct2010 teacher_edu_pspct2013 teacher_exppct2010 teacher_exppct2013 ///
center_number2010 center_number2013 teacher_total2010 teacher_total2013 ///
center_sched2010 center_sched2013 hoursperday2010 hoursperday2013 ///
nratkchd2010 nratkchd2013 nnonplgchd2010 nnonplgchd2013 ///
dist_center dist_fac1_fac2_km ///
supp12010 supp12013 supp22010 supp22013 supp32010 supp32013 ///
zparentinv2010 zparentinv2013 zwealth_va2010 zwealth_va2013


vl set, categorical(4) uncertain(19) dummy

	vl list vldummy
	vl list vlcontinuous
		
	vl list vluncertain
	vl move (fee_mand_n2010 teacher_total2013) vlcontinuous
	
	vl rebuild
	

*------------------------------------------------------------------------------*
*------------------------------------------------------------------------------*
* LASSO
*------------------------------------------------------------------------------*
*------------------------------------------------------------------------------*

estimates drop _all	
		
		
* lasso of predicting whether center is open w/ 2+ teachers

lasso linear two ///
af1 af3 af4 ///
shared_adm2010 shared_child2010 shared_infra2010 shared_teacher2010 shared_outsup2010 ///
shared_adm2013 shared_child2013 shared_infra2013 shared_teacher2013 shared_outsup2013 ///
fee_freq42010 fee_freq42013 fee_mand_n2010 fee_mand_n2013 ///
standards_indonesia ///
teacher_edu_pspct2010 teacher_edu_pspct2013 teacher_exppct2010 teacher_exppct2013 ///
center_number2010 center_number2013 teacher_total2010 teacher_total2013 ///
center_sched2010 center_sched2013 hoursperday2010 hoursperday2013 ///
nratkchd2010 nratkchd2013 nnonplgchd2010 nnonplgchd2013 ///
dist_center dist_fac1_fac2_km ///
supp12010 supp12013 supp22010 supp22013 supp32010 supp32013 ///
zparentinv2010 zparentinv2013 zwealth_va2010 zwealth_va2013 ///
, selection(cv) rseed(02472)

lassocoef, display(coef, postselection)


eststo: reg two shared_teacher2010 shared_outsup2010 shared_child2013 shared_outsup2013 fee_freq42010 fee_mand_n2010 fee_mand_n2013 center_sched2010 center_sched2013 hoursperday2010 nratkchd2010 dist_fac1_fac2_km supp12010 supp32013 zparentinv2013 zwealth_va2013, cluster(facid) 

esttab est1 using "$output/lasso2.csv", replace drop (_cons) b(2) se(2)


* lasso of predicting whether center is open (subset vars to those selected above)

lasso linear depvar1 ///
shared_child2010 shared_teacher2010 shared_outsup2010 ///
shared_child2013 shared_teacher2013 shared_outsup2013 ///
fee_freq42010 fee_freq42013 fee_mand_n2010 fee_mand_n2013 ///
center_sched2010 center_sched2013 hoursperday2010 hoursperday2013 ///
nratkchd2010 nratkchd2013 ///
dist_fac1_fac2_km ///
supp12010 supp12013 supp22010 supp22013 supp32010 supp32013 ///
zparentinv2010 zparentinv2013 zwealth_va2010 zwealth_va2013 ///
, selection(cv) rseed(02472)

lassocoef, display(coef, postselection)

eststo: reg depvar1 ///
shared_outsup2010 shared_teacher2013 fee_freq42013 center_sched2013 nratkchd2010 nratkchd2013 dist_fac1_fac2_km supp12010 supp22010, cluster(facid)

esttab est2 using "$output/lasso1.csv", replace drop (_cons) b(2) se(2)


* lasso only using 2010 vars

lasso linear two ///
shared_adm2010 shared_child2010 shared_infra2010 shared_teacher2010 shared_outsup2010 ///
fee_freq42010 fee_mand_n2010 ///
teacher_edu_pspct2010 teacher_exppct2010 ///
center_number2010 teacher_total2010 ///
center_sched2010 hoursperday2010 ///
nratkchd2010 nnonplgchd2010 ///
dist_center dist_fac1_fac2_km ///
supp12010 supp22010 supp32010 ///
zparentinv2010 zwealth_va2010 ///
, selection(cv) rseed(02472)

lassocoef, display(coef, postselection)

eststo: reg two shared_infra2010 shared_teacher2010 shared_outsup2010 fee_freq42010 fee_mand_n2010 teacher_exppct2010 center_sched2010 hoursperday2010 nratkchd2010 dist_center dist_fac1_fac2_km supp12010 zparentinv2010 zwealth_va2010, cluster(facid) 



lasso linear depvar1 ///
shared_infra2010 shared_teacher2010 shared_outsup2010 fee_freq42010 fee_mand_n2010 teacher_exppct2010 center_sched2010 hoursperday2010 nratkchd2010 dist_center dist_fac1_fac2_km supp12010 zparentinv2010 zwealth_va2010 ///
, selection(cv) rseed(02472)

lassocoef, display(coef, postselection)

eststo: reg depvar1 ///
shared_infra2010 shared_teacher2010 shared_outsup2010 fee_freq42010 fee_mand_n2010 teacher_exppct2010 center_sched2010 hoursperday2010 nratkchd2010 dist_center dist_fac1_fac2_km supp12010 zparentinv2010 zwealth_va2010, cluster(facid)

esttab est3 est4 using "$output/lasso_appendix.csv", replace drop (_cons) b(2) se(2)

	
