/*=======================================================================

Purpose:
	1) Analysis the changes in Green Points

==========================================================================*/
clear
glo d "D:\..."

glo results "$d\results"
glo figures "$d\fig"
glo data "$d\data"
glo results "$d\results"

use "$data\energy_info.dta", clear
*****************************************************************************
* 			  PART A. Initializing (Green Points)		 					*
*****************************************************************************
drop md5_id
keep if year_month >= 201901
keep if year_month <= 202012
gen energy_gp = 1 if biz_type == "COLLECT"
replace energy_gp = 2 if biz_type == "PRODUCE_ENERGY"
replace energy_gp = 3 if biz_type == "ROB"
replace energy_gp = 4 if biz_type == "ROBBED"
drop biz_type

reshape wide energy_amt_1m energy_cnt_1m energy_day_cnt_1m, i(id year_month) j(energy_gp)

tostring year_month, replace
gen year = substr(year_month,1,4)
gen month = substr(year_month,5,6)
drop year_month
destring year month, replace
replace month = month+12 if year == 2020
drop year
merge 1:1 id month using "$data\workfile_long_full.dta"

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
egen city_month = group(city_id time_order)

*****************************************************************************
* 			  PART B. Regression		 					*
*****************************************************************************
* regression on absolute values: points collected
replace energy_amt_1m1=0 if energy_amt_1m1==.

cap erase "$results\Table_greenpoint.xls"
cap erase "$results\Table_greenpoint.txt"
	
	qui reghdfe energy_amt_1m1 t , absorb(id time_order) vce(cl id city_month)
	outreg2 using "$results\Table_greenpoint.xls", dec(3) append bracket nocon nor2 noobs label addstat(Obs., e(N), Adjusted R-Square, e(r2_a), Consumers, e(N_clust))
	parmest, saving("$results\fig_elements\fig_gp\T1_4.dta", replace)
	
* regression on absolute values: points produced
replace energy_amt_1m2=0 if energy_amt_1m2==.

	qui reghdfe energy_amt_1m2 t , absorb(id time_order) vce(cl id city_month)
	outreg2 using "$results\Table_greenpoint.xls", dec(3) append bracket nocon nor2 noobs label addstat(Obs., e(N), Adjusted R-Square, e(r2_a), Consumers, e(N_clust))
	parmest, saving("$results\fig_elements\fig_gp\T1_8.dta", replace)
	
* regression on absolute values: points produced from eleme
gen ne_energy = ne_*16
replace	ne_energy = 0 if ne_energy==.
	qui reghdfe ne_energy t , absorb(id time_order) vce(cl id city_month)
	outreg2 using "$results\Table_greenpoint.xls", dec(3) append bracket nocon nor2 noobs label addstat(Obs., e(N), Adjusted R-Square, e(r2_a), Consumers, e(N_clust))
	parmest, saving("$results\fig_elements\fig_gp\T1_1.dta", replace)	

	
	
	