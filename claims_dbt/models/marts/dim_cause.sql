select
    cause,
    cause_group,
    is_catastrophic
from {{ ref('cause_groups') }}
