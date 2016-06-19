drop table stops cascade constraints;
drop table routes cascade constraints;
drop table trips cascade constraints;
drop table stop_times cascade constraints;
drop table route_directions cascade constraints;
drop table route_stops cascade constraints;



--drop index route_stops_idx ;
--drop index trips_route_idx ;
--drop  index stop_times_idx ;

drop sequence seq_route_stop_id ;
drop  sequence seq_stop_time_id ;


-- create 6 tables
create table stops(
stop_code varchar2(5) constraint stops_pk primary key,
stop_name varchar2(255) not null,
stop_lat number(10,6) ,
stop_lon number(10,6) ,
wheelchair_boarding varchar2(1) constraint stop_wheelchair_ck check (wheelchair_boarding in ('1', '2'))
);

create table routes(
route_id varchar2(3) constraint routes_pk primary key,
route_name varchar2(50) not null,
route_type varchar2(10) not null constraint route_type_ck check ( route_type in ('1','3'))
);

create table route_directions(
route_id varchar2(3)  constraint route_directions_route_fk references routes(route_id),
direction_id varchar2(1) not null constraint direction_id_ck check ( direction_id in ('0','1')),
trip_headsign varchar2(50) not null,
constraint route_directions_pk primary key(route_id, direction_id)
);

create table route_stops(
route_stop_id number(10) constraint route_stops_pk primary key,
route_id varchar2(3) not null,
direction_id varchar2(1) not null,
stop_sequence number(5) not null,
stop_code varchar2(5) not null constraint route_stops_code_fk references stops(stop_code),
shape_id varchar2(30),
constraint route_stops_id_fk foreign key (route_id, direction_id) references route_directions(route_id,direction_id )
);

create table trips(
trip_id  varchar2(30) constraint trips_pk primary key,
service_id varchar2(10) not null,
route_id varchar2(3) not null,
direction_id varchar2(1) not null,
trip_headsign varchar2(50) not null,
wheelchair_accessible varchar2(1) constraint trip_wheelchair_ck check (wheelchair_accessible in ('1', '2')) ,
shape_id varchar2(15) ,
constraint trips_route_direction_fk foreign key(route_id, direction_id) references route_directions (route_id, direction_id)
);



create table stop_times(
stop_time_id number(10) constraint stop_times_pk primary key,
trip_id varchar2(30)  not null constraint stop_times_trip_fk references trips(trip_id),
stop_code varchar2(5)  not null constraint stop_times_stop_fk references stops(stop_code),
stop_sequence number(5) not null,
arrival_time varchar2(8) not null
);

-- create  indexes

create index route_stops_idx on route_stops(route_id, direction_id, stop_code);
create index trips_route_idx on trips(route_id, direction_id );
create index stop_times_idx on stop_times(trip_id);

-- create 2 sequences 
create sequence seq_route_stop_id start with 1 increment by 1;
create sequence seq_stop_time_id start with 1 increment by 1;


-- create two trigger to use sequence when route_stop.route_stop_id  is null
create or replace trigger trg_route_stop_id
before insert on route_stops
for each row
begin
	if :NEW.route_stop_id is null then
		select seq_route_stop_id.nextval into :NEW.route_stop_id from dual;
	end if;
end;
/
-- create two trigger to use sequence when stop_times.stop_time_id  is null
create or replace trigger trg_stop_time_id
before insert on stop_times
for each row
begin
	if :NEW.stop_time_id is null then
		select seq_stop_time_id.nextval into :NEW.stop_time_id from dual;
	end if;
end;
/

-- create views 
---- join stop_times with trips
create or replace view v_stop_times as
select t.trip_id, t.arrival_time, t.stop_sequence , t.stop_code, 
	p.route_id, p.direction_id, p.trip_headsign, p.wheelchair_accessible, p.shape_id, p.service_id
from stop_times t
	left outer join trips p on t.trip_id = p.trip_id;

-- join route_directions with routes
create or replace view v_route_directions as
select r.route_id, r.route_name, r.route_type, d.direction_id, d.trip_headsign
from routes r
right outer join  route_directions d on r.route_id = d.route_id;

-- join route_stops with route_directions
create or replace view v_route_stops as
select s.route_stop_id, r.route_id, r.direction_id, r.trip_headsign,
		s.stop_sequence, s.stop_code	
	from route_directions r
	right outer join route_stops s on r.route_id=s.route_id and r.direction_id=s.direction_id;



-- create function for calculate distance between two points
create or replace function get_distance
(lat1 in number,lon1 in number,lat2 in number, lon2 in number ) return number
is
	d number;
	x number;
	y number;
	r number;
	pi number;
begin
  r:=6371229;
  pi:=3.14159265358979323;
  x:=(lon2-lon1)*pi*r*cos((lat2+lat1)/2*pi/180)/180;
  y:=(lat2-lat1)*pi*r/180;
  d:=SQRT(power(x,2)+power(y,2));
  return d;
end get_distance;
/

-- create function for caculate distance between two stops
CREATE OR REPLACE FUNCTION GET_STOPS_DISTANCE 
(
  STOP_CODE1 IN STOPS.STOP_CODE%TYPE
, STOP_CODE2 IN STOPS.STOP_CODE%TYPE 
) RETURN NUMBER AS 
lat1  STOPS.STOP_LAT%TYPE;
lon1   STOPS.STOP_LON%TYPE;
lat2   STOPS.STOP_LAT%TYPE; 
lon2   STOPS.STOP_LON%TYPE; 
BEGIN
  select stop_lat, STOP_LON into lat1, lon1 from stops where STOP_CODE=stop_code1;
  select stop_lat, stop_lon into lat2, lon2 from stops where stop_code = stop_code2;
  RETURN get_distance(lat1, lon1, lat2, lon2);
exception
  when others then
  return -1;
END GET_STOPS_DISTANCE;
/