drop table if exists master_plan;

create table master_plan(
	id serial primary key,
	the_date date,
	title varchar(100),
	description text
);
