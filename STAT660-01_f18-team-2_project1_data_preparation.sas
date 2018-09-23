*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

* 
This file prepares the dataset described below for analysis.

[Dataset Name] Absenteeism at work

[Experimental Units] working staff

[Number of Observations] 740

[Number of Features] 21

[Data Source] The file 
https://archive.ics.uci.edu/ml/datasets/Absenteeism+at+work was
downloaded from the UCI machine learning repository.

[Data Dictionary] https://archive.ics.uci.edu/ml/datasets/Absenteeism+at+work#

[Unique ID] ID, Absenteeism_time_in_hours form a composite key
;


* environmental setup;

*create output formats;
proc format;
    value reasonofabsence
		0 = 'NA'
		1 = 'Infectious and parasitic disease'
		2 = 'neoplasm'
		3 = 'blood disease'
		4 = 'endocrine disease'
		5 = 'mental and behaviour disorder'
		6 = 'nervous disease'
		7 = 'eye'
		8 = 'ear'
		9 = 'circulatory'
		10= 'respiratory'
		11= 'digestive'
		12= 'skin'
		13= 'muscle'
		14= 'genitourinary'
		15= 'pregnancy'
		16= 'perinatal'
		17= 'congenital'
		18= 'clinical'
		19= 'injury'
		20= 'morbidity and mortality'
		21= 'factors'
		22= 'followup'
		23= 'medical consultation'
		24= 'blodd donation'
		25= 'lab'
		26= 'unjustified'
		27= 'physiotherapy'
		28= 'dental'
	;
run;

*setup environmental parameters;
%let inputDatasetURL =
https://github.com/stat660/team-2_project1/blob/master/Absenteeism_at_work.xls?raw=true
;

*load raw absenteeism_at_work dataset over the wire;
%macro loadDataIfNotAlreadyAvailable(dsn,url,filetype);
    %put &=dsn;
    %put &=url;
    %put &=filetype;
    %if
        %sysfunc(exist(&dsn.)) = 0
    %then
        %do;
            %put Loading dataset &dsn. over the wire now...;
            filename tempfile "%sysfunc(getoption(work))/tempfile.xlsx";
            proc http
                method="get"
                url="&url."
                out=tempfile
                ;
            run;
            proc import
                file=tempfile
                out=&dsn.
                dbms=&filetype.;
            run;
            filename tempfile clear;
        %end;
    %else
        %do;
            %put Dataset &dsn. already exists. Please delete and try again.;
        %end;
%mend;
%loadDataIfNotAlreadyAvailable(
    Absenteeism_at_work_raw,
    &inputDatasetURL.,
    xls
)

*check raw absenteeism_at_work dataset for duplicate records;
proc sort
    noduprecs
	data=Absenteeism_at_work_raw
	dupout=Absenteeism_at_work_dups
	out=Absenteeism_at_work_noduprecs
  ;
  by
    id
 ;
run;

* build analytic dataset from Absenteeism_at_work_noduprecs dataset with the 
least number of columns and minimal cleaning/transformation needed to 
address research questions in corresponding data-analysis files. And then
create a new variable which shows 1 when absenteeism_time_in_hours >0, and
0 otherwise;
data Absenteeism_analytic_file;
    retain
        ID
        Reason_for_absence
        Month_of_absence
        Day_of_the_week
        Absenteeism_time_in_hours
        Work_load_Average_day
        absence
    ;
    keep
        ID
        Reason_for_absence
        Month_of_absence
        Day_of_the_week
        Absenteeism_time_in_hours
        Work_load_Average_day
        absence
    ;
    set Absenteeism_at_work_noduprecs;
    absence = 0;
    if absenteeism_time_in_hours >0 
    then absence = 1;
run;
