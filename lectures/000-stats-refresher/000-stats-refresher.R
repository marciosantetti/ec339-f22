

#== ECON 4650-001 -- Spring 2021
#== Marcio Santetti

#=============================================================================#
#              QUICK STATISTICS REFRESHER / DATA WRANGLING IN R               #
#=============================================================================#


#== IMPORTANT: Before any operations, make sure to set your working directory.
# In other words, you have to tell R in which folder you will save your work, or
# from which folder external data sets will come from. In the lower-right pane, 
# click on 'Files'. Select your desired folder, and click on 'More', then select 
# the option 'Set as Working Directory'.

#================================================================================================#



#== Installing and/or loading required packages:

install.packages("tidyverse")  ## installs the 'tidyverse' package. If you do not have any of the packages 
                               ## below already installed, make sure to first install them, and then run
                               ## the next commands.


library(tidyverse)   # for data wrangling and plotting.
library(rstatix)     # for Statistics tools.
library(pwt9)        # contains data from the Penn World Tables vols. 9.0 and 9.1
library(patchwork)   # for plotting purposes.


# Once you have installed a package, you do not need to run the 'install.packages'
# command again. When you need to use a function from a given package, you must
# use the 'library()' command, so R loads the package's content to your environment.


#================================================================================================#



##=================== A little bit of data wrangling in R with the "tidyverse":



## The 'tidyverse' is a collection of R packages designed for data science. You can learn more
## about it at [https://www.tidyverse.org].


## First, let us use data from the Penn World Tables 9.1. To do that, we use the 'pwt9' package.
## You can check out its website at [https://www.rug.nl/ggdc/productivity/pwt/?lang=en].


data("pwt9.1")      ## you should see something in your 'Environment' pane.


pwt <- as_tibble(pwt9.1)  ## 'tibbles' are a very handy class of data structure to work with the 'tidyverse'.



glimpse(pwt)   ## a quick look at the data. Or...

View(pwt)      ## notice the upper-case "V."


## Question: what is this data set's type? Cross-section, time-series, or panel? Panel data.


##== We have a lot of data here. Let us select a few variables to start off our analysis.

## A very useful tool when working with data is the "pipe" ( %>% ) operator. In plain English,
## it means "and then." In other words, from the previous code, the pipe operator indicate what we
## want to do with that. The shortcut for the pipe is Ctrl(Cmd)+Shift+M.


pwt_select <- pwt %>% select(year, country, pop, rgdpna, hc, cn) ## 'select()' is used for columns (variables).


## Reading the above code, it means: I want to use the 'pwt' tibble, and then select only the 'year', 'country',
## 'pop', 'rgdpna', 'hc', and 'cn' variables. Lastly, I want to store these data in a new object, called 
## 'pwt_select'.


##== What if we want specific countries?


## Countries are row variables. To select rows, we use 'filter()':

pwt_select <- pwt_select %>% filter(country %in% c('United States of America',
                                                   'Canada',
                                                   'Mexico',
                                                   'China',
                                                   'United Kingdom',
                                                   'Germany',
                                                   'India',
                                                   'Brazil'))   ## The %in% operator is useful when filtering
                                                                ## rows with specific values. In our case, these
                                                                ## values are country names. Notice that we need
                                                                ## to use the 'c' function because we
                                                                ## are writing out a list with more than one item.


glimpse(pwt_select)   ## we have narrowed down our sample to 8 countries and 6 variables (544 observations).



pwt_select %>% get_summary_stats()


##=================== Visualizing data with ggplot2:


## 'ggplot2' is the most powerful plotting R package. It is based on a specific grammar vocabulary, which
## we start exploring next.


pwt_select %>% ggplot(mapping = aes(x=year, y=rgdpna)) ## creating the plotting space.



pwt_select %>% ggplot(mapping = aes(x=year, y=rgdpna)) + geom_line()  ## Now, adding a line.


pwt_select %>% ggplot(mapping = aes(x=year, y=rgdpna, group=country)) + geom_line()  ## one line per country.


pwt_select %>% ggplot(aes(x=year, y=rgdpna, group=country)) + 
  geom_line(aes(color=country))  ## distinguishing each country by color.


pwt_select %>% ggplot(aes(x=year, y=rgdpna, group=country)) + geom_line(aes(color=country)) +
  facet_wrap(~country) + theme(legend.position = 'none')  ## what about one panel per country?





##== Still on univariate visualization tools, let us look at box plots and histograms:


## Box plot for the human capital per person index (based on schooling and returns to education): 


pwt_select %>% ggplot(mapping = aes(x=hc)) + geom_boxplot() + facet_wrap(~country) + theme_bw() + 
  labs(x='human capital')


## Histogram:

pwt_select %>% ggplot(mapping = aes(x=hc)) + geom_histogram(color='black', fill='white', bins = 20) + 
  facet_wrap(~country) + theme_bw()



##== Moving on to bivariate relationships:


pwt_usa <- pwt_select %>% filter(country %in% 'United States of America')  ## now, let us look only at US data.

## Notice that, with this filtering, we went from a panel to a time-series data set.



## Scatter plot:


pwt_usa %>% ggplot(mapping = aes(x=hc, y=rgdpna)) + geom_point()




#================================================================================================#


##== Now, let us import an external data set into our R environment. The 'cdc_data.csv' file 
## contains data on drug overdose deaths from the CDC and poverty and unemployment rates 
## from the University of Kentucky Poverty Research Center.

## Thanks to Kyle Raze for making the data set available.


## To import .csv files into R, first the file needs to be stored in the same Working Directory as the
## R script we are working on. Then, we use the 'read_csv' function from the 'tidyverse':


drug_data <- read_csv('cdc_data.csv')

glimpse(drug_data)   ## quick look at the data...




## Let us look at some statistics for these data. But, before that, we will create a new variable (column).
## Suppose we want to analyze the death rate caused by drug overdose, instead of total counts.
## Let us, then, create a 'death_rate' variable, expressing deaths per 100,000 people.
## The mutate() function does that for us:


drug_data <- drug_data %>% 
  mutate(death_rate = deaths/population*100000)  ## this way, a new column will be added to our 'drug_data' object.


drug_data %>% 
  mutate(other = deaths/(population * 10000))


##====================== Now, to the statistics!



##== Univariate measures (with 'summarize()'):

drug_data %>% summarize(min_rate = min(death_rate),
                        max_rate = max(death_rate),
                        avg_rate = mean(death_rate),
                        median_rate = median(death_rate),
                        sd_rate = sd(death_rate),
                        var_rate = var(death_rate))  ## this will generate a tibble with the information 
                                                     ## we have asked for.


## From these statistics, which state showed the minimum death rate? Which state showed the maximum?
##  The 'slice()' function helps us with that.


drug_data %>% slice(which.min(death_rate))   ## Answer?

drug_data %>% slice(which.max(death_rate))   ## Answer?




##== Bivariate relationship measures:


## The most common bivariate relationship measures are (i) covariance and (ii) correlation.


drug_data %>% summarize(covariance = cov(death_rate, unemployment_rate),
                        correlation = cor(death_rate, unemployment_rate))  ## Interpretation?


drug_data %>% 
  filter(year == 2017) %>% 
  summarize(covariance = cov(death_rate, poverty_rate),
                        correlation = cor(death_rate, poverty_rate))


## Plotting this relationship:


drug_data %>% ggplot(mapping = aes(x=unemployment_rate, y=death_rate)) + geom_point() + theme_bw() 


## Adding labels:


drug_data %>% ggplot(mapping = aes(x=unemployment_rate, y=death_rate)) + geom_point() + theme_bw() +
  labs(x="Unemployment rate (%)", y="Drug overdose death rate (per 100,000)",
       title = "A scatter plot")




##== This data set is also a panel data set. Let us transform it into a cross-sectional data set by
## specifying a unique year, say, 2017:


drug_data17 <- drug_data %>% filter(year %in% '2017')


## And let us look at the relationship between death rates and the poverty rate for 2017:


drug_data17 %>% summarize(covariance = cov(death_rate, poverty_rate),
                        correlation = cor(death_rate, poverty_rate))  ## Interpretation?


## Max and min values:


drug_data17 %>% slice(which.min(death_rate))    ## Answer?
drug_data17 %>% slice(which.min(poverty_rate))  ## Answer?
drug_data17 %>% slice(which.max(death_rate))    ## Answer?
drug_data17 %>% slice(which.max(poverty_rate))  ## Answer?


## And plotting the data:


drug_data17 %>% ggplot(mapping = aes(x=poverty_rate, death_rate)) + 
  geom_point(color='blue')   ## Do we see a clear positive/negative relationship?





##============== A quick hypothesis testing review:


##== In ECON 3640, hypothesis testing (inference) is approached is approached in two ways:
## (i) via test statistics (comparing to critical values, consulting tables, etc.)
## (ii) via p-values.

## Let us quickly review a hypothesis testing procedure by testing whether some variables of our 
## 'drug_data17' data set can be considered as following a Normal (bell-shaped) distribution.


## To do that, let us look at the density curves (distributions) of three variables: death_rate,
## poverty_rate, and unemployment_rate.



## We can store plots made with 'ggplot2' into R objects.


drug_data17 %>% ggplot(aes(death_rate)) + 
  geom_histogram(color='black', fill='white', bins=20) + theme_bw()  ## a simple histogram



hist_1 <- drug_data17 %>% ggplot(aes(death_rate)) + 
  geom_histogram(aes(y=..density..), color='black', fill='white', bins=20) + 
  geom_density(alpha=.2, fill="red") + theme_bw()                             ## now, adding density curves.

hist_2 <- drug_data17 %>% ggplot(aes(poverty_rate)) + 
  geom_histogram(aes(y=..density..), color='black', fill='white', bins=20) + 
  geom_density(alpha=.2, fill="red") + theme_bw()

hist_3 <- drug_data17 %>% ggplot(aes(unemployment_rate)) + 
  geom_histogram(aes(y=..density..), color='black', fill='white', bins=20) + 
  geom_density(alpha=.2, fill="red") + theme_bw()


## With the help of the 'patchwork' package, we can organize a nice plotting layout. Using a "|" symbol,
## we can put different plots side by side. If you want a plot below another, simply use "/".


hist_1 | hist_2 | hist_3       ## can we visually infer anything about their distributions?




#== The Shapiro-Wilk test is a statistical test to check whether an array of data
#== can be considered normally distributed. Its null hypothesis states that
#== the data follow a normal distribution. Therefore, in case H0 is rejected, the data
#== are NOT normally distributed.

## In statistical notation...

## H0: The data are normally distributed
## Ha: The data are not normally distributed



drug_data17 %>% shapiro_test(death_rate)              ## Inference?

drug_data17 %>% shapiro_test(poverty_rate)            ## Inference?

drug_data17 %>% shapiro_test(unemployment_rate)       ## Inference?



#================================================================================================#


##============= Practice:


## Play around and have fun with these data. Explore more plotting and wrangling options. Get yourself 
## acquainted with R and the tidyverse. It will be important for our upcoming weeks!



