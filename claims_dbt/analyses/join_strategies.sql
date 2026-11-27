select w.network, count(*) as claims, sum(f.paid_amount) as paid
from {{ ref('fact_claim') }} as f
inner join {{ ref('dim_workshop') }} as w on f.workshop_id = w.workshop_id
where f.city = 'Guadalajara'
group by w.network;

select /*+ SHUFFLE_MERGE(w) */ w.network, count(*) as claims, sum(f.paid_amount) as paid
from {{ ref('fact_claim') }} as f
inner join {{ ref('dim_workshop') }} as w on f.workshop_id = w.workshop_id
where f.city = 'Guadalajara'
group by w.network;
