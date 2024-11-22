with pre_pivot as(
  select 
    customer_id, 
    split_part(pivot_columns, '___', 1) as device, 
    split_part(pivot_columns, '___', 2) as factor, 
    value 
  from 
    (
      select 
        * 
      from 
        PD2023_WK06_DSB_CUSTOMER_SURVEY
    ) as src unpivot (
      value for pivot_columns in (
        mobile_app___ease_of_use, mobile_app___ease_of_access, 
        mobile_app___navigation, mobile_app___likelihood_to_recommend, 
        mobile_app___overall_rating, online_interface___ease_of_use, 
        online_interface___ease_of_access, 
        online_interface___navigation, 
        online_interface___likelihood_to_recommend, 
        online_interface___overall_rating
      )
    ) as pvt
), 
p as (
  select 
    * 
  from 
    pre_pivot pivot (
      max(value) for device in (
        'MOBILE_APP', 'ONLINE_INTERFACE'
      )
    ) as p (
      customer_id, factor, mobile, online
    )
), 
data as (
  select 
    customer_id, 
    AVG(MOBILE) as mobile_avg, 
    AVG(ONLINE) as online_avg, 
    mobile_avg - online_avg as difference, 
    case when difference >= 2 then 'Mobile App Superfan' when difference >= 1 then 'Mobile App Fan' when difference <=-2 then 'Online INterface Superfans' when difference <= -1 then 'Online Interface Fan' else 'Neutral' end as Preference 
  from 
    p 
  where 
    factor not like 'OVERALL_RATING' 
  group by 
    customer_id
) 
select 
  preference, 
  round(
    (
      count(*)/(
        select 
          count(*) 
        from 
          data
      )
    )* 100, 
    1
  ) as percent_of_customers, 
from 
  data 
group by 
  preference
