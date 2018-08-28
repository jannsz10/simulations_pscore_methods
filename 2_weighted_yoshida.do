 clear
cd "G:\Epidata Share\9) Tali Analyses\THESIS\propensity_scores\simulation study"

file open output using "2_output_sim_yoshida.csv", write replace
file write output ", exp=1, exp=2, confounder 1, confounder 2, confounder 3"
global numsims=1000
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
*save data.dta, replace
*-------------------------------------------------------------------
mlogit exp  con1 con2 con3 
predict ps0 ps1 ps2
*hist ps1, by(exp)
** min PS - numerator
gen ps_min2= min(ps0 , ps1, ps2)
** dummy vars for treatment levels
*tab treat, gen(treat)

**PS for assigned treatment - denominator
 gen ps_assign2 = (exp0)*ps0 + exp1* ps1+ exp2* ps2
** generate weight 
gen mw2=ps_min2/ps_assign2
** regress using probability weighting
 
stset dout [pw=mw2], failure(outcome) 
stcox i.exp  
local out1 =exp(_b[1.exp])
local out2 =exp(_b[2.exp])
file write output _n "`x',`out1', `out2' "

}

file close output




stset dout  , failure(outcome) 
stcox i.exp  con1 con2 con3
