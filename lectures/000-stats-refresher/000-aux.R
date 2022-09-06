library(tidyverse)
library(quantreg)
library(ggeasy)
library(hrbrthemes)

theme_set(theme_ipsum_rc())

data(engel)


engel %>% as_tibble() %>% 
  ggplot(aes(x = log(income), y = log(foodexp))) +
  geom_point(color = "#006661", alpha = 0.8, size = 2.3) +
  labs(x = "Income (log)", y = "Food expenditure (log)") +
  easy_x_axis_title_size(13) +
  easy_y_axis_title_size(13)
