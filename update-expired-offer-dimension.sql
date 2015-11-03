SELECT * FROM db_discounts WHERE discount_group_id = '{801}'

SELECT * FROM d_clients WHERE client_id = 2

SELECT * FROM d_partners WHERE partner_id = 0

SELECT * FROM d_currencies WHERE currency_code = 'USD'

SELECT * FROM d_paymentgateways WHERE paymentgateway_id = 15

SELECT * FROM d_offers WHERE offer_id = 37010

SELECT * FROM d_locations WHERE city = 'N/A' AND country = 'Indonesia'

SELECT * FROM d_users WHERE user_id = 416016

UPDATE d_offers
SET current_version = 0, expired_date = '2015-10-29'
WHERE offer_key = 287359

UPDATE d_offers d_offers
SET current_version = 0, expired_date = expired_date_new
FROM (
SELECT MIN(offer_key) AS offer_key, MAX(effective_date) - 1 AS expired_date_new FROM d_offers WHERE offer_id IN (
SELECT offer_id FROM d_offers WHERE current_version = 1 GROUP BY offer_id HAVING COUNT(*) > 1
)
AND current_version = 1
GROUP BY offer_id) z
WHERE z.offer_key = d_offers.offer_key

TRUNCATE TABLE s_sales_new