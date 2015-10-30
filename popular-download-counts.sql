SELECT 
	core_brands.id AS item_id, 
	core_brands.name AS item_name,
	core_items.item_type,
	is_free.is_free,
	COUNT(*) AS download_count
FROM 
	core_useractivities 
	JOIN core_items ON core_items.id = core_useractivities.item_id
	JOIN core_brands ON core_brands.id = core_items.brand_id
	LEFT JOIN (
		SELECT item_id, STRING_AGG(core_offers.is_free::TEXT, ',') AS is_free
		FROM core_offers_items
			JOIN core_offers ON core_offers.id = core_offers_items.offer_id
		GROUP BY item_id
		) is_free ON is_free.item_id = core_items.id
WHERE
	core_useractivities.activity_type = 'download'
	AND core_useractivities.download_status = 'success'
	AND core_useractivities.datetime >= current_date - INTERVAL '2 month'
GROUP BY 
	core_brands.id,
	core_brands.name,
	core_items.item_type,
	is_free.is_free
ORDER BY
	download_count DESC