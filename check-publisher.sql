SELECT vendor_id, COUNT(*)
FROM auto_calculate
GROUP BY vendor_id
ORDER BY 2 DESC

SELECT
  currency_code,
  price,
  final_price,
  publisher_gross_share,
  publisher_gross_share_after_pg,
  publisher_net_share,
  publisher_gross_share_after_pg * 0.6,
  paymentgateway_id,
  platform_id
FROM auto_calculate
WHERE
  vendor_id = 553
  AND publisher_net_share <> publisher_gross_share_after_pg * 0.6


SELECT * FROM core_offers WHERE id = 43103

vendor_id
139 standard new agreement
22
251
333
553

SELECT * FROM core_vendors WHERE id = 553

SELECT 30870 / 44100::NUMERIC