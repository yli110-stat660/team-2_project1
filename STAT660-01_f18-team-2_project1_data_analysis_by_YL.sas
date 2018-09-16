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


* load external file that generates analytic dataset Absenteeism_at_work;
%include '.\STAT660-01_f18-team-2_project1_data_preparation.sas';



title1
'Research Question: What does the distribution of the workers absenteeism look like?'
;

title2
'Rationale: This gives a general idea of the absenteeism in the company including the mean and median missing hours, and the seasonal changes of working absenteeism.'
;

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
Methodology: First use PROC MEANS to check the mean, median and a few other 
statistics for several interested variables, and then get a histogram to vividly
show the distribtuion of absenteeism time in hours.

Limitations: Because the experimental unit and measurement unit are different
in this case, getting the mean and median for variables that show the employees' 
properties has no practical meaning.

Possible Follow-up Steps: use a CLASS statement in PROC MEANS to get the summary
statistics for each employee
;
proc means data = absenteeism_at_work_noduprecs mean median maxdec=2;
    var Absenteeism_time_in_hours;
run;


proc univariate data=Absenteeism_at_work_noduprecs noprint;
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
'Research Question: What factors are mostly related to workers absenteeism?'
;

title2
'Rationale: This helps to build a linear regression model that helps to predict a workers abseentism in the future.'
;

footnote1
''
;

footnote2
''
;

footnote3
''
;

*
Methodology: Compute a linear regression model that has all the factors, then
compare the significant values of these factors.

Limitations: didn't check if there were co-founding factors, that is, if any of
the two factors have a linear relationship.

Possible Follow-up Steps: run a scatter plot of each two factors to see if any
have a linear relationship, if yes, only keep the factor that makes logical
sense.
;
proc logistic data=absence_categorical;
	model absence = Work_load_Average_day;
run;

proc glm
        data=Absenteeism_at_work_noduprecs
    ;
    model
        absenteeism_time_in_hours= ~ /*this ~ is used in R, what about SAS*/
    ;
run;
title;
footnote;



title1
'Research Question: How is workload related to absenteesim?'
;

title2
'Rationale: Studying the relationships between workload and absenteesim can help HR to decide a proper workload for workers'
;

footnote1
''
;

footnote2
''
;
*
Methodology: Plot workload Vs absenteeism in order to check their 
relationships.

Limitations: only visual diagnostics are not adequate.

Follow-up Steps: Use some sort of a test to see if their colinearity
is significant or not.
;
proc sgplot
        data=Absenteeism_at_work
    ;
    scatter x=workload y=absenteeism_time_in_hours;
    ;
run;
title;
footnote;

