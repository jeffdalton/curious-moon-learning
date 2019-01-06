drop table if exists inms.chem_data;

create table inms.chem_data
(
    name text,
    formula varchar(10),
    molecular_weight integer,
    peak integer,
    sensitivity numeric
);

copy inms.chem_data
from '/home/jeffdalton/labs/curious_moon/cassini/data/INMS/chem_data.csv'
with delimiter ',' header csv;

alter table inms.chem_data
add id serial primary key;


