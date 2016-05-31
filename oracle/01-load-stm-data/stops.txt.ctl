load data 
CHARACTERSET UTF8
infile 'stops.txt' "str '\n'"
append
into table stops
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( stop_id CHAR(4000),
             stop_code CHAR(4000),
             stop_name CHAR(4000),
             stop_lat CHAR(4000) "TO_NUMBER(:stop_lat,'999.999999')",
             stop_lon CHAR(4000) "TO_NUMBER(:stop_lon,'999.999999')",
             stop_url CHAR(4000),
             wheelchair_boarding CHAR(4000)
           )
