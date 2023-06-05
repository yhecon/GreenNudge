/*=======================================================================

Purpose:
	1) RD regression at 1600 green points cutoff

==========================================================================*/
clear
glo d "..."

glo results "$d\results"
glo figures "$d\fig"
glo data "$d\data"
glo results "$d\results"
*****************************************************************************
* 			  PART A. Initializing (Green Points)		 					*
*****************************************************************************

use "$data\energy_info.dta", clear
drop md5_id
keep if year_month >= 201901
keep if year_month <= 202012
gen energy_gp = 1 if biz_type == "COLLECT"
replace energy_gp = 2 if biz_type == "PRODUCE_ENERGY"
replace energy_gp = 3 if biz_type == "ROB"
replace energy_gp = 4 if biz_type == "ROBBED"
drop biz_type
reshape wide energy_amt_1m energy_cnt_1m energy_day_cnt_1m, i(id year_month) j(energy_gp)
drop energy_cnt*
drop energy_day_cnt_*
tostring year_month, replace
gen year = substr(year_month,1,4)
gen month = substr(year_month,5,6)
drop year_month
destring year month, replace
replace month = month+12 if year == 2020
drop year
merge 1:1 id month using "$data\workfile_long_full.dta"

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
* how many individuals in the treated group
gen in_treat =  (city_name == "Beijing" | city_name == "Tianjin" | city_name == "Shanghai")
egen treat_id = group(in_treat city_name id) if in_treat !=0
* max(treat_id) = 110874
replace treat_id = -1 if treat_id ==.
* drop post-treatment
drop if t == 1

/*
preserve
replace energy_amt_1m1 = 0 if energy_amt_1m1 ==.
replace energy_amt_1m3 = 0 if energy_amt_1m3 ==.
replace energy_amt_1m1 = energy_amt_1m1 + energy_amt_1m3 
bys id : egen cum_gp_collect = total(energy_amt_1m1)
duplicates drop id, force
keep id cum_gp_collect
save "$data\pre-treat5.dta", replace
restore
*/

*****************************************************************************
* 			  PART B. Initializing (Analysis)		 					*
*****************************************************************************
clear
use "$data\workfile_long_full.dta", clear
merge m:1 id using "$data/pre-treat5.dta"
drop _merge
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

cap drop time_order
rename month time_order
gen month = time_order if time_order <= 12
replace month = time_order-12 if time_order >12
egen city_id = group(city_name)
egen city_month1 = group(city_id time_order)
cap drop t
gen t = (time_order >=7 & city_name == "Shanghai")
replace t = 1 if time_order >=17 & city_name == "Beijing"
replace t = 1 if time_order >=24 & city_name == "Tianjin"


gen down = (cum_gp_collect < 16000)
gen point_dis = cum_gp_collect - 15999

gen int1 = down*point_dis
gen int2 = t*down /* coefficient of interest */
gen int3 = t*point_dis
gen int4 = t*point_dis*down

*****************************************************************************
* 			  PART C. Regression	 					*
*****************************************************************************
cap erase "$results\rd.txt"
cap erase "$results\rd.xml"

 reghdfe p_e_ t int1 int2 int3 int4 down point_dis if abs(point_dis)<500, absorb(id time_order) vce(cl id city_month)
 outreg2 using "$results\rd.xls", dec(3) append bracket nocon nor2 noobs label addstat(Obs., e(N), Adjusted R-Square, e(r2_a), Consumers, e(N_clust))
 
 reghdfe p_e_ t int1 int2 int3 int4 down point_dis if abs(point_dis)<1000, absorb(id time_order) vce(cl id city_month)
 outreg2 using "$results\rd.xls", dec(3) append bracket nocon nor2 noobs label addstat(Obs., e(N), Adjusted R-Square, e(r2_a), Consumers, e(N_clust))
 
 reghdfe p_e_ t int1 int2 int3 int4 down point_dis if abs(point_dis)<1500, absorb(id time_order) vce(cl id city_month)
 outreg2 using "$results\rd.xls", dec(3) append bracket nocon nor2 noobs label addstat(Obs., e(N), Adjusted R-Square, e(r2_a), Consumers, e(N_clust))
 
 reghdfe p_e_ t int1 int2 int3 int4 down point_dis if abs(point_dis)<2000, absorb(id time_order) vce(cl id city_month)
 outreg2 using "$results\rd.xls", dec(3) append bracket nocon nor2 noobs label addstat(Obs., e(N), Adjusted R-Square, e(r2_a), Consumers, e(N_clust))
 
 reghdfe p_e_ t int1 int2 int3 int4 down point_dis if abs(point_dis)<2500, absorb(id time_order) vce(cl id city_month)
 outreg2 using "$results\rd.xls", dec(3) append bracket nocon nor2 noobs label addstat(Obs., e(N), Adjusted R-Square, e(r2_a), Consumers, e(N_clust))










