select
    plan,
    coverage_code,
    trim(coverage_name) as coverage_name,
    deductible_pct,
    _ingested_at as ingested_at
from {{ source('bronze', 'coverages') }}
qualify row_number() over (partition by plan, coverage_code order by _ingested_at desc) = 1
