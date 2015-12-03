SELECT
  f_sales_new.orderline_id,
  d_users.user_id,
  valid_from_date.date AS valid_from_date,
  valid_until_date.date AS valid_to_date,
  row_number() OVER (PARTITION BY d_users.user_id ORDER BY orderline_id) AS subscription_number,
  d_clients.client_category
FROM
  f_sales_new
  JOIN d_date valid_from_date ON valid_from_date.date_key = f_sales_new.valid_from_date_key
  JOIN d_date valid_until_date ON valid_until_date.date_key = f_sales_new.valid_to_date_key
  JOIN d_users ON d_users.user_key = f_sales_new.user_key
  JOIN d_offers ON d_offers.offer_key = f_sales_new.offer_key
  JOIN d_clients ON d_clients.client_key = f_sales_new.client_key
WHERE
  d_offers.offer_purchase_plan = 'Buffet';