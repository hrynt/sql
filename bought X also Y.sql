-- Who bought X also bought Y
SELECT
	*
FROM (
	SELECT
		core_brands.id AS brand_id,
		core_payments.user_id,
		COUNT(*) AS count
	FROM 
		core_payments
		JOIN core_orderlines ON core_orderlines.order_id = core_payments.order_id
		JOIN core_offers ON core_offers.id = core_orderlines.offer_id
		LEFT JOIN core_offers_items ON core_offers_items.offer_id = core_offers.id
		LEFT JOIN core_items ON core_items.id = core_offers_items.item_id
		LEFT JOIN core_offers_brands ON core_offers_brands.offer_id = core_offers.id
		JOIN core_brands ON core_brands.id = COALESCE(core_items.brand_id, core_offers_brands.brand_id)
	WHERE 1=1
		AND core_payments.modified::DATE BETWEEN '2015-01-01' AND '2015-06-30'
		AND core_offers.offer_type_id IN (1, 2)
	GROUP BY
		core_brands.id,
		core_payments.user_id
	ORDER BY 
		core_payments.user_id,
		count DESC 
	LIMIT 1000
) data