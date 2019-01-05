-- calculate B and C
/* PREWORK TO BUILD SCRIPT
select id, altitude,
    (altitude + 252) as total_altitude, --b
    ((altitude + 252) / sind(73)) - 252 as target_altitude --c
from flybys;
*/

-- calculate C = target_altitude
update flybys 
set target_altitude = ((altitude + 252) / sind(73)) - 252;

update flybys
set transit_distance = ((target_altitude + 252) * sind(73) * 2);


update flybys set start_time =
(
    select min(time_stamp)
    from flyby_altitudes
    where flybys.time_stamp::date = flyby_altitudes.time_stamp::date AND
          altitude < flybys.target_altitude + 0.75 and altitude > flybys.target_altitude + 0.75
);

update flybys set end_time =
(
    select max(time_stamp)
    from flyby_altitudes
    where flybys.time_stamp::date = flyby_altitudes.time_stamp::date AND
          altitude < flybys.target_altitude + 0.75 and altitude > flybys.target_altitude + 0.75
);

