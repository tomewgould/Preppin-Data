with t as(
  select 
    path.transaction_id as "Transaction ID", 
    path.account_to as "Account To", 
    path.account_from as "Account From", 
    detail.* 
  from 
    PD2023_WK07_TRANSACTION_PATH path 
    inner join PD2023_WK07_TRANSACTION_DETAIL detail on path.transaction_id = detail.transaction_id 
  where 
    cancelled_ = 'N' 
    and value > 1000
), 
a as(
  select 
    account_number, 
    account_type, 
    balance_date, 
    balance, 
    value as account_holder_id, 
  from 
    PD2023_WK07_ACCOUNT_INFORMATION, 
    lateral split_to_table(
      PD2023_WK07_ACCOUNT_INFORMATION.ACCOUNT_HOLDER_ID, 
      ','
    ) 
  where 
    account_holder_id is not null
) 
select 
  t."Transaction ID", 
  t."Account To", 
  t.transaction_date, 
  t.value, 
  a.account_number, 
  a.account_type, 
  a.balance_date, 
  a.balance, 
  h.name, 
  h.date_of_birth, 
  ('0' || h.contact_number) as contact_number, 
  h.first_line_of_address 
from 
  a 
  inner join PD2023_WK07_ACCOUNT_HOLDERS h on a.account_holder_id = h.account_holder_id 
  inner join t on a.account_number = t."Account From" 
where 
  account_type != 'Platinum';