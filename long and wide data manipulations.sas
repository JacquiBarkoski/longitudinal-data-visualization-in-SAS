
/* selecting samples from a long datset*/
/*  1 first mornign void sample and 1 pooled sample with 4 components  */
proc sort data=Xsp4; by subjectID FW_timepoint fw_colldate; run;
Data sp4; set Xsp4; by subjectID FW_timepoint;
  if fw_timepoint='cTrim2' then do;
    if urine_type='Spot' then do; T2_sp4_pba3_s_1 + PBA3; T2_sp4_tcpy_s_1 + tcpy; end;
      else do; T2_sp4_pba3_p_2 + PBA3; T2_sp4_tcpy_p_2 + tcpy; end;
  end;
  if fw_timepoint='dTrim3' then do;
    if urine_type='Spot' then do; T3_sp4_pba3_s_1 + PBA3; T3_sp4_tcpy_s_1 + tcpy; end;
      else do; T3_sp4_pba3_p_2 + PBA3; T3_sp4_tcpy_p_2 + tcpy; end;
  end;
if last.subjectID; 
if T2_sp4_pba3_s_1=0 then T2_sp4_pba3_s_1=.;  if T2_sp4_tcpy_s_1=0 then T2_sp4_tcpy_s_1=.;
if T2_sp4_pba3_p_2=0 then T2_sp4_pba3_p_2=.;  if T2_sp4_tcpy_p_2=0 then T2_sp4_tcpy_p_2=.;
if T3_sp4_pba3_s_1=0 then T3_sp4_pba3_s_1=.;  if T3_sp4_tcpy_s_1=0 then T3_sp4_tcpy_s_1=.;
if T3_sp4_pba3_p_2=0 then T3_sp4_pba3_p_2=.;  if T3_sp4_tcpy_p_2=0 then T3_sp4_tcpy_p_2=.;
output;
T2_sp4_pba3_s_1=0; T2_sp4_pba3_p_2=0; T2_sp4_tcpy_s_1=0; T2_sp4_tcpy_p_2=0;
T3_sp4_pba3_s_1=0; T3_sp4_pba3_p_2=0; T3_sp4_tcpy_s_1=0; T3_sp4_tcpy_p_2=0;
run;
proc print; var subjectID T2_sp4_pba3_s_1 T2_sp4_pba3_p_2 T2_sp4_tcpy_s_1 T2_sp4_tcpy_p_2
                          T3_sp4_pba3_s_1 T3_sp4_pba3_p_2 T3_sp4_tcpy_s_1 T3_sp4_tcpy_p_2; run;

/* checking sample selection by counting unique subjects from the long and wide datasets*/
proc sql; 
create table studypop3 as
 select count(distinct(subjectid)) as subjectIDcount
         from preg_spot_pool
		   ;
quit;
