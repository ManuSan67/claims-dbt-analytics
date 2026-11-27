select
    claim_id,
    any_value(policy_id) as policy_id,
    any_value(workshop_id) as workshop_id,
    any_value(coverage_code) as coverage_code,
    any_value(cause) as cause,
    any_value(state) as state,
    any_value(city) as city,
    any_value(source) as source,
    max(channel) as channel,
    min(event_at) as reported_ts,
    min(event_at) filter (where event_type = 'ADJUSTMENT') as adjusted_ts,
    min(event_at) filter (where event_type = 'PAYMENT') as paid_ts,
    min(event_at) filter (where event_type = 'CLOSE') as closed_ts,
    max(amount) filter (where event_type = 'ADJUSTMENT') as estimate_amount,
    sum(amount) filter (where event_type = 'PAYMENT') as paid_amount,
    coalesce(max(status) filter (where event_type = 'CLOSE'), 'open') as status
from {{ ref('stg_silver__claim_events') }}
group by claim_id
