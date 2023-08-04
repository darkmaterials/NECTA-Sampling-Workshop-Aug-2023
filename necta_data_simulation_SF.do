*cd "C:\Users\wb604630\OneDrive - WBG\NECTA"
clear 
/*************************************************************
Part 1 Randomly sample 10 percent of schools from each council 
*****************************************/
*import from excel 
import excel "Copy of Consolidated_Primary_EnrolmentbyGrade_PTR_2022_PSLE2021.xlsx", sheet("for stata") firstrow clear

*clean data 
rename TotalStudentStandard2 std2_t
rename STD2BOYS std2_m
rename STD2GIRLS std2_f
lab var school_regno "School Registration Number- not in NECTA example data"

*destring variables 
foreach var in CLEANCANDS2021 NUMBEROFCANDPASSEDAC AVERAGETOTALMARKS3002021 AVERAGETOTALMARKS2502020 CHANGEONAVERAGETOTALMARKSFR BANDOFSCHOOL2021 BANDOFSCHOOL2020 RANKOFSCHOOL2020 {
	destring `var', ignore(n/a) replace
}

*check how many schools per council should be in final dataset 
egen n_schoolscouncil = count(SchoolName), by (Council)
gen s_schoolscouncil= round(n_schoolscouncil*0.1) // Allocation per council is 10%, so multiply by 0.1 

save "necta data.dta", replace // save dta file before editing 

sort Council, stable
by Council: count

*Calculate total # of pupils in each council 
egen tot_2pupils_in_council = sum(std2_t), by(Council)

*Randomly sample 10 percent of the schools within each and every council 
by Council: sample 10

*Check sample of schools equals to 10 percent of schools in region 
egen sampled_schools= count(SchoolName), by(Council)
gen check = s_schoolscouncil- sampled_schools
sum check //all zero so matches 
drop check 


drop n_schoolscouncil s_schoolscouncil sampled_schools

*egen tot_pupils_in_council = sum(std2_t), by(Council)

save "necta_10percent.dta", replace

sort SN, stable
*bysort SN: expand 1
 

/*************************************************************
Part 2 Expand dataset to have observation for each student 
*****************************************/

expand std2_t, generate(duplicated)

egen n_studetns = count(SN), by (SN)
gen check = n_studetns- std2_t
sum check 
drop if std2_t==0 //drop schools with zero students in standard 2 
drop check 


save "necta_studentlevel.dta", replace

*egen groupcouncil= group(Council)
/* 
forvalue k=1/184 {
	gen orfTotalScores= runiform()
	
}
*/ 




*Sort by Councils listed in alphabetical order ()
sort Council, stable
merge m:1 Council using dist_ranking.dta, generate(_merge)
	
*Flip the council rankings 
gen flipped_rank = 185-CouncilSchoolRank
	
	


*egen dist = group(flipped_rank)
*set seed 709196
gen orf=.

forvalues i = 1/184 {
		
		*Set seed so this random mark allocation is reproducible  
		
		gen a = 11.5 + `i'*0.01 // Range for mean  
		gen b = 1 + `i'*0.005 // Range for standard deviation 
		replace orf = rnormal(a,b) if flipped_rank==`i' 	
		replace orf = round(orf,0.5)
		
	    drop a b
}



sort CouncilSchoolRank, stable



*Drop unnecessary columns 
drop _merge flipped_rank TOTALBOYS TOTALGIRLS CLEANCANDS2021 NUMBEROFCANDPASSEDAC AVERAGETOTALMARKS2502020 AVERAGETOTALMARKS3002021 CHANGEONAVERAGETOTALMARKSFR BANDOFSCHOOL2020 BANDOFSCHOOL2021 RANKOFSCHOOL2020 RANKOFSCHOOL2021 NOOFPSLECANDATES 
drop duplicated n_studetns
compress 
 
*
bysort SN: gen pupilID=_n

sort Region Council SchoolName pupilID
order pupilID, after(SchoolNo)
 
 
*collapse tot_pupils_in_council, by(Council)

 
 
*_______________________________
*DATA ANALYSIS 

/* 
*Calc the mean scores by district, for the data we just simulated
egen orf_mean = mean(orf), by(CouncilSchoolRank)
*/ 




*_______________________________
*SAVING 
save sim_student_3Rs_data, replace
 
 
 
 