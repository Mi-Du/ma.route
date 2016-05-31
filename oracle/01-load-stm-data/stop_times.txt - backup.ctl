load data 
CHARACTERSET UTF8
infile 'stop_times.txt' "str '\n'"
append
into table stop_times
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( trip_id CHAR(4000),
             arrival_time timestamp "HH24:MI:SS",
             departure_time timestamp "HH24:MI:SS",
             stop_id CHAR(4000),
             stop_sequence CHAR(4000)
           )
