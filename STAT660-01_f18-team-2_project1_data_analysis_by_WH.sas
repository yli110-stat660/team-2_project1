*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
This file uses the following analytic dataset to address several research
questions regarding the absenteeism at work from July 2007 to July 2010 at a 
counrier company in Brazil.

Dataset Name: Absenteeism_at_work created in external file
STAT660_f18-team-2_project1_data_preparation.sas, which is assumed to be
in the same directory as this file.

See included file for dataset properties
;

* environmental setup;

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";


* load external file that generates analytic dataset FRPM1516_analytic_file;
%include '.\STAT6250-02_s17-team-2_project1_data_preparation.sas'

;



title1
'Research Question: What is the distribution of the workers absenteeism based on the dataset?'

;

title2
'Rationale: This should help draw a whole picture of the absenteesim hours during the selected time period.'

;

footnote1
'Based on the summary table, the average absenteeism at work is 6.92 hours with a median of 3 hours.'

;

footnote2
'The distribution is highly skewed to the right which shows 90% of the absenteeism hours are less that 8 hours.'

;

footnote3
'Each employee absenteeism hours distribution can be found out using grouping by employee ID.The result gives us more detailed information.'

;
*
Methodology: Use PROC MEANS and PROC UNIVARIATE to conduct descriptive analysis on the dataset.
Historgram is used to vividly show the distribtuion of absenteeism time in hours.

Limitations: The raw data may have duplicated records. However, with the exsiting columns we are not able to distinguish them successfully.

Possible Follow-up Steps: Add a week_number as a new column to the dataset if possible.
Then use id, absenteeism_time_in_hours, Day_of_the_week,week_number,month_of_absence,reason_for_absence as a composite key.

;

proc means data=Absenteeism_at_work_raw mean median maxdec=2;
    var Absenteeism_time_in_hours;
run;

proc univariate data=Absenteeism_at_work_raw;
    var Absenteeism_time_in_hours;
	histogram;
run;

proc means data=absenteeism_at_work_raw mean median maxdec=2;
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
'After grouping by ID, we could find the most common reason for absence for each employee. If combined with the answer to question 1, we are able to find the reasons for the employees with longer absenteeism hours. '

;

*
Methodology: Used proc frec to find the frequency of each reason, using the result to find out the most common one.

Limitations: Since each employee had multiple reasons,it would be better give same weight to each employee even someone may have more count of one reason.

Possible Follow-up Steps: Add weight to the frequency count.
;

proc freq  data =Absenteeism_at_work_raw;
	table Reason_for_absence /nocum;
run;

proc freq  data =Absenteeism_at_work_raw;
	table Reason_for_absence*ID /nopercent;
run;
title;
footnote;


title1
'Research Question: Is there a special day in a week that employees might be absent? '

;

title2
'Rationale: In reality, it would help with weekly work schedule.'
;

footnote1
'Based on the summary table, there is no such special day. 5 work days have the same frequency.'

;
*
Methodology: Use proc freq to study the weekly pattern for each season. Count the Absenteeism_time_in hours where value is not 0,
Crosstable with ID is also used to find out the week pattern of each employee.

Limitations: In special month or season, it may have special daily distribution.
Follow-up Steps:Checking this pattern in a special month or season according to the context.
;

proc freq data =Absenteeism_at_work_raw;
	table Day_of_the_week /nocum;
	where Absenteeism_time_in_hours NE 0;
run;

proc freq data =Absenteeism_at_work_raw;
	table Day_of_the_week*ID /nocum;
	where Absenteeism_time_in_hours NE 0;
run;
title;
footnote;

