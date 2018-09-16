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
'Rationale: This should help draw a whole picture of the absenteesim hours during the selected time period.'

footnote1
'Based on the summary table, the average absenteeism at work is 6.99 hours with a median of 3 hours'
;

footnote2
'Histogram shows that the distribution of absenteeism is right skewed, but most of the absenteeism hours are between 0 and 10 hours'
;

footnote3
'After grouping the employees, we can easily see that a few employees have many absent hours while some have very small amount of absenteeism, which explained the skewness of the histogram'

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

proc means data=Absenteeism_at_work_noduprecs mean median maxdec=2;
    var Absenteeism_time_in_hours;
	
run;


title;



title1
'Research Question:  What was the most common reason for the absenteesim?'

;

title2
'Rationale: This would help to find out whether most of the workers were havign the same reason for absenteesim. '

;

*
Methodology: Used proc frec to find the frequency of each reason, using the result to find out the most common one.

Limitations: Since each employee had multiple reasons,it would be better give same weight to each employee even someone may have more count of one reason.

Possible Follow-up Steps: Add weight to the frequency count.

;

proc freq  data =Absenteeism_at_work_temp
	table Reason for absence;
run;
title;




title1
'Research Question: Is there any week pattern of absenteeism hours? '

;

title2
'Rationale: This would help determine which day of the week has the most often absenteeism. 
In reality, it would help with work schedule.

;

*
Methodology: Use proc freq to study the weekly pattern for each season. Count the 'Absenteeism time in hours' where value is not 0,
group by seasons.Besides, the sum of absentteesim time in hours in each season could also be calculated for detail information.

Limitations: Limitation may be caused by the duplication of IDs since a single employee .
Follow-up Steps: A possible follow-up to this approach could check the pattern by month or even by week when needed.
;

proc freq data =Absenteeism_at_work_temp
	table Day_of_the_week;
	where Absenteeism_time_in_hour NE 0;
run;
title;

