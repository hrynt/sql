-- single
SELECT core_offers.id, core_brands.id AS brand_id, core_brands.name AS brand_name, core_vendors.id AS vendor_id, core_vendors.name AS vendor_name
FROM core_offers 
JOIN core_offers_items ON core_offers_items.offer_id = core_offers.id
JOIN core_items ON core_items.id = core_offers_items.item_id
JOIN core_brands ON core_brands.id = core_items.brand_id
JOIN core_vendors ON core_vendors.id = core_brands.vendor_id
WHERE core_offers.offer_type_id = 1
UNION
-- subs
SELECT core_offers.id, core_brands.id AS brand_id, core_brands.name AS brand_name, core_vendors.id AS vendor_id, core_vendors.name AS vendor_name
FROM core_offers 
JOIN core_offers_brands ON core_offers_brands.offer_id = core_offers.id
JOIN core_brands ON core_brands.id = core_offers_brands.brand_id
JOIN core_vendors ON core_vendors.id = core_brands.vendor_id
WHERE core_offers.offer_type_id = 2
UNION
-- bundle
SELECT core_offers.id, core_brands.id AS brand_id, core_brands.name AS brand_name, core_vendors.id AS vendor_id, core_vendors.name AS vendor_name
FROM core_offers 
JOIN (SELECT offer_id, MAX(item_id) AS item_id FROM core_offers_items GROUP BY offer_id) core_offers_items ON core_offers_items.offer_id = core_offers.id
JOIN core_items ON core_items.id = core_offers_items.item_id
JOIN core_brands ON core_brands.id = core_items.brand_id
JOIN core_vendors ON core_vendors.id = core_brands.vendor_id
WHERE core_offers.offer_type_id = 3