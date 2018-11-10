select
	targets.description as targets,
	time_stamp,
	time_stamp::date as date,
	title
from events
inner join targets on target_id=targets.id
where 
--	title ~* '^T[A-Z0-9_].*? flyby'
	title ilike '%flyby%' or
	title ilike '%fly by%'
order by date 
