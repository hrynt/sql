SELECT
	row_number() OVER() AS row_number,
	data.*
FROM (
	SELECT
		item_id,
		item_name,
		release_date,
		COUNT(DISTINCT user_id) AS unique_readers,
		COUNT(1) AS page_reads,
		SUM(duration) AS reading_duration,
		AVG(duration) AS avg_reading_duration
	FROM 
		f_userpageviews f
		JOIN d_date ON d_date.date_key = f.date_key
		JOIN d_items ON d_items.item_key = f.item_key
		JOIN d_users ON d_users.user_key = f.user_key
	WHERE 1=1
		
	GROUP BY
		item_id,
		item_name,
		release_date
	ORDER BY
		reading_duration DESC
) data
LIMIT 100
