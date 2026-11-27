select
    policy_sk,
    policy_id,
    customer_id,
    plan,
    vehicle_year,
    vehicle_value,
    annual_premium,
    state,
    city,
    start_date,
    valid_from,
    coalesce(valid_to, timestamp '9999-12-31') as valid_to,
    is_current
from {{ ref('stg_silver__policies') }}
