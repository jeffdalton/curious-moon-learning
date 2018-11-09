drop table if exists [LOOKUP_TABLE];
select distinct([THING]) as description
into [LOOKUP_TABLE]
from import.master_plan;

alter table [LOOKUP_TABLE]
add id serial primary key;
