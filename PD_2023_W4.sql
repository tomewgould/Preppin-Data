with cte as(
  select 
    *, 
    1 as source_table 
  from 
    PD2023_WK04_JANUARY 
  union all 
  select 
    *, 
    2 as source_table 
  from 
    PD2023_WK04_FEBRUARY 
  union all 
  select 
    *, 
    3 as source_table 
  from 
    PD2023_WK04_MARCH 
  union all 
  select 
    *, 
    4 as source_table 
  from 
    PD2023_WK04_APRIL 
  union all 
  select 
    *, 
    5 as source_table 
  from 
    PD2023_WK04_MAY 
  union all 
  select 
    *, 
    6 as source_table 
  from 
    PD2023_WK04_JUNE 
  union all 
  select 
    *, 
    7 as source_table 
  from 
    PD2023_WK04_JULY 
  union all 
  select 
    ID, 
    JOINING_DAY, 
    DEMOGRAPHIIC as DEMOGRAPHIC, 
    VALUE, 
    8 as source_table 
  from 
    PD2023_WK04_AUGUST 
  union all 
  select 
    *, 
    9 as source_table 
  from 
    PD2023_WK04_SEPTEMBER 
  union all 
  select 
    ID, 
    JOINING_DAY, 
    DEMAGRAPHIC as DEMOGRAPHIC, 
    VALUE, 
    10 as source_table 
  from 
    PD2023_WK04_OCTOBER 
  union all 
  select 
    *, 
    11 as source_table 
  from 
    PD2023_WK04_NOVEMBER 
  union all 
  select 
    *, 
    12 as source_table 
  from 
    PD2023_WK04_DECEMBER
), 
pre_pivot as (
  select 
    ID, 
    DEMOGRAPHIC, 
    VALUE, 
    TO_DATE(
      JOINING_DAY || '/' || SOURCE_TABLE || '/' || 2023, 
      'DD/MM/YYYY'
    ) as "JOINING_DATE" 
  from 
    cte
), 
post_pivot as (
  select 
    ID, 
    JOINING_DATE, 
    ETHNICITY, 
    ACCOUNT_TYPE, 
    DATE_OF_BIRTH :: DATE AS DATE_OF_BIRTH, 
    ROW_NUMBER() OVER(
      PARTITION BY id 
      ORDER BY 
        joining_date ASC
    ) as rn --GROUP ROW ID BY ROW NUMBER AND ORDER BY JOINING_DATE TO FIND DUPLICATES
  FROM 
    PRE_PIVOT PIVOT(
      MAX(value) FOR demographic IN (
        'Ethnicity', 'Account Type', 'Date of Birth'
      )
    ) AS P (
      id, joining_date, ethnicity, account_type, 
      date_of_birth
    )
) 
SELECT 
  id, 
  joining_date, 
  account_type, 
  date_of_birth, 
  ethnicity 
FROM 
  post_pivot 
WHERE 
  rn = 1