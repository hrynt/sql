-- TODO: new & return users
SELECT
  utc_sales_month,
  utc_sales_month_name,
  CASE
  WHEN TO_CHAR(user_joined_date, 'YYYYMM') :: INT <> utc_sales_month_key
    THEN 'Return Users'
  ELSE 'New Users'
  END                                                                       AS user_type,
  COUNT(DISTINCT user_id)                                                   AS users,
  SUM(quantity)                                                             AS quantity,
  SUM(f_sales_new.local_currency_net_sales * COALESCE(usd.rate, usd2.rate)) AS usd
FROM
  f_sales_new
  JOIN d_utc_sales_date ON d_utc_sales_date.utc_sales_date_key = f_sales_new.utc_sales_date_key
  JOIN d_users ON d_users.user_key = f_sales_new.user_key
  JOIN d_currencies ON d_currencies.currency_key = f_sales_new.currency_key :: INT
  LEFT JOIN currency_fixed_rate usd ON
    REPLACE(usd.payment_period, '-', '') = LEFT(f_sales_new.sales_settlement_period_key :: TEXT, 6)
    AND usd.currency_from = d_currencies.currency_code
    AND usd.currency_to = 'USD'
  LEFT JOIN (
              SELECT *
              FROM currency_fixed_rate
              WHERE payment_period = (SELECT MAX(payment_period) FROM currency_fixed_rate)
            ) usd2 ON
    usd2.currency_from = d_currencies.currency_code
    AND usd2.currency_to = 'USD'
WHERE
  utc_sales_year = 2015
GROUP BY
  utc_sales_month,
  utc_sales_month_name,
  user_type
ORDER BY
  utc_sales_month DESC;