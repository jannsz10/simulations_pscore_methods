clear
cd "G:\Epidata Share\9) Tali Analyses\THESIS\propensity_scores\simulation study"


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

gen outcome= rbinomial(1, 0.001+exp1*.0005+exp2*0.0005+con1*0.0005+con2*0.00005+con3*0.0005)
gen dout= t if outcome==1
bysort id: egen dout1=min(dout)
drop if t>dout1
replace dout=dout1
bysort id: egen cens=max(t)
replace dout=cens if dout==.
keep if t==dout
drop cens dout1
*save data.dta, replace

stset dout, failure(outcome)
stcox i.exp con1 con2 con3

