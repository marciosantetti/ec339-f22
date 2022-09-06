* Load cdc data:

import delimited "/Users/marciosantetti/Documents/Skidmore College/teaching/applied-metrics/fall-22/lectures/000-stats-refresher/cdc_data.csv"



* stata colors: https://github.com/dclt/stata-colors


* browse

browse


* summarize

summarize


* more specific


tabstat poverty_rate unemployment_rate, statistics(n mean median variance sd min max)


*  filter specific year (2017):

keep if (year == 2017) 


* filter more than 1 state and tabulate by state

keep if (stname == "New York" | stname == "Utah")

tabstat poverty_rate unemployment_rate, by(stname) statistics(mean sd median)



* save filtered data set

save cdc_data17

* then use it

use cdc_data17


* generate death_rate variable

gen death_rate = deaths/population*100000


* correlation (with and without covariance):

correlate poverty_rate death_rate

correlate poverty_rate death_rate, covariance


* plots

twoway scatter (unemployment_rate death_rate), by(stname)


histogram death_rate, kdensity


graph box (death_rate poverty_rate)



* Now, time series data:

clear


keep if (stname == "New York") 


save cdc_data_ny

use cdc_data_ny



* time series plot

twoway line (poverty_rate year)


* two histograms to compare variance

twoway (hist poverty_rate, fcolor(magenta)) (hist unemployment_rate, fcolor(midgreen))

















