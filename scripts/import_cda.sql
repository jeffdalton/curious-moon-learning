drop table if exists import.cda;
create table import.cda (
    event_id text,
    impact_event_time text,
    impact_event_julian_date text,
    qp_amplitude text,
    qi_amplitude text,
    qt_amplitude text,
    qc_amplitude text,
    spacecraft_sun_distance text,
    spacecraft_saturn_distance text,
    spacecraft_x_velocity text,
    spacecraft_y_velocity text,
    spacecraft_z_velocity text,
    counter_number text,
    particle_mass text,
    particle_charge text
);

copy import.cda
from '/home/jeffdalton/labs/curious_moon/cassini/data/CDA/cda.csv'
delimiter ',' header csv;
