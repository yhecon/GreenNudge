clear
glo d "..." /* Set you directory */

glo results "$d/results"
glo figures "$d/fig"
glo data "$d/data"

use "$results/fig3-a_data.dta", clear

gr tw (scatter stn_ time_order if treat == 0, plotr(m(zero)) msize(vsmall) mfcolor(white) msymbol(circle) mcolor("0 51 51")) ///
  (scatter stn_ time_order if city_name == "Beijing",  connect(L) lwidth(medthick) lcolor("119 152 235") mcolor("119 152 235") mfcolor(white) msize(medsmall) msymbol(diamond)) ///
	(scatter stn_ time_order if city_name == "Shanghai", connect(L) lwidth(medthick) lcolor("42 157 143") mcolor("42 157 143") mfcolor(white) msize(medsmall) msymbol(diamond) lp(dash)) ///
	(scatter stn_ time_order if city_name == "Tianjin", mcolor("184 182 111") mfcolor("184 182 111") msize(medsmall) msymbol(diamond) ) ///
	(scatteri 170 13 120 13, connect(L) lp(dash) lwidth(thin) m(none) lcolor("0 51 51")) ///
		(scatteri 170 6.5 75 6.5, connect(L) lp(dash) lwidth(medium) m(none) lcolor("42 157 143")) ///
	(scatteri 170 16.5 75 16.5, connect(L) lp(dash) lwidth(medium) m(none) lcolor("119 152 235")) ///
	,scheme(white_ptol) ///
	xlabel(1 "01/2019" 7 "07/2019" 13 "01/2020" ///
			19 "07/2020" 25 "01/2021", nogrid labsize(*1.3) labcolor(black)) ///
	ylabel(0 50 100 "01/2019=100" 150 200, nogrid labsize(*1.3)) ///
	xscale(range(1 28)) ///
	legend(order(3 "Shanghai" 2 "Beijing" 4 "Tianjin" 1 "Control Group Cities") position(5) ring(0) col(1) size(*1.2)) ///
	xtitle("") ///
	text(180 12 "COVID-19 & Lockdown", size(small)) ///
	ytitle("") ///
	title("a. Customers' Total Spending" " ", span place(w)) ///
	xsize(4) ysize(3.5)
gr export "$figures/Fig-3a.png", replace width(1200)
gr save "$figures/Fig-3a.gph", replace


use "$results/fig3-b_data.dta", clear
gr tw (scatter stn_ time_order if treat == 0, plotr(m(zero)) msize(vsmall) mfcolor(white) msymbol(circle) mcolor("0 51 51")) ///
  (scatter stn_ time_order if city_name == "Beijing",  connect(L) lwidth(medthick) lcolor("119 152 235") mcolor("119 152 235") mfcolor(white) msize(medsmall) msymbol(diamond)) ///
	(scatter stn_ time_order if city_name == "Shanghai", connect(L) lwidth(medthick) lcolor("42 157 143") mcolor("42 157 143") mfcolor(white) msize(medsmall) msymbol(diamond) lp(dash)) ///
	(scatter stn_ time_order if city_name == "Tianjin", mcolor("184 182 111") mfcolor("184 182 111") msize(medsmall) msymbol(diamond) ) ///
	(scatteri 170 13 120 13, connect(L) lp(dash) lwidth(thin) m(none) lcolor("0 51 51")) ///
		(scatteri 170 6.5 75 6.5, connect(L) lp(dash) lwidth(medium) m(none) lcolor("42 157 143")) ///
	(scatteri 170 16.5 75 16.5, connect(L) lp(dash) lwidth(medium) m(none) lcolor("119 152 235")) ///
	,scheme(white_ptol) ///
	xlabel(1 "01/2019" 7 "07/2019" 13 "01/2020" ///
			19 "07/2020" 25 "01/2021", nogrid labsize(*1.3) labcolor(black)) ///
	ylabel(0 50 100 "01/2019=100" 150 200, nogrid labsize(*1.3)) ///
	xscale(range(1 28)) ///
	legend(order(3 "Shanghai" 2 "Beijing" 4 "Tianjin" 1 "Control Group Cities") position(5) ring(0) col(1) size(*1.2)) ///
	xtitle("") ///
	text(180 12 "COVID-19 & Lockdown", size(small)) ///
	ytitle("") ///
	title("b. Customers' Total Number of Orders" " ", span place(w)) ///
	xsize(4) ysize(3.5)
gr export "$figures/Fig-3b.png", replace width(1200)
gr save "$figures/Fig-3b.gph", replace


grc1leg2 "$figures/Fig-3a.gph" "$figures/Fig-3b.gph", span scheme(white_ptol) iscale(*1.1) ring(0) position(6) lyoffset(10) lxoffset(0) lcols(1) cols(2) imargin(zero) xsize(13) ysize(7) labsize(*1)
gr export "$figures/Fig-3.png", replace width(1200)	
gr export "$figures/Fig-3.eps", replace 



