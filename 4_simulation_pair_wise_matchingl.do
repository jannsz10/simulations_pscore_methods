 clear
cd "G:\Epidata Share\9) Tali Analyses\THESIS\propensity_scores\simulation study"

file open output using "4_output_sim_matched_pairwise.csv", write replace
file write output ", exp=1, exp=2, confounder 1, confounder 2, confounder 3"
global numsims=10000
forvalues x = 1/$numsims {
clear
set obs 10000

gen con1= rbinomial(1, 0.5)
gen con2= 40*runiform()   +18
gen con3= rbinomial(1, 0.1)

gen exp1=rbinomial(1, 0.2+ 0.05 * con1 + 0.005*con2 + 0.1*con3)
gen exp2=rbinomial(1, 0.2+ 0.05 * con1 + 0.005*con2 + 0.1*con3)
replace exp1=0 if exp2==1

gen exp=0 
replace exp=1 if exp1==1
replace exp=2 if exp2==1
gen exp0=exp==0
sample 2820 if exp==0, count
sample 463 if exp==1, count
sample 322 if exp==2, count

 
gen id=_n
gen t= round(200*runiform())
expand t
drop t
bysort id: gen t=_n
*gen outcome= rbinomial(1, 0.001+exp1*.0005+exp2*0.0005+0.0005)

gen outcome= rbinomial(1, (0.001+con1*0.0005+con2*0.00005+con3*0.0005)*(1+exp1*0.5+exp2*0.5))
gen dout= t if outcome==1
bysort id: egen dout1=min(dout)
drop if t>dout1
replace dout=dout1
bysort id: egen cens=max(t)
replace dout=cens if dout==.
keep if t==dout
drop cens dout1
save data.dta, replace
*-------------------------------------------------------------------
** matched - exp1 
drop if exp2==1
 psmatch2 exp1 con1 con2 con3, neighbor(1)  noreplacement 
preserve
keep  if _weight==1 & exp==0
save controls1.dta, replace
restore
drop   if _weight==1 & exp==0
 psmatch2 exp1 con1 con2 con3, neighbor(1)  noreplacement 
append using controls1
 keep if _weight==1
 
stset dout , failure(outcome) 
stcox exp1  
local out1 =exp(_b[exp1])
  
stset dout , failure(outcome) 
stcox exp1  
local out1 =exp(_b[exp1])

 **matched - exp2
 use data.dta, replace
 drop if exp1==1
 psmatch2 exp2 con1 con2 con3, neighbor(1)  noreplacement 
preserve
keep  if _weight==1 & exp==0
save controls1.dta, replace
restore
drop   if _weight==1 & exp==0
 psmatch2 exp2 con1 con2 con3, neighbor(1)  noreplacement 
append using controls1
 keep if _weight==1
 
stset dout , failure(outcome) 
stcox exp2  
local out2 =exp(_b[exp2])

file write output _n "`x',`out1', `out2' "

}
file close output
