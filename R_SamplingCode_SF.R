#RCode For Sampling Exercises 

#Formatted Exercise List here: 
# https://docs.google.com/document/d/137LZIztTISlmIZTGAsQO_-IIddM45KFZMMin3b9rA64/edit

rm(list=ls()) 

#Read in all libraries 
library(dplyr)
library(tidyr)
library(tidyverse)


#_______________________________________
# READ IN OUR SIMULATED 3R'S STUDENT-LEVEL DATASET (.dta --> csv --> dataframe) 

#setwd("C:\\Users\\kevin\\Github\\NECTA-Sampling-Workshop-Aug-2023")
df = read.csv("C:\\Users\\kevin\\Github\\NECTA-Sampling-Workshop-Aug-2023\\Simulated Dataset for Training\\sim_student_3Rs_data - Aug 4 2023.csv")

#_______________________________________

# Theme A) SRS  
# 

# Q1) [Demonstration of Central Limit Theorem and Law of Large Numbers] 
# In this example, we will use the principle of Simple Random Sampling (SRS) without replacement, to estimate the national mean value for orf (oral reading fluency) in a simulated 3R's dataset. The simulated dataset has ~180,000 Standard II students in it, which is about ~10% of the actual number. 
# 
# a) Set N = 10, i.e. sample 10 students randomly, from around the country. Play around with the draws, documenting your results for the sample mean and standard deviation below. Run the code a few times. 
# 
# b) Calculate the mean (i.e. average) score amongst your (very small) survey. Then calculate the standard deviation (SD) of these scores. (It's OK if you don't remember the formula, you can look it up, or just ask someone!)
# 
# c) Calculate the Standard Error of The Mean (SEM), often just referred to as Standard Error. 
# 
# Hint: You will need the standard deviation you just calculated. Can you explain to the person sitting beside you what the difference is between the two: SD vs. SEM? 
#   
#   d) Now set N = 100, i.e. sample 100 students randomly, from around the country. This would take quite a bit of time to manually draw students 1 at a time, and do the calculations manually  - fortunately we can just run this piece of code in R, to quickly draw the sample! The code can even calculate the sample mean, and sample standard deviation. Now you can try it - write the results of your draws in the table below: 
#     
#     What do you notice about the values of the sample means and standard deviations? Are they the same, or do they change each time? 


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


#     
#     e) Use the result from one of your draws above (choose any one), to calculate the Standard Error of the Mean. It should be different from the first value you calculated for SEM, in part (c). Is it larger or smaller? And why? 
#   
#   f) You may have noticed this is a rather slow process. What we're doing is analogous to doing multiple 3R's survey rounds - each survey round is a "draw". In real life, because of time and budgetary constraints, we can't do an infinite (or even large) number of survey rounds. But we can do this 'in the lab'! This process is called simulation. Let's try it. 
# 
# Try simulating 1000 draws. The code will generate the sampling distributions (of the mean) as well. What do you notice? 
#   
#   For the SEM you calculated in part (e), pick one of the 4 sampling distributions (from i-iv), draw it below, and illustrate the SEM on the distribution by coloring in the area is represents. 
# 
# g) Now increase the sample size to 28,000 Standard II students. (This is about the number of students that were sampled in total for the 2021 3R's round). Calculate the mean, SEM, and 95% confidence interval. Keep the number of draws/simulations at 1000. What happens to the SEM, and to the sampling distribution, compared to your previous SEM calculated with the smaller sample of N=10? 
#   
#   h) Plot the population distribution, beside your latest sampling distribution, from part (g). How do they compare to each other? Are their shapes the same? Or different? If they're different, how can you justify this? 
#   
#   Hint: Remember from our lecture the definition of the population distribution - it's just all the observations shown on a histogram. What does the sampling distribution represent? 
#   
#_______________________________________
#
#   Q2) [Regional Estimates] For parts (iii) and (iv), calculate the mean, SE, and 95% CI's for each region, to obtain regional estimates. Graph the histograms of the sampling distribution for each region.  [Note that we skip this for parts (i) and (ii), as the sample size is so low here that there will probably be some regions that don't have any samples.]
# 
##_______________________________________
# Q3) [Assessing Potential Differences in Performance by Gender] Calculate the mean, SE, and 95% CI's at the national level, for boys vs. girls.  
# 
##_______________________________________
# Q4) [Assessing Potential Differences in Performance by Urban vs. Rural Council] Calculate the mean, SE, and 95% CI's at the national level, for urban vs. rural districts. 
# 
#
#_______________________________________
# Q5) [Reflection and Logistical Practicalities] What happens to the size of the mean, SE, and 95% CI's as you increase your sample size? Is this reflected in your histograms? Do you think this is worth the cost of hiring more surveyors (which could increase by roughly 10x for each step)? Is this sampling strategy feasible across the whole nation, in terms of cost, time, manpower? Why or why not? 
# 





# ____________________________________________________________________________
# Theme B) Clustered Sampling and Stratification, and Weighting
# 
# Q6) [Stratified Random Sampling: Stratify by Region] Let's stratify by region. There are 26 regions in Mainland Tanzania. Stratification by region means that we now have 26 'boxes', and within each of those boxes/regions, we will do a simple random sample. Stratification increases precision, can increase representativeness/coverage (i.e. while SRS or clustering may not be representative, for e.g. if all of the samples/clusters disproportionately occur in a few regions). It also helps ensure adequate sample size/power for regional estimates (e.g. orf means). However, it also increases cost, due to the requirement to survey all strata (in this case, survey every region). 
# 
# The current 3R's strategy samples almost ~28,000 Standard II students nationwide. We can do stratification in a very simple way, using the following strategy: 
# Divide mainland Tanzania into 26 strata, i.e. the 26 regions. We now have 26 'boxes'. 
# For each and every region, do a simple random sample. For simplicity, we will sample 1077 students from each strata (region). This means 1077 * 26 = 28,002 students in total. 
# Calculate national estimates of the mean, standard error, and 95% confidence intervals for your "stratified 3R's survey." How do they compare to your calculated values for SRS with N=28,000 ? Does this make sense? 
# Calculate regional estimates of the mean, standard error, and 95% confidence intervals for your "stratified 3R's survey." 
#


#v1 <- 1:100 # vector of school IDs
#df <- data.frame(v1)

#Set seed so that our analysis is reproducible. Note that we need to set theseed 
# using a random number of generator, or else the randomization will itself be
# deterministic, i.e. not 'truly random'!! Please ask the statisticians in the room
# about what "true randomness" really means.. 

#Clear environment/variables 
rm(list=ls()) 

#Load in libraries 
library(dplyr)
library(tidyr)
library(tidyverse)

df = read.csv("C:\\Users\\kevin\\Github\\NECTA-Sampling-Workshop-Aug-2023\\Simulated Dataset for Training\\sim_student_3Rs_data - Aug 4 2023.csv")

set.seed(1000)

#v1 is vector of schools ID's 
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





#_______________________________________
#
# Q7) [Clustered Random Sampling: Councils are Clusters] 
# We realize now that doing a total SRS across the country is infeasible. One way to cut costs could be to do clustered sampling.
# 
# a) Choose 5 council clusters. Sample 5600 students from each cluster/council, which makes for a total sample of 5600 * 5 = 28,000 students. Calculate national estimates of the mean, standard error, and 95% confidence intervals for your 'cluster 3R's survey'. How do they compare to your calculated values for SRS with N=28,000 ? Does this make sense? 
# 
# b) In our previous clustering strategy, we only chose a few clusters. Why might this be a problem? To determine this, let's calculate the ICC, the "Intracluster Correlation". 
#  
# 
# c) Let's try a new strategy to address this. Let's choose 50 council clusters. This means that each cluster/council will have 560 students, such that the total number of students is 560 * 50 = 28,000. Calculate national estimates of the mean, standard error, and 95% confidence intervals for your 'many clusters 3R's survey'. How do they compare to part (a), where you only chose 5 clusters? Which strategy do you think has better precision? Which one do you think would be cheaper? 
# 
# d) For the clustering strategy you selected, how does it compare to your calculated values for SRS with N=28,000? Does this make sense given what we said about clustered sampling in class? 
# 
# #_______________________________________
#
# Q8) [Clustered Random Sampling with Council Clusters weighted Proportional to Size]
# Now, we'll do a variation of the previous question, (2). In that question, each council had the same probability of being selected. However, some of you may have thought that this is not 'fair'. If we look at our dataset, Madaba council (in Revuma region) has only 1650 Standard II pupils. In contrast, Dar es Salaam City Council has 46,806 Standard II pupils. In other words, one council has almost 30 times as many Standard II pupils as the other! What this means it that, if Madaba council and Dar es Salaam City council have the same probability of being selected, Standard II pupils are being under-represented by a factor of almost 30, compared to pupils in Madaba council. While there is a way to deal with this in our data analysis by applying 'weights', a much easier way is if we just change our probability of selection for each council during the sampling itself. 
# 
# One of the most popular ways to do this is PPS, sampling with "Probability Proportional to Size". 
# .
# .
##_______________________________________ 
#  
# Q9) [Stratified Clustered Random Sampling: Current, 2019-Present 3R's Strategy, i.e. Stratify by Council, then randomly sub-sample [2,5] School Clusters within each Council weighted Probability Proportional to Size (PPS), resulting from a 20 school/region allocation ]
# The current 3R's strategy, used since 2019, clusters at the school-level. This is because, for every district, between 2 to 5 schools (inclusive) are randomly chosen, where this number is proportional to the council's share of Standard II pupils within the region. Then, for each of those 2 to 5 schools per council, all Standard II pupils within each of those schools are selected for 3R's assessment. 
# 
##_______________________________________
#
# Q10) [Stratified 2-Stage Cluster Random Sampling: Proposed cost-saving measure that's a variation on current strategy, i.e. Stratify by Region, randomly sub-sample 50% of councils within each region, then randomly sub-sub-sample [4,10] schools from each council weighted PPS, resulting from a 40 schools/region allocation]
# 
# Stratify by region, Cluster By Councils then Cluster by Schools] Let's try another approach. What if we stayed mostly with the current sampling approach, but decided to cluster by council, to save costs? With 184 councils in Tanzania, only having to send surveyors to 184*0.5 = 92 councils, as opposed to 184 councils, could substantially save costs. 
# 
# That is to say, instead, we will use what is called a stratified, 2-stage cluster random sampling strategy. We will first stratify at the region level, and then rather than sample every council with each region, only randomly sample 50% of councils for each region. To compensate, we will sample 40 schools from each region - rather than the 20 schools per region allocated in the current 3R's sampling strategy. 
# 
# For example, let's say Region A has 8 councils. Then, to distribute the 40 schools, 4 councils (50% of 8) will randomly selected, of which each of those 4 councils will be allocated 10 schools each. Then, within each of those councils, the 10 schools will be randomly selected. Remember to apply the exclusion criteria, that only schools with between [25,150] pupils in Standard II will be included in the sample frame. 
# 
# Implement this sampling strategy in R. Calculate: 
#   i) The mean, SE, and 95% CI's nationally. Create a histogram. How do the values you obtain compare to the values for the national estimates when you did SRS in (1)? 
#   ii) [Bonus:] Do the same as above, for each region. 
# 
# ____________________________________________________________________________
# 
# Theme C) Data Analysis 
# Q11) [Assessing Performance against Targets] The ____ target for orf (oral reading fluency) is X = 45 wpm. In terms of national performance, is the mean value you measured (say, using SRS previously) statistically different (either above or below) this target? Hint: Use either a 1- or 2- tailed t-test. 
# 
#_______________________________________
#
# Q12) [Assessing Potential Demographic Differences for SRS] We are also interested in assessing whether there are statistically significant differences in national performance amongst 2 key categories. Using your results, do you detect statistically significant differences between: 
#   Girls and Boys? 
#   Urban and Rural localities?  
#   [Hint: Use a t-test for comparison between 2 means.]
# 
#_______________________________________
#
# Q13)  [Assessing Potential Demographic Differences for Advanced Sampling Methods] Bonus: Try the above exercises for assessing national performance with respect to the target, and for boys vs. girls, and urban vs. rural - but using either the stratified sampling strategy, or the clustered sampling strategy. 
# 
