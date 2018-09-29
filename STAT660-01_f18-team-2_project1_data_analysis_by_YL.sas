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

Follow-up Steps: use a CLASS statement in PROC MEANS to get the summary
statistics for each employee
;
proc means 
        mean median maxdec=2
        data = absenteeism_analytic_file
    ;
    var 
        Absenteeism_time_in_hours
    ;
run;


proc univariate 
        noprint
        data=absenteeism_analytic_file
    ;
    var 
        Absenteeism_time_in_hours
    ;
    histogram;
run;

proc means 
        mean median maxdec=2
        data=absenteeism_analytic_file
    ;
    class 
        id
    ;
    var 
        Absenteeism_time_in_hours
    ;
run;

title;
footnote;



title1
'Research Question: Is daily workload a factor that affects the absenteeism of employees?'
;

title2
'Rationale: The answer for this question will help the manager of the company to evaluate if the employees are overloaded.'
;

footnote1
'The simple logistic regression gives a p value of 0.3866 for the coefficient of daily workload, which suggests that daily workload is not a significant factor affecting absenteeism.'
;
footnote2
'A simple linear regression of daily workload on absent hours revealed the same conclusion: workload is statistically irrelavent to absenteeism at work.'
;


*
Methodology: compute a logistic regression to see if the daily workload affects
employees' absenteeism. Because the dataset doesn't have a binary variable to 
indicate absenteeism, a new variable called absence was created and used to run 
logistic regression.

Limitations: Because every employee has repeated measurements in the dataset, it
is not accurate to use this dataset to run regression, as the more absent worker
has more "weighted" conditions for evaluating factors of absenteeism.

Possible Follow-up Steps: check the total abseentism for every worker, and 
create a subset of the dataset, which only has the 36 employees with a binary
variable to indicate if he or she is ever absent.
;
proc logistic 
        data=Absenteeism_analytic_file
    ;
    model absence = Work_load_Average_day
    ;
run;

proc glm 
    ;
    model absenteeism_time_in_hours = Work_load_Average_day
    ;
run;

title;
footnote;



title1
'Research Question: Which employees have more absenteeism?'
;

title2
'Rationale: Identifying the employees who have more absenteeism helps to decide if their absenteeisms are due to personal issues or more common reasons among other employees, in other words, it helps to decide if this employee is an outlier for our linear regression analysis.'
;

footnote1
'The reason frequency table for each worker is given. From this table, a few workers only had 1 absence reason listed as NA, which means that they are never absent from work.'
;

footnote2
'The modified table only considers the absenteeism, and removed the workers who never missed work. The third employee had 111 leaves, which means that he or she could be an outlier in determing the total absenteeism at work in this company.'
;

footnote3
'The bar graph helps to quickly identify the employee who has more absenteeisms. The worker with ID 3 is certainly an observation we want to look into when doing analysis.'
;
*
Methodology: Use a two-way frequency table to take a glance at the common 
absenteeism reasons for each employee. Each row represents the situiton for each
worker.

Limitations: It is hard to evaluate the freuency distribution difference among
different workers.

Possilble Follow-up Steps: get a histogram for the reasons' frequency and then
compare the histograms between workers -- data visualizaion often helps to 
quickly identify the change.
;
proc freq 
        data = Absenteeism_analytic_file
    ;
    tables 
        id*reason_for_absence 
        / nopercent norow nocol
    ;
    format 
        reason_for_absence reasonofabsence.;
run;

proc freq 
        data = Absenteeism_analytic_file
    ;
    tables 
        id*reason_for_absence 
        /nopercent norow nocol
    ;
    where 
        absence = 1
    ;
    format 
        reason_for_absence reasonofabsence.;
run;

proc sgplot 
        data=absenteeism_analytic_file
    ;
    vbar 
        ID
    ;
    where
        absence = 1;
run;
quit;

title;
footnote;

