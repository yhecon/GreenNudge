/*=======================================================================

Purpose:
	1) Figure 2D. Distribution of Individual Treatment Effects (%)

==========================================================================*/

clears
glo d "..." /* Set you directory */

glo results "$d\results"
glo figures "$d\fig"
glo data "$d\data"
glo results "$d\results"

use "$data\workfile_long_full.dta", clear

*****************************************************************************
* 						PART A. Initializing		 					*
*****************************************************************************
replace ne_ =. if n_`i'< 1
replace ota_ =. if n_`i'< 1
replace n_ =. if n_`i'< 1

gen p_e_ = ne_/n_* 100

replace city_name = "Shanghai" if city_name == "上海"		 
replace city_name = "Beijing" if city_name == "北京"		 
replace city_name = "Xi'an" if city_name == "西安"		 
replace city_name = "Nanjing" if city_name == "南京"		 
replace city_name = "Guangzhou" if city_name == "广州"		 
replace city_name = "Tianjin" if city_name == "天津"		 
replace city_name = "Chengdu" if city_name == "成都"		 
replace city_name = "Hangzhou" if city_name == "杭州"		 
replace city_name = "Wuhan" if city_name == "武汉"		 
replace city_name = "Qingdao" if city_name == "青岛"

rename month time_order
gen month = time_order if time_order <= 12
replace month = time_order-12 if time_order >12
gen year = (time_order>12)+2019
gen yearmonth = ym(year,month)

* treatment
gen t = (time_order >=7 & city_name == "Shanghai")
replace t = 1 if time_order >=17 & city_name == "Beijing"
replace t = 1 if time_order >=24 & city_name == "Tianjin"
egen city_id = group(city_name)
egen city_ym = group(city_name time_order)
egen id_ym = group(id time_order)

rename p_e_ p_e

egen city_month = group(city_id time_order)

sum p_e if city_name != "Beijing" & city_name != "Tianjin" & t == 0
sum p_e if city_name != "Shanghai"  & city_name != "Tianjin" & t == 0
sum p_e  if city_name != "Shanghai"  & city_name != "Beijing" & t == 0
sum p_e  if  t == 0

* how many individuals in the treated group
gen in_treat =  (city_name == "Beijing" | city_name == "Tianjin" | city_name == "Shanghai")
/*
. tab in_treat

   in_treat |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |  2,068,512       43.74       43.74
          1 |  2,660,976       56.26      100.00
------------+-----------------------------------
      Total |  4,729,488      100.00
*/
egen treat_id = group(in_treat city_name id) if in_treat !=0
* max(treat_id) = 110874
replace treat_id = -1 if treat_id ==.

gen b_coe =.

drop gender gprofile_pred_age_level user_first_order_ds tb_mobile_value vip88member_status
drop n_ ne_ ota_ lon_ lat_ nl_ month year yearmonth
drop city_name city_id city_ym id_ym in_treat
drop city_month /* we just need coefficients */
gen se_coe =.

*****************************************************************************
* 						PART B. Regression in Loop		 					*
*****************************************************************************

forvalues i = 1/110874{
save "$data\workfile_long_full_tempc1.dta", replace
	di "Currently we focus on `i'"
qui reghdfe p_e t if treat_id==`i' | treat_id == -1, absorb(id time_order) vce(cl id)
replace b_coe = _b[t] if treat_id==`i'
replace se_coe = _se[t] if treat_id==`i'

}

/* check the last regression */
use "$data\workfile_long_full_tempc1.dta", clear
qui reghdfe p_e t if treat_id==110874 | treat_id == -1, absorb(id time_order) vce(cl id)
replace b_coe = _b[t] if treat_id==110874
replace se_coe = _se[t] if treat_id==110874

drop if b_coe ==.
collapse b_coe se_coe, by(id)
hist b_coe if b_coe !=0
save "$data\id_coefficient.dta", replace


*****************************************************************************
* 						PART C. Exporting				*
*****************************************************************************
use "$data\workfile_long_full.dta", clear
duplicates drop id, force
drop month user_first_order_ds n_ ne_ ota_ lon_ lat_ nl_
merge 1:1 id using "$data\id_coefficient.dta"
keep if _merge ==3
drop _merge
save "$data\id_coefficient.dta", replace


*****************************************************************************
* 			  PART D. Merging with Groups and Estimates				*
*****************************************************************************

use "$data\workfile_long_full.dta", clear
replace ne_ =. if n_`i'< 1
replace ota_ =. if n_`i'< 1
replace n_ =. if n_`i'< 1

gen p_e_ = ne_/n_* 100

replace city_name = "Shanghai" if city_name == "上海"		 
replace city_name = "Beijing" if city_name == "北京"		 
replace city_name = "Xi'an" if city_name == "西安"		 
replace city_name = "Nanjing" if city_name == "南京"		 
replace city_name = "Guangzhou" if city_name == "广州"		 
replace city_name = "Tianjin" if city_name == "天津"		 
replace city_name = "Chengdu" if city_name == "成都"		 
replace city_name = "Hangzhou" if city_name == "杭州"		 
replace city_name = "Wuhan" if city_name == "武汉"		 
replace city_name = "Qingdao" if city_name == "青岛"

rename month time_order
gen month = time_order if time_order <= 12
replace month = time_order-12 if time_order >12
gen year = (time_order>12)+2019
gen yearmonth = ym(year,month)
* treatment
gen t = (time_order >=7 & city_name == "Shanghai")
replace t = 1 if time_order >=17 & city_name == "Beijing"
replace t = 1 if time_order >=24 & city_name == "Tianjin"
egen city_id = group(city_name)
egen city_ym = group(city_name time_order)
egen id_ym = group(id time_order)

rename p_e_ p_e l_p_e

egen city_month = group(city_id time_order)

sum p_e if city_name != "Beijing" & city_name != "Tianjin" & t == 0
sum p_e if city_name != "Shanghai"  & city_name != "Tianjin" & t == 0
sum p_e  if city_name != "Shanghai"  & city_name != "Beijing" & t == 0
sum p_e  if  t == 0

* how many individuals in the treated group
gen in_treat =  (city_name == "Beijing" | city_name == "Tianjin" | city_name == "Shanghai")
egen treat_id = group(in_treat city_name id) if in_treat !=0
* max(treat_id) = 110874
replace treat_id = -1 if treat_id ==.
drop if treat_id ==-1

bys id t : egen ave_p = mean(p_e)
duplicates drop id t, force
keep id t ave_p
reshape wide ave_p, i(id) j(t)

merge 1:1 id using "$data/id_everNC.dta"

keep if _merge == 3
drop _merge

merge 1:1 id using "$data/id_coefficient.dta"
drop city_name gender gprofile_pred_age_level tb_mobile_value vip88member_status _merge

save "$data/distribution_plot_element.dta", replace
 
*****************************************************************************
* 						PART E. Graphing				*
*****************************************************************************
use "$data/distribution_plot_element.dta", clear

drop if b_coe == 0 & se_coe == 0

gen upper = b_coe+1.64*se_coe
gen lower = b_coe-1.64*se_coe
gen p_valid = (upper*lower>0)


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


collapse (sum) g_0-g_202, by(p_valid)

gen city_name =1 

reshape long g_, i(city_name p_valid) j(num )
bys city_name : egen total_pop = total(g_)
replace g_ = g_/total_pop
replace g_ = 100*g_	


replace num = num-1 if num>=101

egen negative = total(g_) if p_valid == 1 & num <101
egen noimpact = total(g_) if p_valid == 0
egen positive = total(g_) if p_valid == 1 & num >=101

gr tw (scatteri 0 0,  connect(L) lp(shortdash) m(none) lcolor(black) lwidth(thin)) ///
		(bar g_ num if num <101, plotr(m(zero)) color(black)) ///
		(bar g_ num if  num >=101, color("42 157 143")) ///
		(bar g_ num if p_valid == 0, color("184 182 111")) ///
	,scheme(white_ptol) ///
	xlabel(0 "≤-100" 25 "-75" 50 "-50" 75 "-25" 101 "0" 126 "25" 151 "50" 176 "75" 202 ">100", nogrid labsize(*1.3) labcolor(black)) ///
	ylabel(0 10 20 30, nogrid labsize(*1.3)) ///
	xsize(4.5) ysize(5) ///
	xtitle("Coefficient(s)", size(*1.3)) ytitle("") ///
	legend(order(2 "Negative Impacts ({it:p}<0.1): 10.9%" 4 "Insignificant Impacts ({it:p}>0.1): 6.4%" 3 "Positive Impacts ({it:p}<0.1): 82.7%") ring(0) col(1) position(11)) ///
	title("d. Distribution of Individual Treatment Effects (%)" " ", span place(w)) 	

gr export "$figures/Fig-2d.png", replace width(1200)	




