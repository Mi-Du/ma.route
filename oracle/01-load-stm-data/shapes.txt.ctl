load data 
CHARACTERSET UTF8
infile 'shapes.txt' "str '\r\n'"
append
into table shapes
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( shape_id CHAR(4000),
	     shape_pt_lat CHAR(4000) "TO_NUMBER(:shape_pt_lat,'999.999999')",
             shape_pt_lon CHAR(4000) "TO_NUMBER(:shape_pt_lon,'999.999999')",
             shape_pt_sequence CHAR(4000)
           )
