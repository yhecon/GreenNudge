/*=======================================================================

Purpose:
	1) heterogeneity TableS7

==========================================================================*/
clear
glo d "..."

glo results "$d\results"
glo figures "$d\fig"
glo data "$d\data"
glo results "$d\results"

use "$data\workfile_long_full.dta", clear
*****************************************************************************
* 		                  	  PART A. Initializing 	 					*
*****************************************************************************
merge m:1 id using "$data/pre-treat3.dta"
drop _merge

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
egen city_month1 = group(city_id time_order)
cap drop t
gen t = (time_order >=7 & city_name == "Shanghai")
replace t = 1 if time_order >=17 & city_name == "Beijing"
replace t = 1 if time_order >=24 & city_name == "Tianjin"

* interaction - personal info
foreach u of var  g_dummy age_3 age_4 age_5 age_6 age_7 age_1 mobile_1 mobile_2 mobile_3{
	gen v`u' = t*`u'
}
*	

* interaction - No. of Orders
foreach u of var  ave_order ave_money{
	gen v`u' = t*`u'
}
*	
gen ave_order1 = (ave_order <= 1 & ave_order != .)
gen ave_order2 = (ave_order <= 3 & ave_order > 1 & ave_order != .)
gen ave_order3 = (ave_order <= 6 & ave_order > 3 & ave_order != .)
gen ave_order4 = (ave_order <= 9 & ave_order > 6 & ave_order != .)
gen ave_order5 = (ave_order <= 12 & ave_order > 9 & ave_order != .)
gen ave_order6 = (ave_order <= 15 & ave_order > 12 & ave_order != .)
gen ave_order7 = (ave_order > 15 & ave_order != .)

egen median_ave_money = median(ave_money)
gen above_ave_money = (ave_money>median_ave_money)

*****************************************************************************
* 		              PART E. Regresssion: Table-S7 					*
*****************************************************************************
*price per order
gen ave_price = ave_money/ave_order

preserve 
duplicates drop id, force
drop if ave_order ==.
_pctile ave_price, p(20)
return list
_pctile ave_price, p(40)
return list
_pctile ave_price, p(60)
return list
_pctile ave_price, p(80)
return list
restore

gen aveprice1 = (ave_price <= 32.02  & ave_order != .)
gen aveprice2 = (ave_price <= 38.52 & aveprice1 !=1  & ave_order != .)
gen aveprice3 = (ave_price <= 45.69 & aveprice1 !=1 & aveprice2 !=1  & ave_order != .)
gen aveprice4 = (ave_price <= 57.68 & aveprice1 !=1 & aveprice2 !=1 & aveprice3 !=1  & ave_order != .)
gen aveprice5 = (aveprice1 !=1 & aveprice2 !=1 & aveprice3 !=1 & aveprice4 !=1 & ave_order != .)

forvalues i = 1/5{
	gen v_aveprice`i' = aveprice`i'*t
}

reghdfe p_e_ t v_aveprice2- v_aveprice5,  absorb(id time_order) vce(cl id city_month)

reghdfe p_e_ t if aveprice1 == 1 & ave_order !=.,  absorb(id time_order) vce(cl id city_month)
sum p_e_ if aveprice1 == 1 & ave_order !=. & t == 0

reghdfe p_e_ t if aveprice2 == 1 & ave_order !=.,  absorb(id time_order) vce(cl id city_month)
sum p_e_ if aveprice2 == 1 & ave_order !=. & t == 0

reghdfe p_e_ t if aveprice3 == 1 & ave_order !=.,  absorb(id time_order) vce(cl id city_month)
sum p_e_ if aveprice3 == 1 & ave_order !=. & t == 0

reghdfe p_e_ t if aveprice4 == 1 & ave_order !=.,  absorb(id time_order) vce(cl id city_month)
sum p_e_ if aveprice4 == 1 & ave_order !=. & t == 0

reghdfe p_e_ t if aveprice5 == 1 & ave_order !=.,  absorb(id time_order) vce(cl id city_month)
sum p_e_ if aveprice5 == 1 & ave_order !=. & t == 0
