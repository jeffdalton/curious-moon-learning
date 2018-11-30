select
	time_stamp::date as date,
	min(altitude) as nadir
from flyby_altitudes
group by
	time_stamp::date
order by date;
