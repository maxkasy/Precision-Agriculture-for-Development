library(tidyverse)

n=1200
k=6
theta=seq(from=.25, to=.3, by=.01)

test_data=tibble(treatment=sample(k,n, replace=T),
                 theta_i= theta[treatment],
                 outcome=runif(n)<theta_i) %>% 
    select(-theta_i)

write_csv(test_data, "test_data.csv")