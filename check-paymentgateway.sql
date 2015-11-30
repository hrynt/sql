SELECT paymentgateway_id, COUNT(*)
FROM auto_calculate
GROUP BY paymentgateway_id
ORDER BY 2 DESC

SELECT
  currency_code,
  price,
  final_price,
  publisher_gross_share,
  publisher_gross_share_after_pg,
  publisher_net_share,
  publisher_gross_share * 0.98,
  paymentgateway_id,
  platform_id
FROM auto_calculate
WHERE
  paymentgateway_id = 5
  AND paymentgatewaycosts_id = 1
  AND publisher_gross_share_after_pg <> publisher_gross_share * 0.98


SELECT * FROM core_offers WHERE id = 43103

paymentgateway_id
1
9
15
12
5


SELECT * FROM core_paymentgateways WHERE id = 5

SELECT 30870 / 44100::NUMERIC