/*=======================================================================

Purpose:
	1) Figure 2C. Green Nudges' Impacts in Medium- and Long-Run

==========================================================================*/

clears
glo d "..." /* Set you directory */

glo results "$d\results"
glo figures "$d\fig"
glo data "$d\data"
glo results "$d\results"

*****************************************************************************
* 						PART A. Graphing		 					*
*****************************************************************************

use "$results/fig_elements/T2_1.dta", clear

replace estimate = 0 if parm == "_cons"
replace max95 = 0 if parm == "_cons"
replace min95 = 0 if parm == "_cons"
gen dup = _n
drop parm dof t
gen ab = (dup <= 19)
gen x = dup if ab == 1
replace x = dup - 19 if ab == 0
replace x = x+ 1 if x >= 9
replace x = 9 if x == 20
sort ab x
replace x = x - 10
		
gr tw (rcap max95 min95 x if ab == 1, plotr(m(zero))lp(solid) lwidth(thick) color("42 157 143")) ///
	(scatter estimate x if ab == 1, connect(L) lp(dash) lwidth(medthick) lcolor("244 162 97") mcolor("244 162 97") mfcolor(white) msize(medsmall) msymbol(circle)) ///
	,scheme(plotplain) ///
	ylabel(-10 0 10 20 30, nogrid labsize(*1.3) labcolor(black)) ///
	legend(order(2 "Estimated Impacts" 1 "95% CI" ) ring(0) position(1) size(*1.3)) ///
	xlabel(-10.5 " " -9 "≤9" -8 -7 -6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 7 8 9 "≥9" 10.5 " ", nogrid labsize(*1.3) labcolor(black)) ///
	xtitle("Months before and after Nudging") ///
	ytitle("Effects on SEFO (percentage point)") ///
	xsize(4) ysize(3) ///
	yline(0) xline(-0.5)
gr export "$figures/Fig-2c.png", replace width(1200)	



	
