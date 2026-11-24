select
    claim_id,
    investigated_on as investigated_at,
    outcome,
    arrival_date,
    _ingested_at as ingested_at
from {{ source('bronze', 'investigations') }}
qualify row_number() over (partition by claim_id order by _ingested_at desc) = 1
