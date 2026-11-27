{% set milestones = {
    'ADJUSTMENT': 'adjusted_ts',
    'PAYMENT': 'paid_ts',
    'CLOSE': 'closed_ts'
} %}

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
    {% for event_type, column_name in milestones.items() %}
        min(event_at) filter (where event_type = '{{ event_type }}') as {{ column_name }},
    {% endfor %}
    max(amount) filter (where event_type = 'ADJUSTMENT') as estimate_amount,
    sum(amount) filter (where event_type = 'PAYMENT') as paid_amount,
    coalesce(max(status) filter (where event_type = 'CLOSE'), 'open') as status
from {{ ref('stg_silver__claim_events') }}
group by claim_id
