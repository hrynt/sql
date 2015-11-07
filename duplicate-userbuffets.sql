SELECT * 
FROM core_userbuffets 
WHERE orderline_id IN (
	SELECT orderline_id
	FROM core_userbuffets
	WHERE is_restore = FALSE 
	GROUP BY orderline_id
	HAVING COUNT(*) > 1
)
AND is_restore = FALSE
AND orderline_id IN (
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
ORDER BY orderline_id