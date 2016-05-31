load data 
CHARACTERSET UTF8
infile 'calendar_dates.txt' "str '\n'"
append
into table calendar_dates
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( service_id CHAR(4000),
             calendar_date DATE "YYYYMMDD",
             exception_type CHAR(4000)
           )
