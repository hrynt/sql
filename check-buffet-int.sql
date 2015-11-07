SELECT 
	TO_CHAR(valid_to, 'YYYY-MM') AS period,
	COUNT(DISTINCT core_orderlines.id) AS count
FROM 
	core_payments
	JOIN core_orderlines ON core_orderlines.order_id = core_payments.order_id
	JOIN core_offers ON core_offers.id = core_orderlines.offer_id
	JOIN (
		SELECT	
			orderline_id,
			MIN(valid_from) AS valid_from,
			MAX(valid_to) AS valid_to
		FROM 
			core_userbuffets
		WHERE 1=1
			AND core_userbuffets.is_restore = FALSE
			AND core_userbuffets.is_trial = FALSE
		GROUP BY
			orderline_id
		) core_userbuffets ON core_userbuffets.orderline_id = core_orderlines.id
WHERE 1=1
	AND core_payments.payment_status = 20003
	AND core_payments.is_active = TRUE
	AND core_payments.is_test_payment = FALSE
	AND core_orderlines.is_active = TRUE
	AND core_orderlines.is_free = FALSE
	AND core_offers.offer_type_id = 4
GROUP BY
	period
ORDER BY
	period
;