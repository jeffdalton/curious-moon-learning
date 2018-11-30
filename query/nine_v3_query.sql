select
	date_part('year',time_stamp) as year,
	date_part('week',time_stamp) as week,
	min(altitude) as nadir
from flyby_altitudes
group by
	date_part('year', time_stamp),
	date_part('week', time_stamp)

