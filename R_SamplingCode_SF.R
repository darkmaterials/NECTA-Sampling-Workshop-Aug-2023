#Read libraries 
library(dplyr)


#Do Randomization 
#setwd("C:\\Users\\kevin\\Github\\NECTA-Sampling-Workshop-Aug-2023")
df = read.csv("C:\\Users\\kevin\\Github\\NECTA-Sampling-Workshop-Aug-2023\\Simulated Dataset for Training\\sim_student_3Rs_data - Aug 4 2023.csv")

#Set seed to make our random sampling reproducible 
set.seed(211667)

#read_dta("")


#Randomize with SRS 
pupil_sample <- df %>% mutate(random = runif(nrow(df)))

pupil_sample <-
  pupil_sample %>%
  arrange(random)

pupil_sample <-
  pupil_sample %>%
  mutate(
    sample = case_when(row_number() <= 300 ~ 1,
                       row_number() > 300  ~ 0)
  )

