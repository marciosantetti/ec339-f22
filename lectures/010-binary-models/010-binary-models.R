

#== EC 339
#== Prof. Santetti 

#=============================================================================#
#                   BINARY DEPENDENT VARIABLE MODELS IN PRACTICE              #
#=============================================================================#


#== IMPORTANT: Before any operations, make sure to set your working directory.
# In other words, you have to tell R in which folder you will save your work, or
# from which folder external data sets will come from. In the lower-right pane, 
# click on 'Files.' Select your desired folder, and click on 'More', then select 
# the option 'Set as Working Directory.'

#================================================================================================#






###--- Loading the necessary packages for today:


library(tidyverse)
library(wooldridge)
library(margins)


##---------------------------------------------------------



## Our first examples will use data from the Current Population Survey (CPS), with a 
## sample of workers from Boston and Chicago to study employment patterns by race,
## gender, education, and experience.


cps_data <- read_csv('cps_data.csv')

cps_data %>% 
  count(educ)


# We can see that 'educ' is not a numeric, but a character variable. Let's adopt a 
# simple strategy and create a dummy variable that takes on 1 if the individual 
# has at least finished college, and 0 otherwise.


cps_data %>% 
  mutate(higher_ed = if_else(educ == "College or Higher", true = 1, false = 0))
