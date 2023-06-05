
* Graphs for keywords
clear
global data "..." 
use "$data/Baidu_data.dta", clear
* aggregate
collapse (mean) pc_and_mobile pc mobile, by(year month keyword city_id city)
gen time_order = (year - 2019)*12+month
* treatment
gen treatment = 0 
replace treatment = 1 if (time_order >=7) & (city == "Shanghai")
replace treatment = 1 if (time_order >=17) & (city == "Beijing")
replace treatment = 1 if (time_order >=24) & (city == "Tianjin")

gen ever_treat = (city == "Shanghai" | city == "Beijing" | city == "Tianjin")

sort keyword city time_order 

* normalize 2019/01 = 100
gen value_base = pc_and_mobile if year == 2019 & month == 1
bys keyword city : egen value_base19 = max(value_base)
drop value_base

gen nol = 100*pc_and_mobile/value_base19


* Delivery food
gr tw (scatter nol time_order if ever_treat == 0 & keyword == "df", plotr(m(zero)) msize(vsmall) mfcolor(white) msymbol(circle) mcolor("0 51 51")) ///
  (scatter nol time_order if city == "Beijing" & keyword == "df",  connect(L) lwidth(medthick) lcolor("119 152 235") mcolor("119 152 235") mfcolor(white) msize(medsmall) msymbol(diamond)) ///
	(scatter nol time_order if city == "Shanghai" & keyword == "df", connect(L) lwidth(medthick) lcolor("42 157 143") mcolor("42 157 143") mfcolor(white) msize(medsmall) msymbol(diamond) lp(dash)) ///
	(scatter nol time_order if city == "Tianjin" & keyword == "df", mcolor("184 182 111") mfcolor("184 182 111") msize(medsmall) msymbol(diamond) ) ///
	,scheme(white_ptol) ///
	xlabel(1 "01/2019" 7 "07/2019" 13 "01/2020" ///
			19 "07/2020" 25 "01/2021", nogrid labsize(*1.3) labcolor(black)) ///
	ylabel(40 70 100 "01/2019=100" 130 160, nogrid labsize(*1.3)) ///
	xscale(range(1 28)) ///
	xline(6.5, lcolor("42 157 143")) ///
	xline(16.5, lcolor("119 152 235")) ///
	legend(order(3 "Shanghai" 2 "Beijing"  4 "Tianjin" 1 "Control Group Cities") position(1) ring(0) col(4) size(*1.3)) ///
	xtitle("") ytitle("") ///
	title(`"a. Search for "Food Delivery" (in Chinese) "', span place(w)) ///
	xsize(5) ysize(3.5) 
gr save "$data/FigS3-a.gph", replace 



* Single-Use Cutlery
gr tw (scatter nol time_order if ever_treat == 0 & keyword == "suc", plotr(m(zero)) msize(vsmall) mfcolor(white) msymbol(circle) mcolor("0 51 51")) ///
  (scatter nol time_order if city == "Beijing" & keyword == "suc",  connect(L) lwidth(medthick) lcolor("119 152 235") mcolor("119 152 235") mfcolor(white) msize(medsmall) msymbol(diamond)) ///
	(scatter nol time_order if city == "Shanghai" & keyword == "suc", connect(L) lwidth(medthick) lcolor("42 157 143") mcolor("42 157 143") mfcolor(white) msize(medsmall) msymbol(diamond) lp(dash)) ///
	(scatter nol time_order if city == "Tianjin" & keyword == "suc", mcolor("184 182 111") mfcolor("184 182 111") msize(medsmall) msymbol(diamond) ) ///
	,scheme(white_ptol) ///
	xlabel(1 "01/2019" 7 "07/2019" 13 "01/2020" ///
			19 "07/2020" 25 "01/2021", nogrid labsize(*1.3) labcolor(black)) ///
	ylabel(0 50 100 "01/2019=100" 150 200, nogrid labsize(*1.3)) ///
	xscale(range(1 28)) ///
	xline(6.5, lcolor("42 157 143")) ///
	xline(16.5, lcolor("119 152 235")) ///
	legend(order(3 "Shanghai" 2 "Beijing"  4 "Tianjin" 1 "Control Group Cities") position(5) ring(0) col(1) size(*1.3)) ///
	xtitle("") ytitle("") ///
	title(`"b. Search for "Single-Use Cutlery" (in Chinese) "', span place(w)) ///
	xsize(5) ysize(3.5) 
gr save "$data/FigS3-b.gph", replace 



* Plastic Waste
gr tw (scatter nol time_order if ever_treat == 0 & keyword == "plastic_w", plotr(m(zero)) msize(vsmall) mfcolor(white) msymbol(circle) mcolor("0 51 51")) ///
  (scatter nol time_order if city == "Beijing" & keyword == "plastic_w",  connect(L) lwidth(medthick) lcolor("119 152 235") mcolor("119 152 235") mfcolor(white) msize(medsmall) msymbol(diamond)) ///
	(scatter nol time_order if city == "Shanghai" & keyword == "plastic_w", connect(L) lwidth(medthick) lcolor("42 157 143") mcolor("42 157 143") mfcolor(white) msize(medsmall) msymbol(diamond) lp(dash)) ///
	(scatter nol time_order if city == "Tianjin" & keyword == "plastic_w", mcolor("184 182 111") mfcolor("184 182 111") msize(medsmall) msymbol(diamond) ) ///
	,scheme(white_ptol) ///
	xlabel(1 "01/2019" 7 "07/2019" 13 "01/2020" ///
			19 "07/2020" 25 "01/2021", nogrid labsize(*1.3) labcolor(black)) ///
	ylabel(0 100 "01/2019=100" 200 300 400 500, nogrid labsize(*1.3)) ///
	xscale(range(1 28)) ///
	xline(6.5, lcolor("42 157 143")) ///
	xline(16.5, lcolor("119 152 235")) ///
	legend(order(3 "Shanghai" 2 "Beijing"  4 "Tianjin" 1 "Control Group Cities") position(1) ring(0) col(1) size(*1.3)) ///
	xtitle("") ytitle("") ///
	title(`"c. Search for "Plastic Waste" (in Chinese) "', span place(w)) ///
	xsize(5) ysize(3.5) 
gr save "$data/FigS3-c.gph", replace

* Pollution
gr tw (scatter nol time_order if ever_treat == 0 & keyword == "pollution", plotr(m(zero)) msize(vsmall) mfcolor(white) msymbol(circle) mcolor("0 51 51")) ///
  (scatter nol time_order if city == "Beijing" & keyword == "pollution",  connect(L) lwidth(medthick) lcolor("119 152 235") mcolor("119 152 235") mfcolor(white) msize(medsmall) msymbol(diamond)) ///
	(scatter nol time_order if city == "Shanghai" & keyword == "pollution", connect(L) lwidth(medthick) lcolor("42 157 143") mcolor("42 157 143") mfcolor(white) msize(medsmall) msymbol(diamond) lp(dash)) ///
	(scatter nol time_order if city == "Tianjin" & keyword == "pollution", mcolor("184 182 111") mfcolor("184 182 111") msize(medsmall) msymbol(diamond) ) ///
	,scheme(white_ptol) ///
	xlabel(1 "01/2019" 7 "07/2019" 13 "01/2020" ///
			19 "07/2020" 25 "01/2021", nogrid labsize(*1.3) labcolor(black)) ///
	ylabel(0 50 100 "01/2019=100" 150 200, nogrid labsize(*1.3)) ///
	xscale(range(1 28)) ///
	xline(6.5, lcolor("42 157 143")) ///
	xline(16.5, lcolor("119 152 235")) ///
	legend(order(3 "Shanghai" 2 "Beijing"  4 "Tianjin" 1 "Control Group Cities") position(5) ring(0) col(1) size(*1.3)) ///
	xtitle("") ytitle("") ///
	title(`"d. Search for "Pollution" (in Chinese) "', span place(w)) ///
	xsize(5) ysize(3.5) 
gr save "$data/FigS3-d.gph", replace  

* regression results

sum pc_and_mobile if keyword == "takeout"
reghdfe pc_and_mobile treatment if keyword == "takeout", absorb(city_id time_order) vce(cl city_id)
sum pc_and_mobile if keyword == "disposable_cutlery"
reghdfe pc_and_mobile treatment if keyword == "disposable_cutlery", absorb(city_id time_order) vce(cl city_id)
sum pc_and_mobile if keyword == "air_quality"
reghdfe pc_and_mobile treatment if keyword == "air_quality", absorb(city_id time_order) vce(cl city_id)
sum pc_and_mobile if keyword == "air_pollution"
reghdfe pc_and_mobile treatment if keyword == "air_pollution", absorb(city_id time_order) vce(cl city_id)
sum pc_and_mobile if keyword == "pollution"
reghdfe pc_and_mobile treatment if keyword == "pollution", absorb(city_id time_order) vce(cl city_id)

* event study
preserve 
keep if keyword == "pollution"
xtset city_id time_order
rename treatment t
* create var
		bysort city_id: gen t_sum = sum(t)

		forvalues i =0/9{
		gen D`i' = 0
		replace D`i' = 1 if t_sum ==`i'+1
		}
		replace D9 = 1 if t_sum >=10

		*
		forvalues i =1/8{
		gen Lead_D`i' = F`i'.D0
		replace Lead_D`i' = 0 if Lead_D`i'==.
		}
		*
		bys city_id : egen t_if = total(t)

		gen Lead_D9 = t - Lead_D1 - Lead_D2 - Lead_D3 - Lead_D4 - Lead_D5 - Lead_D6 - Lead_D7 - Lead_D8
		replace Lead_D9 = . if Lead_D9 != 0
		replace Lead_D9 = 1 if Lead_D9 == 0
		replace Lead_D9 = 0 if Lead_D9 == .
		replace Lead_D9 = 0 if t_if == 0	
		drop t_if
label var Lead_D9 "-9"	
label var Lead_D8 "-8"	
label var Lead_D7 "-7"	
label var Lead_D6 "-6"	
label var Lead_D5 "-5"	
label var Lead_D4 "-4"	
label var Lead_D3 "-3"	
label var Lead_D2 "-2"	
label var D0 "0"	
label var D1 "1"	
label var D2 "2"	
label var D3 "3"	
label var D4 "4"	
label var D5 "5"	
label var D6 "6"	
label var D7 "7"	
label var D8 "8"	
label var D9 "9"	

reghdfe pc_and_mobile Lead_D9 Lead_D8 Lead_D7 Lead_D6 Lead_D5 Lead_D4 Lead_D3 Lead_D2 D0 D1 D2 D3 D4 D5 D6 D7 D8 D9, absorb(city_id time_order) vce(cl city_id) 
parmest, saving(results/pollution.dta,replace)
coefplot ,drop(_cons) vertical scheme(white_ptol) yline(0) subtitle("suc")
restore




* graph 
use results/df.dta, clear
gen dup = _n
gen ab = (dup <= 19)
gen x = dup if ab == 1
replace x = dup - 19 if ab == 0
replace x = x+ 1 if x >= 9
replace x = 9 if x == 20
sort ab x
replace x = x - 10
foreach u of var stderr min95 max95 estimate{
	replace `u' = 0 if parm == "_cons"
}
gr tw (rcap max95 min95 x if ab == 1, plotr(m(zero))  lp(solid) lwidth(medium) lcolor("42 157 143")) ///
	(scatter estimate x if ab == 1, mfcolor("0 51 51") msize(medsmall) msymbol(circle)) ///
	,scheme(white_ptol) ///
	ylabel(-100 -50 0 50 100, nogrid labsize(*1.3) labcolor(black)) ///
	legend(order(2 "Estimated Impacts" 1 "95% CI" ) ring(0) position(1) size(*1.3) col(2)) ///
	xlabel(-10.5 " " -9 "≤9" -8 -7 -6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 7 8 9 "≥9" 10.5 " ", nogrid labsize(*1.3) labcolor(black)) ///
	xtitle("Months before and after Nudging", size(*1.5)) ///
	ytitle("") ///
	title(`"a. Search for "Food Delivery" (in Chinese) "', span place(w)) ///
	xsize(5) ysize(3.5) ///
	yline(0) xline(-1)
	
gr_edit .plotregion1.plot1.style.editstyle marker(size(vlarge)) 			
gr save "$data/FigS4-a.gph", replace  


* graph 
use results/suc.dta, clear
gen dup = _n
gen ab = (dup <= 19)
gen x = dup if ab == 1
replace x = dup - 19 if ab == 0
replace x = x+ 1 if x >= 9
replace x = 9 if x == 20
sort ab x
replace x = x - 10
foreach u of var stderr min95 max95 estimate{
	replace `u' = 0 if parm == "_cons"
}
gr tw (rcap max95 min95 x if ab == 1, plotr(m(zero))  lp(solid) lwidth(medium) lcolor("42 157 143")) ///
	(scatter estimate x if ab == 1, mfcolor("0 51 51") msize(medsmall) msymbol(circle)) ///
	,scheme(white_ptol) ///
	ylabel(-100 -50 0 50 100, nogrid labsize(*1.3) labcolor(black)) ///
	legend(order(2 "Estimated Impacts" 1 "95% CI" ) ring(0) position(1) size(*1.3)) ///
	xlabel(-10.5 " " -9 "≤9" -8 -7 -6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 7 8 9 "≥9" 10.5 " ", nogrid labsize(*1.3) labcolor(black)) ///
	xtitle("Months before and after Nudging", size(*1.5)) ///
	ytitle("") ///
	title(`"b. Search for "Single-Use Cutlery" (in Chinese) "', span place(w)) ///
	xsize(5) ysize(3.5) ///
	yline(0) xline(-1)
	
gr_edit .plotregion1.plot1.style.editstyle marker(size(vlarge)) 			
gr save "$data/FigS4-b.gph", replace  



* graph 
use results/plastic_w.dta, clear
gen dup = _n
gen ab = (dup <= 19)
gen x = dup if ab == 1
replace x = dup - 19 if ab == 0
replace x = x+ 1 if x >= 9
replace x = 9 if x == 20
sort ab x
replace x = x - 10
foreach u of var stderr min95 max95 estimate{
	replace `u' = 0 if parm == "_cons"
}
gr tw (rcap max95 min95 x if ab == 1, plotr(m(zero))  lp(solid) lwidth(medium) lcolor("42 157 143")) ///
	(scatter estimate x if ab == 1, mfcolor("0 51 51") msize(medsmall) msymbol(circle)) ///
	,scheme(white_ptol) ///
	ylabel(-100 -50 0 50 100, nogrid labsize(*1.3) labcolor(black)) ///
	legend(order(2 "Estimated Impacts" 1 "95% CI" ) ring(0) position(1) size(*1.3)) ///
	xlabel(-10.5 " " -9 "≤9" -8 -7 -6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 7 8 9 "≥9" 10.5 " ", nogrid labsize(*1.3) labcolor(black)) ///
	xtitle("Months before and after Nudging", size(*1.5)) ///
	ytitle("") ///
	title(`"c. Search for "Plastic Waste" (in Chinese) "', span place(w)) ///
	xsize(5) ysize(3.5) ///
	yline(0) xline(-1)
	
gr_edit .plotregion1.plot1.style.editstyle marker(size(vlarge)) 			
gr save "$data/FigS4-c.gph", replace 



* graph 
use results/pollution.dta, clear
gen dup = _n
gen ab = (dup <= 19)
gen x = dup if ab == 1
replace x = dup - 19 if ab == 0
replace x = x+ 1 if x >= 9
replace x = 9 if x == 20
sort ab x
replace x = x - 10
foreach u of var stderr min95 max95 estimate{
	replace `u' = 0 if parm == "_cons"
}
gr tw (rcap max95 min95 x if ab == 1, plotr(m(zero))  lp(solid) lwidth(medium) lcolor("42 157 143")) ///
	(scatter estimate x if ab == 1, mfcolor("0 51 51") msize(medsmall) msymbol(circle)) ///
	,scheme(white_ptol) ///
	ylabel(-100 -50 0 50 100, nogrid labsize(*1.3) labcolor(black)) ///
	legend(order(2 "Estimated Impacts" 1 "95% CI" ) ring(0) position(1) size(*1.3)) ///
	xlabel(-10.5 " " -9 "≤9" -8 -7 -6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 7 8 9 "≥9" 10.5 " ", nogrid labsize(*1.3) labcolor(black)) ///
	xtitle("Months before and after Nudging", size(*1.5)) ///
	ytitle("") ///
	title(`"d. Search for "Pollution" (in Chinese) "', span place(w)) ///
	xsize(5) ysize(3.5) ///
	yline(0) xline(-1)
	
gr_edit .plotregion1.plot1.style.editstyle marker(size(vlarge)) 			
gr save "$data/FigS4-d.gph", replace 














