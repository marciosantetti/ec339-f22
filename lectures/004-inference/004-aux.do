use "/Users/marciosantetti/Documents/Skidmore College/teaching/applied-metrics/fall-22/lectures/004-inference/wage2.dta"


reg lwage educ exper tenure 



* area:

display ttail(931, 1.96)

* critical value:

display invttail(931, 0.025)

* confidence intervals manually:

display _b[educ] + .0065124 * 1.96

display _b[educ] - .0065124 * 1.96
