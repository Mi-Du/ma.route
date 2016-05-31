load data 
CHARACTERSET UTF8
infile 'stop_times.txt' "str '\n'"
append
into table stop_times
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( trip_id CHAR(4000),
             arrival_time CHAR(4000),
             departure_time CHAR(4000),
             stop_id CHAR(4000),
             stop_sequence CHAR(4000)
           )
