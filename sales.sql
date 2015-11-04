SELECT
	TO_CHAR(COALESCE(core_payments.payment_datetime, core_payments.modified), 'YYYYMMDD')::INT AS utc_sales_date_key,
	TO_CHAR(COALESCE(core_payments.payment_datetime, core_payments.modified), 'HH24MISS')::INT AS utc_sales_time_key,
	core_payments.user_id,
	core_orderlines.offer_id,
	core_payments.paymentgateway_id,
	COALESCE(core_orderdetails.user_city, 'N/A') AS sales_city,
	COALESCE(core_orderdetails.user_country, 'N/A') AS sales_country,
	core_orders.client_id,
	COALESCE(core_orders.partner_id, 0) AS partner_id,
	UPPER(core_orderlines.currency_code) AS currency_code,
	core_orderlines.price AS local_currency_gross_sales,
	core_orderlines.final_price AS local_currency_net_sales,
	core_orderlines.id AS orderline_id,
	core_orders.id AS order_id,
	core_payments.id AS payment_id,
	COALESCE(core_orderlinediscounts.discount_group_id, '{0}') AS discount_group_id
FROM 
	core_payments
	JOIN core_orderlines ON core_orderlines.order_id = core_payments.order_id
	JOIN core_orders ON core_orders.id = core_orderlines.order_id
	LEFT JOIN core_orderdetails ON core_orderdetails.order_id = core_orders.id
	JOIN core_offers ON core_offers.id = core_orderlines.offer_id
	LEFT JOIN(SELECT orderline_id, ARRAY_AGG(DISTINCT discount_id ORDER BY discount_id) discount_group_id FROM core_orderlinediscounts GROUP BY orderline_id) core_orderlinediscounts on core_orderlinediscounts.orderline_id = core_orderlines.id
WHERE 1=1
	AND TO_CHAR(COALESCE(core_payments.payment_datetime, core_payments.modified), 'YYYYMM')::INT = 201510