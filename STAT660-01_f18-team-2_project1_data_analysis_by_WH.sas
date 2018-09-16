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
'Based on the summary table, the average absenteeism at work is 13.44 hours with a median of 4 hours'

;

footnote2
'The distribution is highly skewed to the right which shows 75% of the absenteesim hours are less that 8 hours.The longest absenteesim hour was 120 hours. '

;

footnote3
'We can also find out the distribution of hours among differnet employees while grouping by employee ID.Employee 9 had the biggest average absenteeism hours of 41 hours.'

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

proc univariate data=Absenteeism_at_work_noduprecs;
    var Absenteeism_time_in_hours;
	histogram;
run;

proc means data=absenteeism_at_work_noduprecs mean median maxdec=2;
    class id;
	var Absenteeism_time_in_hours;
run;


title;
footnote;



title1
'Research Question:  What was the most common reason for the absenteesim?'

;

title2
'Rationale: This would help to find out whether most of the workers were havign the same reason for absenteesim. '

;

footnote1
'Based on the summary table, the most common reason was medical consultation(23).'

;

footnote2
'After grouping by ID, we could find the most common reason for absence for each employee. If combined with the answer to question 1, we are able to find the reasons for the employees with longer absenteeism hours. .'

;

*
Methodology: Used proc frec to find the frequency of each reason, using the result to find out the most common one.

Limitations: Since each employee had multiple reasons,it would be better give same weight to each employee even someone may have more count of one reason.

Possible Follow-up Steps: Add weight to the frequency count.

;

proc freq  data =Absenteeism_at_work_noduprecs;
	table Reason_for_absence /nocum;
run;

proc freq  data =Absenteeism_at_work_noduprecs;
	table Reason_for_absence*ID /nopercent;
run;
title;
footnote;


title1
'Research Question: Is there any week pattern of absenteeism hours? '

;

title2
'Rationale: This would help determine which day of the week has the most often absenteeism. 
In reality, it would help with work schedule.

;

footnote1
'Based on the summary table, 29% employee were usually absence on the second day of the week. Since there are five work days a week, I would say there was no special day that employee would be absence.'

;


*
Methodology: Use proc freq to study the weekly pattern for each season. Count the 'Absenteeism time in hours' where value is not 0,
group by seasons.Besides, the sum of absentteesim time in hours in each season could also be calculated for detail information.

Limitations: Limitation may be caused by the duplication of IDs since a single employee .
Follow-up Steps: A possible follow-up to this approach could check the pattern by month or even by week when needed.
;

proc freq data =Absenteeism_at_work_noduprecs;
	table Day_of_the_week;
	where Absenteeism_time_in_hours NE 0;
run;
title;
footnote;

