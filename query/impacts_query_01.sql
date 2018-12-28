select 
    impact_date,
    pythag(x_velocity, y_velocity, z_velocity) as v_kms
from cda.impacts
where x_velocity <> -99.99