#RCode For Sampling Exercises 

#Formatted Exercise List here: 
# https://docs.google.com/document/d/137LZIztTISlmIZTGAsQO_-IIddM45KFZMMin3b9rA64/edit

# #
# Theme 1) SRS
# 
# a) [Demonstration of Central Limit Theorem and Law of Large Numbers] "Calculate the national mean", using a SRS with a sample size of N=100 Standard II students. Create a sampling distribution of the means, by doing simulations to collect and repeat for (i) 10, (ii) 100, (iii) 1000, and (iv) 10,000 draws. Report the mean, SE, and 95% CI's for each [formulas to be provided]. Graph your sampling distributions as histograms for each of the 4 cases - does the shape of the distribution change as you increase the number of draws?
# 
# b) [Regional Estimates] For parts (iii) and (iv), calculate the mean, SE, and 95% CI's for each region, to obtain regional estimates. Graph the histograms of the sampling distribution for each region.  [Note that we skip this for parts (i) and (ii), as the sample size is so low here that there will probably be some regions that don't have any samples.]
# 
# c) [Assessing Potential Differences in Performance by Gender] Calculate the mean, SE, and 95% CI's at the national level, for boys vs. girls.
# 
# d) [Assessing Potential Differences in Performance by Urban vs. Rural Council] Calculate the mean, SE, and 95% CI's at the national level, for urban vs. rural districts.
# 
# e) [Reflection and Logistical Practicalities] What happens to the size of the mean, SE, and 95% CI's as you increase your sample size? Is this reflected in your histograms? Do you think this is worth the cost of hiring more surveyors (which could increase by roughly 10x for each step)? Is this sampling strategy feasible across the whole nation, in terms of cost, time, manpower? Why or why not?
# 
# 
#   Theme 2) Clustered Sampling and Stratification
# We realize now that doing a total SRS across the country is infeasible. One way to cut costs could be to do clustered sampling. The current 3R's strategy, used since 2019, clusters at the school-level. This is because, for every district, between 2 to 5 schools (inclusive) are randomly chosen, where this number is proportional to the council's share of Standard II pupils within the region. Then, for each of those 2 to 5 schools per council, all Standard II pupils within each of those schools are selected for 3R's assessment.
# 
# a) [2-Stage Cluster Random Sampling: Cluster by Councils then Cluster by Schools]
# 
# 
# b) [Stratified 2-Stage Cluster Random Sampling: Stratify by region, Cluster By Councils then Cluster by Schools] Let's try another approach. What if we stayed mostly with the current sampling approach, but decided to cluster by council, to save costs? With 184 councils, only having to send surveyors to 184*0.5 = 92 councils could substantially save costs.
# 
# That is to say, instead, we will use what is called a stratified, 2-stage cluster random sampling strategy. We will first stratify at the region level, and then rather than sample every council with each region, only randomly sample 50% of councils for each region. To compensate, we will sample 40 schools from each region - rather than the 20 schools per region allocated in the current 3R's sampling strategy. Because we don't want to over-complicate things with weighting just yet, we will then randomly allocate the schools evenly.
# 
# For example, let's say Region A has 8 councils. Then, to distribute the 40 schools, 4 councils (50% of 8) will randomly selected, of which each of those 4 councils will be allocated 10 schools each. Then, within each of those councils, the 10 schools will be randomly selected. Remember to apply the exclusion criteria, that only schools with between [25,150] pupils in Standard II will be included in the sample frame.
# 
# Implement this sampling strategy in R. Calculate:
# i) The mean, SE, and 95% CI's nationally. Create a histogram. How do the values you obtain compare to the values for the national estimates when you did SRS in (1)?
# ii) [Bonus:] Do the same as above, for each region.
# 
# 
# Theme 3) Sampling using Weighting
# a) [Stratified Cluster Random Sampling with Weighting Proportional to Size: Stratify by Council, then Cluster by Schools] Let's try to replicate the same sampling strategy that's already being used. That is, we stratify at district level, then choose 2 <= X <= 5 schools per council.
# i) Calculate the mean, SE, and 95% for each region. Create a histogram for each region. How do the values you obtain compare to the values for the regional estimates when you did SRS in (1)? Are they more precise, or less precise?
# 
# [Stratified 2-Stage Cluster Random Sampling with Weighting Proportional to Size: Stratify by region, Cluster By Council proportional to size, then Cluster by Schools]
# b) Note that in the previous example 2(b), we assigned 10 schools to each of half the councils in a particular region (8 * 0.50 = 4 councils), making for 40 schools sampled in Region A. However, in reality, each of the 4 councils are likely to be unequal - some councils selected will have more pupils in Standard II, while other councils will have fewer. In other words, our council "clusters" are of unequal size, and we must account for this.
# 
# i) Implement the sampling strategy used in (2), but this time, accounting for the different number of pupils in each council, by using "Proportional To Size" weighting. Hint: Note that we have a variable in the simulated dataset called "tot_pupils_in_council". We can use this to calculate the weight given to each ______ . To provide some intuition, "Proportional To Size" weighting means that a council with say 2000 pupils in Standard II, should be given twice as much weight as another council with 1000 pupils in Standard II.
# 
# ii) Calculate the mean, SE, and 95% for each region. Create a histogram for each region. How do the values you obtain compare to the values for the regional estimates when you did SRS in (1)? Are they more precise, or less precise?
# 
# 
# Theme 4) Data Analysis
# [Assessing Performance against Targets] The ____ target for orf (oral reading fluency) is X = 45 wpm. In terms of national performance, is the mean value you measured (say, using SRS previously) statistically different (either above or below) this target? Hint: Use either a 1- or 2- tailed t-test.
# 
# [Assessing Potential Demographic Differences for SRS] We are also interested in assessing whether there are statistically significant differences in national performance amongst 2 key categories. Using your results, do you detect statistically significant differences between:
# Girls and Boys?
# Urban and Rural localities?
# [Hint: Use a t-test for comparison between 2 means.]
# 
# [Assessing Potential Demographic Differences for Advanced Sampling Methods] Bonus: Try the above exercises for assessing national performance with respect to the target, and for boys vs. girls, and urban vs. rural - but using either the stratified sampling strategy, or the clustered sampling strategy.
# 
# 


#Read libraries 
library(dplyr)
library(tidyr)

#_______________________________________
# READ IN OUR SIMULATED 3R'S STUDENT-LEVEL DATASET 

#setwd("C:\\Users\\kevin\\Github\\NECTA-Sampling-Workshop-Aug-2023")
df = read.csv("C:\\Users\\kevin\\Github\\NECTA-Sampling-Workshop-Aug-2023\\Simulated Dataset for Training\\sim_student_3Rs_data - Aug 4 2023.csv")


#_______________________________________ 
# Theme 0) Introduction 
# 
# a) Play around with the draws. Increase and decrease the number of draws, e.g. from 10, to 100, to 1000, and to 100,000. What do you notice? 
#   

#Do Randomization 

#Set seed to make our random sampling reproducible 
#set.seed(211667)

#Randomize with SRS 
N <- 100 

pupil_sample <- df %>% mutate(random = runif(nrow(df)))

pupil_sample <-
  pupil_sample %>%
  arrange(random)

pupil_sample <-
  pupil_sample %>%
  mutate(
    sample = case_when(row_number() <= N ~ 1,
                       row_number() > N  ~ 0)
  )


#hist(pupil_sample[pupil_sample$sample == 1 ]$orf)

pupils_in_sample <- subset(pupil_sample, subset = sample == 1, drop = TRUE)

hist(pupils_in_sample$orf)
#Histogram of orf scores for the sample just selected 



#_________________________________
# Theme 1) SIMPLE RANDOM SAMPLING (SRS)

# a) [Demonstration of Central Limit Theorem and 
# Law of Large Numbers] "Calculate the national mean", using a 
# SRS with a sample size of N=100 Standard II students. Create a 
# sampling distribution of the means, by doing simulations to 
# collect and repeat for (i) 10, (ii) 100, (iii) 1000, and 
# (iv) 10,000 draws. Report the mean, SE, and 95% CI's for each 
# [formulas to be provided]. Graph your sampling distributions as
# histograms for each of the 4 cases - does the shape of the 
# distribution change as you increase the number of draws? 






# 
