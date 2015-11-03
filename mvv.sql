SELECT 
	offers.vendor_name,
	SUM(core_orderlines.final_price * idr.rate) AS total,
	SUM(CASE WHEN core_payments.payment_period = '2015-06' THEN core_orderlines.final_price * idr.rate ELSE 0 END) AS jun_2015,
	SUM(CASE WHEN core_payments.payment_period = '2015-05' THEN core_orderlines.final_price * idr.rate ELSE 0 END) AS may_2015,
	SUM(CASE WHEN core_payments.payment_period = '2015-04' THEN core_orderlines.final_price * idr.rate ELSE 0 END) AS apr_2015,
	SUM(CASE WHEN core_payments.payment_period = '2015-03' THEN core_orderlines.final_price * idr.rate ELSE 0 END) AS mar_2015,
	SUM(CASE WHEN core_payments.payment_period = '2015-02' THEN core_orderlines.final_price * idr.rate ELSE 0 END) AS feb_2015,
	SUM(CASE WHEN core_payments.payment_period = '2015-01' THEN core_orderlines.final_price * idr.rate ELSE 0 END) AS jan_2015
FROM
	core_payments
	JOIN core_orderlines ON core_orderlines.order_id = core_payments.order_id
	JOIN (
		-- single
		SELECT core_offers.id, core_brands.id AS brand_id, core_brands.name AS brand_name, core_vendors.id AS vendor_id, COALESCE(core_vendors.name_by_finance, core_vendors.name) AS vendor_name
		FROM core_offers 
		JOIN core_offers_items ON core_offers_items.offer_id = core_offers.id
		JOIN core_items ON core_items.id = core_offers_items.item_id
		JOIN core_brands ON core_brands.id = core_items.brand_id
		JOIN core_vendors ON core_vendors.id = core_brands.vendor_id
		WHERE core_offers.offer_type_id = 1
		UNION
		-- subs
		SELECT core_offers.id, core_brands.id AS brand_id, core_brands.name AS brand_name, core_vendors.id AS vendor_id, COALESCE(core_vendors.name_by_finance, core_vendors.name) AS vendor_name
		FROM core_offers 
		JOIN core_offers_brands ON core_offers_brands.offer_id = core_offers.id
		JOIN core_brands ON core_brands.id = core_offers_brands.brand_id
		JOIN core_vendors ON core_vendors.id = core_brands.vendor_id
		WHERE core_offers.offer_type_id = 2
		UNION
		-- bundle
		SELECT core_offers.id, core_brands.id AS brand_id, core_brands.name AS brand_name, core_vendors.id AS vendor_id, COALESCE(core_vendors.name_by_finance, core_vendors.name) AS vendor_name
		FROM core_offers 
		JOIN (SELECT offer_id, MAX(item_id) AS item_id FROM core_offers_items GROUP BY offer_id) core_offers_items ON core_offers_items.offer_id = core_offers.id
		JOIN core_items ON core_items.id = core_offers_items.item_id
		JOIN core_brands ON core_brands.id = core_items.brand_id
		JOIN core_vendors ON core_vendors.id = core_brands.vendor_id
		WHERE core_offers.offer_type_id = 3
		) offers ON offers.id = core_orderlines.offer_id
	JOIN currency_rate idr ON idr.payment_period = core_payments.payment_period AND idr.currency_from = UPPER(core_orderlines.currency_code) AND idr.currency_to = 'IDR'
WHERE
	core_payments.modified BETWEEN '2015-01-01 00:00:00' AND '2015-06-30 23:59:59'
GROUP BY
	offers.vendor_name
ORDER BY
	total DESC