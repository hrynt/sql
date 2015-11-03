WITH core_useractivities AS (
	SELECT
		datetime, 
		item_id, 
		user_id, 
		activity_type, 
		duration, 
		CASE WHEN page_number > 9999 THEN 9999 ELSE page_number END AS page_number
	FROM (
		SELECT 
			datetime,
			item_id,
			user_id,
			activity_type,
			CASE WHEN duration > 1800 THEN 1800 ELSE duration END AS duration,
			UNNEST(page_number) AS page_number
		FROM
			core_useractivities
			JOIN core_items ON core_items.id = core_useractivities.item_id
		WHERE 1=1
			AND activity_type = 'pageview'
			AND datetime BETWEEN '2015-06-01 00:00:00' AND current_timestamp
	) data
)

SELECT
	0 AS period,
	item_id,
	page_number,
	COUNT(DISTINCT user_id) AS unique_readers,
	SUM(CASE WHEN activity_type = 'pageview' THEN 1 ELSE 0 END) AS page_reads,
	SUM(duration) AS reading_duration,
	AVG(duration) AS avg_reading_duration
FROM
	core_useractivities
	JOIN core_items ON core_items.id = core_useractivities.item_id
	JOIN core_brands ON core_brands.id = core_items.brand_id
GROUP BY
	item_id,
	page_number
UNION ALL
SELECT 
	TO_CHAR(datetime, 'YYYYMM')::INT AS period,
	item_id,
	page_number,
	COUNT(DISTINCT user_id) AS unique_readers,
	SUM(CASE WHEN activity_type = 'pageview' THEN 1 ELSE 0 END) AS page_reads,
	SUM(duration) AS reading_duration,
	AVG(duration) AS avg_reading_duration
FROM 
	core_useractivities
	JOIN core_items ON core_items.id = core_useractivities.item_id
	JOIN core_brands ON core_brands.id = core_items.brand_id
WHERE
	TO_CHAR(datetime, 'YYYYMM')::INT >= TO_CHAR(current_date - INTERVAL '2 month', 'YYYYMM')::INT
GROUP BY
	TO_CHAR(datetime, 'YYYYMM')::INT,
	item_id,
	page_number
