load data 
CHARACTERSET UTF8
infile 'frequencies.txt' "str '\n'"
append
into table frequencies
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( trip_id CHAR(4000),
             start_time char(4000),
             end_time char(4000),
             headway_secs CHAR(4000)
           )
