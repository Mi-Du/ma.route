load data 
CHARACTERSET UTF8
infile 'routes.txt' "str '\n'"
append
into table routes
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( route_id CHAR(4000),
             agency_id CHAR(4000),
             route_short_name CHAR(4000),
             route_long_name CHAR(4000),
             route_type CHAR(4000),
             route_url CHAR(4000),
             route_color CHAR(4000),
             route_text_color CHAR(4000)
           )
