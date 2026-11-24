select
    workshop_id,
    trim(workshop_name) as workshop_name,
    state,
    city,
    network,
    cast(opened_date as date) as opened_date,
    _ingested_at as ingested_at
from {{ source('bronze', 'workshops') }}
qualify row_number() over (partition by workshop_id order by _ingested_at desc) = 1
