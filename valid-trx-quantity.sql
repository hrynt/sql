SELECT 
	COUNT(*)
FROM 
	core_payments
	JOIN core_orderlines ON core_orderlines.order_id = core_payments.order_id
	JOIN core_orders ON core_orders.id = core_payments.order_id
WHERE 1=1
	AND core_payments.payment_status = 20003
	AND core_payments.is_active = TRUE
	AND core_payments.is_test_payment = FALSE
	AND core_orderlines.is_active = TRUE
	AND core_orderlines.is_free = FALSE
	AND core_payments.modified BETWEEN '2015-10-01 00:00:00' AND '2015-10-31 23:59:59';