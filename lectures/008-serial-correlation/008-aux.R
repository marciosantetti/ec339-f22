library(tidyverse)
library(fpp3)

ausmacro <- read_csv("phillips5_aus.csv")


ausmacro <- ausmacro %>% 
  mutate(period = as.Date(dateid01, format = "%m/%d/%Y"))

model1 <- lm(inf ~ du, data = ausmacro)



res <- model1 %>% 
  resid()


ausmacro <- ausmacro %>% 
  add_column(res)


ausmacro %>% 
  ggplot(aes(x = period, y = res)) +
  geom_line() +
  scale_x_date(date_breaks = "4 years", date_labels = "%Y") +
  labs(y = expression(u[t]),
       x = "",
       title = expression(u[t]))


ausmacro %>% 
  mutate(qtr = yearquarter(period)) %>% 
  as_tsibble(index = qtr) %>% 
  ACF(res) %>% 
  autoplot() +
  labs(x = "Lag (quarters)",
       y = expression(rho))
