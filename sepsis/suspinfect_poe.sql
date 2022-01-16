DROP TABLE IF EXISTS sepsis.suspinfect_poe CASCADE;
CREATE TABLE sepsis.suspinfect_poe as
with abx as
(
  select stay_id
    , suspected_infection_time
    , specimen, positiveculture
    , antibiotic_name
    , antibiotic_time
    , ROW_NUMBER() OVER
    (
      PARTITION BY stay_id
      ORDER BY suspected_infection_time
    ) as rn
  from sepsis.abx_micro_poe
)
select
  ie.stay_id
  , antibiotic_name
  , antibiotic_time
  , suspected_infection_time
  , specimen, positiveculture
from mimiciv.icustays ie
left join abx
  on ie.stay_id = abx.stay_id
  and abx.rn = 1
order by ie.stay_id
;

