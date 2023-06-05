/*=======================================================================

Purpose:
	1) Figure 5: Counterfactuals

==========================================================================*/
clears
glo d "..." /* Set you directory */

glo results "$d/results"
glo figures "$d/fig"
glo data "$d/data"

use "$results/CT_results.dta", clear
replace saved_hat_cf = real_saved if time_order <= 6

foreach u of var saved_hat_cf real_saved{
	replace `u' = `u'/1000
}

gen saved_new = real_saved - saved_hat_cf

foreach u of var saved_new saved_hat_cf real_saved{
	replace `u' = `u'*2
}

gr tw (bar saved_new time_order, plotr(m(zero))  bcolor("85 170 85")) ///
	(scatter saved_hat_cf time_order, connect(L) lp(solid) lwidth(medthick) lcolor("13 77 77") mcolor("13 77 77") mfcolor(white) msize(medsmall) msymbol(diamond)) ///
	(scatter real_saved time_order, connect(L) msize(medsmall) lcolor("128 69 21") lwidth(medthick) mfcolor(white) lp(solid)  mfcolor(white) msymbol(circle) mcolor("128 69 21")) ///
	(scatteri 225 6.5 0 6.5,  connect(L) lp(dash) m(none) lcolor(black) lwidth(thin)) ///
	(scatteri 300 16.5 0 16.5,  connect(L) lp(dash) m(none) lcolor(black) lwidth(thin)) ///
	,scheme(white_ptol) ///
	legend(order(3 "Observed SUCs" 2 "SUCs Without Green Nudges" 1 "Reductions in SUCs") position(11) col(1) ring(0) col(1) size(*1.2)) ///
	xlabel(1 "01/2019" 7 "07/2019" 13 "01/2020" 19 "07/2020" 25 "01/2021", nogrid labsize(*1.3) labcolor(black)) ///
	xsize(4) ysize(3.5)  ///
	ylabel(0 100 200 300, nogrid labsize(*1.3)) ///
	xscale(range(1 28))  ///
	title("a. Estimated SUCs Reductions in Three Pilot Cities" " ", span place(w)) ///
	xtitle("") ///
	ytitle("Reduced Single-Use Cutlery, thounsand sets") ///
	text(200 7.2 "Nudge Started in Shanghai",place(r) size(small)) ///
	text(300 17.2 "Nudge Started in Beijing",place(r) size(small)) 
gr export "$figures/Fig-5a.png", replace width(1200)	
gr save "$figures/Fig-5a.gph", replace



use "$results/ct.dta", clear
replace saved_hat_cf = real_saved if time_order <= 6
gen saved_new = real_saved - saved_hat_cf
gen month = time_order-12 if time_order>12
replace month = time_order if month ==.
gen year = 2019 if time_order<=12
replace year = 2020 if time_order>=13
gen consumer = 0 if month<=6 & year == 2019
replace consumer = 61879 if time_order <= 16 & consumer != 0
replace consumer = 61879+40261 if time_order > 16 & consumer != 24
replace consumer = 61879+40261+8734 if time_order == 24
gen save_rate = saved_new/consumer
gen entire = 439500000*save_rate
foreach u of var entire {
	replace `u' = `u'/1000000000
}
gen total_saved = sum(entire)

foreach u of var entire total_saved{
	replace `u' = (`u'*2)/0.4
}

gr tw (bar entire time_order, plotr(m(zero))  bcolor("85 170 85")) ///
	(scatter total_saved time_order, yaxis(2) connect(L) lp(solid) lwidth(medthick) lcolor("13 77 77") mcolor("13 77 77") mfcolor(white) msize(medsmall) msymbol(diamond)) ///
	(scatteri 3 6.5 0 6.5,  connect(L) lp(dash) m(none) lcolor(black) lwidth(thin)) ///
	,scheme(white_ptol) ///
	legend(order(1 "Monthly Reductions" 3 "Cumulative Reductions") position(11) col(1) ring(0) col(1) size(*1.2)) ///
	xlabel(1 "01/2019" 7 "07/2019" 13 "01/2020" 19 "07/2020" 25 "01/2021", nogrid labsize(*1.3) labcolor(black)) ///
	xsize(4) ysize(3.5)  ///
	ylabel(0 1 2 3 4, nogrid labsize(*1.3)) ///
	ylabel(0 10 20 30 40, nogrid labsize(*1.3) axis(2)) ///
	xscale(range(1 25))  ///
	title("b. Simulated Reductions in the Entire Country" " ", span place(w)) ///
	ytitle(`"Reductions in Single-Use Cutleries, billion sets"', axis(1)) ///
	ytitle(`"Cumulative Reductions in Single-Use Cutleries, billion sets"', axis(2)) ///
	xtitle("") ///
	text(3 7.2 "Nudge Started in the Entire Country",place(r) size(small)) 
gr export "$figures/Fig-5b.png", replace width(1200)	
gr save "$figures/Fig-5b.gph", replace



