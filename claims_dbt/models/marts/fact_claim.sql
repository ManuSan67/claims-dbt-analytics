-- depends_on: {{ ref('stg_silver__claim_events') }}
{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='claim_id',
        liquid_clustered_by=['reported_date_key']
    )
}}

{% if is_incremental() %}
    with cutoff as (
        select max(greatest(reported_ts, adjusted_ts, paid_ts, closed_ts)) - interval 3 days as since_ts
        from {{ this }}
    ),

    touched as (
        select distinct e.claim_id
        from {{ ref('stg_silver__claim_events') }} as e
        inner join cutoff as k on e.event_at >= k.since_ts
    ),

    claims as (
        select r.*
        from {{ ref('int_claims__rolled_up') }} as r
        inner join touched as t on r.claim_id = t.claim_id
    )
{% else %}
    with claims as (
        select * from {{ ref('int_claims__rolled_up') }}
    )
{% endif %}

select
    c.claim_id,
    p.policy_sk,
    c.policy_id,
    c.workshop_id,
    c.coverage_code,
    {{ date_key('c.reported_ts') }} as reported_date_key,
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
from claims as c
left join {{ ref('dim_policy') }} as p
    on
        c.policy_id = p.policy_id
        and c.reported_ts >= p.valid_from
        and c.reported_ts < p.valid_to
