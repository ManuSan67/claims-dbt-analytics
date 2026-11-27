select
    workshop_id,
    workshop_name,
    state,
    city,
    network,
    opened_date
from {{ ref('stg_bronze__workshops') }}
