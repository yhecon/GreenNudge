/*=======================================================================

Purpose:
	1) Pre-treatment Characteristics

==========================================================================*/
clear
clear
glo d "..."

glo results "$d\results"
glo figures "$d\fig"
glo data "$d\data"
glo results "$d\results"

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

rename p_e_ p_e

egen city_month = group(city_id time_order)

* how many individuals in the treated group
gen in_treat =  (city_name == "Beijing" | city_name == "Tianjin" | city_name == "Shanghai")
egen treat_id = group(in_treat city_name id) if in_treat !=0
* max(treat_id) = 110874
replace treat_id = -1 if treat_id ==.

* drop post-treatment
drop if t == 1

* outcomes
bys id : egen ave_p = mean(p_e)

* characteristics: age_group, gender, income, frequency of ordering, 
* age
rename gprofile_pred_age_level age
replace age = ">=50" if age == "[50,54]" | age == "[55,59]" | age == ">=60"
tab age, gen(age_)
* gender
gen g_dummy = (gender == "女")
replace g_dummy = 0 if gender == "男"
* income
rename tb_mobile_value mobile
tab mobile, gen(mobile_)
* frequency of orders
bys id : egen ave_order = mean(n_)
* monthly expenditure
bys id : egen ave_money = mean(ota_)
* first order month
gen first_order_month = user_first_order_ds

drop user_first_order_ds
duplicates drop id, force
drop n_ ne_ ota_ lon_ lat_ nl_
drop vip88member_status

save "$data\pre-treat3.dta", replace

**** Analysis
use "$data\pre-treat3.dta", clear

cap erase "$results\Corr.xls"
cap erase "$results\Corr.txt"

reghdfe ave_p g_dummy mobile_1 mobile_2 mobile_3 age_3 age_4 age_5 age_6 age_7 age_1, a(city_id) vce(cl id)
outreg2 using "$results\T10\Corr.xls", dec(3) append bracket nocon nor2 noobs label addstat(Obs., e(N), Adjusted R-Square, e(r2_a), Consumers, e(N_clust))
parmest, saving("$results\Corr_1.dta", replace)

* order groups
gen ave_order1 = (ave_order <= 1 & ave_order != .)
gen ave_order2 = (ave_order <= 3 & ave_order > 1 & ave_order != .)
gen ave_order3 = (ave_order <= 6 & ave_order > 3 & ave_order != .)
gen ave_order4 = (ave_order <= 9 & ave_order > 6 & ave_order != .)
gen ave_order5 = (ave_order <= 12 & ave_order > 9 & ave_order != .)
gen ave_order6 = (ave_order <= 15 & ave_order > 12 & ave_order != .)
gen ave_order7 = (ave_order > 15 & ave_order != .)


reghdfe ave_p g_dummy mobile_1 mobile_2 mobile_3 age_3 age_4 age_5 age_6 age_7 age_1 ave_order2-ave_order7, a(city_id) vce(cl id)
outreg2 using "$results\Corr.xls", dec(3) append bracket nocon nor2 noobs label addstat(Obs., e(N), Adjusted R-Square, e(r2_a), Consumers, e(N_clust))
parmest, saving("$results\Corr_2.dta", replace)





