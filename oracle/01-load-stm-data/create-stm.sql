drop table agency;
drop table stops;
drop table routes;
drop table trips;
drop table stop_times;
drop table calendar_dates;
drop table shapes;
drop table frequencies;


create table agency(
agency_id varchar(3) not null,
agency_name varchar(40) not null,
agency_url varchar(60) not null,
agency_timezone varchar(20) not null,
agency_lang varchar(10),
agency_phone varchar(15),
agency_fare_url varchar(255)
);


create table stops(
stop_id varchar(10) not null,
stop_code varchar(10) not null,
stop_name varchar(255) not null,
stop_lat number(10,6) not null,
stop_lon number(10,6) not null,
stop_url varchar(255) ,
wheelchair_boarding varchar(1)
);

create table routes(
route_id varchar(3) not null,
agency_id varchar(3) ,
route_short_name varchar(30) not null,
route_long_name varchar(255) not null,
Route_type varchar(10) not null,
Route_url varchar(255),
Route_Color varchar(6),
Route_Text_Color varchar(6)
);

create table trips(
route_id varchar(10) not null,
Service_id varchar(20) not null,
Trip_id  varchar(30) not null,
trip_headsign varchar(100) ,
direction_id varchar(10),
wheelchair_accessible varchar(1) ,
shape_id varchar(30) ,
note_fr varchar(255),
note_en varchar(255)
);



create table stop_times(
trip_id varchar(50)  ,
arrival_time varchar(30)  ,
departure_time varchar(30)  ,
stop_id varchar(20)  ,
stop_sequence varchar(10) 
);

create table calendar_dates(
service_id varchar(10) not null,
calendar_date date not null,
Exception_type varchar(1) not null
);



create table shapes(
shape_id varchar(15) not null,
shape_pt_lat number(10,6) not null,
shape_pt_lon number(10,6) not null,
shape_pt_sequence varchar(8) not null
);


create table frequencies(
trip_id varchar(20),
start_time varchar(10),
end_time varchar(10),
headway_secs number(5)
);