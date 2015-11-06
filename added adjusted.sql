-- 2167
SELECT
	*
FROM (
SELECT 
	core_orderlines.id,
	CASE 
	WHEN COALESCE(core_payments.payment_datetime, core_payments.modified) >= '2015-08-01 00:00:00' THEN 
		CASE 
		WHEN core_payments.paymentgateway_id IN (1, 15) AND core_orderlines.localized_currency_code = 'IDR' THEN core_orderlines.localized_currency_code
		WHEN core_payments.paymentgateway_id NOT IN (1, 15) OR (core_payments.paymentgateway_id IN (1, 15) AND core_orderlines.localized_currency_code <> 'IDR') THEN core_orderlines.currency_code
		END
	WHEN COALESCE(core_payments.payment_datetime, core_payments.modified) < '2015-08-01 00:00:00' THEN 
		core_orderlines.currency_code
	END AS adjusted_currency_code,
	CASE 
	WHEN COALESCE(core_payments.payment_datetime, core_payments.modified) >= '2015-08-01 00:00:00' THEN 
		CASE 
		WHEN core_payments.paymentgateway_id IN (1, 15) AND core_orderlines.localized_currency_code = 'IDR' THEN (core_matrixtiers_price.rate_price->>'IDR')::NUMERIC
		WHEN core_payments.paymentgateway_id NOT IN (1, 15) OR (core_payments.paymentgateway_id IN (1, 15) AND core_orderlines.localized_currency_code <> 'IDR') THEN core_orderlines.price
		END
	WHEN COALESCE(core_payments.payment_datetime, core_payments.modified) < '2015-08-01 00:00:00' THEN 
		core_orderlines.price
	END AS adjusted_price,
	CASE 
	WHEN COALESCE(core_payments.payment_datetime, core_payments.modified) >= '2015-08-01 00:00:00' THEN 
		CASE 
		WHEN core_payments.paymentgateway_id IN (1, 15) AND core_orderlines.localized_currency_code = 'IDR' THEN (core_matrixtiers_final_price.rate_price->>'IDR')::NUMERIC
		WHEN core_payments.paymentgateway_id NOT IN (1, 15) OR (core_payments.paymentgateway_id IN (1, 15) AND core_orderlines.localized_currency_code <> 'IDR') THEN core_orderlines.final_price
		END
	WHEN COALESCE(core_payments.payment_datetime, core_payments.modified) < '2015-08-01 00:00:00' THEN 
		core_orderlines.final_price
	END AS adjusted_final_price
FROM 
	core_payments
	JOIN core_orderlines ON core_orderlines.order_id = core_payments.order_id
	LEFT JOIN core_matrixtiers core_matrixtiers_price ON core_matrixtiers_price.is_alternate = FALSE AND core_matrixtiers_price.paymentgateway_id = core_payments.paymentgateway_id AND core_matrixtiers_price.tier_price = core_orderlines.price AND core_payments.payment_datetime BETWEEN core_matrixtiers_price.valid_from AND core_matrixtiers_price.valid_to
	LEFT JOIN core_matrixtiers core_matrixtiers_final_price ON core_matrixtiers_final_price.is_alternate = FALSE AND core_matrixtiers_final_price.paymentgateway_id = core_payments.paymentgateway_id AND core_matrixtiers_final_price.tier_price = core_orderlines.final_price AND core_payments.payment_datetime BETWEEN core_matrixtiers_final_price.valid_from AND core_matrixtiers_final_price.valid_to
WHERE
	core_payments.payment_status = 20003
	AND core_payments.is_active = TRUE
	AND core_payments.is_test_payment = FALSE
	AND core_orderlines.is_active = TRUE
	AND core_orderlines.is_free = FALSE
-- 	AND core_orderlines.id = 554560
ORDER BY
	core_payments.id
) data
WHERE 
	adjusted_currency_code IS NULL OR adjusted_final_price IS NULL OR adjusted_price IS NULL
ORDER BY adjusted_final_price, adjusted_price