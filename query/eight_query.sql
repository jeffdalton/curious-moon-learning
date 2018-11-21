select (time_stamp at time zone 'UTC'), title
from events
where time_stamp::date = '2009-11-02'
order by time_stamp;
