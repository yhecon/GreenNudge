/*=======================================================================

Purpose:
	1) Table S2. Green Nudges' Impacts in Medium- and Long-Run

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

xtset id time_order
* create var
		bysort id: gen t_sum = sum(t)

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
		bys id : egen t_if = total(t)

		gen Lead_D9 = t - Lead_D1 - Lead_D2 - Lead_D3 - Lead_D4 - Lead_D5 - Lead_D6 - Lead_D7 - Lead_D8
		replace Lead_D9 = . if Lead_D9 != 0
		replace Lead_D9 = 1 if Lead_D9 == 0
		replace Lead_D9 = 0 if Lead_D9 == .
		
cap drop rowsum
egen rowsum = rowtotal(D0-Lead_D8 Lead_D9)
tab rowsum
drop t_if
		
egen city_month = group(city_id time_order)
		

*****************************************************************************
* 						PART B. Regression		 					*
*****************************************************************************
cap erase "$results/Table2.xls"
cap erase "$results/Table2.txt"
	qui reghdfe p_e Lead_D9 Lead_D8 Lead_D7 Lead_D6 Lead_D5 Lead_D4 Lead_D3 Lead_D2 D0 D1 D2 D3 D4 D5 D6 D7 D8 D9, absorb(id time_order) vce(cl id city_month)
	outreg2 using "$results/Table2.xls", dec(3) append bracket nocon nor2 noobs label addstat(Obs., e(N), Adjusted R-Square, e(r2_a), Consumers, e(N_clust))
	parmest, saving("$results/fig_elements/T2_1.dta", replace)

	
	
	
