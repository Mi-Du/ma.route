load data 
CHARACTERSET UTF8
infile 'agency.txt' "str '\n'"
append
into table agency
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( agency_id CHAR(4000),
             agency_name CHAR(4000),
             agency_url CHAR(4000),
             agency_timezone CHAR(4000),
             agency_lang CHAR(4000),
             agency_phone CHAR(4000),
             agency_fare_url CHAR(4000)
           )
