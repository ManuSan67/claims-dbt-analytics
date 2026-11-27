{{ config(severity='warn', store_failures=true) }}

select claim_id, policy_id, reported_ts
from {{ ref('fact_claim') }}
where not policy_in_force
