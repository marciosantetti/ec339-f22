clear


use okun



gen period = tq(1978q2) +_n-1


format period %tq

* now, declare as time-series:

tsset period


* create lagged variable


gen lag1_u = l1.u

* create du

gen du = u - lag1_u


* okun's regression:

reg du g

predict u_hat, residuals


twoway (line u_hat period)


* durbin-watson:

estat dwatson

* breusch-godfrey:

estat bgodfrey, lag(1) nomiss0


* cochrane-orcutt:

prais du g, corc


******--------------------------------------------------------------***



clear

use inequality

gen period = 1921 + _n-1

tsset period


reg us_share us_tax


estat dwatson

estat bgodfrey, lag(1) nomiss0


predict u_hat, residuals

twoway (line u_hat period)

ac u_hat

prais us_share us_tax, corc



reg us_share us_tax

estat ovtest


******--------------------------------------------------------------***


clear


keep if country == "United States"

tsset year


reg csumptn hours gov r inc

vif

estat dwatson

estat bgodfrey, lag(1) nomiss0

reg csumptn hours gov inc l1.csumptn


vif

estat dwatson

estat bgodfrey, lag(1) nomiss0


estat ovtest
