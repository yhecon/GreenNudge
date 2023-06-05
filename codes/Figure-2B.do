/*=======================================================================

Purpose:
	1) Figure 2b. Green Nudges' Impacts on Individual's SNCO

==========================================================================*/

clear
glo d "..." /* Set you directory */

glo results "$d\results"
glo figures "$d\fig"
glo data "$d\data"
glo results "$d\results"
	
	
*****************************************************************************
* 						PART A. Graphing		 					*
*****************************************************************************

use "$results/fig_elements/T1_1.dta", clear

forvalues i = 2(1)4{
	append using "$results/fig_elements/T1_`i'.dta"
}

drop if parm == "_cons"
gen dup = _n
drop parm dof t
gen ab = (dup <= 4)
gen x = dup if ab == 1
replace x = dup-4 if ab == 0
drop p stderr	
		
gr tw (bar estimate x if ab ==1, plotr(m(zero)) barwidth(0.6) color("42 157 143")) ///
		(rcap max95 min95 x if ab == 1, lcolor("38 70 83") lp(solid) lwidth(medthick)) ///
		,scheme(plotplain) ///
		ylabel(0 10 20 30, nogrid labsize(*1.3) labcolor(black)) ///
		legend(order(1 "Estimated Impacts" 2 "95% CI") ring(0) position(11) size(*1.3)) ///
		xlabel(0.5 " " 1 `""Shanghai" "(07/2019)""' 2 `""Beijing" "(05/2020)""' 3 `""Tianjin" "(12/2020)""' 4 `""Average" "Impacts""' 4.5 " ", nogrid labsize(*1.3) labcolor(black)) ///
		xscale(range(0.5  3.5)) ///
		xtitle(" ") ///
		ytitle("Effects on SEFO (percentage point)") ///
		xsize(4) ysize(3) ///
		text(5 1 "19.3pp {&uarr}", color(white) size(medium)) ///
		text(5 2 "21.2pp {&uarr}", color(white) size(medium)) ///
		text(5 3 "20.4pp {&uarr}", color(white) size(medium)) ///
		text(5 4 "20.1pp {&uarr}", color(white) size(medium)) 
gr export "$figures/Fig-2b.png", replace width(1200)	


		