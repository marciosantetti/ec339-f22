**************** Problem 1 *****************
/* A. OLS robustness using MC analysis*/
clear
set seed 12345
postfile buffer1 beta se_x tstat using ols, replace 
forvalues i=1/1000{
	quietly drop _all
	quietly set obs 50
	quietly gen double x=rnormal()
	quietly gen double e=rnormal(0,sqrt(1+exp(x)))
	quietly gen double y=2+1*x+e
	quietly reg y x
	post buffer1 (_b[x]) (_se[x]) ((_b[x]-1)/_se[x])
}
postclose buffer1              // Estimate beta 1000 times and store results in ols.dta 

use ols, clear                // Check for unbiasedness: t-test of the estimated slope "beta" 
ttest beta==1

su tstat, detail              // Inference properties of the model: percentiles of t-stat 
count if abs(tstat)>1.96      // The count is 108 

su se_x                       // Average estimated standard error is  .231617 



/* B. Robustness of White SE using MC analysis */
clear
set seed 12345
postfile buffer2 beta se_x tstat using robust, replace 
forvalues i=1/1000{
	quietly drop _all
	quietly set obs 50
	quietly gen double x=rnormal()
	quietly gen double e=rnormal(0,sqrt(1+exp(x)))
	quietly gen double y=2+1*x+e
	quietly  reg  y x, vce(robust)
	post buffer2 (_b[x]) (_se[x]) ((_b[x]-1)/_se[x])
}
postclose buffer2               // Estimate beta 1000 times and store results in robust.dta 

use robust, clear              
su tstat, detail               // Inference properties of the model: percentiles of t-stat 
count if abs(tstat)>1.96       // The count is 68

su se_x                       // Average estimated standard error is  .2652483


/* C. Changing number of observations */
clear
set seed 12345
postfile buffer3 beta se_x tstat using ols, replace 
forvalues i=1/1000{
	quietly drop _all
	quietly set obs 5
	quietly gen double x=rnormal()
	quietly gen double e=rnormal(0,sqrt(1+exp(x)))
	quietly gen double y=2+1*x+e
	quietly reg y x
	post buffer3 (_b[x]) (_se[x]) ((_b[x]-1)/_se[x])
}
postclose buffer3               // Changing the number of observations to 5, 10, 200 for both OLS and White robust model. Obtain the corresponding rejection rates 

use ols, clear 
count if abs(tstat)>1.96        


/* D. FGLS */
clear
set seed 12345
postfile buffer4 beta se_x tstat using fgls, replace 
forvalues i=1/1000{
	quietly drop _all
	quietly set obs 50
	quietly gen double x=rnormal()
	quietly gen double e=rnormal(0,sqrt(1+exp(x)))
	quietly gen double y=2+1*x+e
	quietly reg y x
	predict double ehat, resid
	quietly gen double ehatsq=ehat^2
	quietly gen double exp_x=exp(x)
	quietly  reg ehatsq exp_x
	quietly predict double var_e, xb
	quietly reg y x [aweight=1/var_e]
	post buffer4 (_b[x]) (_se[x]) ((_b[x]-1)/_se[x])
}
postclose buffer4  

use fgls, clear    
su beta       
ttest beta==1
su se_x                         // Average estimated standard error is .2318213
count if abs(tstat)>1.96        // The count is 81

/* E. New d.g.p. */
* i. OLS with naive SE
clear
set seed 12345
postfile buffer5 beta se_x tstat using ols2, replace 
forvalues i=1/1000{
	quietly drop _all
	quietly set obs 50
	quietly gen double x=rnormal()
	quietly gen double e=rnormal(0,sqrt(1+3*abs(x)))
	quietly gen double y=2+1*x+e
	quietly reg y x
	post buffer5 (_b[x]) (_se[x]) ((_b[x]-1)/_se[x])
}
postclose buffer5              
use ols2, clear               
ttest beta==1

su tstat, detail               
count if abs(tstat)>1.96      // The count is 133 

su se_x                       // Average estimated standard error is  .2622604

* ii. OLS with White-robust SE
clear
set seed 12345
postfile buffer6 beta se_x tstat using robust2, replace 
forvalues i=1/1000{
	quietly drop _all
	quietly set obs 50
	quietly gen double x=rnormal()
	quietly gen double e=rnormal(0,sqrt(1+3*abs(x)))
	quietly gen double y=2+1*x+e
	quietly reg y x, vce(robust)
	post buffer6 (_b[x]) (_se[x]) ((_b[x]-1)/_se[x])
}
postclose buffer6              
use robust2, clear               
ttest beta==1

su tstat, detail               
count if abs(tstat)>1.96      // The count is 76 

su se_x                       // Average estimated standard error is  .3206091

* iii. FGLS with incorrect heteroskedaticity
clear
set seed 12345
postfile buffer7 beta se_x tstat using fgls2, replace 
forvalues i=1/1000{
	quietly drop _all
	quietly set obs 50
	quietly gen double x=rnormal()
	quietly gen double e=rnormal(0,sqrt(1+3*abs(x)))
	quietly gen double y=2+1*x+e
	quietly reg y x
	predict double ehat, resid
	quietly gen double ehatsq=ehat^2
	quietly gen double exp_x=exp(x)
	quietly  reg ehatsq exp_x
	quietly predict double var_e, xb
	quietly reg y x [aweight=1/var_e]
	post buffer7 (_b[x]) (_se[x]) ((_b[x]-1)/_se[x])
}
postclose buffer7  

use fgls2, clear    
su beta       
ttest beta==1
su se_x                         // Average estimated standard error is  .2616543
count if abs(tstat)>1.96        // The count is 153

* iv. FGLS with correct heteroskedaticity
clear
set seed 12345
postfile buffer8 beta se_x tstat using fgls3, replace 
forvalues i=1/1000{
	quietly drop _all
	quietly set obs 50
	quietly gen double x=rnormal()
	quietly gen double e=rnormal(0,sqrt(1+3*abs(x)))
	quietly gen double y=2+1*x+e
	quietly reg y x
	predict double ehat, resid
	quietly gen double ehatsq=ehat^2
	quietly gen double abs_x=abs(x)
	quietly  reg ehatsq abs_x
	quietly predict double var_e, xb
	quietly reg y x [aweight=1/var_e]
	post buffer8 (_b[x]) (_se[x]) ((_b[x]-1)/_se[x])
}
postclose buffer8  

use fgls3, clear    
su beta       
ttest beta==1
su se_x                         // Average estimated standard error is .311863
count if abs(tstat)>1.96        // The count is 80

* v. FGLS with incorrect heteroskedaticity & White-robust
clear
set seed 12345
postfile buffer9 beta se_x tstat using fgls4, replace 
forvalues i=1/1000{
	quietly drop _all
	quietly set obs 50
	quietly gen double x=rnormal()
	quietly gen double e=rnormal(0,sqrt(1+3*abs(x)))
	quietly gen double y=2+1*x+e
	quietly reg y x
	predict double ehat, resid
	quietly gen double ehatsq=ehat^2
	quietly gen double abs_x=abs(x)
	quietly  reg ehatsq abs_x
	quietly predict double var_e, xb
	quietly reg y x [aweight=1/var_e], vce(robust)
	post buffer9 (_b[x]) (_se[x]) ((_b[x]-1)/_se[x])
}
postclose buffer9  

use fgls4, clear    
su beta       
ttest beta==1
su se_x                         // Average estimated standard error is .3120692
count if abs(tstat)>1.96        // The count is 73







**************** Problem 2 *****************
/* A. Omitted variable bias */
clear
set seed 12345
postfile buffer10 beta se_vol tstat liqd vol size using ovb, replace 
forvalues i=1/1000{
	quietly drop _all
	quietly set obs 500
	quietly gen double vol=exp(rnormal())
	quietly gen double e=rnormal()
	quietly gen double size=2*vol+rnormal()
	quietly gen double liqd=1+2*vol+1*size+e
	quietly reg liqd vol
	post buffer10 (_b[vol]) (_se[vol]) ((_b[vol]-2)/_se[vol]) (liqd) (vol) (size)
}
postclose buffer10              // Estimate beta 1000 times and store results in ovb.dta 

use ovb, clear                
ttest beta==2

su tstat, detail              // Inference properties of the model: percentiles of t-stat 
count if abs(tstat)>1.96      // The count is 1000 

* Calculate bias using the formula
correlate liqd vol, covariance    //Obtain cov(liqd,vol)=16.0332 and var(vol)=3.95796

quietly gen bias_lhs=16.0332/3.95796
di bias_lhs                        //The bias using lhs of equation is 4.0508747

quietly reg size vol
quietly gen delta=_b[vol]
di delta
quietly gen bias_rhs=2+delta*1
di bias_rhs                      //The bias using rhs of equation is 4.026557


/* B. Bad control bias */
clear
set seed 12345
postfile buffer11 beta se_vol tstat using badcontrol, replace 
forvalues i=1/1000{
	quietly drop _all
	quietly set obs 500
	quietly gen double vol=exp(rnormal())
	quietly gen double e=rnormal()
	quietly gen double size=exp(rnormal())
	quietly gen double liqd=1+2*vol+1*size+e
	quietly gen double mcap=1+0.5*vol+0.5*size
	quietly reg liqd vol mcap
	post buffer11 (_b[vol]) (_se[vol]) ((_b[vol]-2)/_se[vol])
}
postclose buffer11              // Estimate beta 1000 times and store results in badcontrol.dta 

use badcontrol, clear                
ttest beta==2

su tstat, detail              // Inference properties of the model: percentiles of t-stat 
count if abs(tstat)>1.96      // The count is 1000 






**************** Problem 3 *****************
/* A. Summary statistics */
set more off
use "/FILE PATH/kenya.dta"
tabstat test00 test01 test02 math cognitive vocab, stats(n mean med sd p5 p95) format(%9.4f) by(treat) col(stats)
ttest test00, by (treat)
ttest test01, by (treat)
ttest test02, by (treat)
ttest math, by (treat)
ttest cognitive, by (treat)
ttest vocab, by (treat)

/* C. Scatterplot */
separate test01, by(treat)
twoway (scatter test010 test00)(scatter test011 test00), ///
ytitle(test score 2001) legend(order(1 "treated" 0 "control"))

/* D. Kernel density */
* i. Epanechnikov kernel with “optimal” bandwidth
kdensity test00

* ii. Epanechnikov kernel with “optimal” bandwidth equal to 0.05
kdensity test00, bwidth(0.05)

* iii. Gaussian kernel with optimal bandwidth
kdensity test00, kernel(gaussian)

/* E. Kernel for two groups */
kdensity test00 if treat == 1, addplot(kdensity test00 if treat == 0) legend(ring(0) pos(2) label(1 "Treated") label(2 "Control"))
kdensity test01 if treat == 1, addplot(kdensity test01 if treat == 0) legend(ring(0) pos(2) label(1 "Treated") label(2 "Control"))
kdensity test02 if treat == 1, addplot(kdensity test02 if treat == 0) legend(ring(0) pos(2) label(1 "Treated") label(2 "Control"))





**************** Problem 4 *****************
/* A. Proof by regressions */
clear
quietly set obs 1000
set seed 10101
gen x_true=rnormal()
gen e=rnormal()
gen y=1+1*x_true+e
gen u=rnormal()
gen x_observed=x_true+u
reg y x_true
reg y x_observed

/* B. MC analysis of measurement error */
* MC with measurement error
clear
set seed 10101
postfile buffer12 beta se_x tstat using m_error, replace 
forvalues i=1/1000{
	quietly drop _all
	quietly set obs 10000
	quietly gen double x_true=rnormal()
	quietly gen double e=rnormal()
	quietly gen double y=1+1*x_true+e
	quietly gen double u=rnormal()
	quietly gen double x_observed=x_true+u
	quietly reg y x_observed
	post buffer12 (_b[x_observed]) (_se[x_observed]) ((_b[x_observed]-1)/_se[x_observed])
}
postclose buffer12              // Estimate beta 1000 times and store results in m_error.dta 

use m_error, clear                
ttest beta==1
su beta se_x
su tstat, detail              // Inference properties of the model: percentiles of t-stat 
count if abs(tstat)>1.96      // The count is 1000 

* MC w/o measurement error
clear
set seed 10101
postfile buffer13 beta se_x tstat using true, replace 
forvalues i=1/1000{
	quietly drop _all
	quietly set obs 10000
	quietly gen double x_true=rnormal()
	quietly gen double e=rnormal()
	quietly gen double y=1+1*x_true+e
	quietly gen double u=rnormal()
	quietly gen double x_observed=x_true+u
	quietly reg y x_true
	post buffer13 (_b[x_true]) (_se[x_true]) ((_b[x_true]-1)/_se[x_true])
}
postclose buffer13              // Estimate beta 1000 times and store results in true.dta 

use true, clear                
ttest beta==1
su beta se_x


/* C. Additional regressor */
clear
quietly set obs 1000
set seed 10101
gen x1_true=rnormal()
gen x2_true=rnormal()
gen e=rnormal()
gen y=1+1*x1_true+x2_true+e
gen u=rnormal()
gen x1_observed=x1_true+u
reg y x1_observed x2_true
reg y  x2_true



