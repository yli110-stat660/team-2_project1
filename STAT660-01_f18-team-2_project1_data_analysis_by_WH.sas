*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
This file uses the following analytic dataset to address several research
questions regarding the absenteeism at work from July 2007 to July 2010 at a 
counrier company in Brazil
Dataset Name: Absenteeism_at_work created in external file
STAT660_f18-team-2_project1_data_preparation.sas, which is assumed to be
in the same directory as this file
See included file for dataset properties
;

* environmental setup;

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";


* load external file that generates analytic dataset FRPM1516_analytic_file;
%include '.\STAT6250-02_s17-team-2_project1_data_preparation.sas';



title1
'Research Question: What is the distribution of the workers absenteeism based on the dataset ?'
;

title2
'Rationale: This should help draw a whole picture of the absenteesim hours during the selected time period, moreover, .'
;

footnote1

;

footnote2


footnote3
;

*
Methodology: Use PROC PRINT to print just the first twenty observations from
the temporary dataset created in the corresponding data-prep file.
Limitations: This methodology does not account for IDs with missing data,
nor does it attempt to validate data in any way, like filtering for percentages
between 0 and 1.Then the distribution is checked by drawing a histogram of the 'absenteeism_time_in_hours' variable.

Possible Follow-up Steps: More carefully clean the values of the variable
Absenteeism_at_work so that the means computed do not include any possible
illegal values, and better handle missing data, e.g., by rolling average of previous years' data as a proxy 
or ingoring if it's a very small percentage.
;
proc print
        noobs
        data=Absenteeism_at_work_temp(obs=20)
    ;
    id
        ID
    ;
    var
        absenteeism_time_in_hours
    ;
run;

proc univariate data=Absenteeism_at_work_temp;
    var absenteeism_time_in_hours;
	histogram;
run;

title;
footnote;



title1
'Research Question:  What factors are mostly related to workers absenteeism?'
;

title2
'Rationale: This would help not only inform what are the factors affect the workers absenteesim hours but also predict workers abssentism.'
;

footnote1

;

footnote2

;

footnote3

;

*
Methodology: Draw scatter plots for each pair, then select the potential variables to compute a multiple linear regression model.

Limitations: This methodology may not be good enough to explain some factors affection such as the reason for absence 
which is a coded categroy variable.

Possible Follow-up Steps: Further analysis may be needed to check specific factors effection.
;



    ;
run;
title;
footnote;



title1
'Research Question: Is there any seasonal patthern of absenteeism hours? '
;

title2
'Rationale: This would help determine which season of the year has the most often absenteeism or longerst absenteesim hours. 
In reality, it would help with work schedule.

footnote1

;

footnote2

;
*
Methodology: Use proc count to study the seasonal pattern for each season. Count the 'Absenteeism time in hours' where value is not 0,
group by seasons.Besides, the sum of absentteesim time in hours in each season could also be calculated for detail information.

Limitations: Seasonal pattern might be too general in some cases.
Follow-up Steps: A possible follow-up to this approach could check the pattern by month or even by week when needed.
;

  
run;
title;
footnote;
