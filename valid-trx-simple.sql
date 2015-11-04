SELECT
	COUNT(*)
FROM 
	core_payments
	JOIN core_orderlines ON core_orderlines.order_id = core_payments.order_id
WHERE 1=1
	AND TO_CHAR(COALESCE(core_payments.payment_datetime, core_payments.modified), 'YYYYMM')::INT = 201510