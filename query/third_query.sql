select
	targets.description as target,
	events.time_stamp,
	event_types.description as event
from events
inner join event_types on event_types.id = events.event_type_id
inner join targets on targets.id = events.target_id
where
	events.time_stamp::date = '2005-02-17' and
	targets.id = 28
order by
	events.time_stamp;
