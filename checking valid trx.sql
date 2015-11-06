SELECT 
-- 	COUNT(DISTINCT core_orderlines.id)
	COUNT(*)
FROM 
	core_payments
	JOIN core_orderlines ON core_orderlines.order_id = core_payments.order_id
	JOIN core_offers ON core_offers.id = core_orderlines.offer_id
-- 	LEFT JOIN core_orderlinediscounts ON core_orderlinediscounts.id = core_orderlines.id
-- 	LEFT JOIN core_discounts ON core_discounts.id = core_orderlinediscounts.discount_id
WHERE 1=1
-- 	AND core_orderlines.is_active = FALSE 
	AND core_payments.payment_period = '2015-10'
-- 	AND core_payments.modified >= '2015-08-01 00:00:00'
-- 	AND core_offers.offer_type_id <> 4
-- 	AND COALESCE(core_discounts.publisher_involvement_status, 0) <> 1
-- ORDER BY
-- 	core_payments.modified
