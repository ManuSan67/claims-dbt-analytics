select distinct
    coverage_code,
    coverage_name,
    cast(deductible_pct as decimal(4, 2)) as deductible_pct
from {{ ref('stg_bronze__coverages') }}
