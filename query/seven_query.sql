select id, date, title
from enceladus_events
where search @@  to_tsquery('closest')
