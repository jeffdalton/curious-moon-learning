with kms as (
    select 
        impact_date as the_date,
        date_part('month', time_stamp) as month,
        date_part('year', time_stamp) as year,
        pythag(x_velocity, y_velocity, z_velocity) as v_kms
    from cda.impacts
    where x_velocity <> -99.99
), speeds as (
    select 
        kms.*,
        (v_kms * 60 * 60)::integer as kmh,
        (v_kms * 60 * 60 * .621)::integer as mph
    from kms
)
select * from speeds;
