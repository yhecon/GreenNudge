
* Graphs for keywords
clear
glo d "..."

use "$d/distribution_plot_element.dta", clear

gen upper = b_coe+1.64*se_coe
gen lower = b_coe-1.64*se_coe
gen p_valid = (upper*lower>0)

replace cncb = 0 if ave_p0 ==.

forvalues i = 0(1)201{
	local k = `i'-1
	gen g_`i'=0
	replace g_`i'=1 if b_coe+100>`k' & b_coe+100<= `i'
}

replace g_100 =0 if b_coe == 0
replace g_1 = 1 if b_coe <= -100
replace g_201 = 1 if b_coe > 100

forvalues i = 201(-1)101{
	local k = `i'+1
	rename g_`i' g_`k'
}


collapse (sum) g_0-g_202, by(cncb p_valid)


gen city_name =1 

reshape long g_, i(city_name cncb p_valid) j(num )
bys city_name cncb : egen total_pop = total(g_)
replace g_ = g_/total_pop
replace g_ = 100*g_	

replace num = num-1 if num>=101

bys cncb : egen negative = total(g_) if p_valid == 1 & num <101
bys cncb : egen noimpact = total(g_) if p_valid == 0
bys cncb : egen positive = total(g_) if p_valid == 1 & num >=101


gr tw (scatteri 0 0,  connect(L) lp(shortdash) m(none) lcolor(black) lwidth(thin)) ///
		(bar g_ num if num <101 & cncb == 1, plotr(m(zero)) color(black)) ///
		(bar g_ num if  num >=101 & cncb == 1, color("42 157 143")) ///
		(bar g_ num if p_valid == 0 & cncb == 1, color("184 182 111")) ///
	,scheme(white_ptol) ///
	xlabel(0 "≤-100" 25 "-75" 50 "-50" 75 "-25" 101 "0" 126 "25" 151 "50" 176 "75" 202 ">100", nogrid labsize(*1.3) labcolor(black)) ///
	ylabel(0 2 4 6, nogrid labsize(*1.3)) ///
	xsize(4.5) ysize(5) ///
	xtitle("Coefficient(s)", size(*1.3)) ytitle("") ///
	legend(order(2 "Negative Impacts ({it:p}<0.1): 31.4%" 4 "Insignificant Impacts ({it:p}>0.1): 0.9%" 3 "Positive Impacts ({it:p}<0.1): 67.7%") ring(0) col(1) position(11)) ///
	title("d. Distribution of Individual Treatment Effects (%)" " ", span place(w)) 	
gr save "$data/FigS1-a.gph", replace 


gr tw (scatteri 0 0,  connect(L) lp(shortdash) m(none) lcolor(black) lwidth(thin)) ///
		(bar g_ num if num <101 & cncb == 0, plotr(m(zero)) color(black)) ///
		(bar g_ num if  num >=101 & cncb == 0, color("42 157 143")) ///
		(bar g_ num if p_valid == 0 & cncb == 0, color("184 182 111")) ///
	,scheme(white_ptol) ///
	xlabel(0 "≤-100" 25 "-75" 50 "-50" 75 "-25" 101 "0" 126 "25" 151 "50" 176 "75" 202 ">100", nogrid labsize(*1.3) labcolor(black)) ///
	ylabel(0 10 20 30 40, nogrid labsize(*1.3)) ///
	xsize(4.5) ysize(5) ///
	xtitle("Coefficient(s)", size(*1.3)) ytitle("") ///
	legend(order(2 "Negative Impacts ({it:p}<0.1): 6.2%" 4 "Insignificant Impacts ({it:p}>0.1): 7.7%" 3 "Positive Impacts ({it:p}<0.1): 86.1%") ring(0) col(1) position(11)) ///
	title("d. Distribution of Individual Treatment Effects (%)" " ", span place(w)) 
gr save "$data/FigS1-b.gph", replace 

