clear


cd "`filedirname("`c(current_dofile)'")'"
import delimited "TempSelfControl.csv", clear

gen prob = 0 if _n<196
replace prob = 1 if sp==0
replace prob = 0.8 if sp==1
replace prob = 0.6 if sp==2
replace prob = 0.55 if sp==3
replace prob = 0.5 if sp==4
replace prob = 0.45 if sp==5
replace prob = 0.4 if sp==6
replace prob = 0.3 if sp==7
replace prob = 0.2 if sp==8
replace prob = 0.1 if sp==9
replace prob = 0 if sp==10 | sp==11

gen field = "Stem" if stem==1
replace field = "Econ" if economists==1
replace field = "Social" if social==1

gen German = german

**** TABLE 3

table1_mc, by(charity) ///
vars( ///
male  bine %4.2f \ ///
age  contn %4.2f \ ///
German  bine %4.2f \ ///
raven  contn %4.2f \ ///
field cate %4.2f \ ///
honesty contn %4.2f \ ///
agreeableness contn %4.2f \ ///
extraversion contn %4.2f \ ///
resiliency contn %4.2f \ ///
originality contn %4.2f \ ///
conscientiousness contn %4.2f \ ///
) ///
nospace percent onecol missing total(before) ///
saving("Table3.xlsx", replace)

**** TABLE 4

reg prob charity if msb==0, cluster(group)
outreg2 using Table4.xls, replace ctitle(Switching Point)
reg prob charity male stem social raven age german germanlang if msb==0, cluster(group)
outreg2 using Table4.xls, append ctitle(Switching Point)
reg prob charity male stem social raven german germanlang honesty conscientiousness extraversion originality agreeableness if msb==0, cluster(group)
outreg2 using Table4.xls, append ctitle(Switching Point)


