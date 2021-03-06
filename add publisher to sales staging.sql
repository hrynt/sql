﻿SELECT
	TO_CHAR(COALESCE(core_payments.payment_datetime, core_payments.modified), 'YYYYMMDD')::INT AS utc_sales_date_key,
	TO_CHAR(COALESCE(core_payments.payment_datetime, core_payments.modified), 'HH24MISS')::INT AS utc_sales_time_key,
	core_payments.user_id,
	core_orderlines.offer_id,
	core_payments.paymentgateway_id,
	COALESCE(core_orderdetails.user_city, 'N/A') AS sales_city,
	COALESCE(core_orderdetails.user_country, 'N/A') AS sales_country,
	core_orders.client_id,
	COALESCE(core_orders.partner_id, 0) AS partner_id,
	UPPER(core_orderlines.adjusted_currency_code) AS currency_code,
	core_orderlines.adjusted_price AS local_currency_gross_sales,
	core_orderlines.adjusted_final_price AS local_currency_net_sales,
	core_orderlines.id AS orderline_id,
	core_orders.id AS order_id,
	core_payments.id AS payment_id,
	COALESCE(core_orderlinediscounts.discount_group_id, '{0}') AS discount_group_id,
	publisher_calculation.publisher_gross_share,
	publisher_calculation.publisher_net_share,
	CASE WHEN LENGTH(core_payments.payment_period) = 7 THEN TO_CHAR((TO_DATE(core_payments.payment_period, 'YYYY-MM') + INTERVAL '1 month' - INTERVAL '1 day')::DATE, 'YYYYMMDD')::INT ELSE null END AS sales_settlement_period_key
FROM 
	core_payments
	JOIN core_orderlines ON core_orderlines.order_id = core_payments.order_id
	JOIN core_orders ON core_orders.id = core_orderlines.order_id
	LEFT JOIN core_orderdetails ON core_orderdetails.order_id = core_orders.id
	JOIN core_offers ON core_offers.id = core_orderlines.offer_id
	LEFT JOIN(
		SELECT orderline_id, ARRAY_AGG(DISTINCT discount_id ORDER BY discount_id) discount_group_id 
		FROM core_orderlinediscounts
		GROUP BY orderline_id
		) core_orderlinediscounts on core_orderlinediscounts.orderline_id = core_orderlines.id
	LEFT JOIN publisher_calculation ON publisher_calculation.orderline_id = core_orderlines.id
WHERE
	core_payments.id != 505474