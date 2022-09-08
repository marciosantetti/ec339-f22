

#== EC 339
#== Prof. Santetti 

#=============================================================================#
#              QUICK STATISTICS REFRESHER / DATA WRANGLING IN R               #
#=============================================================================#


#== IMPORTANT: Before any operations, make sure to set your working directory.
# In other words, you have to tell R in which folder you will save your work, or
# from which folder external data sets will come from. In the lower-right pane, 
# click on 'Files.' Select your desired folder, and click on 'More', then select 
# the option 'Set as Working Directory.'

#================================================================================================#






###--- Loading the necessary packages for today:


library(tidyverse)
library(skimr)
library(rstatix)


## The 'tidyverse' is a collection of R packages designed for data science. You can learn more
## about it at [https://www.tidyverse.org].


###--- Importing our data set:


## The 'cdc_data.csv' file 
## contains data on drug overdose deaths from the CDC and poverty and unemployment rates 
## from the University of Kentucky Poverty Research Center.
## Thanks to Kyle Raze for making the data set available.


cdc_data <- read_csv("cdc_data.csv")           # Q: This data set is of what type?




##--- The {skimr} package has a very convenient function for a general overview of a data set:


cdc_data %>%                      # %>% is called the "pipe" operator.
  skim()



##--- If we want to select a specific column, we use the "select()" function:


cdc_data %>%                            
  select(stname, poverty_rate)




## And we can play around with it...


cdc_data %>% 
  select(stname, poverty_rate) %>% 
  slice(which.max(poverty_rate))                ## Which state has the greatest poverty rate of all?



##--- Some summary statistics (univariate):


cdc_data %>% 
  group_by(stname) %>%                                      ## it is convenient to group by state to compute some
  summarize(mean_poverty_rate = mean(poverty_rate),         ## summary statistics.
            median_poverty_rate = median(poverty_rate),
            variance_poverty_rate = var(poverty_rate),
            sd_poverty_rate = sd(poverty_rate))


##--- Some summary statistics (bivariate):


cdc_data %>% 
  group_by(stname) %>%                                     
  summarize(cov_poverty_unemp = cov(poverty_rate, unemployment_rate),
            cor_poverty_unemp = cor(poverty_rate, unemployment_rate))


##--- If we want to select by rows, we use the "filter()" function:

## Suppose we just want data for the year 2017:


cdc_data %>% 
  filter(year == 2017)           # Q: Now, this data set is of what type?




## If we want to keep working with it, we can store this modified data set:


cdc_data17 <- cdc_data %>% 
  filter(year %in% 2017) 




## And we can play around with it:


cdc_data17 %>% 
  summarize(mean_poverty_rate = mean(poverty_rate),         
            median_poverty_rate = median(poverty_rate),
            variance_poverty_rate = var(poverty_rate),
            sd_poverty_rate = sd(poverty_rate))


cdc_data17 %>% 
  summarize(cov_poverty_unemp = cov(poverty_rate, unemployment_rate),
            cor_poverty_unemp = cor(poverty_rate, unemployment_rate))



##--- If we want to create a new variable and add as a column to the data set, we use the "mutate()" function:

## Suppose we want to analyze the death rate per 100,000 people. We do the following:
  
  
cdc_data17 <- cdc_data17 %>% 
  mutate(death_rate = (deaths / population) * 100000)




##--- Creating plots with {ggplot2}:


## {ggplot2} is an awesome plotting library, that we will use a lot to visualize our data.

## Cedric Scherer has a great blog post, where he explore all the nuts and bolts of the package:

## https://www.cedricscherer.com/2019/08/05/a-ggplot2-tutorial-for-beautiful-plotting-in-r/

## Bookmark this page and it will be of great help moving along.




## Getting started:


## We start with our data set, and start the process with the "ggplot()" function.
## Then, within the "aes()" argument ["aes" for aesthetics], we decide our x-axis and y-axis variables:


cdc_data17 %>% 
  ggplot(aes(x = poverty_rate, y = unemployment_rate))



## You will see in the "Plots" pane an empty canvas. 
## Now, we must decide what kind of plot we would like to produce.  


## Let's go with a scatter diagram:


cdc_data17 %>% 
  ggplot(aes(x = poverty_rate, y = unemployment_rate)) +
  geom_point()                                                 # Notice that, as soon as we start a plot, we keep adding  
                                                               # layers to it using a "+" sign. The "geom_()" function
                                                               # defines what kind of plot we want. Notice that for a scatter diagram,
                                                               # we use "geom_point()".


## We can also make univariate plots, such as histograms and box plots:


cdc_data17 %>% 
  ggplot(aes(x = population)) +
  geom_histogram(color = "white")     ## notice that we can change some parameters within the parentheses.


cdc_data17 %>% 
  ggplot(aes(x = poverty_rate)) +
  geom_boxplot()



##--- Now, let us filter out a single state over time:

cdc_ny <- cdc_data %>% 
  filter(stname %in% "New York")   ## for string (text) variables, it is better to use the %in% operator.



cdc_ny %>% 
  ggplot(aes(y = poverty_rate, x = year)) +
  geom_line()                                           ## "geom_line()" works great for plotting variables over time.



## For more than one state...

cdc_ny_ut <- cdc_data %>% 
  filter(stname %in% c("New York", "Utah"))
  


cdc_ny_ut %>% 
  ggplot(aes(y = unemployment_rate, x = year, color = stname)) +     ## the "color argument is convenient here
  geom_line()



##--- Hypothesis testing:


## We will dedicate an entire week for Hypothesis Testing, but let us run a quick test before we wrap up:


## The Shapiro-Wilk test (1965) is a common test to see whether a continuous variable follows a normal distribution.
## Its null hypothesis (H0) is that the variable is normally distributed.

## More formally, 

# H0: the variable follows a normal distribution; 
# H1: the variable does not follow a normal distribution.


cdc_ny %>% 
  shapiro_test(poverty_rate)      ## What is your inference?



