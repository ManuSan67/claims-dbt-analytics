{{ config(materialized='view') }}

select
    workshop_id,
    workshop_name,
    state,
    city,
    {% if var('demo_change', false) %}
        case
            when workshop_id not in ('W0001', 'W0002', 'W0003') then network
            when network = 'agencia' then 'multimarca'
            else 'agencia'
        end as network,
    {% else %}
        network,
    {% endif %}
    opened_date
from {{ ref('stg_bronze__workshops') }}
