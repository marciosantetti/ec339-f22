

#== EC 339
#== Prof. Santetti 

#=============================================================================#
#                         MULTIPLE LINEAR REGRESSION IN R                     #
#=============================================================================#


#== IMPORTANT: Before any operations, make sure to set your working directory.
# In other words, you have to tell R in which folder you will save your work, or
# from which folder external data sets will come from. In the lower-right pane, 
# click on 'Files.' Select your desired folder, and click on 'More', then select 
# the option 'Set as Working Directory.'

#================================================================================================#






###--- Loading the necessary packages for today:


library(tidyverse)
library(broom)
library(wooldridge) 
library(rstatix)      ## for a specific normality test.


##---------------------------------------------------------


##--- Assumption 1: the model is linear in parameters, well-specified, 
# and contains an additive error term.


## We will study this assumption through artificial data.


# We will create some random numbers. The first step is to set a common seed for reproducibility:


set.seed(1234)


x1_true <- 30 + 2 * runif(n = 100, min = 20, max = 60)                        ## the "true" process defining x1.


x2_true <- 10 + x1_true * rnorm(n = 100, mean = 0, sd = 1)                   ## the "true" process defining x2.


y_true <- 45 + 2 * x1_true + 4 * x2_true + rnorm(n = 100, mean = 0, sd = 1)    ## the "true" process defining y.




true_data <- cbind(x1_true, x2_true, y_true) %>%       ## joining all columns.
  as_tibble()                                          ## converting to a tibble format.



## Visualizing:

true_data %>% 
  ggplot(aes(y = x2_true, x = x1_true)) +
  geom_point()



## Estimating a model for "y_true" without "x1_true":


model_omit <- lm(y_true ~ x2_true, data = true_data)

model_omit %>% 
  tidy()


## Now, estimating the model with all the relevant variables:


model_true <- lm(y_true ~ x1_true + x2_true, data = true_data)

model_true %>% 
  tidy()


##---------------------------------------------------------