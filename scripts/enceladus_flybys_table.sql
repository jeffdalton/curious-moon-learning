drop table if exists flybys;

with lows_by_week as(
select
	year,
	week,
	min(altitude) as altitude
from flyby_altitudes
group by
	year,
	week
), nadirs as(
    select 
        low_time(altitude, year, week) as time_stamp,
        altitude
    from lows_by_week
)

select 
    nadirs.*,
    null::varchar as name,
    null::timestamptz as start_time,
    null::timestamptz as end_time
into flybys
from nadirs;

alter table flybys
add column id serial primary key;

update flybys
set name = 'E-' || id-1;
