-- Output 1: Total Values of Transactions by each bank
  SELECT 
    SPLIT_PART(transaction_code, '-', 1) as "Bank", 
    SUM(value) as "Value" 
  FROM 
    pd2023_wk01 
  GROUP BY 
    "Bank"
;

-- Output 2: Total Values by Bank, Day of the Week and Type of Transaction

SELECT 
  SPLIT_PART(transaction_code, '-', 1) as "Bank", 
  CASE WHEN online_or_in_person = 1 THEN 'Online' ELSE 'In-Person' END AS "Online or In-Person", 
  DAYNAME(
    TO_DATE(
      TRANSACTION_DATE, 'DD/MM/YYYY HH:MI:SS'
    )
  ) as "Transaction Date", 
  SUM(value) as "Value" 
FROM 
  pd2023_wk01 
GROUP BY 
  "Bank", 
  "Transaction Date", 
  "Online or In-Person"
;

-- Output 3: Total Values by Bank and Customer Code

SELECT 
  SPLIT_PART(transaction_code, '-', 1) as "Bank", 
  customer_code as "Customer Code",
  SUM(value) as "Value" 
FROM
    pd2023_wk01
GROUP BY 
    "Bank",
    "Customer Code"
;