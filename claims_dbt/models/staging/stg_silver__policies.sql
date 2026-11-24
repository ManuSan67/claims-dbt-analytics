select
    xxhash64(policy_id, __start_at) as policy_sk,
    policy_id,
    customer_id,
    plan,
    vehicle_year,
    vehicle_value,
    annual_premium,
    state,
    city,
    start_date,
    __start_at as valid_from,
    __end_at as valid_to,
    __end_at is null as is_current
from {{ source('silver', 'policies') }}
