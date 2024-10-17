Select 
  t.transaction_id, 
  concat(
    'GB', 
    check_digits, 
    swift_code, 
    replace(sort_code, '-', '')
  ) as "IBAN" 
from 
  pd2023_wk02_transactions as t 
  join pd2023_wk02_swift_codes as s on s.bank = t.bank