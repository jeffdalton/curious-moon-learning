select 
    distinct(targets.description) as target,
    100 * (
        (count(1) over (partition by targets.description))::numeric /
        (count(1) over ())::numeric) as percent_of_mission
from events
inner join targets on targets.id = target_id
order by percent_of_mission desc;