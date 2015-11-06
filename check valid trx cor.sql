SELECT 
-- 	COUNT(DISTINCT core_orderlines.id)
	*
FROM 
	core_payments
	JOIN core_orderlines ON core_orderlines.order_id = core_payments.order_id
	JOIN core_offers ON core_offers.id = core_orderlines.offer_id
-- 	JOIN core_userbuffets ON core_userbuffets.orderline_id = core_orderlines.id
-- 	LEFT JOIN core_orderlinediscounts ON core_orderlinediscounts.id = core_orderlines.id
-- 	LEFT JOIN core_discounts ON core_discounts.id = core_orderlinediscounts.discount_id
WHERE 1=1
	AND core_orderlines.is_active = FALSE 
	AND core_payments.payment_status = 20003
	AND core_payments.is_active = TRUE
	AND core_payments.is_test_payment = FALSE
	AND core_payments.modified >= '2015-08-01 00:00:00'
	AND core_offers.offer_type_id = 4 -- include buffet / tidak
	AND core_orderlines.is_free = FALSE
