library(tidyverse)

v1 <- 1:100 # vector of school IDs
df <- data.frame(v1)

set.seed(1000)

df2 <- df %>%
  rename(school_id = v1) %>%
  mutate(council_id = round(row_number()/10, 0), # create council ID
         random = runif(n()))

df3 <- df2 %>%
  arrange(council_id, random) # sorting by councid_id and random

n <- 5 # number of units to sample from each council

df4 <- df3 %>%
  group_by(council_id) %>%
  mutate(sample = case_when(row_number() <= n ~ 1,
                            row_number() > n  ~ 0))

p <- 0.2 # proportion of units to sample from each council

df5 <- df3 %>%
  group_by(council_id) %>%
  mutate(sample = case_when(row_number() <= round(p * n(), 0) ~ 1,
                            row_number() >  round(p * n(), 0) ~ 0))
# note that using round() is not needed
