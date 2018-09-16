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

[Unique ID] first column ID
;


* environmental setup;

*create output formats;

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

*check raw absenteeism_at_work dataset for duplicates with respect to its 
composite key;
proc sort
    nodupkey
	data=Absenteeism_at_work_raw
	dupout=Absenteeism_at_work_dups
	out=_null_
  ;
  by
    id
 ;
run;
