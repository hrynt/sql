SELECT *
FROM auto_calculate
-- GROUP BY discount_id
-- ORDER BY 2 DESC

SELECT
  discount_id,
  currency_code,
  price,
  final_price,
  publisher_gross_share,
  paymentgateway_id,
  platform_id
FROM auto_calculate
WHERE
  discount_id ILIKE '%1239%'
  AND final_price <> publisher_gross_share
;

discount_id
{610}
{1220}
{1239}

SELECT * FROM core_discounts WHERE id = 1239

SELECT 30870 / 44100::NUMERIC