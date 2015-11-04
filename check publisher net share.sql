SELECT
	core_orderlines.id, 
	core_discounts.vendor_participation,
	core_payments.paymentgateway_id,
-- 	core_orderlines.adjusted_currency_code,
	core_orderlines.adjusted_price,
	core_orderlines.adjusted_final_price, 
	core_orderlines.publisher_gross_share,
-- 	core_orderlines.paymentgateway_gross_charge,
	core_orderlines.publisher_net_share, 
	publisher_calculation.publisher_gross_share,
	CASE WHEN core_orderlines.adjusted_currency_code = 'PTS' THEN publisher_calculation.publisher_net_share * 100 ELSE publisher_calculation.publisher_net_share END AS publisher_net_share,
	core_orderlines.publisher_net_share - CASE WHEN core_orderlines.adjusted_currency_code = 'PTS' THEN publisher_calculation.publisher_net_share * 100 ELSE publisher_calculation.publisher_net_share END
FROM core_payments
JOIN core_orderlines ON core_orderlines.order_id = core_payments.order_id
JOIN core_offers ON core_offers.id = core_orderlines.offer_id
JOIN publisher_calculation ON publisher_calculation.orderline_id = core_orderlines.id
LEFT JOIN core_orderlinediscounts ON core_orderlinediscounts.orderline_id = core_orderlines.id 
LEFT JOIN core_discounts ON core_discounts.id = core_orderlinediscounts.discount_id AND core_discounts.vendor_participation IN (2, 3)
WHERE 
	core_payments.payment_period = '2015-10' 
	AND core_offers.offer_type_id != 4
	AND core_orderlines.publisher_net_share <> CASE WHEN core_orderlines.adjusted_currency_code = 'PTS' THEN publisher_calculation.publisher_net_share * 100 ELSE publisher_calculation.publisher_net_share END
	AND core_orderlines.id NOT IN (-1067416, 568856)
-- 	AND core_orderlines.adjusted_currency_code != 'IDR'
-- 	AND core_payments.paymentgateway_id IN (1, 15)
-- 	AND core_orderlinediscounts.id IS NULL
