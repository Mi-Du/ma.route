load data 
CHARACTERSET UTF8
infile 'trips.txt' "str '\n'"
append
into table trips
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( route_id CHAR(4000),
             service_id CHAR(4000),
             trip_id CHAR(4000),
             trip_headsign CHAR(4000),
             direction_id CHAR(4000),
             shape_id CHAR(4000),
             wheelchair_accessible CHAR(4000),
             note_fr CHAR(4000),
             note_en CHAR(4000)
           )
