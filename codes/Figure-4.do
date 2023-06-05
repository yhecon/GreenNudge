/*=======================================================================

Purpose:
	1) Six Heterogenous Analysis - Graphing
==========================================================================*/

clear
glo d "..." /* Set you directory */


glo figures "$d/fig"
glo data "$d/data"
glo results "$d/results"
glo data "$d/data"
glo elements "$d/results/fig_elements"

*****************************************************************************
* 						PART A. by Gender Groups	 					*
*****************************************************************************
use "$elements/T1_1_p_e_.dta"
append using "$elements/T1_2_p_e_.dta"
drop if parm == "_cons"
drop parm dof t
gen x = _n 
drop p stderr	
graph set window fontface "Abel"	
gr tw (bar estimate x , plotr(m(zero)) barwidth(0.4) color("170 108 57")) ///
		(rcap max95 min95 x, lp(solid) lwidth(medium) lcolor("0 51 51")) ///
		(scatteri 24 1 24 2,  recast(line) lw(medthin)  mc(none) lc(black) lp("-")) ///
		(scatteri 24 1 24 2,  recast(dropline) base(23) lw(medthin) mc(none) lc(black) lp(solid)) ///
		,scheme(white_ptol) ///
		ylabel(0 10 20 30, nogrid labsize(*1.3) labcolor(black)) ///
		legend(order(1 "Estimated Impacts" 2 "95% CI") ring(0) position(11) size(*1.3)) ///
		xlabel(0.5 " " 1 "Female" 2 "Male" 2.5 " ", nogrid labsize(*1.3) labcolor(black)) ///
		xscale(range(0.5  2.5)) ///
		xtitle("Consumer's Gender Groups" , size(*1.5)) ///
		ytitle("") ///
		title("a. by Gender Groups" " ", span place(w)) ///
		xsize(4) ysize(3.5) ///
		text(3 1 "21.4pp{&uarr}" , color(white) size(medium)) ///
		text(3 2 "18.4pp{&uarr}" , color(white) size(medium)) ///
		text(25 1.5 "p < 0.01")
gr_edit .plotregion1.plot2.style.editstyle marker(size(huge)) 		
gr export "$figures/Fig-4a.png", replace width(1200)	
gr save "$figures/Fig-4a.gph", replace 


*****************************************************************************
* 						PART B. by Phone-Value Groups	 					*
*****************************************************************************
glo elements "..." /* Link to the results */
use "$elements/T1_1_p_e_.dta", clear
forvalues i = 2/4 {
	append using "$elements/T1_`i'_p_e_.dta"
}
drop if parm == "_cons"
gen dup = _n 
drop dof t p stderr	
gen x = dup 
gr tw (bar estimate x , plotr(m(zero)) barwidth(0.58) bcolor("170 108 57") ) ///
		(rcap max95 min95 x , lp(solid) lwidth(medium) lcolor("0 51 51")) ///
		(scatteri 21 1 21 2,  recast(line) lw(medthin)  mc(none) lc(black) lp("-")) ///
		(scatteri 21 1 21 2,  recast(dropline) base(20.5) lw(medthin) mc(none) lc(black) lp(solid)) ///
		(scatteri 23 1 23 3,  recast(line) lw(medthin)  mc(none) lc(black) lp("-")) ///
		(scatteri 23 1 23 3,  recast(dropline) base(22.5) lw(medthin) mc(none) lc(black) lp(solid)) ///
		(scatteri 25 1 25 4,  recast(line) lw(medthin)  mc(none) lc(black) lp("-")) ///
		(scatteri 25 1 25 4,  recast(dropline) base(24.5) lw(medthin) mc(none) lc(black) lp(solid)) ///
		,scheme(white_ptol) ///
		ylabel(0 10 20 30 , nogrid labsize(*1.3) labcolor(black)) ///
		legend(order(1 "Estimated Impacts" 2 "95% CI") ring(0) position(11) size(*1.3) col(2)) ///
		xlabel(0.5 " " 1 "<1900" 2 "[1900,5000]" 3 "[5000,8000]" 4 "8000+" 4.5 " ", nogrid labsize(*1.3) labcolor(black)) ///
		xscale(range(0.5  4.5)) ///
		xtitle("Consumer's Cellphone Value (CNY)" , size(*1.5)) ///
		ytitle("") ///
		title("e. by Cellphone Value" " ", span place(w)) ///
		xsize(4) ysize(3.5)  ///
		text(3 1 "18.8pp{&uarr}" , color(white) size(medium)) ///
		text(3 2 "18.4pp{&uarr}" , color(white) size(medium)) ///
		text(3 3 "20.2pp{&uarr}" , color(white) size(medium)) ///
		text(3 4 "22.2pp{&uarr}" , color(white) size(medium)) ///
		text(22 1.5 "p > 0.1",size(*0.8)) ///
		text(24 2 "p < 0.01",size(*0.8)) ///
		text(26 2.5 "p < 0.01",size(*0.8))
		
gr_edit .plotregion1.plot2.style.editstyle marker(size(vlarge)) 		
gr export "$figures/Fig-4b.png", replace width(1200)	
gr save "$figures/Fig-4b.gph", replace 	

*****************************************************************************
* 						PART C. by Age Groups	 					*
*****************************************************************************
glo elements "..." /* Link to the results */

use "$elements/T1_1_p_e_.dta", clear
forvalues i = 2/7 {
	append using "$elements/T1_`i'_p_e_.dta"
}
drop if parm == "_cons"
gen dup = _n
drop parm dof t
gen x = dup 
drop p stderr	
gen x2 = x+0.1

gen estimate_k = string(estimate)
replace estimate_k = substr(estimate_k,1,4)		
replace estimate_k = estimate_k + "pp"
gr tw (bar estimate x , plotr(m(zero)) barwidth(0.5) bcolor("170 108 57") ) ///
		(rcap max95 min95 x , lp(solid) lwidth(medium) lcolor("0 51 51")) ///
		(scatter estimate x2 , mlabel(estimate_k) m(none) mlabposition(1) mlabsize(*1.2)) ///
		,scheme(white_ptol) ///
		ylabel(0 10 20 30 40, nogrid labsize(*1.3) labcolor(black)) ///
		legend(order(1 "Estimated Impacts" 2 "95% CI") ring(0) position(11) size(*1.3)) ///
		xlabel(0.5 " " 1 "[18,24]" 2 "[25,29]" 3 "[30,34]" 4 "[35,39]" 5 "[40,44]" 6 "[45,49]" 7 "50+" 7.5 " ", nogrid labsize(*1.3) labcolor(black)) ///
		xscale(range(0.5  2.5)) ///
		xtitle("Consumer Age Groups", size(*1.5)) ///
		ytitle("") ///
		title("b. by Age Groups" " ", span place(w)) ///
		xsize(4) ysize(3.5) 
gr_edit .plotregion1.plot2.style.editstyle marker(size(large)) 			
gr export "$figures/Fig-4c.png", replace width(1200)	
gr save "$figures/Fig-4c.gph", replace 	
	

*****************************************************************************
* 						PART D. by Order Frequency Groups	 					*
*****************************************************************************
import excel "$d/results/FIG4D4E4F_SUM.xlsx", firstrow 
gen max95 = estimate + 1.96*stderr
gen min95 = estimate - 1.96*stderr
gen x2 = x+0.1
gen estimate_k = string(estimate)
replace estimate_k = substr(estimate_k,1,4)		
replace estimate_k = estimate_k + "pp"
gr tw (bar estimate x if Cat == "AveOrders", plotr(m(zero)) barwidth(0.5) bcolor("170 108 57") ) ///
		(rcap max95 min95 x if Cat == "AveOrders", lp(solid) lwidth(medium) lcolor("0 51 51")) ///
		(scatter estimate x2 if Cat == "AveOrders", mlabel(estimate_k) m(none) mlabposition(1) mlabsize(*1.2)) ///
		,scheme(white_ptol) ///
		ylabel(0 10 20 30, nogrid labsize(*1.3) labcolor(black)) ///
		legend(order(1 "Estimated Impacts" 2 "95% CI") ring(0) position(11) size(*1.3)) ///
		xlabel(0.5 " " 1 "[0,1]" 2 "(1,3]" 3 "(3,6]" 4 "(6,9]" 5 "(9,12]" 6 "(12,15]" 7 "15+" 7.5 " ", nogrid labsize(*1.3) labcolor(black)) ///
		xscale(range(0.5  2.5)) ///
		xtitle("Consumer's Average Monthly Orders", size(*1.5)) ///
		ytitle("") ///
		title("c. by Orders Frenquency" " ", span place(w)) ///
		xsize(4) ysize(3.5) 
gr_edit .plotregion1.plot2.style.editstyle marker(size(large)) 
gr export "$figures/Fig-4d.png", replace width(1200)	
gr save "$figures/Fig-4d.gph", replace 	

*****************************************************************************
* 						PART E. by Average Expenditure per Order 				*
*****************************************************************************
clear
import excel "$d/results/FIG4D4E4F_SUM.xlsx", firstrow 
gen max95 = estimate + 1.96*stderr
gen min95 = estimate - 1.96*stderr
gen x2 = x+0.1
gen estimate_k = string(estimate)
replace estimate_k = substr(estimate_k,1,4)		
replace estimate_k = estimate_k + "pp"
gr tw (bar estimate x if Cat == "OrderUnitPrice", plotr(m(zero)) barwidth(0.5) bcolor("170 108 57") ) ///
		(rcap max95 min95 x if Cat == "OrderUnitPrice", lp(solid) lwidth(medium) lcolor("0 51 51")) ///
		(scatter estimate x2 if Cat == "OrderUnitPrice", mlabel(estimate_k) m(none) mlabposition(1) mlabsize(*1.2)) ///
		,scheme(white_ptol) ///
		ylabel(0 10 20 30, nogrid labsize(*1.3) labcolor(black)) ///
		legend(order(1 "Estimated Impacts" 2 "95% CI") ring(0) position(11) size(*1.3)) ///
		xlabel(0.5 " " 1 "0-20%" 2 "20-40%" 3 "40-60%" 4 "60-80%" 5 "80-100%" 5.5 " ", nogrid labsize(*1.3) labcolor(black)) ///
		xscale(range(0.5  2.5)) ///
		xtitle("Consumer's Average Expenditure per Order (Percentile)", size(*1.5)) ///
		ytitle("") ///
		title("d. by Average Expenditure per Order " " ", span place(w)) ///
		xsize(4) ysize(3.5) 
gr_edit .plotregion1.plot2.style.editstyle marker(size(large)) 
gr export "$figures/Fig-4e.png", replace width(1200)	
gr save "$figures/Fig-4e.gph", replace 

*****************************************************************************
* 						PART F. by Previous No-Cutlery Orders Choice			*
*****************************************************************************
clear
import excel "$d/results/FIG4D4E4F_SUM.xlsx", firstrow 
gen max95 = estimate + 1.96*stderr
gen min95 = estimate - 1.96*stderr
gen x2 = x+0.1
gen estimate_k = string(estimate)
replace estimate_k = substr(estimate_k,1,4)		
replace estimate_k = estimate_k + "pp"
gr tw (bar estimate x if Cat == "EverSNCO", plotr(m(zero)) barwidth(0.4) bcolor("170 108 57") ) ///
		(rcap max95 min95 x if Cat == "EverSNCO", lp(solid) lwidth(medium) lcolor("0 51 51")) ///
		(scatteri 29 1 29 2,  recast(line) lw(medthin)  mc(none) lc(black) lp("-")) ///
		(scatteri 29 1 29 2,  recast(dropline) base(28) lw(medthin) mc(none) lc(black) lp(solid)) ///
		,scheme(white_ptol) ///
		ylabel(0 10 20 30 40, nogrid labsize(*1.3) labcolor(black)) ///
		legend(order(1 "Estimated Impacts" 2 "95% CI") ring(0) position(11) size(*1.3)) ///
		xlabel(0.5 " " 1 "Ever Chose No-Cutlery Orders" 2 "Never Chose No-Cutlery Orders" 2.5 " ", nogrid labsize(*1.3) labcolor(black)) ///
		xscale(range(0.5  2.5)) ///
		xtitle("Consumer's Environmental Consciousness", size(*1.5)) ///
		ytitle("") ///
		title("f. by Previous No-Cutlery Orders Choice" " ", span place(w)) ///
		xsize(4) ysize(3.5) ///
		text(31 1.5 "p < 0.01") ///
		text(3 1 "24.0pp{&uarr}" , color(white) size(medium)) ///
		text(3 2 "19.1pp{&uarr}" , color(white) size(medium)) 
gr_edit .plotregion1.plot2.style.editstyle marker(size(large)) 
gr export "$figures/Fig-4f.png", replace width(1200)	
gr save "$figures/Fig-4f.gph", replace 	
	
