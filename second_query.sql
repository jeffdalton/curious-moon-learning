select target, title, date
from import.master_plan
where start_time_utc::date = '2005-02-17'
order by start_time_utc::date
