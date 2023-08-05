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
rename SchoolNo schoolID
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

*Randomly sample 9.5 percent of the schools within each and every council 
by Council: sample 9.5

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

*_______________________________
*GENERATE ORF AND ORC SCORES USING NORMAL DISTRIBUTIONS 
      *NEED TO INCORPORATE ICC INTO DGP SO THAT CLUSTERED SAMPLING DETECTS VARIATION! 
gen orf=.
gen region_mean=.
gen region_sd=.
*gen orc=.

forvalues i = 1/184 {
		
		*Set seed so this random mark allocation is reproducible?
		
		gen a = 8.75 + `i'*0.04 // Range for mean ; 'average' mean across country is 12.43, same as that determined in 2021 3R's report (p19)
		*gen b = 0.3 + `i'*0.01 // Range for standard deviation 
		gen b = 5 - `i'*0.025 // Range of standard deviation for each council; 'average' standard deviation across country is 8.94, same as that determined in 2021 3R's report (p19)
		replace orf = rnormal(a, b) if flipped_rank==`i' 
		replace orf = round(orf, 0.5)
		
		*replace orc = rnormal(a, b) if flipped_rank==`i' 
		*replace orc = rnormal(orc, 0.5) 

		replace region_mean = a if flipped_rank==`i'
		replace region_sd = b if flipped_rank==`i'
	    drop a b
		
}


*Take care of scores out of range (i.e. <0, or >25), by fixing them to 0 or 25, respectively 
		replace orf = 0 if orf<0 
		replace orf = 25 if orf>25

		
sort CouncilSchoolRank, stable



*Drop unnecessary columns 
drop _merge flipped_rank TOTALBOYS TOTALGIRLS CLEANCANDS2021 NUMBEROFCANDPASSEDAC AVERAGETOTALMARKS2502020 AVERAGETOTALMARKS3002021 CHANGEONAVERAGETOTALMARKSFR BANDOFSCHOOL2020 BANDOFSCHOOL2021 RANKOFSCHOOL2020 RANKOFSCHOOL2021 NOOFPSLECANDATES 
drop duplicated n_studetns
compress 
 
*
bysort SN: gen student_groupNo=_n

sort Region Council SchoolName student_groupNo
order student_groupNo, after(schoolID)
 
 
*collapse tot_pupils_in_council, by(Council)



*_______________________________
*Gen unique ID's at different (administrative) levels 

*[Aidan:] Can we make sure there are unique identifiers for the student, school, district and region?
*Is there a rural/urban indicator that we are able to include from anywhere?

*Fill in Missing Administrative Identifiers 
gsort Council -CouncilNo
carryforward CouncilNo, replace

*Gen unique Pupil ID 
rename Region region 
rename Council council

sort region council SchoolName student_groupNo
egen regionID = group(region)
egen councilID = group(council)
*Already have unique school ID ("PS_____"), so don't need to generate another one
gen studentID = _n
order studentID, before(SN)
 
replace SchoolName = lower(SchoolName)
 
*Move around variables 
order regionID, after(SchoolName)
order councilID, after(regionID) 
order CouncilNo, after(councilID)
order CouncilSchoolRank, after(CouncilNo)
order schoolID, after(CouncilSchoolRank)
order SN, after(schoolID)
order studentID, before(student_groupNo)

*_______________________________
*DATA ANALYSIS 


*Calc the mean scores by district, for the data we just simulated


egen orf_councilMean = mean(orf), by(CouncilSchoolRank)
sum orf 
count if orf==0 // Count 0 scores 
count if orf==25 // Count perfect scores






*_______________________________
*SAVING 

save sim_student_3Rs_data, replace
 
 
 
 