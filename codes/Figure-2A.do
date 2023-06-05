/*=======================================================================

Purpose:
	1) Figure 2a. Share of "No Cutlery" Orders"

==========================================================================*/
clear
glo d "..." /* Set you directory */

glo results "$d/results"
glo figures "$d/fig"
glo data "$d/data"
*****************************************************************************
* 						PART A. Graphing		 					*
*****************************************************************************
use "$results/city_collapse.dta", clear


gr tw (scatter p_e time_order if treat == 0, plotr(m(zero)) msize(vsmall) mfcolor(white) msymbol(circle) mcolor("0 51 51")) ///
  (scatter p_e time_order if city_name == "Beijing",  connect(L) lwidth(medthick) lcolor("119 152 235") mcolor("119 152 235") mfcolor(white) msize(medsmall) msymbol(diamond)) ///
	(scatter p_e time_order if city_name == "Shanghai", connect(L) lwidth(medthick) lcolor("42 157 143") mcolor("42 157 143") mfcolor(white) msize(medsmall) msymbol(diamond) lp(dash)) ///
	(scatter p_e time_order if city_name == "Tianjin", mcolor("184 182 111") mfcolor("184 182 111") msize(medsmall) msymbol(diamond) ) ///
	,scheme(white_ptol) ///
	xlabel(1 "01/2019" 7 "07/2019" 13 "01/2020" ///
			19 "07/2020" 25 "01/2021", nogrid labsize(*1.3) labcolor(black)) ///
	ylabel(0 10 20 30 40, nogrid labsize(*1.3)) ///
	xscale(range(1 28)) ///
	xline(6.5, lcolor("42 157 143")) ///
	xline(16.5, lcolor("119 152 235")) ///
	legend(order(3 "Shanghai" 2 "Beijing"  4 "Tianjin" 1 "Control Cities") position(1) ring(0) col(1) size(*1.0)) ///
	xtitle("") ytitle("") ///
	title(`"a. Share of "No Cutlery" Orders"' " ", span place(w)) ///
	xsize(4.5) ysize(5) 
gr export "$figures/Fig-2a.png", replace width(1200)	


