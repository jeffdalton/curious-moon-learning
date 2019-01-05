 with mins as 
 (
 select
    min(altitude) as nadir,
    year,
    week
 from time_altitudes
 group by year, week
 order by year, week
 ), min_times as (
 select 
    mins.*,
    min(time_stamp) as low_time,
    min(time_stamp) + interval '20 seconds' as window_end,
    min(time_stamp) - interval '20 seconds' as window_start
 from mins
 inner join time_altitudes ta
    on mins.year = ta.year and mins.week = ta.week and mins.nadir = ta.altitude
 group by mins.week, mins.year, mins.nadir 
 ), fixed_flybys as (
     select f.id,
        f.name,
        f.date,
        f.altitude,
        f.speed,
        mt.nadir,
        mt.year,
        mt.week,
        mt.low_time,
        mt.window_start,
        mt.window_end
    from flybys f 
    inner join min_times mt on 
        date_part('year', f.date) = mt.year AND
        date_part('week', f.date) = mt.week 
 )
 select * into flybys_2
 from fixed_flybys
 order by date;

 alter table flybys_2
 add primary key (id);

drop table flybys cascade;
drop table time_altitudes;

alter table flybys_2
rename to flybys;

