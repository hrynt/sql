SELECT
	*
FROM
	core_userbuffets
WHERE 1=1
	AND core_userbuffets.is_restore = FALSE
	AND core_userbuffets.is_trial = FALSE
	AND core_userbuffets.orderline_id IN (
		SELECT 
			core_orderlines.id
		FROM 
			core_payments
			JOIN core_orderlines ON core_orderlines.order_id = core_payments.order_id
			JOIN core_offers ON core_offers.id = core_orderlines.offer_id
		WHERE 1=1
			AND core_payments.payment_status = 20003
			AND core_payments.is_active = TRUE
			AND core_payments.is_test_payment = FALSE
			AND core_orderlines.is_active = TRUE
			AND core_orderlines.is_free = FALSE
			AND core_offers.offer_type_id = 4
		)
	AND valid_to BETWEEN '2015-09-01 00:00:00' AND '2015-09-30 23:59:59'