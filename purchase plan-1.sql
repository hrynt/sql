-- TODO: purchase plan
SELECT
  utc_sales_month,
  utc_sales_month_name,
  CASE
    WHEN offer_purchase_plan = 'Single' THEN 1
    WHEN offer_purchase_plan = 'Subscription' THEN 2
    WHEN offer_purchase_plan = 'Buffet' THEN 3
    WHEN offer_purchase_plan = 'Bundle' THEN 4
    END AS id_offer_purchase_plan,
  offer_purchase_plan,
  COUNT(DISTINCT user_id)                                                   AS users,
  SUM(quantity)                                                             AS quantity,
  SUM(f_sales_new.local_currency_net_sales * COALESCE(usd.rate, usd2.rate)) AS usd
FROM
  f_sales_new
  JOIN d_utc_sales_date ON d_utc_sales_date.utc_sales_date_key = f_sales_new.utc_sales_date_key
  JOIN d_offers ON d_offers.offer_key = f_sales_new.offer_key
  JOIN d_users ON d_users.user_key = f_sales_new.user_key
  JOIN d_currencies ON d_currencies.currency_key = f_sales_new.currency_key :: INTEGER
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
GROUP BY
  utc_sales_month,
  utc_sales_month_name,
  offer_purchase_plan;