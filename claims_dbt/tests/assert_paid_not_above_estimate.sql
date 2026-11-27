select claim_id, estimate_amount, paid_amount
from {{ ref('fact_claim') }}
where paid_amount > estimate_amount
