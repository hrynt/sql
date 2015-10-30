SELECT
	
	UNNEST(page_number) AS page_number,
	COUNT(DISTINCT user_id) AS unique_users,
	COUNT(1) page_reads,
	SUM(duration) AS reading_duration,
	AVG(duration) AS avg_reading_duration
FROM 
	core_useractivities
WHERE 1=1
	AND core_useractivities.activity_type = 'pageview'
	AND core_useractivities.item_id = 87100
	AND core_useractivities.datetime >= current_date - INTERVAL '1 month'
GROUP BY
	page_number
LIMIT 20
OFFSET 20