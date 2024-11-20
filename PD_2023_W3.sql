with transactions as (
  select 
    CASE WHEN online_or_in_person = 1 THEN 'Online' ELSE 'In-Person' END AS "Online or In-Person", 
    QUARTER(
      TO_DATE(
        transaction_date, 'DD/MM/YYYY HH:MI:SS'
      )
    ) as "Quarter", 
    SUM(value) as "Value" 
  from 
    pd2023_wk01 
  where 
    transaction_code like 'DSB%' 
  group by 
    "Online or In-Person", 
    "Quarter"
), 
pivot as(
  select 
    * 
  from 
    pd2023_wk03_targets unpivot(
      "Quarterly targets" for "Quarter" in (Q1, Q2, Q3, Q4)
    )
), 
targets as(
  select 
    ONLINE_OR_IN_PERSON as "Online or In-Person", 
    to_numeric(
      right("Quarter", 1)
    ) as "Quarter", 
    "Quarterly targets" 
  from 
    pivot
) 
select 
  transactions."Online or In-Person", 
  transactions."Quarter", 
  transactions."Value", 
  targets."Quarterly targets", 
  transactions."Value" - targets."Quarterly targets" as "Variance to target" 
from 
  transactions 
  inner join targets on transactions."Online or In-Person" = targets."Online or In-Person" 
  and transactions."Quarter" = targets."Quarter"