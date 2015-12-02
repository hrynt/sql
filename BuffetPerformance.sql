-- TODO: buffet cohort analysis
SELECT
  d_users.user_id,
  MIN(valid_from_date.date) AS subscription_start,
  MAX(valid_until_date.date) AS subscription_end,
  (MAX(valid_until_date.date) - MIN(valid_from_date.date)) / 30 ::NUMERIC,
  ROUND((MAX(valid_until_date.date) - MIN(valid_from_date.date)) / 30 + 0.5 :: NUMERIC) AS number_of_subscription
FROM
  f_sales_new
  JOIN d_date valid_from_date ON valid_from_date.date_key = f_sales_new.valid_from_date_key
  JOIN d_date valid_until_date ON valid_until_date.date_key = f_sales_new.valid_to_date_key
  JOIN d_users ON d_users.user_key = f_sales_new.user_key
  JOIN d_offers ON d_offers.offer_key = f_sales_new.offer_key
WHERE
  d_offers.offer_purchase_plan = 'Buffet'
GROUP BY
  d_users.user_id;

-- TODO: buffet subscriber
SELECT
  d_clients.platform_name,
  d_clients.client_name,
  COUNT(DISTINCT d_users.user_id) AS buffet_subscriber
FROM
  f_sales_new
  JOIN d_date valid_from_date ON valid_from_date.date_key = f_sales_new.valid_from_date_key
  JOIN d_users ON d_users.user_key = f_sales_new.user_key
  JOIN d_clients ON d_clients.client_key = f_sales_new.client_key
WHERE
  valid_from_date.date <= current_date
GROUP BY
  d_clients.platform_name,
  d_clients.client_name;