SELECT 
	DISTINCT core_discounts.*
FROM 
	core_payments
	JOIN core_orderlines ON core_orderlines.order_id = core_payments.order_id
	JOIN core_orderlinediscounts ON core_orderlinediscounts.orderline_id = core_orderlines.id
	JOIN core_userbuffets ON core_userbuffets.orderline_id = core_orderlines.id
	JOIN core_discounts ON core_discounts.id = core_orderlinediscounts.discount_id
WHERE 1=1
	AND core_payments.payment_status = 20003
	AND core_payments.is_active = TRUE
	AND core_payments.is_test_payment = FALSE
	AND core_orderlines.is_active = TRUE
	AND core_orderlines.is_free = FALSE
-- 	AND core_payments.modified BETWEEN '2015-08-01 00:00:00' AND '2015-10-31 23:59:59'
	AND core_userbuffets.valid_to BETWEEN '2015-09-01 00:00:00' AND '2015-10-31 23:59:59'
;