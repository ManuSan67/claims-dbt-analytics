{{ config(liquid_clustered_by=['reported_date_key']) }}

select
    c.claim_id,
    p.policy_sk,
    c.policy_id,
    c.workshop_id,
    c.coverage_code,
    cast(date_format(c.reported_ts, 'yyyyMMdd') as int) as reported_date_key,
    c.cause,
    c.state,
    c.city,
    c.source,
    c.channel,
    c.reported_ts,
    c.adjusted_ts,
    c.paid_ts,
    c.closed_ts,
    c.estimate_amount,
    c.paid_amount,
    c.status,
    datediff(c.closed_ts, c.reported_ts) as days_to_close,
    p.policy_sk is not null as policy_in_force
from {{ ref('int_claims__rolled_up') }} as c
left join {{ ref('dim_policy') }} as p
    on
        c.policy_id = p.policy_id
        and c.reported_ts >= p.valid_from
        and c.reported_ts < p.valid_to
