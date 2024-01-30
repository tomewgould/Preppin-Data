with cte1 as (
  select 
    regexp_substr(transaction_code, '[A-Z]{2,3}') as Bank, 
    monthname(
      to_date(
        transaction_date, 'DD/MM/YYYY hh24:mi:ss'
      )
    ) as Month, 
    sum(value) as TotalValue, 
    rank() over(
      partition by month 
      order by 
        totalvalue desc
    ) as "Bank Rank per Month" 
  from 
    pd2023_wk01 
  group by 
    Bank, 
    Month
) 
select 
  *, 
  avg("Bank Rank per Month") over(partition by bank) as "Avg rank per bank", 
  avg(totalvalue) over(
    partition by "Bank Rank per Month"
  ) as "Avg transaction value per rank" 
from 
  cte1