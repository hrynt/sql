SELECT 
	core_vendors.name AS publisher,
	TO_CHAR(core_items.release_date, 'MONTH') AS release_month,
	COUNT(DISTINCT core_items.id) AS total_item,
	AVG(price_idr) AS price_idr,
	MAX(price_idr) AS max_price_idr,
	MIN(price_idr) AS min_price_idr
FROM 
	core_items
	JOIN core_offers_items ON core_offers_items.item_id = core_items.id
	JOIN core_offers ON core_offers.id = core_offers_items.offer_id
	JOIN core_brands ON core_brands.id = core_items.brand_id
	JOIN core_vendors ON core_vendors.id = core_brands.vendor_id
WHERE 1=1
	AND core_items.itemtype_id = 2
	AND core_offers.id > 0
	AND core_offers.offer_type_id = 1
	AND core_offers.is_active = TRUE
	AND core_items.is_active = TRUE
	AND core_items.release_date BETWEEN '2015-01-01 00:00:00' AND '2015-10-31 23:59:59'
GROUP BY
	core_vendors.name, TO_CHAR(core_items.release_date, 'MM'), TO_CHAR(core_items.release_date, 'MONTH')
ORDER BY
	core_vendors.name, TO_CHAR(core_items.release_date, 'MM')