SELECT 
	* 
FROM 
	core_payments 
WHERE 
	order_id IN (
		SELECT
			core_payments.order_id
		FROM 
			core_payments
			JOIN core_orderlines ON core_orderlines.order_id = core_payments.order_id
		WHERE
			core_payments.is_active = TRUE
			AND core_payments.is_test_payment = FALSE
			AND core_payments.payment_status = 20003
			AND core_orderlines.is_active = TRUE
			AND core_orderlines.is_free = FALSE
	)