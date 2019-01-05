drop table if exists flybys;

create table flybys (
    id int primary key,
    name text not null,
    date date not null,
    altitude numeric (7,1),
    speed numeric (7,1)
);

copy flybys 
from '/home/jeffdalton/labs/curious_moon/cassini/data/jpl_flybys.csv'
delimiter ',' header csv;
