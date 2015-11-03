SELECT 
	user_id,
	username,
	email,
	publisher,
	title,
	valid_from,
	valid_to,
	CASE WHEN length < 150 THEN 3 WHEN length < 300 THEN 6 WHEN length >= 300 THEN 12 END AS length_month,
	COALESCE(currency, 'USD') AS currency,
	CASE 
		WHEN amount IS NULL AND length < 150 THEN 2.99 
		WHEN amount IS NULL AND length < 300 THEN 5.99 
		WHEN amount IS NULL AND length >= 300 THEN 11.99 
		ELSE amount END 
		AS amount,
	valid_to - valid_from AS total_days,
	valid_to - '2015-11-01' AS remaining_days,
	(valid_to - '2015-11-01')::NUMERIC / (valid_to - valid_from)::NUMERIC AS remaining_portion,
	CASE 
		WHEN COALESCE(currency, 'USD') = 'IDR' THEN ROUND((valid_to - '2015-11-01')::NUMERIC / (valid_to - valid_from)::NUMERIC * CASE WHEN amount IS NULL AND length < 150 THEN 2.99 WHEN amount IS NULL AND length < 300 THEN 5.99 WHEN amount IS NULL AND length >= 300 THEN 11.99 ELSE amount END, -3)
		WHEN COALESCE(currency, 'USD') = 'USD' THEN ROUND((valid_to - '2015-11-01')::NUMERIC / (valid_to - valid_from)::NUMERIC * CASE WHEN amount IS NULL AND length < 150 THEN 2.99 WHEN amount IS NULL AND length < 300 THEN 5.99 WHEN amount IS NULL AND length >= 300 THEN 11.99 ELSE amount END, 2)
	END AS remaining_value
FROM (
SELECT
	cas_users.id AS user_id,
	cas_users.username,
	cas_users.email,
	core_vendors.name AS publisher,
	core_brands.name AS title,
	core_usersubscriptions.valid_from::DATE AS valid_from,
	core_usersubscriptions.valid_to::DATE AS valid_to,
	ROUND(core_usersubscriptions.valid_to::DATE - core_usersubscriptions.valid_from::DATE, -1) AS length,
	CASE WHEN core_orderlines.currency_code = 'PTS' THEN 'IDR' ELSE core_orderlines.currency_code END AS currency,
	CASE WHEN core_orderlines.currency_code = 'PTS' THEN core_orderlines.price * 100 ELSE core_orderlines.price END AS amount
FROM
	core_usersubscriptions
	JOIN cas_users ON cas_users.id = core_usersubscriptions.user_id
	JOIN core_brands ON core_brands.id = core_usersubscriptions.brand_id
	JOIN core_vendors ON core_vendors.id = core_brands.vendor_id
	LEFT JOIN core_orderlines ON core_orderlines.id = core_usersubscriptions.orderline_id
WHERE 1=1
	AND brand_id = 5267
	AND core_usersubscriptions.is_active = TRUE
	AND valid_to > '2015-10-31 23:59:59'
) data
ORDER BY amount NULLS FIRST