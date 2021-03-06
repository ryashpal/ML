-- Determines if a patient is ventilated on the first day of their ICU stay.
-- Creates a table with the result.
-- Requires the `ventdurations` table, generated by ../ventilation-durations.sql

DROP MATERIALIZED VIEW IF EXISTS saps_ii.ventfirstday CASCADE;
CREATE MATERIALIZED VIEW saps_ii.ventfirstday AS
select
  ie.subject_id, ie.hadm_id, ie.stay_id
  -- if vd.stay_id is not null, then they have a valid ventilation event
  -- in this case, we say they are ventilated
  -- otherwise, they are not
  , max(case
      when vd.stay_id is not null then 1
    else 0 end) as vent
from mimiciv.icustays ie
left join saps_ii.ventdurations vd
  on ie.stay_id = vd.stay_id
  and
  (
    -- ventilation duration overlaps with ICU admission -> vented on admission
    (vd.starttime <= ie.intime and vd.endtime >= ie.intime)
    -- ventilation started during the first day
    OR (vd.starttime >= ie.intime and vd.starttime <= ie.intime + interval '1' day)
  )
group by ie.subject_id, ie.hadm_id, ie.stay_id
order by ie.subject_id, ie.hadm_id, ie.stay_id;
