alter table flybys
add targeted boolean not null default false;

update flybys 
set targeted = true 
where id in (3, 5, 7, 17, 18, 21);
