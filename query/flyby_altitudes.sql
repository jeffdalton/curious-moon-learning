select
    min(flyby_altitudes.time_stamp)
from flyby_altitudes
inner join flybys on flybys.time_stamp::date = flyby_altitudes.time_stamp::date AND
                     flybys.target_altitude = flyby_altitudes.altitude
        