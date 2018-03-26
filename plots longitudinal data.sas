/* scatter plot of biomarker concentrations from repeated measures by speicmen collection date */
/* x-axis is natural log transformed*/

proc sgplot data=biomarkerdata;
title "Yearly Variation in Urinary 3-PBA Concentrations ";
xaxis label="Specimen Collection Date"  ; 
yaxis type=log label= "SG-corrected 3-PBA Concentrations (ng/mL)" ;
scatter y=PBA3_SG x=fw_colldate ;
format fw_colldate year.;
run;

/* applying a natural log transformation to pesticide concentrations */
data biomarkerdata;
set biomarkerdata;
Ln_3PBA_SG = log(PBA3_SG);
run;

/*longitudinal mixed effects model to test association between pesticide concentrations and season of sample collection*/
/*model adjusted for year of sample collection due to known yeraly variations*/

proc mixed data =biomarkerdata Method=ML covtest;  
  class subjectid season (ref ='0') ;
  model ln_3PBA_SG = season year /solution ;
  random intercept / subject = subjectid ;  
run;

/* estimating the Kendall's transformed intraclass correlation coefficient*/

/* 1. assign ranks to data*/
proc rank data=pyr_longitudinal ties=mean out=rank_all ;
var PBA3; 
ranks r_3PBA ;
run;

/* 2. visualualizing ranked data by specimen type*/
proc sgplot data=rank_all ;
    scatter y=PBA3 x=subjectID / group=specimen_type;
run;

/* 3. sorting by rank*/
proc sort data rank_all;
by subjectID;
run;

/* 4. estimating within- and between-person variablity from a mixed model*/
proc mixed data =rank_all covtest ;  
  class subjectid ;
  model r_3PBA= / solution;
  random  intercept /subject = subjectid;  
run;
