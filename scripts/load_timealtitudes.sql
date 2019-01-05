drop table if exists time_altitudes;
SELECT 
    (sclk::timestamp) as time_stamp,
    alt_t::numeric(9,2) as altitude,
    date_part('year', (sclk::timestamp)) as year,
    date_part('week', (sclk::timestamp)) as week
into time_altitudes
from import.inms
where target = 'ENCELADUS' AND
      alt_t is not null;

