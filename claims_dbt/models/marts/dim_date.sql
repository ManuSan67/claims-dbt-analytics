with days as (
    select explode(sequence(date '2025-01-01', date '2026-12-31')) as d
)

select
    cast(date_format(d, 'yyyyMMdd') as int) as date_key,
    d as date,
    year(d) as year,
    quarter(d) as quarter,
    month(d) as month,
    date_format(d, 'MMMM') as month_name,
    dayofweek(d) as day_of_week,
    dayofweek(d) in (1, 7) as is_weekend
from days
