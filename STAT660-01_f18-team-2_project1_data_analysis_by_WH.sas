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
'Research Question:  What was the most common reason for the absenteesim?'

;

title2
'Rationale: This would help to find out whether most of the workers were havign the same reason for absenteesim. '

;

footnote1
'Based on the summary table, the most common reason was medical consultation(23).'

;

footnote2
'After grouping by ID, we could find the most common reason for absence for each employee.For example, employee 28 used reason 23 for 32 times.'

;

*
Methodology: Used proc freq to find the frequency of each reason, 
using the result to find out the most common one.

Limitations: Since each employee had multiple reasons,it would 
be better give same weight to each employee for more accurate results.

Follow-up Steps: Add weight to the frequency count.
;

proc freq data =Absenteeism_analytic_file;
	table Reason_for_absence /nocum;
run;

proc freq data =Absenteeism_analytic_file;
	table Reason_for_absence*ID /nopercent;
run;
title;
footnote;


title1
'Research Question: What are the reasons with longer absenteeism hours?'

;

title2
'Rationale: This should help to have a general understanding of how many absenteeism hours related with each reason.'

;

footnote
'Based on the summary table, diseases of the circulatory system had the longest average absenteeism hours which is 42 hours while the average of absenteeism hours is 6.99 hours. '

;

*
Methodology: Use PROC MEANS to find out the average absenteeism 
hours for each reason.

Limitations: There may be duplicates in the dataset.

Follow-up Steps: Add a week_number as a new column to the dataset 
if possible.Then use id, absenteeism_time_in_hours, Day_of_the_week,
week_number,month_of_absence,reason_for_absence as a composite key.
;

proc means 
	data=Absenteeism_analytic_file 
	mean median maxdec=2
     ;
     class 
	reason_for_absence
     ;
     var 
        Absenteeism_time_in_hours
     ;
run;

proc means 
	data=Absenteeism_analytic_file 
	mean median maxdec=2
     ;
     var 
        Absenteeism_time_in_hours
     ;
run;
title;
footnote;

title1
'Research Question: Is there a special day in a week that employees might be absent? '

;

title2
'Rationale: In reality, it would help with weekly work schedule.'

;

footnote
'Based on the summary table, although day 2 of the week had a bit higher frequency of 22.34%, hypothesis testing will be needed for significance difference test.'

;

*
Methodology: Use proc freq to study the weekly pattern for each season. Count the
Absenteeism_time_in hours where value is not 0.Crosstable with ID 
is also used to find out the week pattern of each employee.

Limitations: In special month or season, it may have special daily distribution.

Follow-up Steps:Check this pattern in a special month or season when needed.
;

proc freq 
	data =Absenteeism_analytic_file
     ;
     table 
	Day_of_the_week 
	/nocum
     ;
     where 
        Absenteeism_time_in_hours NE 0
     ;
run;

proc freq 
	data =Absenteeism_analytic_file
     ;
     table 
        Day_of_the_week*ID 
	/nocum
     ;
     where 
	Absenteeism_time_in_hours NE 0
     ;
run;
title;
footnote;

