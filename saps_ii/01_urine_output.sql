DROP MATERIALIZED VIEW IF EXISTS saps_ii.uofirstday CASCADE;
create materialized view saps_ii.uofirstday as
select
  -- patient identifiers
  coh.micro_specimen_id, per.person_id

  -- volumes associated with urine output ITEMIDs
  , sum(
      -- we consider input of GU irrigant as a negative volume
      case when oe.itemid = 227488 then -1*VALUE
      else VALUE end
  ) as UrineOutput
from
sepsis_micro.cohort coh
inner join omop_cdm.person per
on per.person_id = coh.person_id
inner join mimiciv.patients pat
on pat.subject_id = per.person_source_value::int
-- inner join mimiciv.admissions adm
-- on adm.subject_id = pat.subject_id and (coh.chart_time > (adm.admittime - interval '2' day)) and (coh.chart_time < (adm.dischtime + interval '2' day))
inner join mimiciv.icustays icu
on icu.subject_id = pat.subject_id and (coh.chart_time > (icu.intime - interval '2' day)) and (coh.chart_time < (icu.outtime + interval '2' day))
left join mimiciv.outputevents oe
-- join on all patient identifiers
on icu.subject_id = oe.subject_id and icu.hadm_id = oe.hadm_id
-- and ensure the data occurs during the first day
and oe.charttime between icu.intime and (icu.intime + interval '1' day) -- first ICU day
where itemid in
(
-- these are the most frequently occurring urine output observations in CareVue
40055, -- "Urine Out Foley"
43175, -- "Urine ."
40069, -- "Urine Out Void"
40094, -- "Urine Out Condom Cath"
40715, -- "Urine Out Suprapubic"
40473, -- "Urine Out IleoConduit"
40085, -- "Urine Out Incontinent"
40057, -- "Urine Out Rt Nephrostomy"
40056, -- "Urine Out Lt Nephrostomy"
40405, -- "Urine Out Other"
40428, -- "Urine Out Straight Cath"
40086,--	Urine Out Incontinent
40096, -- "Urine Out Ureteral Stent #1"
40651, -- "Urine Out Ureteral Stent #2"

-- these are the most frequently occurring urine output observations in MetaVision
226559, -- "Foley"
226560, -- "Void"
226561, -- "Condom Cath"
226584, -- "Ileoconduit"
226563, -- "Suprapubic"
226564, -- "R Nephrostomy"
226565, -- "L Nephrostomy"
226567, --	Straight Cath
226557, -- R Ureteral Stent
226558, -- L Ureteral Stent
227488, -- GU Irrigant Volume In
227489  -- GU Irrigant/Urine Volume Out
)
group by coh.micro_specimen_id, per.person_id
-- order by coh.micro_specimen_id, per.person_id
;
