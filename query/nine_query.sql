select
	date_part('year',time_stamp) as year,
	date_part('month',time_stamp) as month,
	min(altitude) as nadir
from flyby_altitudes
group by
	date_part('year', time_stamp),
	date_part('month', time_stamp)

