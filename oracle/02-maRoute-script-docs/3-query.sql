--01  what bus on stop= 50268
prompt -01-  what bus on stop= 50268
 select   d.trip_headsign , r.route_name			/* add route name */
 from route_directions d,
		routes r 
 where 	d.route_id = r.route_id
		and (d.route_id, d.direction_id) in (
			select unique route_id, direction_id    /* find route id*/
			from route_stops 
			where  stop_code = '50268');
			
			
--02  next three 171 bus time at stop 50270
prompt -02-  next three 171 bus time at stop 50270
column arrival_time format A30
	
with
next_times as (
	select  arrival_time 									/*  get arrival_time list */
		from v_stop_times   
		where route_id = '171'
		and stop_code= '50270'
		and arrival_time > to_char(sysdate, 'HH24:MI:SS') 
		order by arrival_time)
select arrival_time 
	from next_times n1
	where 3> ( 												/*  get first three rows */
			select count(*) from next_times n2
			where n1.arrival_time > n2.arrival_time);
	
			
--03 take which bus to go from stop-a  50270 to stop-z 50296 (without transfer)
prompt -03- take which bus to go from stop-a  50270 to stop-z 50296 (without transfer)

select a.trip_headsign route,  z.stop_sequence - a.stop_sequence stop_number
from			
	(select route_id, direction_id, stop_code , stop_sequence, trip_headsign
	from v_route_stops where stop_code = '50270' ) a
	,
	(select route_id, direction_id, stop_code , stop_sequence,  trip_headsign
	from v_route_stops where stop_code = '50296') z
where a.trip_headsign = z.trip_headsign;


-- 04 take which bus to go from stop-a  50270 to stop-z 50296 (without transfer) , and show the next arrival_time
prompt -04- take which bus to go from stop-a  50270 to stop-z 50296 (without transfer) , and show the next arrival_time

column route_id format A10
column direction_id format A10	
column next_time format A15
with 
	t_route as 	(			/* get routes*/
			select a.trip_headsign , a.stop_code stop_a , z.stop_sequence - a.stop_sequence stop_number
			from			
				(select route_id, direction_id, stop_code , stop_sequence, trip_headsign
				from v_route_stops where stop_code = '50270' ) a
				,
				(select route_id, direction_id, stop_code , stop_sequence,  trip_headsign
				from v_route_stops where stop_code = '50296') z
			where a.trip_headsign = z.trip_headsign
		) 	
 select r.trip_headsign, min(s.arrival_time) next_time from v_stop_times s, t_route r			/* get next arrival_time*/
	where s.trip_headsign = r.trip_headsign
	and s.stop_code= r.stop_a
	and s.arrival_time > to_char(sysdate, 'HH24:MI:SS') 
	group by r.trip_headsign, r.stop_a;
	
--05 find routes (need to transfer) to go from stop-a 50248  to stop-b 50315 
-- first find all the bus for the start stop and end stop 
-- then find the routes that have common stops 
prompt -05- find routes (need to transfer) to go from stop-a 50248  to stop-b 50315 

column route_a format A10
column route_z format A10
column transfer_stop  format A20
column intersection format A40

select ra.trip_headsign route_a, i.stop_code transfer_stop , s.stop_name intersection, rz.trip_headsign route_z
from 
	(select a.route_id route_a, a.direction_id direction_a, a.stop_code , z.route_id route_z, z.direction_id direction_z
		from 
			(select  route_id, direction_id , stop_code from route_stops where (route_id, direction_id) in 	   /* all routes go by start stop*/	
					(select route_id , direction_id from route_stops where stop_code ='50248')) a, 
			(select route_id, direction_id, stop_code from route_stops where (route_id, direction_id) in 		/* all routes go by end stop*/
					(select route_id , direction_id from route_stops where stop_code ='50315')) z
		where a.stop_code = z.stop_code ) i, 
	route_directions ra, 
	route_directions rz, 
	stops s
where 
	i.route_a=ra.route_id and i.direction_a = ra.direction_id
	and i.route_z=rz.route_id and i.direction_z = rz.direction_id
	and s.stop_code = i.stop_code		/* have common  stop*/
;						 		

-- 06 show timetable for route 171 at stop 50268
prompt -06- show timetable for route 171 at stop 50268

column hour format A10
column minute format A50
 
select substr(arrival_time,1,2) "hour", 
		listagg(substr(arrival_time,4,2),'-') within group (order by substr(arrival_time,4,2)) "minute" 
from android.stop_times 
where route_id='171' and stop_code='50268'   
group by  substr(arrival_time,1,2) ;
		
	
-- 07 find the opposite direction stop_code of route 171-O  stop 50268
prompt  -07- find the opposite direction stop_code of route 171-O  stop 50268
column stop_code2 format A50
select stop_code2 from 
(
	select stop_code2, get_stops_distance('50268', stop_code2) distance from 
		(select stop_code stop_code2 from v_route_stops where trip_headsign='171-E' ) stop2       /*all stops of opposite direction */
	order by distance		 /* order by distance */
) orderedstop2
WHERE ROWNUM = 1				 /* get first row */
;