select 
    distinct(teams.description) as teams,
    100 * (
        (count(1) over (partition by teams.description))::numeric /
        (count(1) over ())::numeric) as percent_of_mission
from events
inner join teams on teams.id = team_id
order by percent_of_mission desc;