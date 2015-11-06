WITH pageviews AS (
SELECT 
	datetime::DATE AS activity_date,
	user_id,
	item_id,
	SUM(CASE WHEN duration > '00:30:00' THEN '00:30:00' ELSE duration END) AS reading_duration
FROM
	core_buffetpageviews
WHERE 1=1
	AND datetime >= '2015-06-01 00:00:00'
GROUP BY
	datetime::DATE,
	user_id,
	item_id
), downloads AS (
SELECT 
	datetime::DATE AS activity_date,
	user_id,
	item_id,
	SUM(1) AS download
FROM
	core_useractivities
WHERE 1=1
	AND activity_type = 'download'
	AND datetime >= '2015-06-01 00:00:00'
GROUP BY
	datetime::DATE,
	user_id,
	item_id	
)

SELECT
	pageviews.activity_date,
	pageviews.user_id,
	pageviews.item_id,
	core_brands.id AS brand_id,
	core_brands.name AS title,
	core_brands.vendor_id,
	COALESCE(downloads.download, 0) download,
	reading_duration
FROM 
	pageviews
	LEFT JOIN downloads ON 
		downloads.activity_date = pageviews.activity_date 
		AND downloads.user_id = pageviews.user_id
		AND downloads.item_id = pageviews.item_id
	JOIN core_items ON core_items.id = pageviews.item_id
	JOIN core_brands ON core_brands.id = core_items.brand_id
	
LIMIT 1000