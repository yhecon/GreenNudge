/*=======================================================================

Purpose:
	1) heterogeneity by gender groups

==========================================================================*/
clear
glo d "..." /* Set you directory */

glo results "$d\results"
glo figures "$d\fig"
glo data "$d\data"
glo results "$d\results\T5"
glo elements "$d\results\fig_elements\fig8"

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

gen g_dummy = (gender == "女")
replace g_dummy = 0 if gender == "男"
gen i_g_t = g_dummy*t

xtset id time_order

sum p_e_ if gender == "女" & t ==0
sum p_e_ if gender == "男" & t ==0
egen city_month1 = group(city_id time_order)
		
	
*****************************************************************************
* 						PART B. Regression		 					*
*****************************************************************************
cap erase "$results\Table.xls"
cap erase "$results\Table.txt"

foreach u of var p_e_{

	qui reghdfe `u' t if g_dummy == 1, absorb(id time_order) vce(cl id city_month)
	outreg2 using "$results\Table.xls", dec(3) append bracket nocon nor2 noobs label addstat(Obs., e(N), Adjusted R-Square, e(r2_a), Consumers, e(N_clust))
	parmest, saving("$elements\T1_1_`u'.dta", replace)	
	
	qui reghdfe `u' t if g_dummy == 0, absorb(id time_order) vce(cl id city_month)
	outreg2 using "$results\Table.xls", dec(3) append bracket nocon nor2 noobs label addstat(Obs., e(N), Adjusted R-Square, e(r2_a), Consumers, e(N_clust))
	parmest, saving("$elements\T1_2_`u'.dta", replace)	
	
	qui reghdfe `u' t i_g_t , absorb(id time_order) vce(cl id city_month)
	outreg2 using "$results\Table.xls", dec(3) append bracket nocon nor2 noobs label addstat(Obs., e(N), Adjusted R-Square, e(r2_a), Consumers, e(N_clust))
	parmest, saving("$elements\T1_3_`u'.dta", replace)	
}

	
